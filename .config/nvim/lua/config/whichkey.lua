local M = {}

function M.setup()
  local status_ok, whichkey = pcall(require, 'which-key')

  if not status_ok then
    return
  end

  local conf = {
    window = {
      border = "single", -- none, single, double, shadow
      position = "bottom", -- bottom, top
    },
  }

  local opts_n = {
    mode = "n", -- Normal mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
  }

  -- local opts_v = {
  --   mode = "v", -- Visual mode
  --   prefix = "<leader>",
  --   buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  --   silent = true, -- use `silent` when creating keymaps
  --   noremap = true, -- use `noremap` when creating keymaps
  --   nowait = false, -- use `nowait` when creating keymaps
  -- }

  local keymap_n = {
    ["w"] = { "<cmd>update!<CR>", "Save" },
    ["q"] = { "<cmd>q!<CR>", "Quit" },

    b = {
      name = "Buffer",
      c = { "<Cmd>bd!<Cr>", "Close current buffer" },
      D = { "<Cmd>%bd|e#|bd#<Cr>", "Delete all buffers" },
      b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Go to buffer" },
      a = { "<cmd>lua require('quiver').add_current()<cr>", "Add to Quiver" },
      g = { "<cmd>lua require('quiver').pick()<cr>", "Pick from Quiver" },
    },

    f = {
      name = "Find",
      f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "Files" },
      p = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "Git Files" },
      b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Buffers" },
      o = { "<cmd>lua require('telescope.builtin').oldfiles()<cr>", "Old Files" },
      g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "Live Grep" },
      s = { "<cmd>lua require('telescope.builtin').grep_string()<cr>", "Search Word (under cursor)" },
      c = { "<cmd>lua require('telescope.builtin').commands()<cr>", "Commands" },
      r = { "<cmd>Telescope file_browser<cr>", "Browser" },
      w = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Current Buffer" },
      h = { "<cmd>lua require('telescope.builtin').help_tags()<cr>", "Help Tags" },
    },

    -- p = {
    --   name = "Project",
    --   p = { "<cmd>lua require'telescope'.extensions.project.project{}<cr>", "List" },
    --   s = { "<cmd>Telescope repo list<cr>", "Search" },
    -- },

    -- P = {
    --   name = "Packer",
    --   c = { "<cmd>PackerCompile<cr>", "Compile" },
    --   i = { "<cmd>PackerInstall<cr>", "Install" },
    --   s = { "<cmd>PackerSync<cr>", "Sync" },
    --   S = { "<cmd>PackerStatus<cr>", "Status" },
    --   u = { "<cmd>PackerUpdate<cr>", "Update" },
    -- },

    G = {
      name = "Git",
      s = { "<cmd>lua require('telescope.builtin').git_status()<cr>", "Git Status" },
      S = { "<cmd>Neogit<CR>", "Status" },
    },

  --   d = {
  --     name = "Debug",
  --     R = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run to Cursor" },
  --     E = { "<cmd>lua require'dapui'.eval(vim.fn.input '[Expression] > ')<cr>", "Evaluate Input" },
  --     C = { "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>", "Conditional Breakpoint" },
  --     U = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
  --     b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
  --     c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
  --     d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
  --     e = { "<cmd>lua require'dapui'.eval()<cr>", "Evaluate" },
  --     g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
  --     h = { "<cmd>lua require'dap.ui.widgets'.hover()<cr>", "Hover Variables" },
  --     S = { "<cmd>lua require'dap.ui.widgets'.scopes()<cr>", "Scopes" },
  --     i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
  --     o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
  --     p = { "<cmd>lua require'dap'.pause.toggle()<cr>", "Pause" },
  --     q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
  --     r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
  --     s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
  --     t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
  --     x = { "<cmd>lua require'dap'.terminate()<cr>", "Terminate" },
  --     u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
  --   },
  }

  -- local keymap_v = {
  --   e = { "<cmd>lua require'dapui'.eval()<cr>", "Evaluate" },
  -- }

  whichkey.setup(conf)
  whichkey.register(keymap_n, opts_n)
  -- whichkey.register(keymap_v, opts_v)
end

return M
