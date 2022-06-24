-- Colors
vim.cmd 'colorscheme darcula'

vim.opt.completeopt = 'menuone,noinsert,noselect'

vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = -1
vim.opt.tabstop = 8
vim.opt.textwidth = 80
vim.opt.title = true

vim.opt.fixendofline = false
vim.opt.startofline = false
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8
vim.opt.ruler = false
vim.opt.showmode = false
vim.opt.signcolumn = 'yes'

vim.opt.mouse = 'a'
vim.opt.updatetime = 200

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false
