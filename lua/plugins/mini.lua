--------------------------------------------------------------------------------
-- Mini.nvim plugins
--------------------------------------------------------------------------------

local function config()
    reload('mini.comment').setup({
        mappings = {
            -- Toggle comment on current line (NORMAL)
            comment_line = '<C-/>',
            -- Toggle comment on selection (VISUAL)
            comment_visual = '<C-/>',
            -- Define 'comment' textobject (like `dgc` - delete whole comment block)
            textobject = 'gc',
        },
    })

    reload('mini.pairs').setup({
        modes = { insert = true, command = false, terminal = false },

        mappings = {
            ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
            ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
            ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },
            ['<'] = { action = 'open', pair = '<>', neigh_pattern = '[^\\].' },

            [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
            [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
            ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },
            ['>'] = { action = 'close', pair = '<>', neigh_pattern = '[^\\].' },

            ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
            ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
            ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
        },
    })
end

return {
    {
        'echasnovski/mini.nvim',
        config = config,
    },
}
