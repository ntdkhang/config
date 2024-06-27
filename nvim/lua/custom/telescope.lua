local data = assert(vim.fn.stdpath "data") --[[@as string]]

require("telescope").setup {
    pickers = {
        find_files = {
            hidden = true
        }
    },
    extensions = {
        wrap_results = true,

        fzf = {},
        history = {
            path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
            limit = 100,
        },
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {},
        },

        file_browser = {
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
        }
    },
}
require("telescope").load_extension "file_browser"

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "smart_history")
pcall(require("telescope").load_extension, "ui-select")

local builtin = require "telescope.builtin"

vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fs", builtin.live_grep)
vim.keymap.set("n", "<leader>fa", builtin.grep_string)

vim.keymap.set("n", "<leader>ft", builtin.git_files)
vim.keymap.set("n", "<leader>fh", builtin.help_tags)
vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find)


vim.keymap.set('n', '<leader>et', ":Telescope file_browser<CR>", {})
