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
                local stderr = {}
                vim.fn.jobstart('preview-markdown.sh ' .. vim.fn.shellescape(filename), {
                    stderr_buffered = true,
                    on_stderr = function(_, data)
                        stderr = data
                    end,
                    on_exit = function(_, code)
                        if code ~= 0 then
                            vim.notify(
                                'preview-markdown.sh failed (exit ' .. code .. ')\n' .. table.concat(stderr, '\n'),
                                vim.log.levels.ERROR
                            )
                        end
                    end
                })
            end,
            {
                buffer = args.buf,
                desc = 'Preview markdown'
            }
        )
    end
})
