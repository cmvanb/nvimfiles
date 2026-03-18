--------------------------------------------------------------------------------
-- Render Markdown configuration
--------------------------------------------------------------------------------

-- Highlights
local HighlightsUtils = reload('utils.highlights')
local hi = HighlightsUtils.highlight
local ln = HighlightsUtils.link

hi('RenderMarkdownCode',  { bg = 'black' },  { bg = 'ansi_black' })  -- code blocks
hi('RenderMarkdownDash',  { fg = 'gray_4' },  { fg = 'ansi_brblack' })    -- line separator

hi('RenderMarkdownH1Bg',  { fg = 'heading_1', attrs = 'bold' },  { fg = 'ansi_brwhite' })
hi('RenderMarkdownH2Bg',  { fg = 'heading_2', attrs = 'bold' },  { fg = 'ansi_brwhite' })
hi('RenderMarkdownH3Bg',  { fg = 'heading_3', attrs = 'bold' },  { fg = 'ansi_white' })
hi('RenderMarkdownH4Bg',  { fg = 'heading_4', attrs = 'bold' },  { fg = 'ansi_white' })
hi('RenderMarkdownH5Bg',  { fg = 'heading_5', attrs = 'bold' },  { fg = 'ansi_brblack' })
hi('RenderMarkdownH6Bg',  { fg = 'heading_6', attrs = 'bold' },  { fg = 'ansi_brblack' })

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
