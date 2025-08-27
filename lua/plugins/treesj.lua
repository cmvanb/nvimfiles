--------------------------------------------------------------------------------
-- Treesj configuration
--------------------------------------------------------------------------------

local function config()
    reload('treesj').setup({
        use_default_keymaps = false,
        max_join_length = 9999,
    })
end

return {
    {
        'Wansmer/treesj',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = config,
    },
}
