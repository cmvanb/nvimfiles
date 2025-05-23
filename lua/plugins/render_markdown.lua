--------------------------------------------------------------------------------
-- Render Markdown configuration
--------------------------------------------------------------------------------

-- Highlights
local HighlightsUtils = reload('utils.highlights')
local hi = HighlightsUtils.highlight
local ln = HighlightsUtils.link

hi('RenderMarkdownCode',  { bg = 'primary_1' },  { bg = 'ansi_blue' })
hi('RenderMarkdownDash',  { fg = 'text_6' },  { fg = 'ansi_brblack' })

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
            code = {
                sign = false,
                highlight = 'RenderMarkdownCode',
                left_margin = 4,
                left_pad = 2,
                right_pad = 2,
                width = 'block',
            },
        },
        ft = { 'markdown', 'Avante' },
    },
}
