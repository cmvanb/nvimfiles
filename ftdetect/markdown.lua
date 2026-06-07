vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = "*.md",
    callback = function(args)
        vim.bo.filetype = 'markdown'

        -- Preview markdown keymap
        local keys = require('utils.keymaps')
        local filename = vim.api.nvim_buf_get_name(args.buf)

        keys.nnoremap(
            '<leader>v',
            function()
                vim.fn.jobstart('preview-markdown.sh ' .. vim.fn.shellescape(filename))
            end,
            {
                buffer = args.buf,
                desc = 'Preview markdown'
            }
        )
    end
})
