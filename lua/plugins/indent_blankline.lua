--------------------------------------------------------------------------------
-- Indent blankline
--------------------------------------------------------------------------------

-- Highlights
local HighlightsUtils = reload('utils.highlights')
local hi = HighlightsUtils.highlight

hi('IblIndent',      { fg = 'gray_1' },                                        { fg = 'ansi_brblack' })
hi('IblWhitespace',  { fg = 'gray_1' },                                        { fg = 'ansi_brblack' })
hi('IblScope',       { fg = 'gray_4' },                                        { fg = 'ansi_brblack' })

-- Config
local function config()
    local ThemeSymbols = reload('theme.symbols')

    reload('ibl').setup({
        indent = {
            char = ThemeSymbols.indent_char,
        },
        scope = {
            enabled = true,
        }
    })
end

return {
    {
        'lukas-reineke/indent-blankline.nvim',
        config = config,
    },
}
