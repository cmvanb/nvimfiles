--------------------------------------------------------------------------------
-- Avante AI plugin
--------------------------------------------------------------------------------

-- Highlights
local HighlightsUtils = reload('utils.highlights')
local hi = HighlightsUtils.highlight

hi('AvanteConflictCurrent',   { bg = 'red_1' },    { bg = 'ansi_red' })
hi('AvanteConflictIncoming',  { bg = 'green_1' },  { bg = 'ansi_green' })

-- Config
return {
    {
        'yetone/avante.nvim',
        event = 'VeryLazy',
        -- Never set this value to '*'! Never!
        version = false,
        opts = {
            provider = 'claude',
        },
        build = 'make',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'stevearc/dressing.nvim',
            'nvim-lua/plenary.nvim',
            'MunifTanjim/nui.nvim',
            'MeanderingProgrammer/render-markdown.nvim',
        },
    }
}
