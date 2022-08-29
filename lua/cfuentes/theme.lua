local lualine = require('lualine')
local gitsigns = require('gitsigns')
local autopairs = require('nvim-autopairs')
local comment = require('Comment')
vim.g.tokyonight_style = "night"
vim.cmd([[colorscheme tokyonight]])

lualine.setup()
gitsigns.setup()
autopairs.setup()
comment.setup({
    mappings = {
        extra = true
    }
})
