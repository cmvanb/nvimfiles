--------------------------------------------------------------------------------
-- Snacks.nvim plugins
--------------------------------------------------------------------------------

-- Highlights
local HighlightsUtils = reload('utils.highlights')
local hi = HighlightsUtils.highlight
local ln = HighlightsUtils.link

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

            -- TODO: Investigate why these bindings are not working.
            -- LSP functions
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
