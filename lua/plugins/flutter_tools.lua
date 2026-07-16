--------------------------------------------------------------------------------
-- Flutter-tools configuration
--------------------------------------------------------------------------------

local theme_config = require('theme.config')

-- flutter-tools' own `lsp.color` option is deprecated in favor of core LSP
-- document colors; enable those directly for the Dart client instead.
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.flutter_tools', {}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == 'dartls' then
            vim.lsp.document_color.enable(true, { bufnr = args.buf })
        end
    end,
})

local function config()
    require('flutter-tools').setup({
        ui = {
            border = theme_config.border,
        },
        decorations = {
            statusline = {
                app_version = false,
                device = false,
            },
        },
    })
end

return {
    {
        'nvim-flutter/flutter-tools.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-dap',
        },
        config = config,
    },
}
