--------------------------------------------------------------------------------
-- Treesitter configuration
--------------------------------------------------------------------------------

local function config()
    reload('nvim-treesitter.configs').setup({
        ensure_installed = {
            'bash',
            'c',
            'c_sharp',
            'cpp',
            'css',
            'dockerfile',
            'fish',
            'go',
            'html',
            'javascript',
            'json',
            'lua',
            'make',
            'markdown',
            'markdown_inline',
            'nix',
            'python',
            'rust',
            'toml',
            'typescript',
            'vim',
            'yaml',
            'zig',
        },
        auto_install = true,
        highlight = {
            enable = true,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<A-S-j>',    -- gnn
                node_incremental = '<A-S-j>',  -- grn
                node_decremental = '<A-S-k>',  -- grm
                scope_incremental = 'grc', -- grc
            },
        },
        indent = {
            enable = true
        },
        playground = {
            enable = true,
        }
    })
end

return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = function()
            local ts_update = reload('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
        config = config,
    },
    { 'nvim-treesitter/playground' },
}
