return {
  dir = vim.fn.stdpath("config"),
  name = "aimux",
  lazy = false,
  init = function()
    require("custom.aimux").setup({
      tools = {
        claude = {
          cmd = { "/Users/dk/.local/bin/claude" },
          patterns = { "claude" },
        },
        opencode = {
          cmd = { "opencode" },
          env = { OPENCODE_THEME = "system" },
          patterns = { "opencode" },
        },
      },
    })
  end,
  keys = {
    {
      "<leader>af",
      function()
        local aimux = require("custom.aimux")
        local mode = vim.fn.mode()
        if mode:match("[vV\22]") then
          aimux.send_and_focus(aimux.file_position())
        else
          aimux.send_and_focus(aimux.file_path())
        end
      end,
      mode = { "n", "x" },
      desc = "Send File to AI",
    },
    {
      "<leader>as",
      function() require("custom.aimux").select() end,
      desc = "Select AI Instance",
    },
    {
      "<leader>an",
      function() require("custom.aimux").create_new() end,
      desc = "New AI Instance",
    },
    {
      "<leader>ad",
      function() require("custom.aimux").detach() end,
      desc = "Detach AI",
    },
    {
      "<leader>ax",
      function() require("custom.aimux").kill() end,
      desc = "Kill AI Pane",
    },
  },
}
