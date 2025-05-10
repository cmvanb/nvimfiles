vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = "*dircolors~esh",
    callback = function()
        vim.bo.filetype = 'dircolors'
    end
})
