vim.cmd 'colorscheme kanagawa'

vim.opt.guicursor = "n-v-c-i-ci-ver:block,r-cr-o:hor20"
vim.opt.termguicolors = true

vim.opt.nu = true
vim.opt.relativenumber = true

-- vim.opt.errorbells = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true -- copy indent from current line when starting new one
vim.opt.smartindent = true

-- wrapping long lines
-- https://stackoverflow.com/questions/36950231/auto-wrap-lines-in-vim-without-inserting-newlines
--- vim.opt.autoindent = true -- copy indent from current line when starting new one-- vim.opt.autoindent = true -- copy indent from current line when starting new one-- vim.opt.autoindent = true -- copy indent from current line when starting new one- -- vim.opt.autoindent = true -- copy indent from current line when starting new one
vim.opt.wrap = true
vim.opt.textwidth = 0
vim.opt.wrapmargin = 0
vim.opt.linebreak = true
-- vim.opt.columns = 80

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Give more space for displaying messages.
vim.opt.cmdheight = 1

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 50

-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append("c")

-- vim.opt.colorcolumn = "80"

vim.opt.mouse = "a"

-- search smartcase: only do case-sensitive when there's a uppercase letter in the search
-- incLude
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Prevent auto commenting next line
vim.cmd('autocmd BufEnter * set formatoptions-=cro')
vim.cmd('autocmd BufEnter * setlocal formatoptions-=cro')


-- remove trailing whitespace
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    command = [[%s/\s\+$//e]],
})


-- no autoformat
vim.g.autoformat = false


-- vim.api.nvim_create_autocmd
