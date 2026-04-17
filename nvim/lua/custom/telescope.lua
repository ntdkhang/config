local actions_setup, actions = pcall(require, "telescope.actions")
if not actions_setup then
  return
end

require("telescope").setup {
  pickers = {
    find_files = {
      hidden = true,
      find_command = { "rg", "--files", "--no-ignore-vcs", "--ignore-file=.rgignore" },
    },
    lsp_references = {
      theme = "ivy",
    },
    live_grep = {
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.4,
        },
        width = 0.9,
        height = 0.9,
      },
    },
  },
  extensions = {
    wrap_results = true,

    fzf = {},
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {},
    },

    --[[ file_browser = {
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,

            -- show hidden files
            hidden = { file_browser = true, folder_browser = true },

            -- disable the use of ignore files
            no_ignore = true,

            select_buffer = true, -- will place the cursor at the path of the current file
        } ]]
  },
  defaults = {
    theme = "center",
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.4,
      },
      width = 0.9,
      height = 0.9,
    },

    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--no-ignore-vcs", -- ignore .gitignore
      "--ignore-file=.rgignore", -- use .rgignore instead
    },
    file_ignore_patterns = { "%.git/" },
    -- mappings = {
    --   i = {
    --     ["<C-q>"] = actions.smart_send + actions.open_qflist, -- send selected to quickfixlist
    --
    --   }
    -- }
  },
}
require("telescope").load_extension "file_browser"

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")

local builtin = require "telescope.builtin"

vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fs", builtin.live_grep)
vim.keymap.set("n", "<leader>fw", builtin.grep_string)
vim.keymap.set("n", "<leader>fr", builtin.resume)

vim.keymap.set("n", "<leader>fg", builtin.git_files)
vim.keymap.set("n", "<leader>fh", builtin.help_tags)
vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find)

-- open file_browser with the path of the current buffer
vim.keymap.set("n", "<space>fb", ":Telescope file_browser path=%:p:h<CR>")

-- Open find file in neovim config
vim.keymap.set("n", "<leader>en", function()
  builtin.find_files {
    cwd = vim.fn.stdpath "config",
  }
end)
