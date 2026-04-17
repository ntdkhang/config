vim.g.mapleader = " "
-- open netrw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
-- vim.keymap.set("n", "<leader>u", ":UndotreeShow<CR>")

-- Move Block of code
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-u>", "20kzz")
vim.keymap.set("n", "<C-d>", "20jzz")
vim.keymap.set("n", "{", "5kzz")
vim.keymap.set("n", "}", "5jzz")

-- center cursor when jumping up down and search
vim.keymap.set("n", "J", "mzJ`z") -- make the cursor when doing J stays the same place
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "gd", "gdzz")

-- greatest remap ever: paste on a selected text and put the selected text to register
vim.keymap.set("x", "<leader>p", '"_dP')

-- auto reindent when pasting
vim.keymap.set("n", "p", "p`[v`]=")

-- yank / delete to clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- navigate windows (handled by tmux.nvim for seamless vim/tmux pane navigation)

vim.keymap.set("n", "<C-f>", "<C-w>o") -- make current window the only window on screen. Close all other windows

-- resize windows
vim.keymap.set("n", "<leader>>", ":vertical resize +10<CR>", { desc = "Increase window width" })
vim.keymap.set("n", "<leader><", ":vertical resize -10<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<leader>=", function()
  -- Clear fixed size restrictions on all windows, then equalize
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    vim.wo[win].winfixwidth = false
    vim.wo[win].winfixheight = false
  end
  vim.cmd("wincmd =")
end, { desc = "Equal window sizes" })

-- navigate buffers
-- vim.keymap.set("n", "<S-l>", ":bnext<CR>")
-- vim.keymap.set("n", "<S-h>", ":bprevious<CR>")

-- indent and stay in visual mode
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

-- search replace all words under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<C-n>", ":noh<CR>")

-- delete duplicated keymap (pcall in case they don't exist yet)
pcall(vim.keymap.del, "n", "grr")
pcall(vim.keymap.del, "n", "grn")
pcall(vim.keymap.del, "n", "gra")
pcall(vim.keymap.del, "x", "gra")
pcall(vim.keymap.del, "n", "gri")

-- Map :W to :w (handle typo for save command)
vim.cmd("command! W write")

local function set_clipboard(value)
  vim.fn.setreg("+", value)
  vim.fn.setreg("*", value)
  if vim.fn.has("macunix") == 1 and vim.fn.executable("pbcopy") == 1 then
    vim.fn.system("pbcopy", value)
  elseif vim.fn.executable("wl-copy") == 1 then
    vim.fn.system("wl-copy", value)
  elseif vim.fn.executable("xclip") == 1 then
    vim.fn.system({ "xclip", "-selection", "clipboard" }, value)
  end
end

local function copy_relative_path()
  local path = vim.fn.expand("%")
  if path == "" then
    vim.notify("No file name for current buffer", vim.log.levels.WARN)
    return
  end
  set_clipboard(path)
  vim.notify("Copied: " .. path)
end

local function copy_path_with_selection()
  local path = vim.fn.expand("%")
  if path == "" then
    vim.notify("No file name for current buffer", vim.log.levels.WARN)
    return
  end
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  local suffix = start_line == end_line and (":" .. start_line) or (":" .. start_line .. "-" .. end_line)
  local value = path .. suffix
  set_clipboard(value)
  vim.notify("Copied: " .. value)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
end

vim.keymap.set("n", "<leader>fp", copy_relative_path, { noremap = true, silent = true, desc = "Copy relative file path" })
vim.keymap.set("v", "<leader>fp", copy_path_with_selection, { noremap = true, silent = true, desc = "Copy file path with selected lines" })
