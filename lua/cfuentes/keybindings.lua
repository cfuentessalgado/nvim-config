local wk = require("which-key")
wk.register({
    l = {
        name = "lsp", -- optional group name
        f = { "<cmd>Format<cr>", "Format" }, -- create a binding with label
        a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", 'Code Action' }
    },
}, { prefix = "<leader>" })



vim.keymap.set('n', '<C-s>', function()
    vim.api.nvim_command('write')
end)
vim.keymap.set('n', '<C-t>', function()
    vim.api.nvim_command('PhpTestOnSaveHomestead')
end)
