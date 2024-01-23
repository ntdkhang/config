local Remap = require("galacticcoder.keymap")
-- local nnoremap = Remap.nnoremap
-- local vnoremap = Remap.vnoremap
-- local inoremap = Remap.inoremap
-- local xnoremap = Remap.xnoremap
-- local imap = Remap.imap

local comment = require("Comment")

comment.setup {
    toggler = {
        ---Line-comment toggle keymap
        -- line = '<C-x>',
        line = 'gcc',
        ---Block-comment toggle keymap
        block = 'gbc',
    },
     opleader = {
        ---Line-comment keymap
        -- line = '<C-x>',
        line = 'gcc',
        ---Block-comment keymap
        block = 'gb',
    },
}
vim.keymap.set("i", "<C-x>", "<Esc>gcca", {remap = true})
vim.keymap.set("n", "<C-x>", "gcc", {remap = true})
vim.keymap.set("v", "<C-x>", "gcc", {remap = true})


