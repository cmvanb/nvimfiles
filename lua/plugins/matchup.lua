--------------------------------------------------------------------------------
-- Matchup configuration
--------------------------------------------------------------------------------

local function config()
    -- reload('match-up').setup({
    --     treesitter = {
    --         stopline = 500
    --     }
    -- })

    require('mathch-up').setup({})

    vim.g.matchup_matchparen_end_sign = '>'
end

return {
    'andymass/vim-matchup',
    config = config,
}
