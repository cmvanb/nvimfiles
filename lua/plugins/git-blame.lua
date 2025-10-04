--------------------------------------------------------------------------------
-- blame.nvim configuration
--------------------------------------------------------------------------------

local function config()
    reload('blame').setup()
end

return {
    'FabijanZulj/blame.nvim',
    opts = {},
    config = config,
}
