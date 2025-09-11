--------------------------------------------------------------------------------
-- Matchup configuration
--------------------------------------------------------------------------------

local function config()
    reload('match-up').setup({
        treesitter = {
            stopline = 500
        }
    })
end

return {
    'andymass/vim-matchup',
    config = config,
}
