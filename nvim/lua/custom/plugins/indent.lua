return {
  -- ident-blankline causing some neovim scroll lags
  -- {
  --   "lukas-reineke/indent-blankline.nvim",
  --   main = "ibl",
  --   ---@module "ibl"
  --   ---@type ibl.config
  --   opts = {},
  --   config = function()
  --     local highlight = {
  --       "IndentThick",
  --       "IndentThin",
  --     }
  --     local hooks = require "ibl.hooks"
  --     -- create the highlight groups in the highlight setup hook, so they are reset
  --     -- every time the colorscheme changes
  --     hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  --       vim.api.nvim_set_hl(0, "IndentThick", { fg = "#666666" })
  --       vim.api.nvim_set_hl(0, "IndentThin", { fg = "#444444" })
  --     end)
  --
  --     require("ibl").setup {
  --       indent = {
  --         char = { "▎", "▏" },
  --         highlight = highlight,
  --       },
  --     }
  --   end,
  -- },
  {
    -- "HiPhish/rainbow-delimiters.nvim",

  }
}
