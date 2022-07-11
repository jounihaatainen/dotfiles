local M = {}

-- Debugger installation location
local HOME = os.getenv "HOME"
local DEBUGGER_LOCATION = HOME .. "/.local/bin/netcoredbg"

function M.setup()
  local dap = require "dap"

  dap.configurations.cs = {
    {
      type = "coreclr",
      name = "launch - netcoredbg",
      request = "launch",
      program = function()
        return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
      end,
    },
  }

  dap.adapters.coreclr = {
    type = 'executable',
    command = DEBUGGER_LOCATION .. '/netcoredbg',
    args = {'--interpreter=vscode'}
  }
end

return M
