--------------------------------------------------------------------------------
-- Treesitter configuration
--------------------------------------------------------------------------------

local ensure_installed = {
    'bash',
    'c',
    'c_sharp',
    'cpp',
    'css',
    'dockerfile',
    'dtd',
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
    'xml',
    'yaml',
    'zig',
}

local function config()
    require('nvim-treesitter').setup()

    -- Install parsers asynchronously; already-installed parsers are skipped.
    require('nvim-treesitter').install(ensure_installed)

    -- Enable treesitter features per-buffer on FileType.
    -- Highlighting and folding are native Neovim features; indentation is
    -- provided by this plugin (experimental).
    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter_features', { clear = true }),
        callback = function(ev)
            -- start() returns nil on success, raises on unknown language
            local ok = pcall(vim.treesitter.start, ev.buf)
            if not ok then return end

            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

            vim.wo[0][0].foldmethod = 'expr'
            vim.wo[0][0].foldexpr   = 'v:lua.vim.treesitter.foldexpr()'
        end,
    })
end

return {
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        -- This plugin does not support lazy loading
        lazy = false,
        build = ':TSUpdate',
        config = config,
    },
}
