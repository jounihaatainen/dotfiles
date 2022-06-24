return require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- so packer can update itself

  use 'doums/darcula'
  use 'jlcrochet/vim-razor'
  use 'folke/lsp-colors.nvim'
  use 'mfussenegger/nvim-dap'

  use 'nvim-treesitter/nvim-treesitter'
  use {
    'romgrk/nvim-treesitter-context',
    after = { 'nvim-treesitter' },
    config = function()
        require('treesitter-context').setup({
            enable = true,
            throttle = true,
        })
    end
  }
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'JoosepAlviste/nvim-ts-context-commentstring'
  use 'p00f/nvim-ts-rainbow'
  use 'theHamsta/nvim-dap-virtual-text'

  use 'neovim/nvim-lspconfig' -- native LSP support
  use 'williamboman/nvim-lsp-installer'
  use 'simrat39/symbols-outline.nvim'
  use 'ray-x/lsp_signature.nvim'

  use 'hrsh7th/nvim-cmp' -- autocompletion framework
  use 'hrsh7th/cmp-nvim-lsp' -- LSP autocompletion provider
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'

  use 'windwp/nvim-autopairs'

  use 'vim-test/vim-test'
  use 'b3nj5m1n/kommentary'
  use 'folke/which-key.nvim'

  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  use 'rafamadriz/friendly-snippets'

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use {
      'kyazdani42/nvim-tree.lua',
      requires = {
        'kyazdani42/nvim-web-devicons', -- optional, for file icon
      },
      tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }

  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'
end)
