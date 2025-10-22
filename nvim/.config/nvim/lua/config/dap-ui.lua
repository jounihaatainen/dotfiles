local dap = require("dap")
local dapui = require("dapui")

-- open ui immediately when debugging starts
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

-- minimal ui (just local variables)
dapui.setup({
  expand_lines = true,
  controls = { enabled = false }, -- no extra play/step buttons
  floating = { border = "rounded" },
  -- Set dapui window
  render = {
    max_type_length = 60,
    max_value_lines = 200,
  },
  -- Only one layout: just the "scopes" (variables) list at the bottom
  layouts = {
    {
      elements = {
        { id = "scopes", size = 1.0 }, -- 100% of this panel is scopes
      },
      size = 15,                       -- height in lines (adjust to taste)
      position = "bottom",             -- "left", "right", "top", "bottom"
    },
  },
})

-- make breakpoints prettier
vim.api.nvim_set_hl(0, 'DapBreakpointSymbol', { fg = "#db4b4b" })
vim.api.nvim_set_hl(0, 'DapStoppedSymbol', { fg = "#9ece6a" })
vim.fn.sign_define('DapBreakpoint',
{
  text = '●',
  texthl = 'DapBreakpointSymbol',
  linehl = 'DapBreakpoint',
  numhl = 'DapBreakpoint'
})

vim.fn.sign_define('DapStopped',
{
  text = '▶',
  texthl = 'DapStoppedSymbol',
  linehl = 'DapBreakpoint',
  numhl = 'DapBreakpoint'
})
vim.fn.sign_define('DapBreakpointRejected',
{
  text = '○',
  texthl = 'DapBreakpointSymbol',
  linehl = 'DapBreakpoint',
  numhl = 'DapBreakpoint'
})

-- vim: ts=2 sts=2 sw=2 et
