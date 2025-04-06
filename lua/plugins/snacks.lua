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
        }
    },
}
