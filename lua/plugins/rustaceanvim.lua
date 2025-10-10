--------------------------------------------------------------------------------
-- Rustaceanvim configuration
--------------------------------------------------------------------------------

local function config()
    vim.g.rustaceanvim = {
        server = {
            default_settings = {
                ['rust-analyzer'] = {
                    procMacro = {
                        enable = true,
                    },
                },
            },
        },
    }
end

return {
    {
        'mrcjkb/rustaceanvim',
        config = config,
    },
}
