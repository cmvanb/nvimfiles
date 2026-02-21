--------------------------------------------------------------------------------
-- Treesitter configuration
--------------------------------------------------------------------------------

local function config()
    require('nvim-treesitter.configs').setup({
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
                init_selection = '<Enter>',    -- gnn
                node_incremental = '<A-j>',    -- grn
                node_decremental = '<A-k>',    -- grm
                scope_incremental = '<Enter>', -- grc
            },
        },
        indent = {
            enable = true
        },
    })
end

return {
    {
        'nvim-treesitter/nvim-treesitter',
        -- Treesitter plugin does not support lazy loading
        lazy = false,
        build = ':TSUpdate',
        config = config,
    },
}
