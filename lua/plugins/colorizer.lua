--------------------------------------------------------------------------------
-- Colorizer configuration
--------------------------------------------------------------------------------

local function config()
    local colorizer = reload('colorizer')

    colorizer.setup({
        filetypes = {
            '*',
        },
        options = {
            parsers = {
                -- Don't highlight CSS names.
                names = { enable = false },
            },
            display = {
                mode = 'background',
            },
            always_update = true,
        },
    })

    vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
            -- NOTE: Ugly timer hack because Colorizer is buggy.
            vim.fn.timer_start(300, function()
                colorizer.attach_to_buffer(0)
            end)
        end,
    })
end

return {
    {
        'NvChad/nvim-colorizer.lua',
        config = config,
    },
}
