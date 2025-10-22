local M = {}

M.setup = function()
  -- Set <space> as the leader key
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "

  -- Keymaps for better default experience
  vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

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

  -- Resizing panes
  vim.keymap.set("n", "<Left>", ":vertical resize -1<CR>", { silent = true })
  vim.keymap.set("n", "<Right>", ":vertical resize +1<CR>", { silent = true })
  vim.keymap.set("n", "<Up>", ":resize -1<CR>", { silent = true })
  vim.keymap.set("n", "<Down>", ":resize +1<CR>", { silent = true })

  -- Switch between source and header
  vim.keymap.set("n", "<leader>t", function() require("altfiles").open_alternate_file() end, { silent = true })

  -- Fzf keymaps
  vim.keymap.set("n", "<leader>?", "<cmd>History<cr>", { desc = "[?] Find recently opened files" })
  vim.keymap.set("n", "<leader><space>", "<cmd>Buffers<cr>", { desc = "[ ] Find existing buffers" })
  vim.keymap.set("n", "<leader>/", "<cmd>BLines<cr>", { desc = "[/] Fuzzily search in current buffer]" })
  vim.keymap.set("n", "<leader>sf", "<cmd>Files<cr>", { desc = "[S]earch [F]iles" })
  vim.keymap.set("n", "<leader>sh", "<cmd>Helptags<cr>", { desc = "[S]earch [H]elp" })
  vim.keymap.set("n", "<leader>sc", "<cmd>Commands<cr>", { desc = "[S]earch [C]ommands" })
  vim.keymap.set("n", "<leader>sg", "<cmd>Rg<cr>", { desc = "[S]earch by [G]rep" })

  -- Diagnostic keymaps
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

  -- DAP keymaps
  vim.keymap.set("n", "<F5>", "<Cmd>lua require'dap'.continue()<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<F6>", "<Cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<F9>", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<F11>", "<Cmd>lua require'dap'.step_into()<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<F8>", "<Cmd>lua require'dap'.step_out()<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>dr", "<Cmd>lua require'dap'.repl.toggle()<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>dl", "<Cmd>lua require'dap'.run_last()<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>dt", "<Cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>", { noremap = true, silent = true, desc = 'debug nearest test' })
  vim.keymap.set("n", "<leader>du", function() dapui.toggle() end, { noremap = true, silent = true, desc = "Toggle DAP UI" })
  vim.keymap.set({ "n", "v" }, "<leader>dw", function() require("dapui").eval(nil, { enter = true }) end, { noremap = true, silent = true, desc = "Add word under cursor to Watches" })
  vim.keymap.set({ "n", "v" }, "Q", function() require("dapui").eval() end, { noremap = true, silent = true, desc = "Hover/eval a single value (opens a tiny window instead of expanding the full object) " })

  -- File marks (my mini harpoon)
  vim.keymap.set("n", "<leader>mg", "mA", { silent = true, noremap = true })
  vim.keymap.set("n", "<leader>mf", "mB", { silent = true, noremap = true })
  vim.keymap.set("n", "<leader>md", "mC", { silent = true, noremap = true })
  vim.keymap.set("n", "<leader>ms", "mD", { silent = true, noremap = true })
  vim.keymap.set("n", "<leader>ma", "mE", { silent = true, noremap = true })
  vim.keymap.set("n", "<leader>gg", "'A'\"zz", { silent = true, noremap = true })
  vim.keymap.set("n", "<leader>gf", "'B'\"zz", { silent = true, noremap = true })
  vim.keymap.set("n", "<leader>gd", "'C'\"zz", { silent = true, noremap = true })
  vim.keymap.set("n", "<leader>gs", "'D'\"zz", { silent = true, noremap = true })
  vim.keymap.set("n", "<leader>ga", "'E'\"zz", { silent = true, noremap = true })
  vim.keymap.set("n", "<leader>ml", "<cmd>marks ABCDE<cr>", { silent = true, noremap = true })
  vim.keymap.set("n", "<leader>mc", "<cmd>delmarks ABCDE<cr>", { silent = true, noremap = true })
end

M.setup_lsp = function(client, bufnr)
  local nmap = function(keys, func, desc)
    if desc ~= nil then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  -- LSP keymaps
  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>la", vim.lsp.buf.code_action, "[L]sp Code [A]ction")

  nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")
end

return M

-- vim: ts=2 sts=2 sw=2 et
