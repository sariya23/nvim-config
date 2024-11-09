-- Basic
--
require('core.plugins')
require('core.mappings')
require('core.colors')
require('core.configs')
-- Plugs
require('plugins.neotree')
require('plugins.treesitter')
require('plugins.lsp')
require('plugins.cmp')
require('plugins.mason')
require('plugins.telescope')

-- init.lua
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()

        vim.cmd("silent! lua vim.lsp.buf.format()")
        vim.cmd("silent! !go fmt %")
    end,
})

