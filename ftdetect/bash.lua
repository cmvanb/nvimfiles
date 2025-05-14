vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = "*.sh~esh",
    callback = function()
        vim.bo.filetype = 'bash'
    end
})
