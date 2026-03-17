--------------------------------------------------------------------------------
-- Equalize splits when window size changes.
--------------------------------------------------------------------------------

local augroup = vim.api.nvim_create_augroup('EqualizeSplits', { clear = true })

vim.api.nvim_create_autocmd({ 'VimEnter', 'VimResized' }, {
    group = augroup,
    callback = function()
        vim.cmd('wincmd =')
    end,
})
