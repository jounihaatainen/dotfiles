-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
require("config.options").setup()

local keymaps = require("config.keymaps")
keymaps.setup()

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here
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
    {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        ensure_installed = {
	        "bash",
	        "c",
          "c_sharp",
          "css",
          "diff",
          "html",
          "javascript",
          "json",
          "markdown",
          "markdown_inline",
          "lua",
          "razor",
          "vim",
          "vimdoc",
          "xml",
          "yaml",
        },
      },
    },
    {
      "junegunn/fzf.vim",
      dependencies = { "junegunn/fzf" },
      config = function()
        vim.g.fzf_vim = {
          preview_window = {
            "down,50%",
            "ctrl-/",
          }
        }
      end
    },
    {
      "williamboman/mason.nvim",
      opts = {
        registries = {
          "github:mason-org/mason-registry",
          "github:Crashdummyy/mason-registry",
        },
      },
    },
    {
      "seblyng/roslyn.nvim",
      ---@module 'roslyn.config'
      ---@type RoslynNvimConfig
      ft = { "cs", "razor" },
      opts = {
        -- your configuration comes here; leave empty for default settings
      },
      dependencies = {
        {
          -- By loading as a dependencies, we ensure that we are available to set the handlers for Roslyn.
          "tris203/rzls.nvim",
          config = true,
        },
      },
      lazy = false,
      config = function()
        --require("config.lsp").setup_roslyn(function(client, bufnr) keymaps.setup_lsp(client, bufnr) end)
        require("config.lsp").setup_roslyn(keymaps.setup_lsp)
      end,
      init = function()
        -- We add the Razor file types before the plugin loads.
        vim.filetype.add({
          extension = {
            razor = "razor",
            cshtml = "razor",
          },
        })
      end,
    },
    {
      "mfussenegger/nvim-dap",
      dependencies = {
        "rcarriga/nvim-dap-ui",
      },
      config = function()
        require "config.dap"
      end,
      event = "VeryLazy",
    },
    {
      "rcarriga/nvim-dap-ui",
      dependencies = {
        "mfussenegger/nvim-dap",
      },
      config = function()
        require "config.dap-ui"
      end,
    },
    { "nvim-neotest/nvim-nio" },
    {
      "nvim-neotest/neotest",
      commit = "52fca6717ef972113ddd6ca223e30ad0abb2800c", -- REMOVE when finding test works for dotnet
      requires = {
        {
          "Issafalcon/neotest-dotnet",
        }
      },
      dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter"
      }
    },
    {
      "Issafalcon/neotest-dotnet",
      lazy = false,
      dependencies = {
        "nvim-neotest/neotest"
      }
    },
    {
      "rachartier/tiny-inline-diagnostic.nvim",
      event = "VeryLazy", -- Or `LspAttach`
      priority = 1000,    -- needs to be loaded in first
      config = function()
        require('tiny-inline-diagnostic').setup()
        vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
      end
    },
    { 'nvim-mini/mini.completion', version = '*' },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

require('mini.completion').setup()

--require("config.lsp").setup(function(client, bufnr) keymaps.setup_lsp(client, bufnr) end)
require("config.lsp").setup(keymaps.setup_lsp)

require("neotest").setup({
  adapters = {
    require("neotest-dotnet")
  }
})

require("tiny-inline-diagnostic").setup({
  -- signs = {
  --   left = "",
  --   right = "",
  --   diag = "●",
  --   arrow = "    ",
  --   up_arrow = "    ",
  --   vertical = " │",
  --   vertical_end = " └",
  -- },
  -- blend = {
  --   factor = 0.22,
  -- },
})

-- vim: ts=2 sts=2 sw=2 et
