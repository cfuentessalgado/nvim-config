local packer = require("packer")
packer.startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'folke/tokyonight.nvim'
    use "williamboman/nvim-lsp-installer"
    use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use {
        'hrsh7th/nvim-cmp',
        config = function() require('cfuentes.completion').setup() end,
    }
    use {
        'L3MON4D3/LuaSnip',
        after = 'nvim-cmp',
        config = function() require('cfuentes.completion').setup() end,
    }
    use 'saadparwaiz1/cmp_luasnip'
    -- Lua
    use {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup {
            }
        end
    }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use 'lewis6991/gitsigns.nvim'
    use 'windwp/nvim-autopairs'
    use 'numToStr/Comment.nvim'
    use 'sheerun/vim-polyglot'
end)
