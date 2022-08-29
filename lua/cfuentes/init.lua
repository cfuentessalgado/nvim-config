local group = vim.api.nvim_create_augroup('cfuentes-group', { clear = true })

vim.api.nvim_create_autocmd('BufWritePost', {
    group = group,
    pattern = "init.lua",
    callback = function()
        vim.cmd([[source %]])
    end
})

vim.api.nvim_create_user_command('Format', function(bufnr)
    vim.lsp.buf.format()
end, {})
