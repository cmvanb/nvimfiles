--------------------------------------------------------------------------------
-- Github Copilot
--------------------------------------------------------------------------------

-- Highlights
local HighlightsUtils = reload('utils.highlights')
local hi = HighlightsUtils.highlight

hi('CopilotSuggestion',  { fg = 'text_6' },  { fg = 'ansi_brblack' })

-- Config
return {
    { 'github/copilot.vim' },
}
