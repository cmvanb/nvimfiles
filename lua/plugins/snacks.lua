--------------------------------------------------------------------------------
-- Snacks.nvim plugins
--------------------------------------------------------------------------------

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
            {
                '<leader>e',
                function() Snacks.explorer({
                    replace_netrw = true,
                }) end,
                desc = 'File explorer',
            },
        },
    },
}
