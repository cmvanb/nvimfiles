--------------------------------------------------------------------------------
-- Indent blankline
--------------------------------------------------------------------------------

local function config()
    local ThemeSymbols = reload('theme.symbols')

    reload('ibl').setup({
        indent = {
            char = ThemeSymbols.indent_char,
        },
        scope = {
            enabled = true,
        }
    })
end

return {
    {
        'lukas-reineke/indent-blankline.nvim',
        config = config,
    },
}
