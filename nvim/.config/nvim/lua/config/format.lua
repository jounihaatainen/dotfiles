local M = {}

M.setup = function()
  local conform = require("conform")

  conform.setup({
    formatters_by_ft = {
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      lua = { "stylua" },
      python = { "isort", "black" },
      htmldjango = { "djlint" },
    },
    format_on_save = function(bufnr)
      -- Disable autoformat on certain filetypes
      local ignore_filetypes = { "sql", "cs" }
      if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
        return
      end
      -- -- Disable with a global or buffer-local variable
      -- if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      -- 	return
      -- end
      -- Disable autoformat for files in a certain path
      local ignore_dirs = { "/node_modules/", "/venv/", "/.venv/" }
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      for _, value in ipairs(ignore_dirs) do
        if bufname:match(value) then
          return
        end
      end
      -- ...additional logic...
      return {
        timeout_ms = 500,
        lsp_fallback = true,
        async = false,
      }
    end,
  })

  vim.keymap.set({ "n", "v" }, "<leader>mp", function()
    conform.format({
      lsp_fallback = true,
      async = false,
      timeout_ms = 1000,
    })
  end, { desc = "[M]ake [P]rettier: Format file or range (in visual mode)" })
end

return M

-- vim: ts=2 sts=2 sw=2 et
