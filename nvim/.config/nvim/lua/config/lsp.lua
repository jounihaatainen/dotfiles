local M = {}

local lsp_setup = function(server, opts, lsp_keymap_fn)
  if not vim.tbl_isempty(opts) then
    vim.lsp.config(server, vim.tbl_extend("keep", opts, {
      on_attach = function(client, bufnr)
        lsp_keymap_fn(client, bufnr)
      end
    }))
  end
  vim.lsp.enable(server)
end

local servers = {
  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  }
}

M.setup_roslyn = function(lsp_keymap_fn)
  -- Use one of the methods in the Integration section to compose the command.
  local mason_registry = require("mason-registry")

  local rzls_path = vim.fn.expand("$MASON/packages/rzls/libexec")
  local cmd = {
    "roslyn",
    "--stdio",
    "--logLevel=Information",
    "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
    "--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
    "--razorDesignTimePath=" .. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
    "--extension",
    vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
  }

  vim.lsp.config("roslyn", {
    cmd = cmd,
    handlers = require("rzls.roslyn_handlers"),
    settings = {
      ["csharp|inlay_hints"] = {
        csharp_enable_inlay_hints_for_implicit_object_creation = true,
        csharp_enable_inlay_hints_for_implicit_variable_types = true,

        csharp_enable_inlay_hints_for_lambda_parameter_types = true,
        csharp_enable_inlay_hints_for_types = true,
        dotnet_enable_inlay_hints_for_indexer_parameters = true,
        dotnet_enable_inlay_hints_for_literal_parameters = true,
        dotnet_enable_inlay_hints_for_object_creation_parameters = true,
        dotnet_enable_inlay_hints_for_other_parameters = true,
        dotnet_enable_inlay_hints_for_parameters = true,
        dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
        dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
        dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
      },
      ["csharp|code_lens"] = {
        dotnet_enable_references_code_lens = true,
      },
    },
    on_attach = function(client, bufnr)
      lsp_keymap_fn(client, bufnr)
    end,
  })
  vim.lsp.enable("roslyn")
end

M.setup = function(lsp_keymap_fn)
  -- setup diagnostic texts & signs
  vim.diagnostic.config(
    {
      underline = false,
      virtual_text = false,
      update_in_insert = false,
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = " ",
          [vim.diagnostic.severity.INFO] = " ",
        }
      }
    }
  )

  -- setup lsps (except roslyn & rzls)
  for server_name, opts in pairs(servers) do
    lsp_setup(server_name, opts, lsp_keymap_fn)
  end
end

return M

-- vim: ts=2 sts=2 sw=2 et
