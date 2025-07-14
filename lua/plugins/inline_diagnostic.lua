--------------------------------------------------------------------------------
-- Inline diagnostic configuration
--------------------------------------------------------------------------------

local function config()
    reload('tiny-inline-diagnostic').setup()
end

return {
    {
        'rachartier/tiny-inline-diagnostic.nvim',
        event = 'VeryLazy',
        priority = 1000,
        config = config,
    },
}
