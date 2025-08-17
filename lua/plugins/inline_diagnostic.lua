--------------------------------------------------------------------------------
-- Inline diagnostic configuration
--------------------------------------------------------------------------------

local function config()
    reload('tiny-inline-diagnostic').setup({
        preset = 'powerline',
        hi = {
            mixing_color = 'None',
        },
        options = {
            use_icons_from_diagnostic = true,
            show_all_diags_on_cursorline = false,
            multilines = {
                enabled = false,
                tabstop = 2,
            },
            overflow = {
                mode = 'oneline',
                padding = 0,
            },
        },
    })
end

return {
    {
        'rachartier/tiny-inline-diagnostic.nvim',
        event = 'LspAttach',
        priority = 1000,
        config = config,
    },
}
