--------------------------------------------------------------------------------
-- Gitsigns configuration
--------------------------------------------------------------------------------

-- Highlights
local HighlightsUtils = reload('utils.highlights')
local hi = HighlightsUtils.highlight

hi('GitSignsAddCul',     { fg = 'green_3', bg = 'primary_2', attrs = 'bold' },   { fg = 'ansi_green', bg = 'ansi_blue' })
hi('GitSignsChangeCul',  { fg = 'orange_3', bg = 'primary_2', attrs = 'bold' },  { fg = 'ansi_yellow', bg = 'ansi_blue' })
hi('GitSignsDeleteCul',  { fg = 'red_3', bg = 'primary_2', attrs = 'bold' },     { fg = 'ansi_red', bg = 'ansi_blue' })

-- Config
local function config()
    local ThemeSymbols = reload('theme.symbols')

    reload('gitsigns').setup({
        -- Enable cursor line highlights (fixes missing background color
        -- in sign column)
        culhl = true,
        signs = {
            add          = { text = ThemeSymbols.git_signs.add },
            change       = { text = ThemeSymbols.git_signs.change },
            delete       = { text = ThemeSymbols.git_signs.delete },
            topdelete    = { text = ThemeSymbols.git_signs.topdelete },
            changedelete = { text = ThemeSymbols.git_signs.changedelete },
            untracked    = { text = ThemeSymbols.git_signs.untracked },
        },
    })
end

return {
    {
        'lewis6991/gitsigns.nvim',
        config = config,
    },
}
