return {
  {
    -- Auto close tags, and allow renaming of tags
    "windwp/nvim-ts-autotag",
  },

  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  },
}
