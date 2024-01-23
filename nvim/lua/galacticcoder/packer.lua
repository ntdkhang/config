--[[
return require("packer").startup(function(use)
    use("wbthomason/packer.nvim")

    -- Simple plugins can be specified as strings

    -- TJ created lodash of neovim
    use("nvim-lua/plenary.nvim")
    use("nvim-lua/popup.nvim")
    use("nvim-telescope/telescope.nvim")

    -- display status line
    use({
        'nvim-lualine/lualine.nvim',
        config = function()
            require("lualine").setup({
                options = { theme = 'gruvbox-material' }
            })
        end
    })


    -- All the things
    use("nvim-tree/nvim-tree.lua") -- file explorer tree
    use("nvim-tree/nvim-web-devicons") -- icons for nvim tree
    -- use("akinsho/toggleterm.nvim") -- floating, toggle floating, toggle  terminal
    use("numToStr/Comment.nvim") -- comment code
    use("windwp/nvim-autopairs") -- auto pairs brackets
    -- use("lukas-reineke/indent-blankline.nvim") -- show indent of each line

    -- use({"nvim-treesitter/nvim-treesitter-context",
    --     config = function()
    --         require("treesitter-context").setup({})
    --     end
    -- }) -- show function name on top

    -- LSP
    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    }


    -- Primeagen doesn"t create lodash
    use("ThePrimeagen/refactoring.nvim")
    use("ThePrimeagen/git-worktree.nvim")
    use("ThePrimeagen/harpoon")

    use("mbbill/undotree")

    -- Colorscheme section
    use("ellisonleao/gruvbox.nvim")
    use("rebelot/kanagawa.nvim")

    use("nvim-treesitter/nvim-treesitter", {
        run = ":TSUpdate"
    })

    use("mfussenegger/nvim-dap")
    use("rcarriga/nvim-dap-ui")
    use("theHamsta/nvim-dap-virtual-text")


    -- NOTES
    -- use("renerocksai/telekasten.nvim")
    use("mickael-menu/zk-nvim")
--  use({
--      "epwalsh/obsidian.nvim",
--      requires = {
--          -- Required.
--          "nvim-lua/plenary.nvim",

--          -- see below for full list of optional dependencies 👇
--      }
--  })


end)

--]]


