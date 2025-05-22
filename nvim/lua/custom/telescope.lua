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
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {},
        },

        file_browser = {
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
            hidden = { file_browser = true, folder_browser = true },
            select_buffer = true, -- will place the cursor at the path of the current file
        }
    },
    defaults = {
        -- install ripgrep, and it will automatically ignore everything in .gitignore for us
        file_ignore_patterns = { "%.git/" },
    }
}
require("telescope").load_extension "file_browser"

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")

local builtin = require "telescope.builtin"

vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fs", builtin.live_grep)
vim.keymap.set("n", "<leader>fa", builtin.grep_string)

vim.keymap.set("n", "<leader>ft", builtin.git_files)
vim.keymap.set("n", "<leader>fh", builtin.help_tags)
vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find)


-- vim.keymap.set('n', '<leader>et', ":Telescope file_browser<CR>", {})

-- open file_browser with the path of the current buffer
vim.keymap.set("n", "<space>fb", ":Telescope file_browser path=%:p:h<CR>")

