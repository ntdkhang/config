local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require("lazy").setup({
    -- TJ created lodash of neovim
    "nvim-lua/plenary.nvim",
    "nvim-lua/popup.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    'nvim-telescope/telescope-media-files.nvim',


    -- display status line
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require("lualine").setup({
                options = { theme = 'gruvbox-material' }
            })
        end
    },



    -- All the things
    -- "nvim-tree/nvim-tree.lua", -- file explorer tree
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        }
    },
    "nvim-tree/nvim-web-devicons", -- icons for nvim tree
    "numToStr/Comment.nvim", -- comment code
    "windwp/nvim-autopairs", -- auto pairs brackets
    -- "lukas-reineke/indent-blankline.nvim", -- show indent of each line

    -- {"nvim-treesitter/nvim-treesitter-context",
    --     config = function()
    --         require("treesitter-context").setup({})
    --     end
    -- } ,
    -- show function name on top

    -- LSP
    {
        'VonHeikemen/lsp-zero.nvim',
        dependencies = {
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
            {'hrsh7th/cmp-nvim-lsp-signature-help'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    },

    "ray-x/lsp_signature.nvim",


    -- Primeagen doesn"t create lodash
    "ThePrimeagen/refactoring.nvim",
    "ThePrimeagen/git-worktree.nvim",
    "ThePrimeagen/harpoon",

    "mbbill/undotree",


    -- Colorscheme section
    "ellisonleao/gruvbox.nvim",
    "rebelot/kanagawa.nvim",
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },


    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate"
    },

    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",


    -- NOTES
    "renerocksai/telekasten.nvim",
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },



    -- "mickael-menu/zk-nvim",

    -- {
    --     "epwalsh/obsidian.nvim",
    --     dependencies = {
    --         -- Required.
    --         "nvim-lua/plenary.nvim",
    --     },
    -- },



    -- iOS DEV
    {
        "wojciech-kulik/xcodebuild.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("xcodebuild").setup({
                -- put some options here or leave it empty to use default settings
            })
        end,
    },
    {
        'stevearc/conform.nvim',
        opts = {},
    }

})
