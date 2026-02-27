--------------------------------------------------------------------------------
-- Custom keymaps for the Lazy plugin manager UI.
--------------------------------------------------------------------------------

local augroup = vim.api.nvim_create_augroup('LazyKeymaps', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
    group = augroup,
    pattern = 'lazy',
    callback = function(event)
        local close = function()
            vim.api.nvim_win_close(0, true)
        end

        vim.keymap.set('n', 'w',     close, { buffer = event.buf, desc = 'Close Lazy', nowait = true })
        vim.keymap.set('n', '<Esc>', close, { buffer = event.buf, desc = 'Close Lazy', nowait = true })
    end,
})
