--------------------------------------------------------------------------------
-- Completion config
--------------------------------------------------------------------------------

local function luasnip_config()
    reload('luasnip').setup({
        history = true,
        update_events = 'TextChanged,TextChangedI',
    })
end

local function snippets_config()
    reload('luasnip.loaders.from_vscode').lazy_load()
end

local function blink_config(_, opts)
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

    -- TODO: fix
    -- add ai_accept to <Tab> key
    -- if not opts.keymap['<Tab>'] then
    --     if opts.keymap.preset == 'super-tab' then -- super-tab
    --         opts.keymap['<Tab>'] = {
    --             require('blink.cmp.keymap.presets')['super-tab']['<Tab>'][1],
    --             LazyVim.cmp.map({ 'snippet_forward', 'ai_accept' }),
    --             'fallback',
    --         }
    --     else -- other presets
    --         opts.keymap['<Tab>'] = {
    --             LazyVim.cmp.map({ 'snippet_forward', 'ai_accept' }),
    --             'fallback',
    --         }
    --     end
    -- end

    -- Unset custom prop to pass blink.cmp validation
    opts.sources.compat = nil

    -- TODO: fix
    -- check if we need to override symbol kinds
    -- for _, provider in pairs(opts.sources.providers or {}) do
    --     ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
    --     if provider.kind then
    --         local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
    --         local kind_idx = #CompletionItemKind + 1
    --
    --         CompletionItemKind[kind_idx] = provider.kind
    --         ---@diagnostic disable-next-line: no-unknown
    --         CompletionItemKind[provider.kind] = kind_idx
    --
    --         ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
    --         local transform_items = provider.transform_items
    --         ---@param ctx blink.cmp.Context
    --         ---@param items blink.cmp.CompletionItem[]
    --         provider.transform_items = function(ctx, items)
    --             items = transform_items and transform_items(ctx, items) or items
    --             for _, item in ipairs(items) do
    --                 item.kind = kind_idx or item.kind
    --                 item.kind_icon = LazyVim.config.icons.kinds[item.kind_name] or item.kind_icon or nil
    --             end
    --             return items
    --         end
    --
    --         -- Unset custom prop to pass blink.cmp validation
    --         provider.kind = nil
    --     end
    -- end

    require('blink.cmp').setup(opts)
end

return {
    -- Snippet engine.
    {
        'L3MON4D3/LuaSnip',
        config = luasnip_config,
    },

    -- Various snippets.
    {
        'rafamadriz/friendly-snippets',
        dependencies = { 'L3MON4D3/LuaSnip' },
        config = snippets_config,
    },

    -- Blink
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

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- TODO: fix
            -- snippets = {
            --     expand = function(snippet, _)
            --         return LazyVim.cmp.expand(snippet)
            --     end,
            -- },
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
                    enabled = vim.g.ai_cmp,
                },
            },

            -- experimental signature help support
            -- signature = { enabled = true },

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
            },
        },
        ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
        config = blink_config,
    },
}

-- local cmp = reload('cmp')
-- local luasnip = reload('luasnip')
--
-- vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
--
-- cmp.setup({
--     mapping = cmp.mapping.preset.insert({
--         ['<C-j>'] = cmp.mapping.select_next_item(),
--         ['<C-k>'] = cmp.mapping.select_prev_item(),
--
--         ['<Right>'] = cmp.mapping(function(fallback)
--             -- NOTE: Try this for copilot:
--             -- vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](vim.api.nvim_replace_termcodes('<Tab>', true, true, true)), 'n', true)
--
--             if cmp.visible() then
--                 -- NOTE: `select = false` prevents inferring a selection when
--                 -- no item is highlighted.
--                 cmp.confirm({ select = false })
--             elseif luasnip.expand_or_jumpable() then
--                 luasnip.expand_or_jump()
--             else
--                 fallback()
--             end
--         end, { 'i', 's' }),
--
--         ['<CR>'] = cmp.mapping(function(fallback)
--             if cmp.visible() then
--                 cmp.confirm({ select = true })
--             else
--                 fallback()
--             end
--         end, { 'i', 's' }),
--
--         ['<Esc>'] = cmp.mapping(function(fallback)
--             vim.cmd.stopinsert()
--
--             if cmp.visible() then
--                 cmp.abort()
--             else
--                 fallback()
--             end
--         end, { 'i', 's' }),
--     }),
--
--     completion = {
--         completeopt = 'menu,menuone,noinsert'
--     },
--
--     formatting = {
--         fields = { 'abbr', 'menu', 'kind' },
--         format = function(entry, item)
--             local short_name = {
--                 nvim_lsp = 'LSP',
--                 nvim_lua = 'nvim'
--             }
--
--             local menu_name = short_name[entry.source.name] or entry.source.name
--
--             item.menu = string.format('[%s]', menu_name)
--             return item
--         end,
--     },
--     matching = {
--         disallow_fuzzy_matching = true,
--     },
--     snippet = {
--         expand = function(args)
--             reload('luasnip').lsp_expand(args.body)
--         end,
--     },
--
--     sources = {
--         { name = 'buffer', keyword_length = 2 },
--         { name = 'nvim_lua', keyword_length = 2 },
--         { name = 'nvim_lsp', keyword_length = 2 },
--         { name = 'nvim_lsp_signature_help', keyword_length = 2 },
--         { name = 'luasnip', keyword_length = 2 },
--         {
--             name = 'spell',
--             option = {
--                 keep_all_entries = false,
--                 enable_in_context = function()
--                     return true
--                 end,
--             },
--         },
--     },
--
--     window = {
--         completion = cmp.config.window.bordered(),
--         documentation = vim.tbl_deep_extend(
--             'force',
--             cmp.config.window.bordered(),
--             {
--                 max_height = 15,
--                 max_width = 60,
--             }
--         ),
--     },
-- })
