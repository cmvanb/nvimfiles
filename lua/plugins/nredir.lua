--------------------------------------------------------------------------------
-- Nredir configuration
--------------------------------------------------------------------------------

local function config()
    reload('nredir').setup()
end

return {
    {
        'sbulav/nredir.nvim',
        cmd = 'Nredir',
        config = config,
    },
}
