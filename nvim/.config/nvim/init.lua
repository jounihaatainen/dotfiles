------------------------------------------------------------------------------
-- Quite minimal nvim configuration
--
-- No other plugins than nvim-treesitter
--
-- Requirements:
--   * cargo (for installing treesitter-cli)
--   * tree-sitter-cli (for nvim-treesitter: cargo install --locked tree-sitter-cli)
--   * gopls (for go lsp)
------------------------------------------------------------------------------

-- Options -------------------------------------------------------------------
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
vim.o.winborder = "╭,─,╮,│,╯,─,╰,│"
vim.o.pumborder = vim.o.winborder
vim.o.list = true
vim.o.listchars = 'tab:  ,trail:·,nbsp:␣'
vim.o.wildmode = 'longest:full,full'
vim.o.completeopt = 'menu,menuone,popup,noinsert,fuzzy'
vim.o.wildoptions = fuzzy, pum

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

-- highlight yanked text briefly on yank
vim.api.nvim_create_autocmd('TextYankPost', { callback = function() vim.highlight.on_yank() end })

-- Helper funcs --------------------------------------------------------------
local is_windows = package.config:sub(1,1) == "\\"

local function find_window_for_buf(bufnr)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == bufnr then
      return win
    end
  end
end

local function debounce(fn, delay)
  local timer = nil

  return function(...)
    local args = { ... }
    if timer then
      timer:stop()
      timer:close()
    end

    timer = vim.loop.new_timer()
    timer:start(delay, 0, function()
      timer:stop()
      timer:close()
      timer = nil
      vim.schedule(function() fn(unpack(args)) end)
    end)
  end
end

-- Reusable terminal ---------------------------------------------------------
local terminals = {}

local function open_terminal(name, opts)
  opts = opts or {}
  local term = terminals[name]

  vim.cmd('split')
  vim.cmd('resize ' .. ((opts.height or 0) ~= 0 and opts.height or 15))

  if term and term.bufnr and vim.api.nvim_buf_is_valid(term.bufnr) then
    vim.api.nvim_set_current_buf(term.bufnr)
  else
    vim.cmd('terminal')
    vim.cmd('keepalt file ' .. name)
    terminals[name] = { bufnr = vim.api.nvim_get_current_buf(), opts = opts }
  end

  vim.cmd('startinsert')
end

-- open if not open, close it if open
local function toggle_terminal(name, opts)
  opts = opts or {}
  local term = terminals[name]
  if term and term.bufnr then
    local win = find_window_for_buf(term.bufnr)
    if win then
      vim.api.nvim_win_close(win, true)
      return
    end
  end

  open_terminal(name, opts)
end

-- autocmd to clean up the terminal from "manager"
vim.api.nvim_create_autocmd('TermClose', {
  callback = function(args)
    for name, term in pairs(terminals) do
      if term.bufnr == args.buf then
        terminals[name] = nil
      end
    end
  end,
})

-- Fuzzy find ----------------------------------------------------------------

-- find suitable file finder command. falls back to globpath() if none find.
local function find_files_func()
  if vim.fn.executable("fd") == 1 then
    return function() return vim.fn.systemlist("fd --type f --follow --hidden --exclude .git") end
  elseif vim.fn.executable("fdfind") == 1 then
    return function() return vim.fn.systemlist("fdfind --type f --follow --hidden --exclude .git") end
  elseif vim.fn.executable("rg") == 1 then
    return function() return vim.fn.systemlist("rg --files --hidden --glob '!.git'") end
  elseif not is_windows and vim.fn.executable("find") == 1 then
    return function() return vim.fn.systemlist("find . -path '*/.git' -prune -o -type f ! -name '.' -print") end
  else
    return function() return vim.split(vim.fn.globpath('.', '**', 1), '\n') end
  end
end
local find_files = find_files_func()

local filescache = {}

function _G.FindFiles(arg, _)
  if #filescache == 0 then filescache = find_files() end
  return #arg == 0 and filescache or vim.fn.matchfuzzy(filescache, arg)
end
vim.o.findfunc = "v:lua.FindFiles"

local find_augroup_id = vim.api.nvim_create_augroup('my.find', { clear = true })
vim.api.nvim_create_autocmd({ "CmdlineLeave", "CmdlineLeavePre", "CmdlineChanged" }, {
  group = find_augroup_id,
  pattern = ":",
  callback = function(ev)
    if ev.event == "CmdlineChanged" then
      if vim.fn.getcmdline():match("^%s*fin[d]?%s") then
        vim.fn.wildtrigger()
      end
    elseif ev.event == "CmdlineLeavePre" then
      local info = vim.fn.cmdcomplete_info()
      if info.matches and #info.matches > 0 then
        if vim.fn.getcmdline():match("^%s*fin[d]?%s") and info.selected == -1 then
          vim.fn.setcmdline("find " .. info.matches[1])
        end
      end
    elseif ev.event == "CmdlineLeave" then
      filescache = {}
    end
  end,
})

-- Live grep ----------------------------------------------------------------
local function grep_cmd()
  if vim.fn.executable("rg") == 1 then
    return "rg --vimgrep --smart-case --hidden --glob '!.git'"
  elseif vim.fn.executable("git") == 1 then
    return 'git grep -n'
  else
    return vim.o.grepprg
  end
end
vim.opt.grepprg = grep_cmd()

local live_grep = debounce(function(pattern)
  vim.cmd("silent grep! " .. vim.fn.escape(pattern, " "))
  vim.cmd("cwindow")
  vim.cmd.redraw()
end, 200)

-- dummy command for swallowing an error if :Lgrep gets executed
vim.api.nvim_create_user_command('Lgrep', function() end, { nargs = '*', })

-- [:grep with live updating quickfix list : r/neovim](https://www.reddit.com/r/neovim/comments/1n2ln9w/grep_with_live_updating_quickfix_list/)
local grep_augroup_id = vim.api.nvim_create_augroup('my.grep', { clear = true })
vim.api.nvim_create_autocmd("CmdlineChanged", {
  group = grep_augroup_id,
  callback = function()
    local cmdline = vim.fn.getcmdline()
    local words = vim.split(cmdline, " ", { trimempty = true })
    -- local pattern = unpack(words, 2, #words)
    -- if words[1] == "Lgrep" and #words > 1 and #pattern > 1 then
    if words[1] == "Lgrep" and #words > 1 then
      local pattern = words[2]
      for i = 3, #words, 1 do
        pattern = pattern .. " " .. words[i]
      end
      live_grep(pattern)
    end
  end,
  pattern = ":",
})

-- Quick fix list ------------------------------------------------------------
local function toggle_qflist()
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd('cclose')
  else
    vim.cmd('copen')
  end
end

-- Plugins -------------------------------------------------------------------
vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
})

-- Treesitter ----------------------------------------------------------------
local nts = require('nvim-treesitter')
nts.install({ 'bash', 'css', 'go', 'gomod', 'gosum', 'html', 'javascript' })
local ts_augroup_id = vim.api.nvim_create_augroup('my.treesitter', { clear = true })
vim.api.nvim_create_autocmd('PackChanged', { group = ts_augroup_id, callback = function() nts.update() end })
vim.api.nvim_create_autocmd("FileType", {
  group = ts_augroup_id,
  callback = function(args)
    local filetype = args.match
    local lang = vim.treesitter.language.get_lang(filetype)
    if vim.treesitter.language.add(lang) then
      vim.treesitter.start()
    end
  end
})

-- LSP -----------------------------------------------------------------------
vim.lsp.config('go_ls', {
  cmd = { 'gopls' },
  root_markers = { 'go.work', 'go.mod', '.git' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
})

vim.lsp.enable({ 'go_ls' })

local border = vim.split(vim.o.winborder, ",")
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    if client:supports_method('textDocument/completion') then
      local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      client.server_capabilities.completionProvider.triggerCharacters = chars
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
    end

    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end

    -- key mappings for lsp (when attached to buffer)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>') -- go to definition
  end,
})

-- Diagnostics ---------------------------------------------------------------
vim.diagnostic.config({
  virtual_text = true,
  -- update_in_insert = true,
})

 -- opens diagnostic popup if cursor sits on a line with lsp diagnostic message for a period of time
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

-- Keymaps -------------------------------------------------------------------
vim.keymap.set('i', 'kj', '<Esc>', { desc = 'escape insert mode with kj' })
vim.keymap.set('i', '<C-space>', '<C-x><C-o>', { desc = 'lsp/filetype autocompletion (does not work in windows terminal)' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'remove highlight after search on esc' })
vim.keymap.set('n', '<C-j>', ':m .+1<CR>==', { desc = 'move current line down fixing indent' })
vim.keymap.set('n', '<C-k>', ':m .-2<CR>==', { desc = 'move current line up fixing indent' })
vim.keymap.set('n', '<leader>t', function() toggle_terminal('terminal', { height = vim.v.count }) end, { desc = 'toggle terminal in horizontal split' })
vim.keymap.set('n', '<leader>e', '<cmd>25Lexplore<CR>', { desc = 'toggle explorer on the left side' })
vim.keymap.set('n', '<leader>f', ':find ', { desc = 'find files' })
vim.keymap.set('n', '<leader>g', ':Lgrep ', { desc = 'live grep' })
vim.keymap.set('n', '<leader>G', ':Lgrep <C-r><C-w>', { desc = 'live grep starting with word under cursor' })
vim.keymap.set('n', '<leader>v', ':vimgrep //j ** | copen<S-Left><S-Left><S-Left><S-Left><Right>', { desc = 'vim grep' })
vim.keymap.set('n', '<leader>V', ':vimgrep /<C-r><C-w>/j ** | copen<S-Left><S-Left><S-Left><Left><Left><Left>', { desc = 'vim grep word under cursor' })
vim.keymap.set('n', '<leader>w', '<cmd>lua vim.diagnostic.open_float()<CR>')
-- vim.keymap.set('n', '<leader>e', '<cmd>lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())<CR>')
vim.keymap.set('n', '<leader>d', '<cmd>lua vim.diagnostic.setqflist()<CR>')
vim.keymap.set('n', '<leader>j', '<cmd>cnext<CR>zz', { desc = "Forward quick fix list" })
vim.keymap.set('n', '<leader>k', '<cmd>cprev<CR>zz', { desc = "Backward quick fix list" })
vim.keymap.set('n', '<leader>q', toggle_qflist, { desc = "Toggle quick fix list" })

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

-- Filetype specific settings ------------------------------------------------
-- Go specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.expandtab = false   -- use real tabs
    vim.opt_local.tabstop = 4         -- tab width
    vim.opt_local.shiftwidth = 4      -- indentation size
    vim.opt_local.softtabstop = 0     -- optional: <Tab> inserts real tab
  end,
})

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

-- Custom colorscheme --------------------------------------------------------
local palette = {
  bg        = "#f7f7f7",
  bg_alt    = "#eeeeee",
  bg_ref    = "#e5e5e5",
  fg        = "#000000",
  fg_muted  = "#666666",
  fg_faint  = "#999999",
  keyword   = "#007acc", -- blue (control flow only)
  string    = "#aa3731", -- muted red
  -- string    = "#448c27",
  error     = "#b00020",
  warn      = "#b08900",
  info      = "#007acc",
  hint      = "#666666",
}

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

vim.o.termguicolors = true
vim.o.background = "light"
vim.cmd("highlight clear")
vim.cmd("syntax reset")

-- Core
hl("Normal",              { fg = palette.fg, bg = palette.bg })
hl("FloatBorder",         { fg = palette.fg, bg = palette.bg })
hl("NormalFloat",         { bg = palette.bg })
hl("LineNr",              { fg = palette.fg_faint })
hl("CursorLineNr",        { fg = palette.fg })
hl("CursorLine",          { bg = palette.bg_alt })
hl("Visual",              { bg = "#e0e0e0" })
hl("VertSplit",           { fg = "#dddddd" })
hl("WinSeparator",        { fg = "#dddddd" })
hl("StatusLine",          { fg = palette.fg, bg = palette.bg_alt })
hl("StatusLineNC",        { fg = palette.fg_faint, bg = palette.bg_alt })
hl("Pmenu",               { fg = palette.fg, bg = palette.bg })
hl("PmenuSel",            { bg = "#dcdcdc" })
hl("PmenuSbar",           { bg = "#e0e0e0" })
hl("PmenuThumb",          { bg = "#c0c0c0" })
hl("PmenuKind",           { fg = palette.fg_faint })
hl("PmenuKindSel",        { bg = "#dcdcdc" })
hl("PmenuExtra",          { fg = palette.fg_faint })
hl("PmenuExtraSel",       { bg = "#dcdcdc" })
hl("PmenuMatch",          { fg = palette.keyword })
hl("PmenuMatchSel",       { fg = palette.keyword })
hl("PmenuBorder",         { fg = palette.fg, bg = palette.bg })

-- LSP diagnostics
hl("DiagnosticError",     { fg = palette.error })
hl("DiagnosticWarn",      { fg = palette.warn })
hl("DiagnosticInfo",      { fg = palette.info })
hl("DiagnosticHint",      { fg = palette.hint })

-- Underlines instead of backgrounds
hl("DiagnosticUnderlineError", { undercurl = true, sp = palette.error })
hl("DiagnosticUnderlineWarn",  { undercurl = true, sp = palette.warn })
hl("DiagnosticUnderlineInfo",  { undercurl = true, sp = palette.info })
hl("DiagnosticUnderlineHint",  { undercurl = true, sp = palette.hint })

-- References & code actions
hl("LspReferenceText",    { fg = palette.fg, bg = palette.bg_alt })
hl("LspReferenceRead",    { fg = palette.fg, bg = palette.bg_alt })
hl("LspReferenceWrite",   { fg = palette.fg, bg = palette.bg_alt })
hl("CodeActionText",      { fg = palette.keyword })

-- Legacy syntax (used when Tree-sitter is unavailable)
hl("Comment",             { fg = palette.fg_faint })
hl("Identifier",          { fg = palette.fg })
hl("Function",            { fg = palette.fg })
hl("Type",                { fg = palette.fg })
hl("Statement",           { fg = palette.keyword })
hl("Keyword",             { fg = palette.keyword })
hl("Conditional",         { fg = palette.keyword })
hl("Repeat",              { fg = palette.keyword })
hl("Operator",            { fg = palette.fg })
hl("Constant",            { fg = palette.fg })
hl("String",              { fg = palette.string })
hl("Number",              { fg = palette.string })
hl("Boolean",             { fg = palette.string })
hl("Delimiter",           { fg = palette.fg_muted })
hl("Special",             { fg = palette.keyword })

-- Comments (TreeSitter)
hl("@comment",            { fg = palette.fg_faint })

-- Variables (TreeSitter)
hl("@variable",           { fg = palette.fg })
hl("@variable.builtin",   { fg = palette.fg })

-- Parameters & fields (TreeSitter)
hl("@parameter",          { fg = palette.fg })
hl("@field",              { fg = palette.fg })
hl("@property",           { fg = palette.fg })

-- Functions (TreeSitter)
hl("@function",           { fg = palette.fg })
hl("@function.builtin",   { fg = palette.fg })
hl("@method",             { fg = palette.fg })
hl("@constructor",        { fg = palette.fg })

-- Types (TreeSitter)
hl("@type",               { fg = palette.fg })
hl("@type.builtin",       { fg = palette.fg })
hl("@interface",          { fg = palette.fg })
hl("@struct",             { fg = palette.fg })

-- Keywords (only real control flow) (TreeSitter)
hl("@keyword",            { fg = palette.keyword })
hl("@keyword.return",     { fg = palette.keyword })
hl("@keyword.conditional",{ fg = palette.keyword })
hl("@keyword.loop",       { fg = palette.keyword })

-- Imports & namespaces (not accentuated) (TreeSitter)
hl("@namespace",          { fg = palette.fg })
hl("@include",            { fg = palette.keyword })

-- Literals (TreeSitter)
hl("@string",             { fg = palette.string })
hl("@number",             { fg = palette.string })
hl("@boolean",            { fg = palette.string })
hl("@enumMember",         { fg = palette.string })
hl("@constant",           { fg = palette.fg })
