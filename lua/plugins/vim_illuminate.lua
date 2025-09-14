--------------------------------------------------------------------------------
-- Highlight words under the cursor
--------------------------------------------------------------------------------

-- Highlights
local HighlightsUtils = reload('utils.highlights')
local hi = HighlightsUtils.highlight

hi('IlluminatedWordRead',   { fg = 'text_15', attrs = 'bold' },  { fg = 'ansi_white' })
hi('IlluminatedWordText',   { fg = 'text_15', attrs = 'bold' },  { fg = 'ansi_white' })
hi('IlluminatedWordWrite',  { fg = 'text_15', attrs = 'bold' },  { fg = 'ansi_white' })

-- Config
return {
    { 'RRethy/vim-illuminate' },
}
