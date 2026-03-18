--------------------------------------------------------------------------------
-- Render Markdown configuration
--------------------------------------------------------------------------------

-- Highlights
local HighlightsUtils = reload('utils.highlights')
local hi = HighlightsUtils.highlight
local ln = HighlightsUtils.link

hi('RenderMarkdownCode',  { bg = 'black' },  { bg = 'ansi_black' })  -- code blocks
hi('RenderMarkdownDash',  { fg = 'gray_4' },  { fg = 'ansi_brblack' })    -- line separator

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
            file_types = { 'markdown' },
            bullet = {
                enabled = true,
                icons = { '•', '◦', '⬥', '⬦' },
                left_pad = 2,
            },
            code = {
                sign = false,
                highlight = 'RenderMarkdownCode',
                left_margin = 3,
                left_pad = 1,
                right_pad = 2,
                inline = true,
                inline_pad = 1,
                width = 'block',
            },
        },
        ft = { 'markdown' },
    },
}
