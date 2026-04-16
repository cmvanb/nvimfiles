--------------------------------------------------------------------------------
-- Smooth scrolling
-- https://github.com/karb94/neoscroll.nvim
--------------------------------------------------------------------------------

local function config()
    reload('neoscroll').setup({
        mappings             = {},
        hide_cursor          = true,
        stop_eof             = true,
        respect_scrolloff    = true,
        cursor_scrolls_alone = true,
        duration_multiplier  = 1.0,
        easing               = 'cubic',
        pre_hook             = nil,
        post_hook            = nil,
        performance_mode     = false,
    })
end

return {
    {
        'karb94/neoscroll.nvim',
        config = config,
    },
}
