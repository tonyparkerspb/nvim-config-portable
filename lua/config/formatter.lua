require("formatter").setup({
	logging = true,
	filetype = {
		typescriptreact = {
			-- prettier
			function()
				return {
					exe = "prettier",
					args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
					stdin = true,
				}
			end,
		},
		typescript = {
			-- prettier
			function()
				return {
					exe = "prettier",
					args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
					stdin = true,
				}
			end,
			-- linter
			function()
				return {
					exe = "eslint",
					args = {
						"--stdin-filename",
						vim.api.nvim_buf_get_name(0),
						"--fix",
						"--cache",
					},
					stdin = true,
				}
			end,
		},
		vue = {
			-- prettier
			function()
				return {
					exe = "prettier",
					args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
					stdin = true,
				}
			end,
			-- linter
			function()
				return {
					exe = "eslint",
					args = {
						"--stdin-filename",
						vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
						"--fix",
						"--cache",
					},
					stdin = true,
				}
			end,
		},
		javascript = {
			-- prettier
			function()
				return {
					exe = "prettier",
					args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
					stdin = true,
				}
			end,
			-- linter
			function()
				return {
					exe = "eslint",
					args = {
						"--stdin-filename",
						vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
						"--fix",
						"--cache",
					},
					stdin = true,
				}
			end,
		},
		javascriptreact = {
			-- prettier
			function()
				return {
					exe = "prettier",
					args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
					stdin = true,
				}
			end,
		},
		json = {
			-- prettier
			function()
				return {
					exe = "prettier",
					args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
					stdin = true,
				}
			end,
		},
		html = {
			-- prettier
			function()
				return {
					exe = "prettier",
					args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
					stdin = true,
				}
			end,
		},
		css = {
			-- prettier
			function()
				return {
					exe = "prettier",
					args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
					stdin = true,
				}
			end,
		},
		lua = {
			-- luafmt
			function()
				return {
					exe = "lua-format",
					args = { "--indent-width", 2 },
					stdin = true,
				}
			end,
		},
		swift = {
			-- luafmt
			function()
				return {
					exe = "swift-format",
					args = { "--indent-count", 2, "--stdin" },
					stdin = true,
				}
			end,
		},
	},
})
