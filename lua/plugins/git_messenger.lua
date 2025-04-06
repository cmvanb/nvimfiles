--------------------------------------------------------------------------------
-- Git messenger
--------------------------------------------------------------------------------

local function config()
    vim.g.git_messenger_no_default_mappings = true
end

return {
    {
        'rhysd/git-messenger.vim',
        config = config,
    },
}
