return {
  {

    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      terminal_cmd = vim.env.HOME .. "/.local/bin/claude",
      -- When true, successful sends will focus the Claude terminal if already connected
      focus_after_send = true,
      -- Diff Integration
      diff_opts = {
        layout = "vertical",
        open_in_current_tab = true,
        keep_terminal_focus = true, -- If true, moves focus back to terminal after diff opens
      },
      terminal = {
        split_width_percentage = 0.50,
      }
    },
    config = true,
    keys = {
      { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>cs", "<cmd>ClaudeCodeAdd %<cr>", mode = "n", desc = "Add current buffer" },
      { "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>cs",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
      },
    },
  },


  -- {
  --   "folke/sidekick.nvim",
  --   opts = {
  --     -- add any options here
  --     cli = {
  --       mux = {
  --         backend = "tmux",
  --         enabled = true,
  --       },
  --     },
  --   },
  --   keys = {
  --     {
  --       "<tab>",
  --       function()
  --         -- if there is a next edit, jump to it, otherwise apply it if any
  --         if not require("sidekick").nes_jump_or_apply() then
  --           return "<Tab>" -- fallback to normal tab
  --         end
  --       end,
  --       expr = true,
  --       desc = "Goto/Apply Next Edit Suggestion",
  --     },
  --     {
  --       "<c-.>",
  --       function() require("sidekick.cli").toggle() end,
  --       desc = "Sidekick Toggle",
  --       mode = { "n", "t", "i", "x" },
  --     },
  --     {
  --       "<leader>aa",
  --       function() require("sidekick.cli").toggle() end,
  --       desc = "Sidekick Toggle CLI",
  --     },
  --     {
  --       "<leader>as",
  --       function() require("sidekick.cli").select() end,
  --       -- Or to select only installed tools:
  --       -- require("sidekick.cli").select({ filter = { installed = true } })
  --       desc = "Select CLI",
  --     },
  --     {
  --       "<leader>ad",
  --       function() require("sidekick.cli").close() end,
  --       desc = "Detach a CLI Session",
  --     },
  --     {
  --       "<leader>at",
  --       function() require("sidekick.cli").send({ msg = "{this}" }) end,
  --       mode = { "x", "n" },
  --       desc = "Send This",
  --     },
  --     {
  --       "<leader>af",
  --       function() require("sidekick.cli").send({ msg = "{file}" }) end,
  --       desc = "Send File",
  --     },
  --     {
  --       "<leader>av",
  --       function() require("sidekick.cli").send({ msg = "{selection}" }) end,
  --       mode = { "x" },
  --       desc = "Send Visual Selection",
  --     },
  --     {
  --       "<leader>ap",
  --       function() require("sidekick.cli").prompt() end,
  --       mode = { "n", "x" },
  --       desc = "Sidekick Select Prompt",
  --     },
  --     -- Example of a keybinding to open Claude directly
  --     {
  --       "<leader>ac",
  --       function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
  --       desc = "Sidekick Toggle Claude",
  --     },
  --   },
  -- }
}
