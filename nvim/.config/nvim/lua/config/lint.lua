local M = {}

M.setup = function()
  local lint = require("lint")

  lint.linters_by_ft = {
    javascript = { "eslint_d" },
    typescript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    typescriptreact = { "eslint_d" },
    python = { "ruff" },
    htmldjango = { "djlint" },
  }

  local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    callback = function()
      lint.try_lint()
    end,
  })

  vim.keymap.set("n", "<leader>li", function()
    lint.try_lint()
  end, { desc = "Trigger [L][I]nting for current file" })
end

return M

-- vim: ts=2 sts=2 sw=2 et
