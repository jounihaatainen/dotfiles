local M = {}

M.setup = function()
	require('telescope').setup {
		defaults = {
			layout_strategy = 'vertical',
			layout_config = {
				vertical = {
					width = 0.9,
					preview_cutoff = 30,
				}
			},
			path_display = { "smart" },
			mappings = {
				i = {
					["<C-j>"] = require('telescope.actions').move_selection_next,
					["<C-k>"] = require('telescope.actions').move_selection_previous,
					["<C-p>"] = require('telescope.actions').cycle_history_prev,
					["<C-n>"] = require('telescope.actions').cycle_history_next
				}
			}
		}
	}

  -- Enable telescope fzf native, if installed
  pcall(require('telescope').load_extension, 'fzf')
end

return M

-- vim: ts=2 sts=2 sw=2 et
