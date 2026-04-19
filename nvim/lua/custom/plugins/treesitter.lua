return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      local parsers = {
        "c",
        "lua",
        "query",
        "markdown",
        "markdown_inline",
        "c_sharp",
        "cpp",
        "typescript",
        "html",
        "css",
      }

      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local bufnr = args.buf
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang then
            return
          end

          local max_filesize = 100 * 1024
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
          if ok and stats and stats.size > max_filesize then
            return
          end

          pcall(vim.treesitter.start, bufnr, lang)
        end,
      })
    end,
  },
}
