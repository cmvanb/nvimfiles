--------------------------------------------------------------------------------
-- Telescope configuration
--------------------------------------------------------------------------------

-- Highlights
local HighlightsUtils = reload('utils.highlights')
local ln = HighlightsUtils.link

ln('TelescopeNormal',         'FloatMenuNormal')
ln('TelescopeBorder',         'WinSeparator')
ln('TelescopeTitle',          'Title')
ln('TelescopePromptCounter',  'TelescopeTitle')
ln('TelescopePromptPrefix',   'TelescopeTitle')
ln('TelescopeMatching',       'FloatMenuItemMatch')
ln('TelescopeSelection',      'FloatMenuSelection')
ln('TelescopePreviewNormal',  'Normal')

-- Config
local telescope = reload('telescope')
local actions = reload('telescope.actions')

local ThemeSymbols = reload('theme.symbols')

local function config()
    telescope.setup({
        defaults = {
            border = true,
            borderchars = ThemeSymbols.borderchars,
            dynamic_preview_title = true,
            layout_strategy = 'flex',
            layout_config = {
                flip_columns = 133,
                prompt_position = 'top',
                horizontal = {
                    mirror = false,
                    preview_width = 0.5,
                },
                vertical = {
                    mirror = true,
                    preview_height = 0.5,
                },
            },
            sorting_strategy = 'ascending',
            prompt_prefix = ThemeSymbols.picker.prompt .. ' ',
            selection_caret = '  ',
            vimgrep_arguments = {
                'rg',
                '--color=never',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',
                '--smart-case',
                '--hidden',
                '--ignore',
            },
            mappings = {
                i = {
                    ['<C-w>'] = actions.delete_buffer,
                    ['<C-n>'] = actions.select_vertical,
                    ['<C-p>'] = actions.select_horizontal,
                    ['<Esc>'] = actions.close,
                },
            },
        },
    })
end

return {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = config,
    },
}
