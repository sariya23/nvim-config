local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then

  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)

  end

end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	{ 'phaazon/hop.nvim' },
	{
    	"nvim-neo-tree/neo-tree.nvim",
    	branch = "v3.x",
    	dependencies = {
      		"nvim-lua/plenary.nvim",
      		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      		"MunifTanjim/nui.nvim",
    }
},
{ 'nvim-treesitter/nvim-treesitter' },
{ 
    'neovim/nvim-lspconfig',
    config = function()
            -- Подключение сервера для Go
            require("lspconfig").gopls.setup {
                on_attach = function(client, bufnr)
                    -- Настройте ваши on_attach параметры здесь, например:
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format()  -- Выполняет автоформатирование при сохранении
                        end,
                    })
                    local opts = { noremap=true, silent=true, buffer=bufnr }
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                    -- и т.д.
                end,
                settings = {
                    gopls = {
                        gofumpt = true,
                        analyses = {
                            unusedparams = true,
                        },
                        staticcheck = true,
                    },
                },
            }
                        require("lspconfig").pyright.setup {
                on_attach = function(client, bufnr)
                    -- Настройка клавиш для Python (можно использовать те же)
                    local opts = { noremap=true, silent=true, buffer=bufnr }
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                end,
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = "basic",
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                        },
                    },
                },
            }
        end,
},
{ 'joshdick/onedark.vim' },
-- { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = ...},
{ 'hrsh7th/cmp-nvim-lsp' },
{'hrsh7th/cmp-buffer'},
{'hrsh7th/cmp-path'},
{'hrsh7th/cmp-cmdline'}, 
{'hrsh7th/nvim-cmp'},
{
    "williamboman/mason.nvim",
    build = ":MasonUpdate"
},
{
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    dependencies = {'nvim-lua/plenary.nvim'}
}
})

