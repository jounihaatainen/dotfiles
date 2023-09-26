local M = {}

M.setup = function()
	require("nvim-treesitter.configs").setup {
		ensure_installed = {
			'bash',
			'c', 'cpp', 'c_sharp',
			'dockerfile',
			'gitcommit', 'gitignore', 'go',
			'html',
			'javascript', 'json',
			'lua',
			'markdown', 'markdown_inline',
			'python',
			'rust',
			'typescript',
			'vimdoc',
			'vim'
		},
		highlight = { enable = true },
		indent = { enable = true, disable = { 'python' } },
		textobjects = {
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					[']m'] = '@function.outer',
					[']]'] = '@class.outer',
				},
				goto_next_end = {
					[']M'] = '@function.outer',
					[']['] = '@class.outer',
				},
				goto_previous_start = {
					['[m'] = '@function.outer',
					['[['] = '@class.outer',
				},
				goto_previous_end = {
					['[M'] = '@function.outer',
					['[]'] = '@class.outer',
				},
			},
		},
	}
end

return M

-- vim: ts=2 sts=2 sw=2 et
