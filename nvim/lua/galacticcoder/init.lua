require("galacticcoder.lazy")
require("galacticcoder.set")
require("galacticcoder.remap")
require("galacticcoder.neo-tree")
-- require("galacticcoder.toggleterm")

vim.cmd [[colorscheme kanagawa]]





-- vim.cmd([[
--  augroup filetype
--  au BufRead,BufNewFile *.flex,*.jflex    set filetype=jflex
--  augroup END
--  au Syntax jflex    so ~/.config/nvim/lua/galacticcoder/jflex.vim
-- ]])

local jflexgroup = vim.api.nvim_create_augroup("JflexGroup", {
    clear = false
})

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = {"*.flex", "*.jflex"},
  command = [[so ~/.config/nvim/lua/galacticcoder/jflex.vim]],
  group = jflexgroup,
})


local cupgroup = vim.api.nvim_create_augroup("CupGroup", {
    clear = false

})

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = {"*.cup"},
  command = [[so ~/.config/nvim/lua/galacticcoder/cup.vim]],
  group = cupgroup,
})
