-- lua/custom/aimux.lua
-- Tmux pane manager for AI CLI tools
-- load-buffer + paste-buffer send pattern from sidekick.nvim (Apache 2.0)

local M = {}

M.targets = {} -- { [tool_name] = pane_id }
M.tools = {} -- configured tools
M.watches = {} -- { [dir] = fs_event_handle }
M.last_tool = nil

local check_timer = vim.uv.new_timer()
local watch_timer = vim.uv.new_timer()

---@param opts table
---@return boolean
local function open_picker(opts)
  local ok, snacks = pcall(require, "snacks")
  if not ok then
    vim.notify("aimux: snacks.nvim is not available", vim.log.levels.ERROR)
    return false
  end

  snacks.picker(opts)
  return true
end

--- Run a tmux command synchronously
---@param cmd string[]
---@param stdin? string
---@return string?
function M.exec(cmd, stdin)
  local result = vim.system(cmd, { text = true, stdin = stdin }):wait()
  if result.code == 0 then
    return vim.trim(result.stdout or "")
  end
  return nil
end

--- Check if a tmux pane exists
---@param pane_id string
---@return boolean
function M.pane_alive(pane_id)
  return vim.system({ "tmux", "display-message", "-t", pane_id, "-p", "" }, { text = true }):wait().code == 0
end

--- Validate a target, clear if pane is dead
---@param tool_name string
---@return boolean
function M.validate(tool_name)
  local pane_id = M.targets[tool_name]
  if not pane_id then return false end
  if M.pane_alive(pane_id) then return true end
  M.targets[tool_name] = nil
  if M.last_tool == tool_name then M.last_tool = nil end
  return false
end

--- Validate all targets
function M.validate_all()
  for name in pairs(M.targets) do
    M.validate(name)
  end
end

--- Match a process name against configured tool patterns
---@param proc_name string
---@return string?
local function match_tool(proc_name)
  for name, tool in pairs(M.tools) do
    for _, pattern in ipairs(tool.patterns or {}) do
      if proc_name:find(pattern, 1, true) then
        return name
      end
    end
  end
  return nil
end

--- Build ppid→children map from a single ps call
---@return { children: table<integer, integer[]>, comm: table<integer, string> }
local function ps_tree()
  local result = vim.system({ "ps", "-ax", "-o", "pid=,ppid=,comm=" }, { text = true }):wait()
  if result.code ~= 0 or not result.stdout then return { children = {}, comm = {} } end
  local children = {} ---@type table<integer, integer[]>
  local comm = {} ---@type table<integer, string>
  for line in result.stdout:gmatch("[^\n]+") do
    local p, pp, c = line:match("^%s*(%d+)%s+(%d+)%s+(.+)$")
    if p and pp and c then
      local pid = tonumber(p) --[[@as integer]]
      local ppid = tonumber(pp) --[[@as integer]]
      comm[pid] = vim.trim(vim.fs.basename(c))
      if not children[ppid] then children[ppid] = {} end
      table.insert(children[ppid], pid)
    end
  end
  return { children = children, comm = comm }
end

--- Walk process tree via ps (BFS, includes pid itself)
---@param pid integer
---@param tree { children: table<integer, integer[]>, comm: table<integer, string> }
---@return string?
function M.find_tool_in_tree(pid, tree)
  local queue = { pid }
  while #queue > 0 do
    local current = table.remove(queue, 1)
    -- Check this process itself
    if tree.comm[current] then
      local tool = match_tool(tree.comm[current])
      if tool then return tool end
    end
    -- Then its children
    for _, child_pid in ipairs(tree.children[current] or {}) do
      queue[#queue + 1] = child_pid
    end
  end
  return nil
end

--- Match pane_current_command against tool patterns
---@param cmd string
---@return string?
local function match_pane_cmd(cmd)
  for name, tool in pairs(M.tools) do
    for _, pattern in ipairs(tool.patterns or {}) do
      if cmd:find(pattern, 1, true) then
        return name
      end
    end
  end
  return nil
end

--- Scan tmux panes in the current session for known tools
---@return { pane_id: string, tool: string, target: string, cwd: string }[]
function M.scan()
  local out = M.exec({
    "tmux", "list-panes", "-s", "-F",
    "#{pane_id}\t#{pane_pid}\t#{pane_current_command}\t#{session_name}:#{window_index}.#{pane_index}\t#{pane_current_path}",
  })
  if not out then return {} end
  local results = {}
  local tree = ps_tree()
  for line in out:gmatch("[^\n]+") do
    local pane_id, pid, pcmd, target, cwd = line:match("^(%%%d+)\t(%d+)\t([^\t]*)\t([^\t]*)\t(.*)$")
    if pane_id and pid then
      -- Try pane_current_command first (fast), then process tree walk (thorough)
      local tool = match_pane_cmd(pcmd or "")
        or M.find_tool_in_tree(tonumber(pid) --[[@as integer]], tree)
      if tool then
        table.insert(results, { pane_id = pane_id, tool = tool, target = target or "", cwd = cwd or "" })
      end
    end
  end
  return results
end

--- Create a new pane for a tool
---@param tool_name string
function M.create(tool_name)
  local tool = M.tools[tool_name]
  if not tool then
    vim.notify("aimux: unknown tool " .. tool_name, vim.log.levels.ERROR)
    return
  end
  local shell_cmd = table.concat(tool.cmd, " ")
  if tool.env then
    local env = {}
    for k, v in pairs(tool.env) do
      env[#env + 1] = k .. "=" .. v
    end
    shell_cmd = table.concat(env, " ") .. " " .. shell_cmd
  end
  local pane_id = M.exec({
    "tmux", "split-window", "-dh", "-l", "50%", "-P", "-F", "#{pane_id}", shell_cmd,
  })
  if pane_id then
    M.targets[tool_name] = pane_id
    M.last_tool = tool_name
    M.focus(tool_name)
  else
    vim.notify("aimux: failed to create " .. tool_name, vim.log.levels.ERROR)
  end
end

--- Attach to an existing pane running a tool (picks if multiple)
---@param tool_name string
---@return boolean
function M.attach(tool_name)
  local matches = {}
  for _, entry in ipairs(M.scan()) do
    if entry.tool == tool_name then
      matches[#matches + 1] = entry
    end
  end
  if #matches == 0 then
    return false
  elseif #matches == 1 then
    M.targets[tool_name] = matches[1].pane_id
    return true
  end
  -- Multiple instances — let user pick
  local items = {}
  for i, entry in ipairs(matches) do
    local cwd = vim.fn.fnamemodify(entry.cwd, ":~")
    items[i] = {
      text = entry.target .. "  " .. cwd,
      pane_id = entry.pane_id,
      sort_idx = i,
    }
  end
  open_picker({
    title = "Attach to " .. tool_name,
    finder = function() return items end,
    format = function(item) return { { item.text } } end,
    sort = { fields = { "sort_idx" } },
    preview = "none",
    layout = { preset = "select" },
    confirm = function(picker, item)
      picker:close()
      if item then
        M.targets[tool_name] = item.pane_id
        M.last_tool = tool_name
        M.focus(tool_name)
      end
    end,
  })
  return true -- handled async
end

--- Toggle: focus if alive, else attach, else create
---@param tool_name string
function M.toggle(tool_name)
  M.last_tool = tool_name
  if M.validate(tool_name) then
    M.focus(tool_name)
  elseif M.attach(tool_name) then
    M.focus(tool_name)
  else
    M.create(tool_name)
  end
end

--- Focus a pane (cross-window)
---@param tool_name string
function M.focus(tool_name)
  local pane_id = M.targets[tool_name]
  if not pane_id then return end
  vim.system({ "tmux", "select-window", "-t", pane_id })
  vim.system({ "tmux", "select-pane", "-t", pane_id })
end

--- Send text via load-buffer + paste-buffer (from sidekick.nvim, Apache 2.0)
---@param text string
---@param tool_name? string
function M.send(text, tool_name)
  tool_name = tool_name or M.last_tool
  if not tool_name then
    vim.notify("aimux: no active tool", vim.log.levels.WARN)
    return
  end
  local pane_id = M.targets[tool_name]
  if not pane_id then
    vim.notify("aimux: no pane for " .. tool_name, vim.log.levels.WARN)
    return
  end
  local buf = "aimux-" .. pane_id
  M.exec({ "tmux", "load-buffer", "-b", buf, "-" }, text)
  M.exec({ "tmux", "paste-buffer", "-b", buf, "-d", "-r", "-t", pane_id })
end

--- Send text and focus the pane
---@param text string
---@param tool_name? string
function M.send_and_focus(text, tool_name)
  tool_name = tool_name or M.last_tool
  if not tool_name then
    if M.select(function(item)
        M.send(" " .. text .. " ", item.tool)
      M.focus(item.tool)
    end) then
      return
    end
    return
  end
  if not M.validate(tool_name) then
    vim.notify("aimux: " .. tool_name .. " is not running", vim.log.levels.WARN)
    return
  end
  M.send(" " .. text .. " ", tool_name)
  M.focus(tool_name)
end

--- Kill a pane (or pick from running tools if no name given)
---@param tool_name? string
function M.kill(tool_name)
  if tool_name then
    local pane_id = M.targets[tool_name]
    if pane_id then
      M.exec({ "tmux", "kill-pane", "-t", pane_id })
      M.targets[tool_name] = nil
      if M.last_tool == tool_name then M.last_tool = nil end
      vim.notify("aimux: closed " .. tool_name, vim.log.levels.INFO)
    else
      vim.notify("aimux: no pane for " .. tool_name, vim.log.levels.WARN)
    end
    return
  end
  M.validate_all()
  local running = vim.tbl_keys(M.targets)
  table.sort(running)
  if #running == 0 then
    vim.notify("aimux: nothing running", vim.log.levels.INFO)
  elseif #running == 1 then
    M.kill(running[1])
  else
    local items = {}
    for i, name in ipairs(running) do
      items[i] = { text = name, tool = name, sort_idx = i }
    end
    open_picker({
      title = "Kill AI Pane",
      finder = function() return items end,
      format = function(item) return { { item.text } } end,
      sort = { fields = { "sort_idx" } },
      preview = "none",
      layout = { preset = "select" },
      confirm = function(picker, item)
        picker:close()
        if item then M.kill(item.tool) end
      end,
    })
  end
end

--- Picker for all running AI instances, sorted by proximity to current tmux context
---@param on_confirm? fun(item: { tool: string, pane_id: string, text: string, sort_idx: integer })
---@return boolean
function M.select(on_confirm)
  local scanned = M.scan()
  if #scanned == 0 then
    vim.notify("aimux: no running instances found", vim.log.levels.INFO)
    return false
  end
  -- Get current tmux session:window for proximity sorting
  local current = M.exec({ "tmux", "display-message", "-p", "#{session_name}:#{window_index}" }) or ""
  local cur_session = current:match("^([^:]+)") or ""
  -- Build set of tracked pane_ids for marking
  local tracked_panes = {}
  for _, pane_id in pairs(M.targets) do
    tracked_panes[pane_id] = true
  end
  -- Score by proximity: 0 = same session+window, 1 = same session, 2 = other
  local function score(item)
    local item_sw = item.target:match("^([^.]+)") or "" -- session:window
    if item_sw == current then return 0 end
    local item_session = item.target:match("^([^:]+)") or ""
    if item_session == cur_session then return 1 end
    return 2
  end
  table.sort(scanned, function(a, b)
    local sa, sb = score(a), score(b)
    if sa ~= sb then return sa < sb end
    return a.tool < b.tool
  end)
  -- Build finder items with sort_idx to preserve proximity order
  local items = {}
  for i, entry in ipairs(scanned) do
    local marker = tracked_panes[entry.pane_id] and " *" or ""
    local cwd = vim.fn.fnamemodify(entry.cwd, ":~")
    items[i] = {
      text = entry.tool .. " " .. entry.target .. " " .. cwd .. marker,
      tool = entry.tool,
      pane_id = entry.pane_id,
      sort_idx = i,
    }
  end
  open_picker({
    title = "AI Instances",
    finder = function() return items end,
    format = function(item)
      return { { item.text } }
    end,
    sort = { fields = { "sort_idx" } },
    preview = "none",
    layout = { preset = "select" },
    confirm = function(picker, item)
      picker:close()
      if not item then return end
      M.targets[item.tool] = item.pane_id
      M.last_tool = item.tool
      if on_confirm then
        on_confirm(item)
      else
        M.focus(item.tool)
      end
    end,
  })

  return true
end

--- Create a new AI instance (pick tool if multiple configured)
function M.create_new()
  local tool_names = vim.tbl_keys(M.tools)
  table.sort(tool_names)
  if #tool_names == 0 then
    vim.notify("aimux: no tools configured", vim.log.levels.WARN)
    return
  elseif #tool_names == 1 then
    M.create(tool_names[1])
    return
  end
  local items = {}
  for i, name in ipairs(tool_names) do
    items[i] = { text = name, tool = name, sort_idx = i }
  end
  open_picker({
    title = "New AI Instance",
    finder = function() return items end,
    format = function(item) return { { item.text } } end,
    sort = { fields = { "sort_idx" } },
    preview = "none",
    layout = { preset = "select" },
    confirm = function(picker, item)
      picker:close()
      if item then M.create(item.tool) end
    end,
  })
end

--- Detach: stop tracking a tool but leave its tmux pane running
---@param tool_name? string
function M.detach(tool_name)
  if tool_name then
    if M.targets[tool_name] then
      M.targets[tool_name] = nil
      if M.last_tool == tool_name then M.last_tool = nil end
      vim.notify("aimux: detached " .. tool_name, vim.log.levels.INFO)
    else
      vim.notify("aimux: " .. tool_name .. " is not tracked", vim.log.levels.WARN)
    end
    return
  end
  M.validate_all()
  local tracked = vim.tbl_keys(M.targets)
  table.sort(tracked)
  if #tracked == 0 then
    vim.notify("aimux: nothing tracked", vim.log.levels.INFO)
  elseif #tracked == 1 then
    M.detach(tracked[1])
  else
    local items = {}
    for i, name in ipairs(tracked) do
      items[i] = { text = name, tool = name, sort_idx = i }
    end
    open_picker({
      title = "Detach AI",
      finder = function() return items end,
      format = function(item) return { { item.text } } end,
      sort = { fields = { "sort_idx" } },
      preview = "none",
      layout = { preset = "select" },
      confirm = function(picker, item)
        picker:close()
        if item then M.detach(item.tool) end
      end,
    })
  end
end

--- Relative path of current buffer
---@return string
function M.file_path()
  return vim.fn.expand("%:.")
end

--- File path with visual line range
---@return string
function M.file_position()
  local path = M.file_path()
  local mode = vim.fn.mode(1)
  local s, e

  if mode:match("^[vV\22]") then
    s = vim.fn.getpos("v")[2]
    e = vim.api.nvim_win_get_cursor(0)[1]
    if s > e then
      s, e = e, s
    end
  else
    s = vim.fn.line("'<")
    e = vim.fn.line("'>")
  end

  return path .. ":" .. s .. "-" .. e
end

-- File watching (from sidekick.nvim, Apache 2.0) --

local function debounced_checktime()
  check_timer:stop()
  check_timer:start(100, 0, vim.schedule_wrap(function()
    vim.cmd.checktime()
  end))
end

function M.watch_enable()
  vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete", "BufWipeout", "BufReadPost" }, {
    group = vim.api.nvim_create_augroup("aimux_watch", { clear = true }),
    callback = function()
      watch_timer:stop()
      watch_timer:start(100, 0, vim.schedule_wrap(M.watch_update))
    end,
  })
  M.watch_update()
end

function M.watch_update()
  local dirs = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" then
        local dir = vim.fs.dirname(name)
        if dir then
          dirs[dir] = true
          if not M.watches[dir] then
            local h = vim.uv.new_fs_event()
            if h then
              local ok = h:start(dir, {}, function() debounced_checktime() end)
              if ok then
                M.watches[dir] = h
              else
                h:close()
              end
            end
          end
        end
      end
    end
  end
  for dir, h in pairs(M.watches) do
    if not dirs[dir] then
      if not h:is_closing() then h:close() end
      M.watches[dir] = nil
    end
  end
end

--- Setup
---@param opts? { tools?: table }
function M.setup(opts)
  if not os.getenv("TMUX") then
    vim.notify("aimux: not in tmux", vim.log.levels.WARN)
    return
  end
  opts = opts or {}
  M.tools = opts.tools or {}
  M.watch_enable()
end

return M
