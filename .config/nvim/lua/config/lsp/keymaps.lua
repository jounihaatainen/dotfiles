local M = {}

local whichkey = require "which-key"

local keymap = vim.api.nvim_set_keymap
local buf_keymap = vim.api.nvim_buf_set_keymap

local function keymappings(client, bufnr)
  local opts = { noremap = true, silent = true }

  -- Key mappings
  buf_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  keymap("n", "[e", "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>", opts)
  keymap("n", "]e", "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>", opts)

  -- Whichkey
  local keymapping = {
    l = {
      name = "Code",
      r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
      a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
      d = { "<cmd>Telescope diagnostic<CR>", "Diagnostics" },
      l = { "<cmd>lua vim.diagnostic.open_float()<CR>", "Line Diagnostics" },
      i = { "<cmd>LspInfo<CR>", "Lsp Info" },
      s = { "<cmd>SymbolsOutline<CR>", "Toggle Symbols Outline" },
      w = {
        name = "Workspace",
        a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add Folder to Workspace" },
        r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove Folder from Workspace" },
        l = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", "List Workspace Folders" },
      }
    },
    g = {
      name = "Goto",
      d = { "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>", "Definitions" },
      i = { "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>", "Implementations" },
      r = { "<cmd>lua require('telescope.builtin').lsp_references()<cr>", "References" },
      t = { "<cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>", "Type Definitions" },
      l = { "<cmd>lua require('telescope.builtin').treesitter()<cr>", "List Functions and Variables" },
      s = { "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", "Document Symbols" },
      S = { "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>", "Workspace Symbols" },
      e = { "<cmd>lua require('telescope.builtin').diagnostics()<cr>", "Diagnostics" },
      -- d = { "<Cmd>lua vim.lsp.buf.definition()<CR>", "Definition" },
      D = { "<Cmd>lua vim.lsp.buf.declaration()<CR>", "Declaration" },
      -- s = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
      -- I = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Goto Implementation" },
      -- t = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Goto Type Definition" },
      -- r = { "<cmd>lua vim.lsp.buf.references()<CR>" , "Go to References" },
    },
  }

  if client.server_capabilities.document_formatting then
    keymapping.l.f = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Format Document" }
  end

  whichkey.register(keymapping, { buffer = bufnr, prefix = "<leader>" })
end

function M.setup(client, bufnr)
  keymappings(client, bufnr)
end

return M
