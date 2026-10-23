--
-- init.lua -- minimal nvim config for Neovim 0.12+ - 2026 Jouni Haatainen
--

--
-- Packages
--
vim.pack.add({
  { src = "https://github.com/blazkowolf/gruber-darker.nvim" },
})
vim.cmd.colorscheme("gruber-darker")

--
-- Options
--
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes:1'
vim.o.wrap = false
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = -1
vim.o.smartindent = true
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.scrolloff = 4
vim.o.sidescrolloff = 4
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.undofile = true
-- vim.o.winborder = "╭,─,╮,│,╯,─,╰,│"
-- vim.o.pumborder = vim.o.winborder
vim.o.list = true
vim.o.listchars = 'tab:  ,trail:·,nbsp:␣'
vim.o.wildmode = 'longest:full,full'
vim.o.completeopt = 'menu,menuone,popup,noinsert,fuzzy'
vim.o.wildoptions = fuzzy, pum

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

require("gruber-darker").setup({
  italic = { string = false },
})

-- highlight yanked text briefly on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank() end
})

local function open_in_quick_fix_list(title, cmd_output)
  local output_lines = vim.split(cmd_output, "\n", { trimempty = true })
  vim.fn.setqflist({}, "r", {
    title = title,
    lines = output_lines,
    efm = vim.o.errorformat,
  })
  vim.cmd("copen")
end

local function prompt_and_exec(prompt, func)
  local cmd = vim.fn.input(prompt)
  if #cmd == 0 then
    print("Cannot run empty command")
    return
  end
  local raw_input = vim.fn.system(cmd)
  local f = func or function(cmd, input) vim.print(input) end
  f(cmd, raw_input)
end

-- Keymaps -------------------------------------------------------------------
vim.keymap.set('i', 'kj', '<Esc>', { desc = 'escape insert mode with kj' })
-- vim.keymap.set('i', '<C-space>', '<C-x><C-o>', { desc = 'lsp/filetype autocompletion (does not work in windows terminal)' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'remove highlight after search on esc' })
vim.keymap.set('n', '<C-j>', ':m .+1<CR>==', { desc = 'move current line down fixing indent' })
vim.keymap.set('n', '<C-k>', ':m .-2<CR>==', { desc = 'move current line up fixing indent' })
vim.keymap.set('n', '<leader><space>', ':ls<CR>:b ', { desc = 'switch buffer' })
vim.keymap.set('n', '<leader>f', ':find ', { desc = 'find files' })
vim.keymap.set('n', '<leader>v', ':vimgrep //j ** | copen<S-Left><S-Left><S-Left><S-Left><Right>', { desc = 'vim grep' })
vim.keymap.set('n', '<leader>V', ':vimgrep /<C-r><C-w>/j ** | copen<S-Left><S-Left><S-Left><Left><Left><Left>', { desc = 'vim grep word under cursor' })
vim.keymap.set('n', '<leader>w', '<cmd>lua vim.diagnostic.open_float()<CR>')
-- vim.keymap.set('n', '<leader>e', '<cmd>lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())<CR>')
-- vim.keymap.set('n', '<leader>d', '<cmd>lua vim.diagnostic.setqflist()<CR>')
vim.keymap.set('n', '<leader>j', '<cmd>cnext<CR>zz', { desc = "Forward quick fix list" })
vim.keymap.set('n', '<leader>k', '<cmd>cprev<CR>zz', { desc = "Backward quick fix list" })
vim.keymap.set('n', '<leader>q', function()
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd('cclose')
  else
    vim.cmd('copen')
  end
end, { desc = "Toggle quick fix list" })
vim.keymap.set('n', '<leader>m', ':make<CR>:cwindow<CR>', { desc = "Run make command" })
vim.keymap.set('n', '<leader>c', function()
  local cmd = vim.fn.prompt("Set make prog for this buffer> ")
  vim.bo.makeprog = cmd
end, { desc = "Set make prog for this buffer" })
vim.keymap.set('n', '<leader>rr', function()
  prompt_and_exec("Run> ")
end, { desc = "Run command" })
vim.keymap.set('n', '<leader>rq', function()
  prompt_and_exec("Run (quick fix)> ", open_in_quick_fix_list)
end, { desc = "Run command, send result to quick fix list" })

vim.keymap.set('v', '<C-j>', ":m'>+<CR>gv=gv", { desc ='move selected lines up, fixing indent' })
vim.keymap.set('v', '<C-k>', ':m-2<CR>gv=gv', { desc = 'move selected lines down, fixing indent' })
vim.keymap.set('v', '<', '<gv', { desc = 'deindent selected lines and keep the selection' })
vim.keymap.set('v', '>', '>gv', { desc = 'indent selected lines and keep the selection' })
vim.keymap.set('v', "<leader>'", "c''<Esc>P", { desc = "surround selection with '" })
vim.keymap.set('v', '<leader>"', 'c""<Esc>P', { desc = 'surround selection with "' })
vim.keymap.set('v', '<leader>(', 'c()<Esc>P', { desc = 'surround selection with ()' })
vim.keymap.set('v', '<leader>[', 'c[]<Esc>P', { desc = 'surround selection with []' })
vim.keymap.set('v', '<leader>{', 'c{}<Esc>P', { desc = 'surround selection with {}' })

vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { desc = 'escape terminal insert mode' })
vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], { desc = 'window navigation from terminal' })

--
-- Filetype specific settings ------------------------------------------------
--
-- Lua specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.opt_local.expandtab = true    -- use spaces for tabs
    vim.opt_local.tabstop = 2         -- tab width
    vim.opt_local.shiftwidth = 2      -- indentation size
    vim.opt_local.softtabstop = -1    -- optional: <Tab> inserts real tab
  end,
})
