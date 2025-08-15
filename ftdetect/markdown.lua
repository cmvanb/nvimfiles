vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = "*.md",
    callback = function()
        vim.bo.filetype = 'markdown'

        -- Wrap long lines
        vim.opt.wrap = true
    end
})
