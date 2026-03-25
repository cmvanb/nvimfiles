--------------------------------------------------------------------------------
-- Plugin configuration
--------------------------------------------------------------------------------

return {
    -- Sugar for UNIX shell commands.
    { 'tpope/vim-eunuch' },

    -- Surround.
    -- sa: add, sd: delete, sr: replace
    -- ib: inner select, ab: outer select (VISUAL mode)
    { 'machakann/vim-sandwich' },

    -- Better buffer deletion
    { 'famiu/bufdelete.nvim' },

    -- Syntax rules.
    { 'khaveesh/vim-fish-syntax' },
    { 'LnL7/vim-nix' },
    { 'ziglang/zig.vim' },
    { 'imsnif/kdl.vim' },

    -- Cursor FX
    { 'sphamba/smear-cursor.nvim', opts = {} },
}
