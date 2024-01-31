local lsp_zero = require('lsp-zero')
local util = require("lspconfig.util")
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

lsp_zero.on_attach(
function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({buffer = bufnr})
end
)

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {'clangd', 'pyright', 'lua_ls', 'gopls'},
    handlers = {
        lsp_zero.default_setup,

        clangd = function()
            require('lspconfig').clangd.setup({
                capabilities = capabilities
            })
        end,

        lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
        end,
    },
})


lsp_zero.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>rr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end)


require('lspconfig').sourcekit.setup({
    capabilities = capabilities,
    cmd = {
        "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp",
    },
    root_dir = function(filename, _)
        return util.root_pattern("buildServer.json")(filename)
        or util.root_pattern("*.xcodeproj", "*.xcworkspace")(filename)
        or util.find_git_ancestor(filename)
        or util.root_pattern("Package.swift")(filename)
    end,
})


local cmp = require('cmp')
local cmp_format = lsp_zero.cmp_format()

cmp.setup({
    preselect = 'none',
    completion = {
        completeopt = 'menu,menuone,noinsert,noselect'
    },
    sources = {
        {name = 'nvim_lsp'},
        {name = 'buffer'},
    },
    -- formatting = cmp_format,
    mapping = cmp.mapping.preset.insert({
        -- scroll up and down the documentation window
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ["<CR>"] = cmp.mapping({
            i = function(fallback)
                if cmp.visible() and cmp.get_active_entry() then
                    cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                else
                    fallback()
                end
            end,
            s = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
        }),
        ["<Tab>"] = cmp.mapping(
            function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    fallback()
                end
            end, { "i", "s" }
        ),
        ["<S-Tab>"] = cmp.mapping(
            function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    fallback()
                end
            end, { "i", "s" }
        ),

    }),
})
--[[
-- copy paste from
-- https://github.com/neovim/nvim-lspconfig/blob/ede4114e1fd41acb121c70a27e1b026ac68c42d6/lua/lspconfig/server_configurations/gopls.lua
local util = require 'lspconfig.util'
local async = require 'lspconfig.async'
-- -> the following line fixes it - mod_cache initially set to value that you've got from `go env GOMODCACHE` command
local mod_cache = '/root/go/pkg/mod'

-- setting the config for gopls, the contents below is also copy-paste from
-- https://github.com/neovim/nvim-lspconfig/blob/ede4114e1fd41acb121c70a27e1b026ac68c42d6/lua/lspconfig/server_configurations/gopls.lua
require('lspconfig.configs').gopls = {
    default_config = {
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        root_dir = function(fname)
            -- see: https://github.com/neovim/nvim-lspconfig/issues/804
            if not mod_cache then
                local result = async.run_command 'go env GOMODCACHE'
                if result and result[1] then
                    mod_cache = vim.trim(result[1])
                end
            end
            if fname:sub(1, #mod_cache) == mod_cache then
                local clients = vim.lsp.get_active_clients { name = 'gopls' }
                if #clients > 0 then
                    return clients[#clients].config.root_dir
                end
            end
            return util.root_pattern 'go.work'(fname) or util.root_pattern('go.mod', '.git')(fname)
        end,
        single_file_support = true,
    }}
]]





--[[ local cmp = require("cmp")


-- Press enter to select suggestion
cmp.setup({
  mapping = {
     ["<CR>"] = cmp.mapping({
       i = function(fallback)
         if cmp.visible() and cmp.get_active_entry() then
           cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
         else
           fallback()
         end
       end,
       s = cmp.mapping.confirm({ select = true }),
       c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
     }),
  }
})
]]
