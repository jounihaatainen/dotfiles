-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  }

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets'
    },
  }

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  use 'nvim-treesitter/nvim-treesitter-context' -- Show context

  -- Debugging support
  use 'mfussenegger/nvim-dap'
  use { 'rcarriga/nvim-dap-ui', requires = { 'mfussenegger/nvim-dap' } }
  use { 'theHamsta/nvim-dap-virtual-text', requires = { 'mfussenegger/nvim-dap', 'nvim-treesitter/nvim-treesitter' } }

  --  -- Git related plugins
  --  use 'tpope/vim-fugitive'
  --  use 'tpope/vim-rhubarb'
  --  use 'lewis6991/gitsigns.nvim'

  use { -- Colorscheme
    "catppuccin/nvim",
    as = "catppuccin",
    config = function()
      vim.g.catppuccin_flavour = "frappe" -- latte, frappe, macchiato, mocha
      require("catppuccin").setup({
        -- transparent_background = true,
        -- term_colors = true,
        integrations = {
          cmp = true,
          markdown = true,
          neogit = true,
          symbols_outline = true,
          telescope = true,
          treesitter = true,
          treesitter_context = true,
          dap = {
            enabled = true,
            enable_ui = true,
          },
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
          },
        },
        -- TODO: Why does this not work?
        highlight_overrides = {
          all = function(colors) -- Global highlight, will be replaced with custom_highlights if exists
            return {
              DapBreakpoint = { fg = colors.red },
              DapBreakpointCondition = { fg = colors.red },
              DapLogPoint = { fg = colors.sapphire },
              DapStopped = { fg = colors.green },
            }
          end, -- Same for each flavour
          -- latte = function(latte) end,
          -- frappe = function(frappe) end,
          -- macchiato = function(macchiato) end,
          -- mocha = function(mocha) end,
        },
      })
      vim.api.nvim_command "colorscheme catppuccin"
    end
  }

  use { -- Lualine
    "nvim-lualine/lualine.nvim",
    requires = { "nvim-tree/nvim-web-devicons" },
  }

  use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  use 'RRethy/vim-illuminate' -- Highlight current word

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

  use 'jlcrochet/vim-razor' -- Razor highlighting

  use "Exafunction/codeium.vim" -- Codeium

  use {
    "jackMort/ChatGPT.nvim",
    requires = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    },
  }

  use '~/Documents/personal/quiver.nvim'

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = true

-- Make line numbers default and show relative line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- Highlight current line
vim.o.cursorline = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Indent settings
vim.o.expandtab = true
vim.o.shiftround = true
vim.o.shiftwidth = 4
vim.o.softtabstop = -1
vim.o.tabstop = 4
vim.o.smartindent = true

-- Where to create new splits
vim.o.splitbelow = true
vim.o.splitright = true

-- Scroll offsets
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

-- Don't show mode because it's shown in lualine
vim.o.showmode = false

-- Folding
vim.o.foldlevel = 20
-- vim.o.foldmethod = 'expr'
-- vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
-- vim.o.foldenable = false
vim.o.foldmethod = 'indent'
vim.o.foldnestmax = 3

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Better escape using kj in insert and terminal mode
vim.keymap.set("i", "kj", "<ESC>", { silent = true })
vim.keymap.set("t", "kj", "<ESC>", { silent = true })

-- Center search results
vim.keymap.set("n", "n", "nzzzv", { silent = true })
vim.keymap.set("n", "N", "Nzzzv", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Better indent
vim.keymap.set("v", "<", "<gv", { silent = true })
vim.keymap.set("v", ">", ">gv", { silent = true })

-- Yank to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y", { silent = true })
vim.keymap.set("n", "<leader>Y", "\"+yg_", { silent = true })
vim.keymap.set("v", "<leader>y", "\"+y", { silent = true })

-- Paste from system clipboard
vim.keymap.set("n", "<leader>p", "\"+p", { silent = true })
vim.keymap.set("n", "<leader>P", "\"+P", { silent = true })
vim.keymap.set("v", "<leader>p", "\"+p", { silent = true })
vim.keymap.set("v", "<leader>P", "\"+P", { silent = true })

-- Move selected line / block of text in visual mode
vim.keymap.set("x", "J", ":move '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("x", "K", ":move '<-2<CR>gv=gv", { silent = true })

-- Switch buffer
-- vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { silent = true })
-- vim.keymap.set("n", "<S-l>", ":bnext<CR>", { silent = true })

-- Resizing panes
vim.keymap.set("n", "<Left>", ":vertical resize -1<CR>", { silent = true })
vim.keymap.set("n", "<Right>", ":vertical resize +1<CR>", { silent = true })
vim.keymap.set("n", "<Up>", ":resize -1<CR>", { silent = true })
vim.keymap.set("n", "<Down>", ":resize +1<CR>", { silent = true })

-- Switch between source and header
local alternate_files = require("alternate_files")
alternate_files.setup(alternate_files.default_extension_patterns())
vim.keymap.set("n", "<leader>t", alternate_files.open_alternate_file, { silent = true })

-- Codeium
-- See `:help codeium`
vim.g.codeium_disable_bindings = 1
-- vim.g.codeium_manual = 1
vim.keymap.set('i', '<Tab>', function() return vim.fn['codeium#Accept']() end, { silent = true, expr = true })
vim.keymap.set('i', '<S-Tab>', function() return vim.fn['codeium#Complete']() end, { silent = true, expr = true })
vim.keymap.set('i', '<M-Tab>', function() return vim.fn['codeium#CycleCompletions'](1) end, { silent = true, expr = true })
vim.keymap.set('i', '<C-X>', function() return vim.fn['codeium#Clear']() end, { silent = true, expr = true })

-- ChatGPT
vim.keymap.set('v', '<leader>le', function() require("chatgpt").edit_with_instructions() end, { expr = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Copy absolute path to the file in the current buffer
vim.api.nvim_create_user_command("CopyAbsPath", function()
  vim.api.nvim_call_function("setreg", { "+", vim.fn.expand("%:p") })
end, {})

-- Copy relative path to the file in the current buffer
vim.api.nvim_create_user_command("CopyRelPath", function()
  vim.api.nvim_call_function("setreg", { "+", vim.fn.fnamemodify(vim.fn.expand("%"), ":.") })
end, {})

-- Helper functions for lualine setup
local get_icon_for_current_file = function()
  local current_filename = vim.api.nvim_buf_get_name(0)
  local filename = vim.fn.fnamemodify(current_filename, ':t')
  local extension = vim.fn.fnamemodify(current_filename, ':e')
  return require('nvim-web-devicons').get_icon(filename, extension, { default = true })
end

local get_cwd = function()
  return '󰉋 ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
end

local get_lsp_status = function()
  local bufnr = vim.api.nvim_win_get_buf(0)
  if vim.tbl_count(vim.lsp.get_active_clients({ bufnr = bufnr })) == 0 then return '' end
  return '󰚩 Lsp'
end

-- get codeium status
local function get_codeium_status()
  local status = vim.fn['codeium#GetStatusString']()
  if status == "OFF" then return '' end
  if status == " ON" then return '' end
  if status == " * " then return ' ...' end
  if status == "   " then return '' end
  if status == " 0 " then return '' end
  return ' ' .. status
end

-- Set lualine as statusline
-- See `:help lualine.txt`
local custom_lualine_theme = require('custom-lualine-catppuccin-theme')
require('lualine').setup {
  options = {
    icons_enabled = true,
    -- theme = 'catppuccin',
    theme = custom_lualine_theme,
    component_separators = '',
    section_separators = { left = '', right = '' },
    globalstatus = true, -- Use a single global status line for all windows
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { },
    lualine_c = {
      { "location", padding = { left = 2 } },
      { "progress", padding = { left = 2, right = 0 } },
      "%=",
      "diagnostics",
    },
    lualine_x = {
      { "branch", icon = '', padding = { left = 1, right = 1 } },
      { get_lsp_status },
      { get_codeium_status },
    },
    lualine_y = {
      { get_icon_for_current_file, padding = { left = 1, right = 0 } },
      { "filename" },
    },
    lualine_z = { get_cwd }
  },
  extensions = { 'nvim-dap-ui' },
}

-- Enable Comment.nvim
require('Comment').setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require('indent_blankline').setup {
  char = '┊',
  show_trailing_blankline_indent = false,
}

-- Gitsigns
-- See `:help gitsigns.txt`
-- require('gitsigns').setup {
--   signs = {
--     add = { text = '+' },
--     change = { text = '~' },
--     delete = { text = '_' },
--     topdelete = { text = '‾' },
--     changedelete = { text = '~' },
--   },
-- }

-- Illuminate setup
require('illuminate').configure({
  -- min_count_to_highlight: minimum number of matches required to perform highlighting
  min_count_to_highlight = 2,
})
vim.cmd('hi def IlluminatedWordText guibg=#51576d')
vim.cmd('hi def IlluminatedWordRead guibg=#51576d')
vim.cmd('hi def IlluminatedWordWrite guibg=#51576d')

-- Quiver setup
require("quiver").setup()
vim.keymap.set("n", "<leader>b", "<cmd>lua require('quiver').add_current()<cr>", { desc = "Add to quiver" })
vim.keymap.set("n", "<leader>v", "<cmd>lua require('quiver').pick()<cr>", { desc = "Pick from quiver" })
vim.keymap.set("n", "<leader>g", "<cmd>lua require('quiver').pick_in_float({ center_to_window = true })<cr>", { desc = "Pick from quiver in float" })
vim.keymap.set("n", "<leader>1", "<cmd>lua require('quiver').go(1)<cr>zz", { desc = "Go to quiver location in index 1" })
vim.keymap.set("n", "<leader>2", "<cmd>lua require('quiver').go(2)<cr>zz", { desc = "Go to quiver location in index 2" })
vim.keymap.set("n", "<leader>3", "<cmd>lua require('quiver').go(3)<cr>zz", { desc = "Go to quiver location in index 3" })

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    layout_strategy = 'vertical',
    layout_config = {
      vertical = { width = 0.9 },
    },
    path_display = { "smart" },
    mappings = {
      i = {
        ["<C-j>"] = require('telescope.actions').move_selection_next,
        ["<C-k>"] = require('telescope.actions').move_selection_previous,
        ["<C-p>"] = require('telescope.actions').cycle_history_prev,
        ["<C-n>"] = require('telescope.actions').cycle_history_next
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sm', require('telescope.builtin').man_pages, { desc = '[S]earch [M]an Pages' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>st', require('telescope.builtin').treesitter, { desc = '[S]earch by [T]reesitter' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    'bash',
    'c', 'cpp', 'c_sharp',
    'dockerfile',
    'gitcommit', 'gitignore', 'go',
    'html',
    'javascript', 'json',
    'lua',
    'markdown', 'markdown_inline',
    'python',
    'rust',
    'typescript',
    'help',
    'vim'
  },

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Jump to context (with treesitter)
vim.keymap.set("n", "[c", function() require("treesitter-context").go_to_context() end, { silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>f', function() require('telescope.builtin').diagnostics({ bufnr=0 }) end, { desc = 'Document Diagnostics' })

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  local nmap = function(keys, func, desc)
    if desc ~= nil then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>la', vim.lsp.buf.code_action, '[L]sp Code [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  -- nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  -- XXX: Hack to make Omnisharp's semantic tokens names adhere to the spec
  if client.name == 'omnisharp' then
    local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
    for i, v in ipairs(tokenModifiers) do
      local tmp = string.gsub(v, ' ', '_')
      tokenModifiers[i] = string.gsub(tmp, '-_', '')
    end
    local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
    for i, v in ipairs(tokenTypes) do
      local tmp = string.gsub(v, ' ', '_')
      tokenTypes[i] = string.gsub(tmp, '-_', '')
    end
  end
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  tsserver = {},
  rust_analyzer = {},
  omnisharp = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- Set custom signs for lsp diagnostics
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})
vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded"
})

-- Setup debugging support
local dap = require('dap')
local dapui = require('dapui')

dap.adapters.coreclr = {
  type = 'executable',
  command = os.getenv('HOME') .. '/.bin/netcoredbg/netcoredbg',
  args = {'--interpreter=vscode'}
}

-- vim.g.dap_dotnet_build_project = function()
--   local default_path = vim.fn.getcwd() .. '/'
--   if vim.g['dotnet_last_proj_path'] ~= nil then
--     default_path = vim.g['dotnet_last_proj_path']
--   end
--   local path = vim.fn.input({ prompt = 'Path to your *proj file', default = default_path, completion = 'file' })
--   vim.g['dotnet_last_proj_path'] = path
--   local cmd = 'dotnet build -c Debug ' .. path .. ' > /dev/null'
--   print('')
--   print('Cmd to execute: ' .. cmd)
--   local f = os.execute(cmd)
--   if f == 0 then
--     print('\nBuild: 👍 ')
--   else
--     print('\nBuild: ⛔️ (code: ' .. f .. ')')
--   end
-- end

vim.g.dap_dotnet_get_dll_path = function()
  local request = function()
    return vim.fn.input({ prompt = 'Path to dll: ', default = vim.fn.getcwd() .. '/bin/Debug/', completion = 'file' })
  end
  if vim.g['dap_dotnet_last_dll_path'] == nil then
    vim.g['dap_dotnet_last_dll_path'] = request()
  else
    if vim.fn.confirm('Do you want to change the path to dll?\n' .. vim.g['dap_dotnet_last_dll_path'], '&yes\n&no', 2) == 1 then
      vim.g['dap_dotnet_last_dll_path'] = request()
    end
  end
  return vim.g['dap_dotnet_last_dll_path']
end

vim.g.dap_get_cmdline_args = function()
  local request = function(default_args)
    return vim.fn.input({ prompt = 'Command line arguments: ', default = default_args })
  end
  if vim.g['dap_last_cmdline_args'] == nil then
    vim.g['dap_last_cmdline_args'] = request()
  else
    if vim.fn.confirm('Do you want to change the command line arguments?\n' .. vim.g['dap_last_cmdline_args'], '&yes\n&no', 2) == 1 then
      vim.g['dap_last_cmdline_args'] = request(vim.g['dap_last_cmdline_args'])
    end
  end
  return vim.g['dap_last_cmdline_args']
end

local dap_cs_config = {
  {
    type = "coreclr",
    name = "Launch - netcoredbg manually",
    request = "launch",
    program = function()
      -- if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
      --   vim.g.dap_dotnet_build_project()
      -- end
      return vim.g.dap_dotnet_get_dll_path()
    end,
    args = function()
      if vim.fn.confirm('Do you want to give command line arguments to executable?', '&yes\n&no', 2) == 1 then
        return { vim.g.dap_get_cmdline_args() }
      end
      return {}
    end,
  },
}

dap.configurations.cs = dap_cs_config
dap.configurations.fsharp = dap_cs_config
require('dap.ext.vscode').load_launchjs(nil, { coreclr = { 'cs', 'fsharp' } })

-- Custom colors for debugging signs
local frappe = require("catppuccin.palettes").get_palette("frappe")
vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = frappe.red })
vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = frappe.sapphire })
vim.api.nvim_set_hl(0, 'DapStopped', { fg = frappe.green })
vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = 'ﳁ', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = '', numhl = '' })

vim.keymap.set('n', '<F4>', function() require('dap').terminate() end, { desc = "Dbg: Terminate" })
vim.keymap.set('n', '<F5>', function() require('dap').continue() end, { desc = "Dbg: Continue" })
vim.keymap.set('n', '<leader><F5>', function() require('dap').run_to_cursor() end, { desc = "Dbg: Run to Cursor" })
vim.keymap.set('n', '<F6>', function() require('dap').step_over() end, { desc = "Dbg: Step Over" })
vim.keymap.set('n', '<F7>', function() require('dap').step_into() end, { desc = "Dbg: Step Into" })
vim.keymap.set('n', '<F8>', function() require('dap').step_out() end, { desc = "Dbg: Step Out" })
vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end, { desc = "[D]bg: Toggle [B]reakpoint" })
vim.keymap.set('n', '<Leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = "[D]bg: Set Conditional [B]reakpoint" })
vim.keymap.set('n', '<Leader>lp', function()
    require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
end, { desc = "Dbg: Set [L]og [P]oint" })
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end, { desc = "[D]bg: Open [R]epl" })
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end, { desc = "[D]bg: Run Last" })
vim.keymap.set('n', '<Leader>du', function() require('dap').up() end, { desc = "[D]bg: Go [U]p in current stacktrace" })
vim.keymap.set('n', '<Leader>dd', function() require('dap').down() end, { desc = "[D]bg: Go [D]own in current stacktrace" })
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
  require('dap.ui.widgets').hover()
end, { desc = "[D]bg: Hover ??" })
vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
  require('dap.ui.widgets').preview()
end, { desc = "[D]bg: Preview ??" })
vim.keymap.set('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end, { desc = "[D]bg: Show [F]rames" })
vim.keymap.set('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end, { desc = "[D]bg: Show [S]copes" })
vim.keymap.set('n', '<Leader>do', function() require('dapui').open() end, { desc = "[D]bg: [O]pen dap-ui" })
vim.keymap.set('n', '<Leader>dq', function() require('dapui').close() end, { desc = "[D]bg: [Q]uit dap-ui" })

dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Use this to override mappings for specific elements
  element_mappings = {
    -- Example:
    -- stacks = {
    --   open = "<CR>",
    --   expand = "o",
    -- }
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has("nvim-0.7") == 1,
  -- Layouts define sections of the screen to place windows.
  -- The position can be "left", "right", "top" or "bottom".
  -- The size specifies the height/width depending on position. It can be an Int
  -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
  -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
  -- Elements are the elements shown in the layout (in order).
  -- Layouts are opened in order so that earlier layouts take priority in window sizing.
  layouts = {
    {
      elements = {
      -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
  controls = {
    -- Requires Neovim nightly (or 0.8 when released)
    enabled = true,
    -- Display controls in this element
    element = "repl",
    icons = {
      pause = "",
      play = "",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "↻",
      terminate = "□",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
    max_value_lines = 100, -- Can be integer or nil.
  }
})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

require('nvim-dap-virtual-text').setup({
  commented = true
})

-- ChatGPT
require("chatgpt").setup({
  -- api_key_cmd = 'op read "op://private/Open AI/apikey" --no-newline'
  api_key_cmd = 'cat ' .. vim.fn.expand("$HOME") .. '/.openai_key'
})

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-p>'] = cmp.mapping.scroll_docs(-4),
    ['<C-n>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<C-j>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-k>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-h>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-f>'] = cmp.mapping(function(fallback)
      if luasnip.choice_active() then
        luasnip.change_choice(1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-d>'] = cmp.mapping(function(fallback)
      if luasnip.choice_active() then
        luasnip.change_choice(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- luasnip configuration
local ls = require('luasnip')
local snippets = require('snippets')
local types = require("luasnip.util.types")

ls.config.set_config({
  history = true,
  update_events = "TextChanged,TextChangedI",
  delete_checked_events = "TextChanged",
  ext_base_prio = 300,
  ext_prio_increase = 1,
  -- store_selection_keys = '<c-j>',
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "<- [choice]", "Error" } },
      }
    }
  }
})
ls.filetype_extend("javascriptreact", { "html" })
ls.filetype_extend("typescriptreact", { "html" })
ls.filetype_extend("razor", { "html" })

snippets.add_snippets({ override_priority = 1100 })
require("luasnip.loaders.from_vscode").lazy_load()

-- XXX: Disable semantic highlighting because it is a mess with C# at the moment
-- vim.api.nvim_create_autocmd('ColorScheme', {
--   callback = function ()
--     -- Hide semantic highlights for functions
--     vim.api.nvim_set_hl(0, '@lsp.type.function', {})
--     -- Hide all semantic highlights
--     for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
--       vim.api.nvim_set_hl(0, group, {})
--     end
--   end
-- })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
