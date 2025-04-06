--------------------------------------------------------------------------------
-- Gitsigns configuration
--------------------------------------------------------------------------------

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
