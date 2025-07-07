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

    -- Redirect command output to new buffer.
    { 'sbulav/nredir.nvim' },

    -- Syntax rules.
    { 'khaveesh/vim-fish-syntax' },
    { 'camnw/lf-vim' },
    { 'LnL7/vim-nix' },
    { 'ziglang/zig.vim' },
    { 'imsnif/kdl.vim' },

    -- Cursor FX
    { 'sphamba/smear-cursor.nvim', opts = {} },

    -- Rust
    { 'mrcjkb/rustaceanvim' },
}
