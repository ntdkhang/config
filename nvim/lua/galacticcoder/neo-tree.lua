vim.keymap.set('n', '<leader>el', ":Neotree reveal=true position=left toggle=true<CR>", {})
vim.keymap.set('n', '<leader>ef', ":Neotree reveal=true position=float toggle=true<CR>", {})
vim.keymap.set('n', '<leader>ec', ":Neotree reveal=true position=current toggle=true<CR>", {})

require('neo-tree').setup {
    filesystem = {
        filtered_items = {
            visible = true, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
            hide_dotfiles = false,
            hide_gitignored = true,
        },
        hijack_netrw_behavior = "open_current"
    }
}
