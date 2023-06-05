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

    use {
        'xbase-lab/xbase',
        run = 'make install', -- or "make install && make free_space" (not recommended, longer build time)
        config = function ()
            require'xbase'.setup({
                log_level = vim.log.levels.INFO,
                log_buffer = {
                    focus  = false,
                    default_direction = "horizontal",
                },
                sourcekit = {
                },
                simctl = {
                    iOS = {
                        "iPhone 14 Pro",
                    },
                },
                mappings = {
                    --- Whether xbase mapping should be disabled.
                    enable = true,
                    --- Open build picker. showing targets and configuration.
                    build_picker = 0, --- set to 0 to disable
                    --- Open run picker. showing targets, devices and configuration
                    run_picker = 0, --- set to 0 to disable
                    --- Open watch picker. showing run or build, targets, devices and configuration
                    watch_picker = 0, --- set to 0 to disable
                    --- A list of all the previous pickers
                    all_picker = "<leader>ef", --- set to 0 to disable
                },
            })
        end
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

	--[[
    --
	-- Lazy loading:
	-- Load on specific commands
	use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}
	-- Load on an autocommand event
	use {'andymass/vim-matchup', event = 'VimEnter'}
	-- Load on a combination of conditions: specific filetypes or commands
	-- Also run code after load (see the "config" key)
	use {
	'w0rp/ale',
	ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex'},
	cmd = 'ALEEnable',
	config = 'vim.cmd[[ALEEnable]]--[['
	}
	-- Plugins can have dependencies on other plugins
	use {
	'haorenW1025/completion-nvim',
	opt = true,
	requires = {{'hrsh7th/vim-vsnip', opt = true}, {'hrsh7th/vim-vsnip-integ', opt = true}}
	}
	-- Plugins can also depend on rocks from luarocks.org:
	use {
	'my/supercoolplugin',
	rocks = {'lpeg', {'lua-cjson', version = '2.1.0'}}
	}
	-- You can specify rocks in isolation
	use_rocks 'penlight'
	use_rocks {'lua-resty-http', 'lpeg'}
	-- Local plugins can be included
	use '~/projects/personal/hover.nvim'
	-- Plugins can have post-install/update hooks
	use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}
	-- Post-install/update hook with neovim command
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	-- Post-install/update hook with call of vimscript function with argument
	use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }
	-- Use specific branch, dependency and run lua file after load
	use {
	'glepnir/galaxyline.nvim', branch = 'main', config = function() require'statusline' end,
	requires = {'kyazdani42/nvim-web-devicons'}
	}
	-- Use dependency and run lua function after load
	use {
	'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
	config = function() require('gitsigns').setup() end
	}
	-- You can specify multiple plugins in a single call
	use {'tjdevries/colorbuddy.vim', {'nvim-treesitter/nvim-treesitter', opt = true}}
	-- You can alias plugin names
	use {'dracula/vim', as = 'dracula'}
	end)
	--]]
end)
