local M = {}

function M.setup()
  local packer_bootstrap = false

  -- packer.nvim configuration
  local config = {
    profile = {
      enable = true,
      threshold = 0
    },
    display = {
      open_fn = function()
        return require("packer.util").float { border = "rounded" }
      end
    }
  }

  -- Check if packer.nvim is installed and install it if not
  -- Run PackerCompile if there is changes in this file
  local function packer_init()
    local fn = vim.fn
    local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
      packer_bootstrap = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path
      }
      vim.cmd [[packadd packer.nvim]]
    end
    vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
  end

  -- Plugins
  local function plugins(use)
    use { "wbthomason/packer.nvim" }

    -- Colorscheme
    use {
      "doums/darcula",
      config = function()
        vim.cmd "colorscheme darcula"
      end
    }

    -- WhichKey
    use {
      "folke/which-key.nvim",
      event = "vimEnter",
      config = function()
        require("config.whichkey").setup()
      end
    }

    -- Plenary
    use {
      "nvim-lua/plenary.nvim",
      module = "plenary"
    }

    -- FZF lua
    use {
      "ibhagwan/fzf-lua",
      event = "BufEnter",
      wants = "nvim-web-devicons",
      requires = { "junegunn/fzf", run = "./install --all" },
    }

   -- Telescope
    use {
      "nvim-telescope/telescope.nvim",
      opt = true,
      config = function()
        require("config.telescope").setup()
      end,
      cmd = { "Telescope" },
      module = "telescope",
      keys = { "<leader>f", "<leader>p" },
      wants = {
        "plenary.nvim",
        "popup.nvim",
        "telescope-fzf-native.nvim",
        "telescope-project.nvim",
        "telescope-repo.nvim",
        "telescope-file-browser.nvim",
        "project.nvim",
      },
      requires = {
        "nvim-lua/popup.nvim",
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
        "nvim-telescope/telescope-project.nvim",
        "cljoly/telescope-repo.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
        {
          "ahmedkhalf/project.nvim",
          config = function()
            require("project_nvim").setup {}
          end,
        },
      },
    }

    -- Completion
    use {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      opt = true,
      config = function()
        require("config.cmp").setup()
      end,
      wants = { "LuaSnip" },
      requires = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lua",
        "ray-x/cmp-treesitter",
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-calc",
        "f3fora/cmp-spell",
        "hrsh7th/cmp-emoji",
        {
          "L3MON4D3/LuaSnip",
          wants = "friendly-snippets",
          config = function()
            require("config.luasnip").setup()
          end,
        },
        "rafamadriz/friendly-snippets",
        disable = false,
      },
    }

    -- Dev Icons
    use {
      "kyazdani42/nvim-web-devicons",
      module = "nvim-web-devicons"
    }

    -- Lualine
    use {
      "nvim-lualine/lualine.nvim",
      requires = { "kyazdani42/nvim-web-devicons", opt = true },
      config = function()
        require("config.lualine").setup()
      end
    }

    -- NvimTree
    use {
      "kyazdani42/nvim-tree.lua",
      event = "VimEnter",
      requires = {
        "kyazdani42/nvim-web-devicons", -- optional, for file icon
      },
      tag = "nightly", -- optional, updated every week. (see issue #1193)
      config = function()
        require("config.nvim-tree").setup()
      end
    }

    -- NeoGit
    use {
      "TimUntersberger/neogit",
      cmd = "NeoGit",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("config.neogit").setup()
      end,
    }

    -- Kommentary
    use {
      "b3nj5m1n/kommentary",
      event = "BufReadPre",
      config = function()
        require("config.kommentary").setup()
      end
    }

    -- Autopairs
    use {
      "windwp/nvim-autopairs",
      event = "BufReadPre",
      config = function ()
        require("config.nvim-autopairs").setup()
      end
    }

    -- Markdown
    use {
      "iamcco/markdown-preview.nvim",
      run = function()
        vim.fn["mkdp#util#install"]()
      end,
      ft = "markdown",
      cmd = { "MarkdownPreview" },
    }

    -- Treesitter
    use {
      "nvim-treesitter/nvim-treesitter",
      opt = true,
      event = "BufRead",
      run = ":TSUpdate",
      config = function()
        require("config.treesitter").setup()
      end,
      requires = {
        { "nvim-treesitter/nvim-treesitter-textobjects" },
        { "JoosepAlviste/nvim-ts-context-commentstring" },
        { "p00f/nvim-ts-rainbow" },
      },
    }

    -- LSP
    use {
      "neovim/nvim-lspconfig",
      opt = true,
      event = "BufReadPre",
      wants = {
        "cmp-nvim-lsp",
        "nvim-lsp-installer",
        "lsp_signature.nvim",
        "lsp-colors.nvim",
        "lua-dev.nvim",
        "vim-illuminate",
      },
      config = function()
        require("config.lsp").setup()
      end,
      requires = {
        "williamboman/nvim-lsp-installer",
        "ray-x/lsp_signature.nvim",
        "folke/lsp-colors.nvim",
        "simrat39/symbols-outline.nvim",
        "folke/lua-dev.nvim",
        "RRethy/vim-illuminate",
      },
    }

    -- Debugging
    use {
      "mfussenegger/nvim-dap",
      opt = true,
      event = "BufReadPre",
      module = { "dap" },
      wants = {
        "nvim-dap-virtual-text",
        "nvim-dap-ui",
        "which-key.nvim",
        --"nvim-dap-python",
      },
      requires = {
        "theHamsta/nvim-dap-virtual-text",
        "rcarriga/nvim-dap-ui",
        "nvim-telescope/telescope-dap.nvim",
        -- "mfussenegger/nvim-dap-python",
        --{ "leoluz/nvim-dap-go", module = "dap-go" },
        --{ "jbyuki/one-small-step-for-vimkind", module = "osv" },
      },
      config = function()
        require("config.dap").setup()
      end,
    }

    if packer_bootstrap then
      print "Restarting Neovim required after installation!"
      require("packer").sync()
    end
  end

  packer_init()

  local packer = require("packer")
  packer.init(config)
  packer.startup(plugins)
end

return M

-- return require('packer').startup(function()
--   use 'wbthomason/packer.nvim' -- so packer can update itself

--   use 'doums/darcula'
--   use 'jlcrochet/vim-razor'
--   use 'folke/lsp-colors.nvim'
--   use 'mfussenegger/nvim-dap'

--   use 'nvim-treesitter/nvim-treesitter'
--   use {
--     'romgrk/nvim-treesitter-context',
--     after = { 'nvim-treesitter' },
--     config = function()
--         require('treesitter-context').setup({
--             enable = true,
--             throttle = true,
--         })
--     end
--   }
--   use 'nvim-treesitter/nvim-treesitter-textobjects'
--   use 'JoosepAlviste/nvim-ts-context-commentstring'
--   use 'p00f/nvim-ts-rainbow'
--   use 'theHamsta/nvim-dap-virtual-text'

--   use 'neovim/nvim-lspconfig' -- native LSP support
--   use 'williamboman/nvim-lsp-installer'
--   use 'simrat39/symbols-outline.nvim'
--   use 'ray-x/lsp_signature.nvim'

--   use 'hrsh7th/nvim-cmp' -- autocompletion framework
--   use 'hrsh7th/cmp-nvim-lsp' -- LSP autocompletion provider
--   use 'hrsh7th/cmp-buffer'
--   use 'hrsh7th/cmp-path'
--   use 'hrsh7th/cmp-cmdline'

--   use 'windwp/nvim-autopairs'

--   use 'vim-test/vim-test'
--   use 'b3nj5m1n/kommentary'
--   use 'folke/which-key.nvim'

--   use 'L3MON4D3/LuaSnip'
--   use 'saadparwaiz1/cmp_luasnip'
--   use 'rafamadriz/friendly-snippets'

--   use {
--     'nvim-lualine/lualine.nvim',
--     requires = { 'kyazdani42/nvim-web-devicons', opt = true }
--   }

--   use {
--       'kyazdani42/nvim-tree.lua',
--       requires = {
--         'kyazdani42/nvim-web-devicons', -- optional, for file icon
--       },
--       tag = 'nightly' -- optional, updated every week. (see issue #1193)
--   }

--   use 'junegunn/fzf'
--   use 'junegunn/fzf.vim'
-- end)
