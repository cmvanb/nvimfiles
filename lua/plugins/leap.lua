--------------------------------------------------------------------------------
-- Leap configuration
--------------------------------------------------------------------------------

local function config()
    reload('leap').setup({
        case_sensitive = true,
    })
end

return {
    {
        url = 'https://codeberg.org/andyg/leap.nvim',
        config = config,
    },
}
