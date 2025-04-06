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
        'ggandor/leap.nvim',
        config = config,
    },
}
