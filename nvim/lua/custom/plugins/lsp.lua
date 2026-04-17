return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      "saghen/blink.cmp",

      { "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },
      { "j-hui/fidget.nvim", opts = {} },

      -- Schema information
      "b0o/SchemaStore.nvim",

      -- signature help
      "ray-x/lsp_signature.nvim",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local servers = {
        bashls = true,
        gopls = {
          settings = {
            gopls = {
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
        lua_ls = {
          server_capabilities = {
            semanticTokensProvider = vim.NIL,
          },
          settings = {
            Lua = {
              -- completion, runtime, workspace, etc.
              diagnostics = {
                globals = { "vim" },
                undefined_global = false, -- remove this from diag!
                missing_parameters = false, -- missing fields :)
              },
            },
          },
        },
        clangd = {
          init_options = { clangdFileStatus = true },
          filetypes = { "c", "cpp" },
        },
        basedpyright = true,
        -- sourcekit = {
        --     cmd = { "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp" },
        --     filetypes = { "swift" }
        -- },

        ts_ls = {},
        html = true,
        cssls = {
          settings = {
            css = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
            scss = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
            less = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
          },
        },
        svelte = {
          settings = {
            svelte = {
              plugin = {
                css = {
                  diagnostics = {
                    enable = false,
                  },
                },
              },
            },
          },
        },
        tailwindcss = {
          filetypes = { "html", "javascript", "typescript", "jsx", "tsx", "css", "scss", "vue", "svelte" },
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  "tw`([^`]*)",
                  'tw="([^"]*)',
                  'tw={"([^"}]*)',
                  "tw\\.\\w+`([^`]*)",
                  "tw\\(.*?\\)`([^`]*)",
                },
              },
            },
          },
        },
      }

      local servers_to_install = vim.tbl_filter(function(key)
        local t = servers[key]
        if type(t) == "table" then
          return not t.manual_install
        else
          return t
        end
      end, vim.tbl_keys(servers))

      require("mason").setup()
      local ensure_installed = {
        "clangd",
        "lua_ls",
        "pyright",
        "typescript-language-server",
        "svelte-language-server",
        "tailwindcss-language-server",
      }

      vim.list_extend(ensure_installed, servers_to_install)

      require("mason-tool-installer").setup { ensure_installed = ensure_installed }

      -- Use new vim.lsp.config API (Neovim 0.11+)
      local server_names = {}
      for name, config in pairs(servers) do
        if config == true then
          config = {}
        end
        config = vim.tbl_deep_extend("force", {}, {
          capabilities = capabilities,
        }, config)

        vim.lsp.config(name, config)
        table.insert(server_names, name)
      end

      -- Enable all configured servers
      vim.lsp.enable(server_names)

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          -- local bufnr = args.buf
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

          local settings = servers[client.name]
          if type(settings) ~= "table" then
            settings = {}
          end

          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { buffer = 0 })
          vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = 0 })

          -- Override server capabilities
          if settings.server_capabilities then
            for k, v in pairs(settings.server_capabilities) do
              if v == vim.NIL then
                ---@diagnostic disable-next-line: cast-local-type
                v = nil
              end

              client.server_capabilities[k] = v
            end
          end
        end,
      })

      -- require('lsp_signature').setup({})

      require("lsp_lines").setup()
      vim.diagnostic.config { virtual_text = true, virtual_lines = false }

      vim.keymap.set("", "<leader>l", function()
        local config = vim.diagnostic.config() or {}
        if config.virtual_text then
          vim.diagnostic.config { virtual_text = false, virtual_lines = true }
        else
          vim.diagnostic.config { virtual_text = true, virtual_lines = false }
        end
      end, { desc = "Toggle lsp_lines" })
    end,
  },
}
