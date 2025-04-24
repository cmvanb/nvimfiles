--------------------------------------------------------------------------------
-- Render Markdown configuration
--------------------------------------------------------------------------------

-- Highlights
local HighlightsUtils = reload('utils.highlights')
local hi = HighlightsUtils.highlight
local ln = HighlightsUtils.link

hi('RenderMarkdownCode',  { bg = 'primary_1' },  { bg = 'ansi_blue' })

ln('RenderMarkdownH1Bg',  'Title')
ln('RenderMarkdownH2Bg',  'Title')
ln('RenderMarkdownH3Bg',  'Title')
ln('RenderMarkdownH4Bg',  'Title')
ln('RenderMarkdownH5Bg',  'Title')
ln('RenderMarkdownH6Bg',  'Title')

-- Config
return {
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
        opts = {
            file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
    },
}
