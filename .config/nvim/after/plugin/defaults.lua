local api = vim.api
local g = vim.g
local opt = vim.opt

api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
g.mapleader = ' '
g.maplocalleader = ' '

--opt.completeopt = 'menuone,noinsert,noselect'
opt.completeopt = 'menuone,preview'
opt.expandtab = true
opt.shiftround = true
opt.shiftwidth = 4
opt.softtabstop = -1
opt.tabstop = 8
-- opt.textwidth = 80
opt.title = true
opt.splitbelow = true
opt.splitright = true
opt.number = true
opt.relativenumber = true
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.ruler = false
opt.showmode = false
opt.signcolumn = 'yes'
opt.mouse = 'a'
opt.updatetime = 250
opt.timeoutlen = 300
opt.swapfile = false
-- opt.foldmethod = "expr"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"
-- opt.foldenable = false
