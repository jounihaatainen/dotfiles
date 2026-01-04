-- Options --
vim.o.number = true                                         -- sets number in signcolumn
vim.o.relativenumber = true
vim.o.signcolumn = 'yes:1'
vim.o.wrap = false
vim.o.expandtab = true                                      -- use 4 spaces to indent  
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = -1
vim.o.smartindent = true
vim.g.mapleader = ' '                                       -- sets <leader> to space
vim.g.maplocalleader = ' '
vim.o.scrolloff = 4
vim.o.sidescrolloff = 4
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.undofile = true
vim.o.winborder = "╭,─,╮,│,╯,─,╰,│"
vim.o.pumborder = "╭,─,╮,│,╯,─,╰,│"
-- vim.o.list = true                                           -- sets characters to represent whitespaces
-- vim.o.listchars = 'trail:·,tab:–»,nbsp:␣,extends:»,eol: ,precedes:«,multispace: '
vim.o.wildmode = 'longest:full,full'                        -- sets popupmenu to be whole list
vim.o.completeopt = 'menu,menuone,popup,noinsert,fuzzy'     -- modern completion menu
vim.o.wildoptions = fuzzy, pum, popup, menuone, preview     -- much of the same but for wildoptions

-- Check for existence of needed tools --
local fd = vim.fn.executable("fd") == 1 and "fd" or vim.fn.executable("fdfind") == 1 and "fdfind" or nil

if not fd then
  vim.notify("fd/fdfind not found", vim.log.levels.ERROR)
end

if vim.fn.executable("fzf") ~= 1 then
  vim.notify("fzf not found", vim.log.levels.ERROR)
end

if vim.fn.executable("rg") ~= 1 then
  vim.notify("rg not found", vim.log.levels.ERROR)
end

-- Helper funcs --
local is_windows = package.config:sub(1,1) == "\\"

local function split(s, delimiter)
  local result = {}
  local from  = 1
  local delim_from, delim_to = string.find(s, delimiter, from)
  while delim_from do
    table.insert(result, string.sub(s, from , delim_from-1))
    from  = delim_to + 1
    delim_from, delim_to = string.find(s, delimiter, from)
  end
  table.insert(result, string.sub(s, from))
  return result
end

-- Reusable terminal --
local terminals = {}

local function find_window_for_buf(bufnr)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == bufnr then
      return win
    end
  end
end

-- open terminal or jump to it if already open
local function open_terminal(name, opts)
  opts = opts or {}
  local term = terminals[name]

  if term and term.bufnr and vim.api.nvim_buf_is_valid(term.bufnr) then
    local win = find_window_for_buf(term.bufnr)
    if win then
      vim.api.nvim_set_current_win(win)
      vim.cmd('startinsert')
      return
    end
  end

  if opts.vertical then
      vim.cmd('vsplit')
      vim.cmd('vertical resize ' .. (opts.width or 80))
  else
    vim.cmd('split')
    vim.cmd('resize ' .. (opts.height or 15))
  end

  if term and term.bufnr and vim.api.nvim_buf_is_valid(term.bufnr) then
    vim.api.nvim_set_current_buf(term.bufnr)
  else
    vim.cmd('terminal')
    vim.cmd('keepalt file ' .. name)
    terminals[name] = { bufnr = vim.api.nvim_get_current_buf() }
  end

  vim.cmd('startinsert')
end

-- open or jump to terminal if not open, close it if open
local function toggle_or_jump_terminal(name, opts)
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

-- Fuzzy finding --
local function open_split_term(term_cmd, bname, opt)
  local saved_spk = vim.o.splitkeep
  local src_winid = vim.fn.win_getid()
  -- local fzf_lines = (vim.v.count > 2 and vim.v.count) or 10
  local fzf_lines = 10
  local tempfile = vim.fn.tempname()
  local on_exit = function ()
    vim.cmd.bwipeout()
    vim.o.splitkeep = saved_spk
    vim.fn.win_gotoid(src_winid)
    if vim.fn.filereadable(tempfile) then
      local lines = vim.fn.readfile(tempfile)
      if #lines > 0 then (opt.action or vim.cmd.edit)(lines[1]) end
    end
    vim.fn.delete(tempfile)
    if opt.on_exit then opt.on_exit() end
  end
  vim.o.splitkeep = 'screen'
  vim.cmd('botright' .. (fzf_lines + 1) .. 'new')
  -- NOTE: `cwd` can also be specified for the job
  local id = vim.fn.termopen(term_cmd .. ' > ' .. tempfile, { on_exit = on_exit, env = opt.env, })
  vim.keymap.set('n', '<esc>', function () vim.fn.jobstop(id) end, {buffer=true})
  vim.cmd('keepalt file ' .. bname)
  vim.cmd.startinsert()
end

local function fuzzy_find_in_split(input_cmd, bname, opt)
  local preview = opt.preview or ''
  local term_cmd = input_cmd .. ' | fzf --no-multi --reverse --preview="' .. preview .. '"' 
  open_split_term(term_cmd, bname, opt)
end

local function fuzzy_find_files()
  local preview = 'cat {}'
  if is_windows then
    preview = 'pwsh -Command Get-Content {}'
  end
  -- fzf("find . -path '*/.git' -prune -o -type f ! -name '.' -print", 'fuzzy find', { preview = preview })
  fuzzy_find_in_split(fd .. " --type f --hidden --exclude .git", 'fuzzy find', { preview = preview })
end

-- XXX: this doesn't work on windows without POSIX shell (reload fails)
local function fuzzy_grep()
  local rg_cmd = 'rg --column --line-number --no-heading --smart-case'
  local term_cmd = table.concat({
    rg_cmd .. ' ${*:-} |',
    'fzf',
    '--disabled',
    '--bind "change:reload:sleep 0.1; ' .. rg_cmd .. ' {q} || true"',
    '--delimiter :',
    '--no-multi',
    '--reverse'
  }, " ")

  open_split_term(term_cmd, 'fuzzy grep', {
      action = function (line)
        local file, lnum, col = unpack(vim.split(line, ':'))
        vim.cmd.edit(file)
        vim.fn.cursor(lnum, col)
        vim.cmd('normal! zz')
      end,
    })
end

local function fuzzy_find_buffers()
  local bufstr = string.gsub(vim.fn.execute('ls'), '^\n', '')
  local bufs = split(bufstr, '\n')
  local tempfile = vim.fn.tempname()
  vim.fn.writefile(bufs, tempfile)
  fuzzy_find_in_split('cat ' .. tempfile, 'fzf buffers', {
    action = function(line)
        vim.cmd('b' .. string.match(line, '%d+'))
    end,
    on_exit = function()
        vim.fn.delete(tempfile)
    end
  })
end

-- Quickfix list --
local function show_arglist_in_qf()
  vim.cmd.argdedupe()
  local list = vim.fn.argv()
  if #list > 0 then
    local qf_items = {}
    for _, filename in ipairs(list) do
      table.insert(qf_items, {
        filename = filename,
        lnum = 1,
        text = filename
      })
    end
    vim.fn.setqflist(qf_items, 'r')
    vim.cmd.copen()
  end
end

-- LSP --
vim.lsp.config('go_ls', {
  cmd = { 'gopls' },
  root_markers = { 'go.work', 'go.mod', '.git' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
})

vim.lsp.enable({ 'go_ls' })

local border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│", }
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })

vim.diagnostic.config({ -- config for diagnostic visuals, sets error sign and indicators
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '!',
      [vim.diagnostic.severity.WARN] = '*',
      [vim.diagnostic.severity.HINT] = '?',
      [vim.diagnostic.severity.INFO] = '#',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
      [vim.diagnostic.severity.HINT] = 'HintMsg',
      [vim.diagnostic.severity.INFO] = 'InfoMsg',
    },
  },
  update_in_insert = true,
})

-- Keymaps --
vim.keymap.set('i', 'kj', '<Esc>', { desc = 'escape insert mode with kj' })
vim.keymap.set('i', '<C-space>', '<C-x><C-o>', { desc = 'lsp/filetype autocompletion (does not work in windows terminal)' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'remove highlight after search on esc' })
vim.keymap.set('n', '<leader>a', function() toggle_or_jump_terminal('terminal') end, { desc = 'toggle terminal in horizontal split' })
vim.keymap.set('n', '<leader>A', function() toggle_or_jump_terminal('terminal', { vertical = true }) end, { desc = 'toggle terminal in vertical split' })
vim.keymap.set('n', '<C-j>', ':m .+1<CR>==', { desc = 'move current line down fixing indent' })
vim.keymap.set('n', '<C-k>', ':m .-2<CR>==', { desc = 'move current line up fixing indent' })
vim.keymap.set('n', '<leader>f', fuzzy_find_files, { desc = 'fuzzy find file(s)' })
vim.keymap.set('n', '<leader>g', fuzzy_grep, { desc = 'fuzzy grep in file(s)' })
vim.keymap.set('n', '<leader><space>', fuzzy_find_buffers, { desc = 'fuzzy find buffer' })
for i = 1,4 do -- mini harpoon with arglist
  vim.keymap.set('n', '<leader>'..i, '<cmd>argu '..i..'<CR>', { silent = true, desc = 'Go to arg '..i })
  vim.keymap.set('n', '<leader>h'..i, '<cmd>'..(i-1)..'arga<CR>', { silent = true, desc = 'Add current file to arg '..i })
  vim.keymap.set('n', '<leader>H'..i, '<cmd>'..i..'argd<CR>', { silent = true, desc = 'Remove current arg '..i })
end
vim.keymap.set('n', '<leader>hq', show_arglist_in_qf, { silent = true, desc = "Show args in qf" })
vim.keymap.set('n', '<leader>w', '<cmd>lua vim.diagnostic.open_float()<CR>')
vim.keymap.set('n', '<leader>e', '<cmd>lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())<CR>')

vim.keymap.set('v', '<C-j>', ":m'>+<CR>gv=gv", { desc ='move selected lines up, fixing indent' })
vim.keymap.set('v', '<C-k>', ':m-2<CR>gv=gv', { desc = 'move selected lines down, fixing indent' })
vim.keymap.set('v', "<leader>'", "c''<Esc>P", { desc = "surround selection with '" })
vim.keymap.set('v', '<leader>"', 'c""<Esc>P', { desc = 'surround selection with "' })
vim.keymap.set('v', '<leader>(', 'c()<Esc>P', { desc = 'surround selection with ()' })
vim.keymap.set('v', '<leader>[', 'c[]<Esc>P', { desc = 'surround selection with []' })
vim.keymap.set('v', '<leader>{', 'c{}<Esc>P', { desc = 'surround selection with {}' })

vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { desc = 'escape terminal insert mode' })
vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], { desc = 'window navigation from terminal' })

vim.api.nvim_create_autocmd('LspAttach', { --attach lsp to buffertype
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
    -- global defaults when neovim starts:
    --     "gra" (Normal and Visual mode) is mapped to vim.lsp.buf.code_action()
    --     "gri" is mapped to vim.lsp.buf.implementation()
    --     "grn" is mapped to vim.lsp.buf.rename()
    --     "grr" is mapped to vim.lsp.buf.references()
    --     "grt" is mapped to vim.lsp.buf.type_definition()
    --     "gO" is mapped to vim.lsp.buf.document_symbol()
    --     CTRL-S (Insert mode) is mapped to vim.lsp.buf.signature_help()
    --     "an" and "in" (Visual and Operator-pending mode) are mapped to outer and inner
    --                   incremental selections, respectively, using vim.lsp.buf.selection_range() 
  end,
})

 -- opens diagnostic popup if cursor sits on a line with lsp diagnostic message for a period of time
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

-- highlight yanked text briefly on yank
vim.api.nvim_create_autocmd('TextYankPost', { callback = function() vim.highlight.on_yank() end })

-- Go specific settings
-- For treesitter support build and install https://github.com/tree-sitter/tree-sitter-go
-- also add queries from https://github.com/nvim-treesitter/nvim-treesitter/tree/main/runtime/queries/go/
-- to $NVIM_ROOT/share/nvim/runtime/queries/go/ to get better highlighting
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.treesitter.start(0, "go")
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

-- Custom colorscheme --
local palette = {
  bg        = "#f7f7f7",
  bg_alt    = "#eeeeee",
  bg_ref    = "#e5e5e5",
  fg        = "#000000",
  fg_muted  = "#666666",
  fg_faint  = "#999999",
  keyword   = "#007acc", -- blue (control flow only)
  -- string    = "#aa3731", -- muted red
  string    = "#448c27",
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
