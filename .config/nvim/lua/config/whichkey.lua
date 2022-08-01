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

  local opts = {
    mode = "n", -- Normal mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
  }

  local mappings = {
    ["w"] = { "<cmd>update!<CR>", "Save" },
    ["q"] = { "<cmd>q!<CR>", "Quit" },

    b = {
      name = "Buffer",
      c = { "<Cmd>bd!<Cr>", "Close current buffer" },
      D = { "<Cmd>%bd|e#|bd#<Cr>", "Delete all buffers" },
      b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Go to buffer" },
    },

    f = {
      name = "Find",
      f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "Files" },
      F = { "<cmd>FzfLua files<cr>", "Files (FZF)" },
      p = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "Git Files" },
      P = { "<cmd>FzfLua git_files<cr>", "Git Files (FZF)" },
      b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Buffers" },
      B = { "<cmd>FzfLua buffers<cr>", "Buffers (FZF)" },
      o = { "<cmd>lua require('telescope.builtin').oldfiles()<cr>", "Old Files" },
      O = { "<cmd>FzfLua oldfiles<cr>", "Old Files (FZF)" },
      g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "Live Grep" },
      G = { "<cmd>FzfLua live_grep<cr>", "Live Grep" },
      c = { "<cmd>lua require('telescope.builtin').commands()<cr>", "Commands" },
      C = { "<cmd>FzfLua commands<cr>", "Commands (FZF)" },
      r = { "<cmd>Telescope file_browser<cr>", "Browser" },
      w = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Current Buffer" },
    },

    p = {
      name = "Project",
      p = { "<cmd>lua require'telescope'.extensions.project.project{}<cr>", "List" },
      s = { "<cmd>Telescope repo list<cr>", "Search" },
    },

    P = {
      name = "Packer",
      c = { "<cmd>PackerCompile<cr>", "Compile" },
      i = { "<cmd>PackerInstall<cr>", "Install" },
      s = { "<cmd>PackerSync<cr>", "Sync" },
      S = { "<cmd>PackerStatus<cr>", "Status" },
      u = { "<cmd>PackerUpdate<cr>", "Update" },
    },

    G = {
      name = "Git",
      s = { "<cmd>Neogit<CR>", "Status" },
    },
  }

  whichkey.setup(conf)
  whichkey.register(mappings, opts)
end

return M
