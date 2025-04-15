--------------------------------------------------------------------------------
-- Leap configuration
--------------------------------------------------------------------------------

-- Highlights
local HighlightsUtils = reload('utils.highlights')
local hi = HighlightsUtils.highlight

hi('LeapMatch',           { fg = 'debug', attrs = 'bold' },                         { fg = 'ansi_magenta' })
hi('LeapLabelPrimary',    { fg = 'gray_0', bg = 'primary_15', attrs = 'bold' },     { fg = 'ansi_magenta' })
hi('LeapLabelSecondary',  { fg = 'primary_2', bg = 'primary_11', attrs = 'bold' },  { fg = 'ansi_brmagenta' })
hi('LeapLabelSelected',   { fg = 'debug', attrs = 'bold' },                         { fg = 'ansi_brmagenta' })

-- Config
local function config()
    reload('leap').setup({
        case_sensitive = true,
    })
end

return {
    {
        'ggandor/leap.nvim',
        config = config,
    },
}
