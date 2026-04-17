return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup {
        start_in_insert = true,
        shade_terminals = true,
        shading_factor = 2,
      }

      local keymap = vim.keymap.set
      local opts = { noremap = true, silent = true }

      local Terminal = require("toggleterm.terminal").Terminal

      -- create persistent terminals
      local term_right = Terminal:new { direction = "vertical", count = 1, hidden = true, close_on_exit = false }
      local term_bottom = Terminal:new { direction = "horizontal", count = 2, hidden = true, close_on_exit = false }
      local term_float = Terminal:new { direction = "float", count = 3, hidden = true, close_on_exit = false }

      local function close_others(except)
        if except ~= term_right and term_right:is_open() then
          term_right:close()
        end
        if except ~= term_bottom and term_bottom:is_open() then
          term_bottom:close()
        end
        if except ~= term_float and term_float:is_open() then
          term_float:close()
        end
      end

      local function toggle_right()
        close_others(term_right)
        local size = math.floor(vim.o.columns * 0.3) -- 30% width
        term_right:toggle(size)
      end

      local function toggle_bottom()
        close_others(term_bottom)
        local size = math.floor(vim.o.lines * 0.2) -- 20% height
        term_bottom:toggle(size)
      end

      local function toggle_float()
        close_others(term_float)
        term_float:toggle()
      end

      -- Lazygit terminal (floating)
      local lazygit = Terminal:new {
        cmd = "lazygit",
        dir = "git_dir", -- open in project git root
        direction = "float",
        hidden = true,
        close_on_exit = true,
        float_opts = {
          border = "curved",
        },
      }

      function _lazygit_toggle()
        lazygit:toggle()
      end

      -- Toggle with <leader>tg in both normal + terminal mode
      keymap({ "n", "t" }, "<leader>tg", _lazygit_toggle, opts)

      -- keymaps for normal + terminal mode
      keymap({ "n", "t" }, "<leader>tl", toggle_right, opts) -- right (vertical) → now <leader>tl
      keymap({ "n", "t" }, "<leader>tj", toggle_bottom, opts) -- bottom
      keymap({ "n", "t" }, "<leader>tk", toggle_float, opts) -- float

      -- QoL inside terminal
      keymap("t", "<esc>", [[<C-\><C-n>]], opts)
      -- C-h/j/k/l handled by tmux.nvim for seamless vim/tmux navigation
    end,
  },
}
