vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = '**/sway/*.conf',
    callback = function()
        vim.bo.filetype = 'swayconfig'
    end
})
