--------------------------------------------------------------------------------
-- Snacks.nvim plugins
--------------------------------------------------------------------------------

local ThemeSymbols = require('theme.symbols')
local HighlightsUtils = reload('utils.highlights')
local ln = HighlightsUtils.link
local hi = HighlightsUtils.highlight

-- Highlights
hi('SnacksPicker',        { bg = 'editor_bg' },  { bg = 'ansi_black' })

ln('SnacksPickerFile',    'File')
ln('SnacksPickerDir',     'Directory')
ln('SnacksPickerTotals',  'Title')
ln('SnacksPickerPrompt',  'Title')
ln('SnacksPickerBorder',  'WinSeparator')

-- Config
return {
    {
        'folke/snacks.nvim',
        priority = 1000,
        lazy = false,
        opts = {
            picker = {
                enabled = true,
                prompt = ThemeSymbols.picker.prompt .. ' ',

                sources = {
                    icons = {
                        icon_sources = { 'nerd_fonts', 'emoji', 'unicode' },
                    },
                },

                -- Picker layout
                ----------------------------------------------------------------
                layouts = {
                    custom = {
                        layout = {
                            backdrop = false,
                            box = 'horizontal',
                            width = 0.8,
                            min_width = 120,
                            max_width = 188,
                            height = 0.8,
                            {
                                box = 'vertical',
                                -- NOTE: For a flat/borderless layout, consider:
                                -- border = { '▗', '▄', '▖', '▌', '▘', '▀', '▝', '▐' },
                                border = 'single',
                                title = '{title} {live} {flags}',
                                {
                                    win = 'input',
                                    height = 1,
                                    border = 'bottom',
                                },
                                {
                                    win = 'list',
                                    border = 'none',
                                },
                            },
                            {
                                win = 'preview',
                                title = '{preview}',
                                border = 'single',
                                width = 0.6,
                            },
                        },
                    }
                },
                layout = 'custom',

                -- Picker keymaps
                ----------------------------------------------------------------
                win = {
                    -- input window
                    input = {
                        keys = {
                            ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
                            ['<c-n>'] = { 'edit_vsplit', mode = { 'n', 'i' } },
                            ['<c-p>'] = { 'edit_split', mode = { 'n', 'i' } },
                            ['<c-k>'] = { 'preview_scroll_up', mode = { 'n', 'i' } },
                            ['<c-j>'] = { 'preview_scroll_down', mode = { 'n', 'i' } },
                        },
                    },

                    -- preview window
                    preview = {
                        -- TODO: This doesn't work. We might need to change the
                        -- diagnostics config on the fly when using the picker.
                        diagnostics = false,
                    }
                },
            },
        },

        -- Editor keymaps
        ------------------------------------------------------------------------
        keys = {
            -- Search functions
            {
                '<leader>a',
                function() Snacks.picker.files({
                    hidden = true,
                    ignored = true,
                }) end,
                desc = 'Search files',
            },
            {
                '<leader>f',
                function() Snacks.picker.files() end,
                desc = 'Search files',
            },
            {
                '<leader>b',
                function() Snacks.picker.buffers({
                    win = {
                        input = {
                            keys = {
                                ['<c-w>'] = { 'bufdelete', mode = { 'n', 'i' } },
                            },
                        },
                        list = { keys = { ['dd'] = 'bufdelete' } },
                    },
                }) end,
                desc = 'Search buffers',
            },
            {
                '<leader>g',
                function() Snacks.picker.grep() end,
                desc = 'Grep files',
            },
            {
                '<leader>h',
                function() Snacks.picker.help() end,
                desc = 'Search help',
            },

            -- File explorer
            {
                '<leader>e',
                function() Snacks.explorer({
                    -- NOTE: Doesn't seem to work.
                    replace_netrw = true,
                }) end,
                desc = 'File explorer',
            },

            -- Insertion
            {
                '<leader>i',
                function() Snacks.picker.icons() end,
                desc = 'Insert icon',
            },
            {
                '<leader>u',
                function() Snacks.picker.icons({
                    sources = {
                        icons = {
                            icon_sources = { 'unicode' },
                        },
                    },
                }) end,
                desc = 'Insert unicode',
            }

            -- LSP functions
            -- TODO: Investigate why these bindings are not working.
            -- {
            --     'gd',
            --     function() Snacks.picker.lsp_definitions() end,
            --     desc = 'LSP: Go to type definition',
            -- },
            -- {
            --     'ge',
            --     function() Snacks.picker.diagnostics() end,
            --     desc = 'LSP: Show diagnostics',
            -- },
            -- {
            --     'gt',
            --     function() Snacks.picker.lsp_type_definitions() end,
            --     desc = 'LSP: Go to type definition',
            -- },
            -- {
            --     'gi',
            --     function() Snacks.picker.lsp_implementations() end,
            --     desc = 'LSP: Go to implementation',
            -- },
            -- {
            --     'gr',
            --     function() Snacks.picker.lsp_references() end,
            --     desc = 'LSP: Find references',
            -- },
        },
        config = function(_, opts)
            require('snacks').setup(opts)

            require('snacks.picker.source.icons').sources['unicode'] = {
                url = 'https://gist.githubusercontent.com/cmvanb/09184db6be4837c6efc365415148af6e/raw/d695721b1179fd9936dd3cefdd4ec5acbaf14581/unicode-table.json',
                v = 1,
                build = function(data)
                    local ret = {}
                    for _, item in pairs(data) do
                        table.insert(ret, {
                            name = item.name,
                            icon = item.icon,
                            source = 'unicode',
                            category = item.category,
                        })
                    end
                    return ret
                end,
            }
        end,
    },
}
