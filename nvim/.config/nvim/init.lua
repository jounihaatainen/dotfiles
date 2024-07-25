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

-- Plugins
local plugins = {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require("tokyonight").setup({ style = "storm" })
      vim.cmd [[colorscheme tokyonight]]
    end
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    config = function() require("config.treesitter").setup() end
  },
  {
    'junegunn/fzf.vim',
    dependencies = { 'junegunn/fzf' },
    config = function() require("config.fzf").setup() end
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets"
    },
    config = function() require("config.completion").setup() end
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
    },
    config = function() require("config.lsp").setup() end
  },
  {
    "jlcrochet/vim-razor",
    ft = "razor"
  },
  {
    "Exafunction/codeium.vim",
    -- keys = { "<tab>", "<S-tab>" },
    config = function() vim.g.codeium_disable_bindings = 1 end
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function() require("config.lint").setup() end
  },
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function() require("config.format").setup() end
  },
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gc",  mode = "v" },
      { "gb",  mode = "v" },
      { "gcc", mode = "n" },
      { "gbc", mode = "n" }
    },
    config = function() require("Comment").setup() end
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" }
  }
}

require("config.options").setup()
require("lazy").setup(plugins)
require("config.keymaps").setup()
require("config.commands").setup()
require("config.statusline").setup()
require("altfiles").setup()

-- vim: ts=2 sts=2 sw=2 et
