local dap = require("dap")

local mason_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg"

local netcoredbg_adapter = {
  type = "executable",
  command = mason_path,
  args = { "--interpreter=vscode" },
}

dap.adapters.netcoredbg = netcoredbg_adapter -- needed for normal debugging
dap.adapters.coreclr = netcoredbg_adapter    -- needed for unit test debugging

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      --return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/net9.0/", "file")
      return require("dap-dll-picker").build_dll_path()
    end,

    -- justMyCode = false,
    -- stopAtEntry = false,
    -- -- program = function()
    -- --   -- todo: request input from ui
    -- --   return "/path/to/your.dll"
    -- -- end,
    env = {
      ASPNETCORE_ENVIRONMENT = function()
        -- todo: request input from ui
        return "Development"
      end,
      ASPNETCORE_URLS = function()
        -- todo: request input from ui
        return "https://localhost:3001;http://localhost:3000"
      end,
    },
    -- cwd = function()
    --   -- todo: request input from ui
    --   return vim.fn.getcwd()
    -- end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
