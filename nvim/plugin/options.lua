vim.opt.termguicolors = true
vim.cmd "colorscheme gruvbox-material"

vim.opt.guicursor = "n-v-c-i-ci-ver:block,r-cr-o:hor20"

vim.opt.nu = true
vim.opt.relativenumber = true

-- Use same system clipboard (register * and +) for yank
-- vim.opt.clipboard = "unnamedplus"

-- vim.opt.errorbells = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true -- copy indent from current line when starting new one
vim.opt.smartindent = true

-- wrapping long lines
-- https://stackoverflow.com/questions/36950231/auto-wrap-lines-in-vim-without-inserting-newlines
-- Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum
vim.opt.wrap = true
vim.opt.textwidth = 0
vim.opt.wrapmargin = 0
vim.opt.linebreak = true
-- vim.opt.columns = 80

vim.opt.swapfile = false
vim.opt.backup = false
-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append "@-@"
-- Give more space for displaying messages.
vim.opt.cmdheight = 1

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 200

-- Reduce timeout for key sequences (default 1000ms)
vim.opt.timeoutlen = 300


-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append "c"

-- vim.opt.colorcolumn = "80"

vim.opt.mouse = "a"

-- search smartcase: only do case-sensitive when there's a uppercase letter in the search
-- incLude
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Prevent auto commenting next line
vim.cmd "autocmd BufEnter * set formatoptions-=cro"
vim.cmd "autocmd BufEnter * setlocal formatoptions-=cro"

-- remove trailing whitespace
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

-- no autoformat
vim.g.autoformat = false
