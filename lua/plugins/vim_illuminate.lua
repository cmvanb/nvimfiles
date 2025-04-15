--------------------------------------------------------------------------------
-- Highlight words under the cursor
--------------------------------------------------------------------------------

-- Highlights
local HighlightsUtils = reload('utils.highlights')
local hi = HighlightsUtils.highlight

hi('IlluminatedWordRead',      { bg = 'primary_3' },                                     { fg = 'ansi_white', bg = 'ansi_blue' })
hi('IlluminatedWordText',      { bg = 'primary_3' },                                     { fg = 'ansi_white', bg = 'ansi_blue' })
hi('IlluminatedWordWrite',     { bg = 'primary_3' },                                     { fg = 'ansi_white', bg = 'ansi_blue' })

-- Config
return {
    { 'RRethy/vim-illuminate' },
}
