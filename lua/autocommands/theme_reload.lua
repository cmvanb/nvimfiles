--------------------------------------------------------------------------------
-- Reload the system theme when `theme switch` signals SIGUSR1.
--------------------------------------------------------------------------------

local augroup = vim.api.nvim_create_augroup('ThemeReload', { clear = true })

vim.api.nvim_create_autocmd('Signal', {
    group = augroup,
    pattern = 'SIGUSR1',
    callback = function()
        local HighlightsUtils = require('utils.highlights')
        HighlightsUtils.reload_theme()

        vim.o.background = require('theme.system').scheme('variant')

        -- Lualine bakes colors into its theme table, so rebuild it from the spec.
        if package.loaded['lualine'] then
            local spec = reload('plugins.lualine')
            require('lualine').setup(spec[1].opts)
        end
    end,
})
