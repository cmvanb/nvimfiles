--------------------------------------------------------------------------------
-- Show the startup screen when Neovim starts without files or commands.
--------------------------------------------------------------------------------

local augroup = vim.api.nvim_create_augroup('StartupScreen', { clear = true })

local function is_bare_start()
    if vim.fn.argc() > 0 or vim.g.started_with_stdin or #vim.api.nvim_list_uis() == 0 then
        return false
    end
    for _, arg in ipairs(vim.v.argv) do
        if arg:sub(1, 1) == '+' or vim.list_contains({ '-c', '-S', '-q', '-d', '-t' }, arg) then
            return false
        end
    end
    return true
end

vim.api.nvim_create_autocmd('StdinReadPre', {
    group = augroup,
    callback = function() vim.g.started_with_stdin = true end,
})

vim.api.nvim_create_autocmd('VimEnter', {
    group = augroup,
    nested = true,
    callback = function()
        if is_bare_start() then
            require('startup').open()
        end
    end,
})
