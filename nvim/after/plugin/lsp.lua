local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.setup_nvim_cmp({
    -- disable autoselect
    preselect = 'none',
    completion = {
        completeopt = 'menu,menuone,noinsert,noselect'
    },
})

lsp.ensure_installed({
    'lua_ls',
    'clangd',
    'pyright',
    -- 'markdown',
})


lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  -- if client.name == "eslint" then
  --     vim.cmd.LspStop('eslint')
  --     return
  -- end

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
  vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end)



lsp.configure('lua_ls', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

-- /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp


-- require'xbase'.setup({
--     log_level = vim.log.levels.INFO,
--     log_buffer = {
--         focus  = false,
--         default_direction = "horizontal",
--     },
--     sourcekit = {
--     },
--     simctl = {
--         iOS = {
--             "iPhone 14 Pro",
--         },
--     },
--     mappings = {
--         --- Whether xbase mapping should be disabled.
--         enable = true,
--         --- Open build picker. showing targets and configuration.
--         build_picker = 0, --- set to 0 to disable
--         --- Open run picker. showing targets, devices and configuration
--         run_picker = 0, --- set to 0 to disable
--         --- Open watch picker. showing run or build, targets, devices and configuration
--         watch_picker = 0, --- set to 0 to disable
--         --- A list of all the previous pickers
--         all_picker = "<leader>ef", --- set to 0 to disable
--     },
-- })


local lsp_config = require('lspconfig')
lsp_config.sourcekit.setup{
    -- cmd = { '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp' },
    root_dir = lsp_config.util.root_pattern("Package.swift", ".git", "*.xcodeproj"),
}

lsp.setup()


-- local Remap = require("galacticcoder.keymap")
-- local nnoremap = Remap.nnoremap
-- local inoremap = Remap.inoremap
--
-- -- setup mason
-- require("mason").setup()
--
-- -- Setup nvim-cmp.
-- local cmp = require("cmp")
-- local source_mapping = {
-- 	buffer = "[Buffer]",
-- 	nvim_lsp = "[LSP]",
-- 	nvim_lua = "[Lua]",
-- 	cmp_tabnine = "[TN]",
-- 	path = "[Path]",
-- }
-- local lspkind = require("lspkind")
--
-- cmp.setup({
-- 	snippet = {
-- 		expand = function(args)
-- 			-- For `vsnip` user.
-- 			-- vim.fn["vsnip#anonymous"](args.body)
--
-- 			-- For `luasnip` user.
-- 			require("luasnip").lsp_expand(args.body)
--
-- 			-- For `ultisnips` user.
-- 			-- vim.fn["UltiSnips#Anon"](args.body)
-- 		end,
-- 	},
-- 	mapping = cmp.mapping.preset.insert({
--         ['<Tab>'] = cmp.mapping.confirm({ select = true }),
-- 		["<C-u>"] = cmp.mapping.scroll_docs(-4),
-- 		["<C-d>"] = cmp.mapping.scroll_docs(4),
-- 		["<C-Space>"] = cmp.mapping.complete(),
-- 	}),
--
-- 	formatting = {
-- 		format = function(entry, vim_item)
-- 			vim_item.kind = lspkind.presets.default[vim_item.kind]
-- 			local menu = source_mapping[entry.source.name]
-- 			if entry.source.name == "cmp_tabnine" then
-- 				if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
-- 					menu = entry.completion_item.data.detail .. " " .. menu
-- 				end
-- 				vim_item.kind = ""
-- 			end
-- 			vim_item.menu = menu
-- 			return vim_item
-- 		end,
-- 	},
--
-- 	sources = {
-- 		-- tabnine completion? yayaya
--
-- 		-- { name = "cmp_tabnine" },
--
-- 		{ name = "nvim_lsp" },
--
-- 		-- For vsnip user.
-- 		-- { name = 'vsnip' },
--
-- 		-- For luasnip user.
-- 		{ name = "luasnip" },
--
-- 		-- For ultisnips user.
-- 		-- { name = 'ultisnips' },
--
-- 		{ name = "buffer" },
-- 	},
-- })
--
--
-- local function config(_config)
-- 	return vim.tbl_deep_extend("force", {
-- 		on_attach = function()
--             local opts = { buffer = true };
-- 			nnoremap("gd", function() vim.lsp.buf.definition() end, opts)
-- 			nnoremap("K", function() vim.lsp.buf.hover() end, opts)
-- 			nnoremap("<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
-- 			nnoremap("<leader>vd", function() vim.diagnostic.open_float() end, opts)
-- 			nnoremap("[d", function() vim.diagnostic.goto_next() end, opts)
-- 			nnoremap("]d", function() vim.diagnostic.goto_prev() end, opts)
-- 			nnoremap("<leader>vca", function() vim.lsp.buf.code_action() end, opts)
-- 			nnoremap("<leader>vco", function() vim.lsp.buf.code_action({
--                 filter = function(code_action)
--                     if not code_action or not code_action.data then
--                         return false
--                     end
--
--                     local data = code_action.data.id
--                     return string.sub(data, #data - 1, #data) == ":0"
--                 end,
--                 apply = true
--             }) end, opts)
-- 			nnoremap("<leader>vrr", function() vim.lsp.buf.references() end, opts)
-- 			nnoremap("<leader>vrn", function() vim.lsp.buf.rename() end, opts)
-- 			inoremap("<C-h>", function() vim.lsp.buf.signature_help() end, opts)
-- 		end,
-- 	}, _config or {})
-- end
--
--
--
-- require("lspconfig").ccls.setup(config())
--
-- require("lspconfig").pyright.setup(config())
--
-- require("lspconfig").gopls.setup(config({
-- 	cmd = { "gopls", "serve" },
-- 	settings = {
-- 		gopls = {
-- 			analyses = {
-- 				unusedparams = true,
-- 			},
-- 			staticcheck = true,
-- 		},
-- 	},
-- }))
--
-- -- who even uses this?
-- require("lspconfig").rust_analyzer.setup(config({
-- 	cmd = { "rustup", "run", "nightly", "rust-analyzer" },
--     settings = {
--         rust = {
--             unstable_features = true,
--             build_on_save = false,
--             all_features = true,
--         },
--     }
-- }))
--
-- require("lspconfig").sumneko_lua.setup(config({
-- 	settings = {
-- 		Lua = {
-- 			runtime = {
-- 				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
-- 				version = "LuaJIT",
-- 				-- Setup your lua path
-- 				path = vim.split(package.path, ";"),
-- 			},
-- 			diagnostics = {
-- 				-- Get the language server to recognize the `vim` global
-- 				globals = { "vim" },
-- 			},
-- 			workspace = {
-- 				-- Make the server aware of Neovim runtime files
-- 				library = {
-- 					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
-- 					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
-- 				},
-- 			},
-- 		},
-- 	},
-- }))
--
-- local opts = {
-- 	-- whether to highlight the currently hovered symbol
-- 	-- disable if your cpu usage is higher than you want it
-- 	-- or you just hate the highlight
-- 	-- default: true
-- 	highlight_hovered_item = true,
--
-- 	-- whether to show outline guides
-- 	-- default: true
-- 	show_guides = true,
-- }
--
-- require("symbols-outline").setup(opts)
--
-- local snippets_paths = function()
-- 	local plugins = { "friendly-snippets" }
-- 	local paths = {}
-- 	local path
-- 	local root_path = vim.env.HOME .. "/.vim/plugged/"
-- 	for _, plug in ipairs(plugins) do
-- 		path = root_path .. plug
-- 		if vim.fn.isdirectory(path) ~= 0 then
-- 			table.insert(paths, path)
-- 		end
-- 	end
-- 	return paths
-- end
--
-- require("luasnip.loaders.from_vscode").lazy_load({
-- 	paths = snippets_paths(),
-- 	include = nil, -- Load all languages
-- 	exclude = {},
-- })
--
