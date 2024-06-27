return {
    {
        "numToStr/Comment.nvim",       -- comment code
        config = function()
            local comment = require("Comment")

            ---@diagnostic disable-next-line: missing-fields
            -- comment.setup {
            --     toggler = {
            --         ---Line-comment toggle keymap
            --         -- line = '<C-x>',
            --         line = 'gcc',
            --         ---Block-comment toggle keymap
            --         block = 'gbc',
            --     },
            --     opleader = {
            --         ---Line-comment keymap
            --         -- line = '<C-x>',
            --         line = 'gcc',
            --         ---Block-comment keymap
            --         block = 'gb',
            --     },
            -- }

            vim.keymap.set("i", "<C-x>", "<Esc>gcca", {remap = true})
            vim.keymap.set("n", "<C-x>", "gcc", {remap = true})
            vim.keymap.set("v", "<C-x>", "gcc", {remap = true})
            vim.keymap.set("n", "<C-x>", "gcc", {remap = true})
        end,
    }
}
