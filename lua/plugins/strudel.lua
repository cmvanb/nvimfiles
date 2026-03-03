return {
    'gruvw/strudel.nvim',
    build = 'npm ci',
    config = function()
        reload('strudel').setup()
    end,
}
