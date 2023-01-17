local M = {}

local servers = {
  html = {},
  jsonls = {},
  lemminx = {},
  cssls = {},
  tsserver = {},
  sumneko_lua = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
          -- Setup your lua path
          path = vim.split(package.path, ";"),
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          },
        },
      },
    },
  },
  omnisharp = {},
  pyright = {},
  ccls = {},
  vimls = {},
  bashls = {},
  marksman = {},
}

local lsp_signature = require "lsp_signature"
lsp_signature.setup {
  bind = true,
  handler_opts = {
    border = "rounded",
  },
}

local lsp_colors = require "lsp-colors"
lsp_colors.setup {
  Error = "#db4b4b",
  Warning = "#e0af68",
  Information = "#0db9d7",
  Hint = "#10B981"
}

local function on_attach(client, bufnr)
  -- Enable completion triggered by <C-X><C-O>
  -- See `:help omnifunc` and `:help ins-completion` for more information.
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Use LSP as the handler for formatexpr.
  -- See `:help formatexpr` for more information.
  vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()")

  -- Configure key mappings
  require("config.lsp.keymaps").setup(client, bufnr)

  -- Configure highlighting
  require("config.lsp.highlighting").setup(client)

  -- Show line diagnostics automatically in hover window
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local float_opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = 'rounded',
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
      }
      vim.diagnostic.open_float(nil, float_opts)
    end
  })

  -- Configure symbol outline
  require("symbols-outline").setup {
    auto_preview = false,
  }
end

-- local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

local opts = {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
}

local handlers = require("config.lsp.handlers")
handlers.setup()

function M.setup()
  require("config.lsp.installer").setup(servers, opts)
end

return M
