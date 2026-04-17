return {
  "folke/tokyonight.nvim",
  "ellisonleao/gruvbox.nvim",
  "rebelot/kanagawa.nvim",
  "catppuccin/nvim",
  {
    'sainnhe/everforest',
    lazy = false,
    priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.everforest_enable_italic = true
    end
  },
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_background = 'medium'  -- 'soft' or 'medium' or 'hard'
      vim.g.gruvbox_material_visual = 'green'       -- green-tinted selection
      -- vim.o.background = 'light'  -- if you want light mode
      vim.cmd.colorscheme('gruvbox-material')
    end
  },
}
