-- Вызывать go fmt после сохранения файла :w
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()

        vim.cmd("silent! lua vim.lsp.buf.format()")
        vim.cmd("silent! !go fmt %")
    end,
})

