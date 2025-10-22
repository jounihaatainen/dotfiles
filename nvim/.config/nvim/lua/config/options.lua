local M = {}

M.setup = function()
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

  -- Always show signcolumn
  vim.wo.signcolumn = 'yes'

  -- Set colorscheme
  vim.o.termguicolors = true

  -- Set completeopt to have a better completion experience
  vim.opt.completeopt = { "menuone" , "noselect" , "popup", "preview" }

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
  -- vim.o.showmode = false

  -- Folding
  vim.o.foldlevel = 20
  vim.o.foldmethod = 'indent'
  vim.o.foldnestmax = 3

  -- Highlight on yank
  -- See `:help vim.highlight.on_yank()`
  local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
  })

  -- Dotnet
  vim.g.dotnet_error_only = false
  vim.g.dotnet_show_project_file = false
end

return M

-- vim: ts=2 sts=2 sw=2 et
