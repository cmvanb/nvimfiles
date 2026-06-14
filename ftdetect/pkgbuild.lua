vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '**/PKGBUILD' },
    callback = function()
        vim.bo.filetype = 'PKGBUILD'
    end
})
