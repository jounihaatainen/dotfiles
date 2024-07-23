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
  vim.keymap.set("n", "<leader>t", require("altfiles").open_alternate_file, { silent = true })

  -- Telescope keymaps
  -- vim.keymap.set("n", "<leader>?", "<cmd>Telescope oldfiles<cr>", { desc = "[?] Find recently opened files" })
  -- vim.keymap.set("n", "<leader><space>", "<cmd>Telescope buffers<cr>", { desc = "[ ] Find existing buffers" })
  -- vim.keymap.set("n", "<leader>/", function()
  --   -- You can pass additional configuration to telescope to change theme, layout, etc.
  --   require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
  --     winblend = 10,
  --     previewer = false,
  --   })
  -- end, { desc = "[/] Fuzzily search in current buffer]" })
  -- vim.keymap.set("n", "<leader>sf", "<cmd>Telescope find_files<cr>", { desc = "[S]earch [F]iles" })
  -- vim.keymap.set("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "[S]earch [H]elp" })
  -- vim.keymap.set("n", "<leader>sm", "<cmd>Telescope man_pages<cr>", { desc = "[S]earch [M]an Pages" })
  -- vim.keymap.set("n", "<leader>sw", "<cmd>Telescope grep_string<cr>", { desc = "[S]earch current [W]ord" })
  -- vim.keymap.set("n", "<leader>sg", "<cmd>Telescope live_grep<cr>", { desc = "[S]earch by [G]rep" })
  -- vim.keymap.set("n", "<leader>st", "<cmd>Telescope treesitter<cr>", { desc = "[S]earch by [T]reesitter" })
  -- vim.keymap.set("n", "<leader>sd", "<cmd>Telescope diagnostics<cr>", { desc = "[S]earch [D]iagnostics" })
  -- vim.keymap.set("n", "<leader>f", function() require("telescope.builtin").diagnostics({ bufnr = 0 }) end,
  --   { desc = "Document Diagnostics" })

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

  -- Codeium
  vim.keymap.set("i", "<Tab>", function() return vim.fn["codeium#Accept"]() end, { silent = true, expr = true })
  vim.keymap.set("i", "<S-Tab>", function() return vim.fn["codeium#Complete"]() end, { silent = true, expr = true })
  vim.keymap.set("i", "<M-Tab>", function() return vim.fn["codeium#CycleCompletions"](1) end,
    { silent = true, expr = true })
  vim.keymap.set("i", "<C-X>", function() return vim.fn["codeium#Clear"]() end, { silent = true, expr = true })

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

return M

-- vim: ts=2 sts=2 sw=2 et
