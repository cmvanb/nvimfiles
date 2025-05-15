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

                -- Picker layout
                ----------------------------------------------------------------
                layouts = {
                    custom = {
                        layout = {
                            backdrop = false,
                            box = 'horizontal',
                            width = 0.8,
                            min_width = 120,
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
                                width = 0.5,
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
                        },
                    },
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
    },
}
