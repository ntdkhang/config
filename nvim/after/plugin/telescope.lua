local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>fs', builtin.live_grep, {})
-- vim.keymap.set('n', '<leader>fg', function()
-- 	builtin.grep_string({ search = vim.fn.input("Grep > ") })
-- end)
require("telescope").load_extension "file_browser"
require('telescope').load_extension('media_files')

vim.keymap.set('n', '<leader>fb', ":Telescope file_browser<CR>", {})


require('telescope').setup {
  extensions = {
    media_files = {
      -- filetypes whitelist
      -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
      filetypes = {"png", "webp", "jpg", "jpeg"},
      -- find command (defaults to `fd`)
      find_cmd = "rg"
    }
  },
}
