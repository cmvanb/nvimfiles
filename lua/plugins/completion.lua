--------------------------------------------------------------------------------
-- Completion config
--------------------------------------------------------------------------------

local CmpUtils = require('utils.completion')
local ThemeSymbols = require('theme.symbols')

local function config(_, opts)
    -- setup compat sources
    local enabled = opts.sources.default
    for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend(
            'force',
            { name = source, module = 'blink.compat.source' },
            opts.sources.providers[source] or {}
        )
        if type(enabled) == 'table' and not vim.tbl_contains(enabled, source) then
            table.insert(enabled, source)
        end
    end

    -- Unset custom prop to pass blink.cmp validation
    opts.sources.compat = nil

    -- check if we need to override symbol kinds
    for _, provider in pairs(opts.sources.providers or {}) do
        if provider.kind then
            local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
            local kind_idx = #CompletionItemKind + 1

            CompletionItemKind[kind_idx] = provider.kind
            ---@diagnostic disable-next-line: no-unknown
            CompletionItemKind[provider.kind] = kind_idx

            local transform_items = provider.transform_items
            provider.transform_items = function(ctx, items)
                items = transform_items and transform_items(ctx, items) or items
                for _, item in ipairs(items) do
                    item.kind = kind_idx or item.kind
                    item.kind_icon = ThemeSymbols.kinds[item.kind_name] or item.kind_icon or nil
                end
                return items
            end

            -- Unset custom prop to pass blink.cmp validation
            provider.kind = nil
        end
    end

    reload('blink.cmp').setup(opts)
end

return {
    {
        'saghen/blink.cmp',
        version = not vim.g.lazyvim_blink_main and '*',
        build = vim.g.lazyvim_blink_main and 'cargo build --release',
        opts_extend = {
            'sources.completion.enabled_providers',
            'sources.compat',
            'sources.default',
        },
        dependencies = {
            'rafamadriz/friendly-snippets',
            -- add blink.compat to dependencies
            {
                'saghen/blink.compat',
                optional = true, -- make optional so it's only enabled if any extras need it
                opts = {},
                version = not vim.g.lazyvim_blink_main and '*',
            },
        },
        event = 'InsertEnter',

        opts = {
            snippets = {
                expand = function(snippet, _)
                    return CmpUtils.expand(snippet)
                end,
            },
            appearance = {
                -- sets the fallback highlight groups to nvim-cmp's highlight groups
                -- useful for when your theme doesn't support blink.cmp
                -- will be removed in a future release, assuming themes add support
                use_nvim_cmp_as_default = false,
                -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono',
            },
            completion = {
                accept = {
                    -- experimental auto-brackets support
                    auto_brackets = {
                        enabled = true,
                    },
                },
                menu = {
                    draw = {
                        treesitter = { 'lsp' },
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                },
                ghost_text = {
                    enabled = true,
                },
            },

            -- experimental signature help support
            signature = {
                enabled = true,
            },

            sources = {
                -- adding any nvim-cmp sources here will enable them
                -- with blink.compat
                compat = {},
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },

            cmdline = {
                enabled = false,
            },

            keymap = {
                preset = 'enter',
                ['<Right>'] = { 'select_and_accept' },
                ['<C-j>'] = { 'select_and_accept' },
            },
        },
        config = config,
    },
}
