---@diagnostic disable: undefined-global
local git_layout = require("custom.picker_layouts").git

return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        actions = {
          aimux_send = function(_, item)
            if item and item.file then
              require("custom.aimux").send_and_focus(vim.fn.fnamemodify(item.file, ":."))
            end
          end,
        },
        sources = {
          smart = {
            multi = { "recent", "files" },
            filter = { cwd = true },
          },
          files = {
            hidden = true,
            ignored = true, -- ignore .gitignore
            args = { "--ignore-file", ".rgignore", "--ignore-file", vim.fn.expand("~/.rgignore") },
            exclude = { ".git/" },
          },
          grep = {
            hidden = true,
            ignored = true, -- show ignored files (like --no-ignore-vcs)
            args = { "--ignore-file", ".rgignore", "--ignore-file", vim.fn.expand("~/.rgignore") },
            exclude = { ".git/" },
          },
          git_diff = { layout = git_layout },
          git_status = { layout = git_layout },
          git_branches = { layout = git_layout },
          git_log = { layout = git_layout },
          git_log_line = { layout = git_layout },
          git_log_file = { layout = git_layout },
          lsp_references = {
            layout = { preset = "ivy" },
          },
          explorer = {
            hidden = true,
            ignored = true,
            follow_file = true,
            win = {
              input = {
                keys = {
                  ["<c-u>"] = { "list_scroll_up", mode = { "i", "n" } },
                  ["<c-d>"] = { "list_scroll_down", mode = { "i", "n" } },
                },
              },
              list = {
                keys = {
                  ["<c-u>"] = "list_scroll_up",
                  ["<c-d>"] = "list_scroll_down",
                  ["<leader>af"] = "aimux_send",
                },
              },
            },
          },
        },
        layouts = {
          default = {
            layout = {
              box = "horizontal",
              width = 0.9,
              -- min_width = 120,
              height = 0.9,
              {
                box = "vertical",
                border = true,
                title = "{title} {live} {flags}",
                { win = "input", height = 1, border = "bottom" },
                { win = "list", border = "none" },
              },
              { win = "preview", title = "{preview}", border = true, width = 0.4 },
            },
          },
        },
        win = {
          input = {
            keys = {
              ["<c-b>"] = false,
              ["<c-f>"] = false,
              ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["<c-b>"] = false,
              ["<c-f>"] = false,
              ["<c-u>"] = "preview_scroll_up",
              ["<c-d>"] = "preview_scroll_down",
            },
          },
        },
        formatters = {
          file = {
            filename_first = true,
          },
        },
      },
      explorer = {},
    },
    keys = {
      -- Matching telescope keybindings
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      {
        "<leader>fd",
        function()
          Snacks.picker.files({
            live = false,
            pattern = vim.fn.strftime("%Y%m%d"),
            focus = "input",
          })
        end,
        desc = "Find Files by Date",
      },
      { "<leader>fs", function() Snacks.picker.grep() end, desc = "Live Grep" },
      { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Grep String", mode = { "n", "x" } },
      { "<leader>fr", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Git Files" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help Tags" },
      { "<leader>/", function() Snacks.picker.lines() end, desc = "Buffer Fuzzy Find" },
      { "<leader>ft", function() Snacks.picker.explorer({ layout = { preset = "default" }, auto_close = true }) end, desc = "File Tree" },
      { "<leader>en", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Neovim Config" },

      -- Additional useful pickers
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
      { "<leader>et", function() Snacks.explorer({ auto_close = false }) end, desc = "File Explorer" },

      -- git
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      -- { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },

      -- search
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
      { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
      { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },

      -- LSP
      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
      { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
      { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    },
  }
}
