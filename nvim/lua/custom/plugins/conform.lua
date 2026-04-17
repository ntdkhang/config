return {
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup {
        formatters_by_ft = {
          javascript = { "prettierd", "prettier", stop_after_first = true },
          typescript = { "prettierd", "prettier", stop_after_first = true },
          json = { "prettierd", "prettier", stop_after_first = true },
          html = { "prettierd", "prettier", stop_after_first = true },
          css = { "prettierd", "prettier", stop_after_first = true },
          scss = { "prettierd", "prettier", stop_after_first = true },
          yaml = { "prettierd", "prettier", stop_after_first = true },
          markdown = { "prettierd", "prettier", stop_after_first = true },
          svelte = { "prettier" },
        },
      }

      -- Manual format with <leader>pt
      vim.keymap.set("n", "<leader>pt", function()
        require("conform").format {
          lsp_fallback = true,
          async = true,
          quiet = true,
        }
      end, { desc = "Format with prettier" })
    end,
  },
}
