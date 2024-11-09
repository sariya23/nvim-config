return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	opts = {
		filesystem = {

			filtered_items = {
				visible = true,

			},
		},
	},

	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},

	config = function()
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none", fg = "none" })
		vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none", fg = "none" })
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.INFO] = " ",
					[vim.diagnostic.severity.HINT] = " ",
				},
			},

		})
		require("neo-tree").setup({
			close_if_last_window = false,
			sources = { "filesystem", "buffers", "git_status" },

		})
		vim.api.nvim_create_autocmd("TermClose", {

			pattern = "*lazygit",
			callback = function()
				if package.loaded["neo-tree.sources.git_status"] then
					require("neo-tree.sources.git_status").refresh()
				end
			end,
		})
	end,
}
