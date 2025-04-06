--------------------------------------------------------------------------------
-- Unicode.vim configuration
--
--  :UnicodeName
--  :UnicodeSearch
--  :UnicodeTable
--  :Digraphs
--------------------------------------------------------------------------------

local function config()
    vim.g.Unicode_no_default_mappings = true
end

return {
    {
        'chrisbra/unicode.vim',
        config = config,
    },
}
