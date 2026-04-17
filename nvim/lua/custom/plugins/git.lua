local function git_output(args)
  local cmd = { "git" }
  vim.list_extend(cmd, args)

  local result = vim.system(cmd, { text = true }):wait()
  if result.code == 0 then
    return vim.trim(result.stdout or "")
  end

  local err = vim.trim(result.stderr or "")
  if err == "" then
    err = vim.trim(result.stdout or "")
  end
  return nil, err
end

local function diff_branch_base()
  local current_branch = git_output({ "branch", "--show-current" }) or ""
  local refs, err = git_output({ "for-each-ref", "--format=%(refname:short)", "refs/remotes", "refs/heads" })
  if not refs then
    vim.notify("git: failed to list branches" .. (err ~= "" and ": " .. err or ""), vim.log.levels.ERROR)
    return
  end

  local seen = {}
  local branches = {}
  for line in refs:gmatch("[^\n]+") do
    local branch = vim.trim(line)
    if branch ~= "" and branch ~= "origin/HEAD" and branch ~= current_branch and not seen[branch] then
      seen[branch] = true
      branches[#branches + 1] = branch
    end
  end

  table.sort(branches, function(a, b)
    if a == "origin/main" then return true end
    if b == "origin/main" then return false end

    local a_remote = a:match("^origin/") ~= nil
    local b_remote = b:match("^origin/") ~= nil
    if a_remote ~= b_remote then return a_remote end

    return a < b
  end)

  if #branches == 0 then
    vim.notify("git: no comparison branches found", vim.log.levels.WARN)
    return
  end

  vim.ui.select(branches, { prompt = "Diff branch from base:" }, function(branch)
    if not branch then return end

    local base = git_output({ "merge-base", "--fork-point", branch, "HEAD" })
    if not base or base == "" then
      base = git_output({ "merge-base", branch, "HEAD" })
    end

    if not base or base == "" then
      vim.notify("git: failed to find branch point for " .. branch, vim.log.levels.ERROR)
      return
    end

    vim.cmd({ cmd = "DiffviewOpen", args = { base .. "..HEAD" } })
  end)
end

return {
  {
    "linrongbin16/gitlinker.nvim",
    cmd = "GitLink",
    opts = {},
    keys = {
      { "<leader>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank git link" },
      { "<leader>gY", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      update_debounce = 200,
      max_file_length = 10000,
    },
  },
  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Repo History" },
      { "<leader>go", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
      { "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
      { "<leader>gD", diff_branch_base, desc = "Diff From Branch Base" },
    },
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit" },
  },
}
