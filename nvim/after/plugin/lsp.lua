local lsp_zero = require('lsp-zero')
local util = require("lspconfig.util")
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())


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
    handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, 'rounded'),
        ["txtdocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, 'rounded'),
    },
})

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({buffer = bufnr})
end)

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
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>rr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("i", "<C-k>", function() require('lsp_signature').toggle_float_win() end, opts)

end)



-- copy paste from (https://github.com/hrsh7th/nvim-cmp/issues/156#issuecomment-916338617)
-- use for reordering the autocomplete
local lspkind_comparator = function(conf)
    local lsp_types = require('cmp.types').lsp
    return function(entry1, entry2)
        if entry1.source.name ~= 'nvim_lsp' then
            if entry2.source.name == 'nvim_lsp' then
                return false
            else
                return nil
            end
        end
        local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
        local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

        local priority1 = conf.kind_priority[kind1] or 0
        local priority2 = conf.kind_priority[kind2] or 0
        if priority1 == priority2 then
            return nil
        end
        return priority2 < priority1
    end
end

local label_comparator = function(entry1, entry2)
    return entry1.completion_item.label < entry2.completion_item.label
end

local cmp = require('cmp')
local cmp_format = lsp_zero.cmp_format()

cmp.setup({
    preselect = 'none',
    completion = {
        completeopt = 'menu,menuone,noinsert,noselect'
    },
    formatting = { -- copy from [https://github.com/hrsh7th/nvim-cmp/discussions/609#discussioncomment-5727678]
        fields = { "abbr", "menu", "kind" },
        format = function(entry, item)
            -- Define menu shorthand for different completion sources.
            local menu_icon = {
                nvim_lsp = "LSP",
                nvim_lua = "LUA",
                luasnip  = "SNIP",
                buffer   = "BUFF",
                path     = "PATH",
            }
            -- Set the menu "icon" to the shorthand for each completion source.
            item.menu = menu_icon[entry.source.name]

            -- Set the fixed width of the completion menu to 60 characters.
            -- fixed_width = 20

            -- Set 'fixed_width' to false if not provided.
            local fixed_width =  false

            -- Get the completion entry text shown in the completion window.
            local content = item.abbr

            -- Set the fixed completion window width.
            if fixed_width then
                vim.o.pumwidth = fixed_width
            end

            -- Get the width of the current window.
            local win_width = vim.api.nvim_win_get_width(0)

            -- Set the max content width based on either: 'fixed_width'
            -- or a percentage of the window width, in this case 20%.
            -- We subtract 10 from 'fixed_width' to leave room for 'kind' fields.
            local max_content_width = fixed_width and fixed_width - 10 or math.floor(win_width * 0.3)

            -- Truncate the completion entry text if it's longer than the
            -- max content width. We subtract 3 from the max content width
            -- to account for the "..." that will be appended to it.
            if #content > max_content_width then
                item.abbr = vim.fn.strcharpart(content, 0, max_content_width - 3) .. "..."
            else
                item.abbr = content .. (" "):rep(max_content_width - #content)
            end
            return item
        end,
    },
    sources = {
        {name = 'nvim_lsp'},
        {name = 'path'},
        {name = 'buffer'},
    },
    -- formatting = cmp_format,
    mapping = cmp.mapping.preset.insert({
        -- scroll up and down the documentation window
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        --[[ ['<C-k'] = cmp.mapping({
            function(fallback)
                if !cmp.visible() then
                    cmp.select_next_item
        }), ]]
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
                    local status_ok, luasnip = pcall(require, "luasnip")
                    if status_ok and luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end
            end, { "i", "s" }
        ),
        ["<S-Tab>"] = cmp.mapping(
            function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    local status_ok, luasnip = pcall(require, "luasnip")
                    if status_ok and luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end
            end, { "i", "s" }
        ),

    }),
    sorting = {
        -- copy paste from (https://github.com/hrsh7th/nvim-cmp/issues/156#issuecomment-916338617)
        -- use for reordering the autocomplete
        comparators = {
            lspkind_comparator({
                kind_priority = {
                    Field = 11,
                    Property = 11,
                    Constant = 10,
                    Enum = 10,
                    EnumMember = 10,
                    Event = 10,
                    Function = 10,
                    Method = 10,
                    Operator = 10,
                    Reference = 10,
                    Struct = 10,
                    Variable = 9,
                    File = 8,
                    Folder = 8,
                    Class = 5,
                    Color = 5,
                    Module = 5,
                    Keyword = 2,
                    Constructor = 12,
                    Interface = 1,
                    Snippet = 0,
                    Text = 1,
                    TypeParameter = 1,
                    Unit = 1,
                    Value = 1,
                },
            }),
            label_comparator,
        },
    }
})

-- copy paste from (https://github.com/L3MON4D3/LuaSnip/issues/258#issuecomment-1429989436)
-- to avoid jumping to previous snippet
vim.api.nvim_create_autocmd('ModeChanged', {
  pattern = '*',
  callback = function()
    if ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
        and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require('luasnip').session.jump_active
    then
      require('luasnip').unlink_current()
    end
  end
})


