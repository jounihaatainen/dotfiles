local M = {}

M.setup = function()
  -- Copy absolute path to the file in the current buffer
  vim.api.nvim_create_user_command("CopyAbsPath", function()
    vim.api.nvim_call_function("setreg", { "+", vim.fn.expand("%:p") })
  end, {})

  -- Copy relative path to the file in the current buffer
  vim.api.nvim_create_user_command("CopyRelPath", function()
    vim.api.nvim_call_function("setreg", { "+", vim.fn.fnamemodify(vim.fn.expand("%"), ":.") })
  end, {})
end

return M

-- vim: ts=2 sts=2 sw=2 et
