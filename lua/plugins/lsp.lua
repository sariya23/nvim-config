return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {

			"shrsh7th/cmp-nvim-lsp",

		},

		config = function()
			local lspconfig = require("lspconfig")
			local configs = require("lspconfig.configs")

			local util = require("lspconfig.util")


			vim.filetype.add({ extension = { brief = "brief" } })

			-- Inject Brief LSP
			if not configs.briefls then

				configs.briefls = {
					default_config = {
						cmd = { "briefls" },

						filetypes = { "brief" },
						root_dir = function(fname)
							return util.root_pattern(".git")(fname)
						end,

						single_file_support = true,
						capabilities = {

							workspace = {

								didChangeWatchedFiles = {

									dynamicRegistration = true,

								},
							},
						},
					},
					settings = {},
				}
			end

			-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
			--local capabilities = vim.lsp.protocol.make_client_capabilities()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()


			lspconfig.lua_ls.setup({})

			lspconfig.gopls.setup({})
			lspconfig.ts_ls.setup({})
			lspconfig.pyright.setup({})

			lspconfig.briefls.setup({

				flags = {
					debounce_text_changes = 150,
				},
				capabilities = capabilities,
			})
			--vim.lsp.start({ cmd = { "briefls" } })

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- поиск места, где определена сущность.
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts) -- поиск мест, где используется метод.
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                    -- Клавиша для закрытия quickfix или location list
                    vim.keymap.set("n", "<leader>q", "<cmd>cclose<CR>", { noremap = true, silent = true }) -- Закрыть quickfix list
                    vim.keymap.set("n", "<leader>l", "<cmd>lclose<CR>", { noremap = true, silent = true }) -- Закрыть location list

					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename Symbol" })
					vim.keymap.set({ "n", "v" }, "<Leader>la", vim.lsp.buf.code_action, opts) -- различные действия с кодом, к примеру импорты и т.п.
					vim.keymap.set("n", "<Leader>lf", function() -- форматирование кода.
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
			})
		end,
	},
}
