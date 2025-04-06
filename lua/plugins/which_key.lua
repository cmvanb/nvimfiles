--------------------------------------------------------------------------------
-- WhichKey keymap helper
--------------------------------------------------------------------------------

local function config()
    require('which-key').setup({
        icons = {
            mappings = false,
        },
    })
end


return {
    {
        'folke/which-key.nvim',
        config = config,
    },
}
