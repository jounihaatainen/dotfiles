-- Functional wrapper for mapping custom keybindings
function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = " "

map("i", "jj", "<Esc>")

map("n", "<Leader>n", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
map("n", "<Leader>o", ":GFiles<CR>", { noremap = true, silent = true })
map("n", "<Leader>fg", ":GFiles<CR>", { noremap = true, silent = true })
map("n", "<Leader>fa", ":Files<CR>", { noremap = true, silent = true })

map("n", "<F5>", "<Cmd>lua require'dap'.continue()<CR>", { noremap = true, silent = true })
map("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
map("n", "<F11>", "<Cmd>lua require'dap'.step_into()<CR>", { noremap = true, silent = true })
map("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>", { noremap = true, silent = true })
map("n", "<Leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true })
map("n", "<Leader>B", "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", { noremap = true, silent = true })
map("n", "<Leader>lp", "<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", { noremap = true, silent = true })
map("n", "<Leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>", { noremap = true, silent = true })
map("n", "<Leader>dl", "<Cmd>lua require'dap'.run_last()<CR>", { noremap = true, silent = true })
