--------------------------------------------------------------------------------
-- Treesj configuration
--------------------------------------------------------------------------------

local function config()
    reload('treesj').setup({
        use_default_keymaps = false,
    })
end

return {
    {
        'Wansmer/treesj',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = config,
    },
}
