--------------------------------------------------------------------------------
-- Snacks.nvim plugins
--------------------------------------------------------------------------------

local ThemeSymbols = require('theme.symbols')
local HighlightsUtils = reload('utils.highlights')
local ln = HighlightsUtils.link
local hi = HighlightsUtils.highlight

-- Highlights
hi('SnacksPicker',        { bg = 'editor_bg' },  { bg = 'ansi_black' })

ln('SnacksPickerFile',    'File')
ln('SnacksPickerDir',     'Directory')
ln('SnacksPickerTotals',  'Comment')
ln('SnacksPickerPrompt',  'Title')
ln('SnacksPickerBorder',  'WinSeparator')

-- Config
local function show_full_path_preview_title(picker, item)
    vim.schedule(function()
        if not item or not item.file then
            return
        end
        picker.preview.win:set_title(item.file)
    end)
end

return {
    {
        'folke/snacks.nvim',
        priority = 1000,
        lazy = false,
        opts = {
            picker = {
                prompt = ' ' .. ThemeSymbols.picker.prompt .. ' ',

                -- Picker-specific configuration
                ----------------------------------------------------------------
                sources = {
                    buffers = {
                        on_change = show_full_path_preview_title
                    },
                    explorer = {
                        layout = { preset = 'explorer' },
                    },
                    files = {
                        on_change = show_full_path_preview_title,
                        win = {
                            input = {
                                keys = {
                                    ['<c-n>'] = { 'edit_vsplit', mode = { 'n', 'i' } },
                                    ['<c-p>'] = { 'edit_split', mode = { 'n', 'i' } },
                                },
                            },
                        },
                    },
                    grep = {
                        on_change = show_full_path_preview_title
                    },
                    icons = {
                        icon_sources = { 'nerd_fonts', 'emoji', 'unicode' },
                        layout = { preset = 'smallmenu' },
                    },
                },

                -- don't truncate long file paths
                formatters = {
                    file = {
                        truncate = 10000,
                    },
                },

                -- Picker layouts
                ----------------------------------------------------------------
                ---@class snacks.picker.layout.Config
                layout = {
                    cycle = true,
                    preset = function()
                        return vim.o.columns > 128 and 'wide' or 'tall'
                    end,
                },
                ---@table<string, snacks.picker.layout.Config>
                layouts = {
                    ---@class snacks.picker.layout.Config
                    wide = {
                        layout = {
                            backdrop = false,
                            box = 'horizontal',
                            width = 0.8,
                            height = 0.8,
                            max_width = 160,
                            -- input, list
                            {
                                box = 'vertical',
                                border = 'rounded',
                                title = '{title}',
                                {
                                    win = 'input',
                                    height = 1,
                                    border = 'bottom',
                                },
                                {
                                    win = 'list',
                                    border = 'none',
                                },
                            },
                            -- preview
                            {
                                win = 'preview',
                                title = '{preview}',
                                border = 'rounded',
                                width = 0.65,
                            },
                        },
                    },
                    ---@class snacks.picker.layout.Config
                    tall = {
                        layout = {
                            backdrop = false,
                            box = 'vertical',
                            border = 'rounded',
                            title = '{title}',
                            width = 0.9,
                            height = 0.8,
                            {
                                box = 'vertical',
                                border = 'none',
                                -- input
                                {
                                    win = 'input',
                                    height = 1,
                                    border = 'bottom',
                                },
                                -- list
                                {
                                    win = 'list',
                                    border = 'none',
                                },
                            },
                            -- preview
                            {
                                win = 'preview',
                                title = '{preview}',
                                border = 'top',
                                height = 0.65,
                            },
                        },
                    },
                    ---@class snacks.picker.layout.Config
                    smallmenu = {
                        preview = false,
                        layout = {
                            backdrop = false,
                            width = 0.4,
                            height = 0.4,
                            min_width = 72,
                            border = 'rounded',
                            box = 'vertical',
                            title = '{title}',
                            {
                                win = 'input',
                                height = 1,
                                border = 'bottom',
                                title_pos = 'center',
                            },
                            {
                                win = 'list',
                                border = 'none',
                            },
                            {
                                win = 'preview',
                                title = '{preview}',
                                border = 'none',
                            },
                        },
                    },
                    ---@class snacks.picker.layout.Config
                    explorer = {
                        preview = 'main',
                        layout = {
                            backdrop = false,
                            width = 40,
                            min_width = 40,
                            height = 0,
                            position = 'left',
                            border = 'none',
                            box = 'vertical',
                            {
                                win = 'input',
                                height = 1,
                                border = 'rounded',
                            },
                            {
                                win = 'list',
                                border = 'none',
                            },
                        },
                    },
                },

                -- Window-specific options
                ----------------------------------------------------------------
                win = {
                    input = {
                        keys = {
                            ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
                            ['<c-k>'] = { 'preview_scroll_up', mode = { 'n', 'i' } },
                            ['<c-j>'] = { 'preview_scroll_down', mode = { 'n', 'i' } },
                        },
                    },

                    preview = {
                        -- don't render fold/sign/statuscolumn
                        wo = {
                            foldcolumn = '0',
                            signcolumn = 'no',
                            statuscolumn = '',
                        },
                    }
                },
            },
        },

        -- Editor keymaps
        ------------------------------------------------------------------------
        keys = {
            -- Search functions
            {
                '<leader>a',
                function() Snacks.picker.files({
                    title = 'All Files',
                    hidden = true,
                    ignored = true,
                }) end,
                desc = 'Search files',
            },
            {
                '<leader>f',
                function() Snacks.picker.files() end,
                desc = 'Search files',
            },
            {
                '<leader>b',
                function() Snacks.picker.buffers({
                    win = {
                        input = {
                            keys = {
                                ['<c-w>'] = { 'bufdelete', mode = { 'n', 'i' } },
                            },
                        },
                        list = { keys = { ['dd'] = 'bufdelete' } },
                    },
                }) end,
                desc = 'Search buffers',
            },
            {
                '<leader>g',
                function() Snacks.picker.grep({
                    title = 'Grep Files',
                }) end,
                desc = 'Grep files',
            },
            {
                '<leader>h',
                function() Snacks.picker.help() end,
                desc = 'Search help',
            },

            -- File explorer
            {
                '<leader>e',
                function() Snacks.explorer({
                    -- NOTE: Doesn't seem to work.
                    replace_netrw = true,
                }) end,
                desc = 'File explorer',
            },

            -- Insertion
            {
                '<leader>i',
                function() Snacks.picker.icons({
                    title = 'Icons & Emojis',
                }) end,
                desc = 'Insert icons and emojis',
            },
            {
                '<leader>u',
                function() Snacks.picker.icons({
                    title = 'Unicode Symbols',
                    sources = {
                        icons = {
                            icon_sources = { 'unicode' },
                        },
                    },
                }) end,
                desc = 'Insert unicode symbols',
            },

            -- NOTE: LSP functions are bound by lsp.lua
        },

        -- Custom icon source injection
        ------------------------------------------------------------------------
        config = function(_, opts)
            require('snacks').setup(opts)

            require('snacks.picker.source.icons').sources['unicode'] = {
                url = 'https://gist.githubusercontent.com/cmvanb/09184db6be4837c6efc365415148af6e/raw/d695721b1179fd9936dd3cefdd4ec5acbaf14581/unicode-table.json',
                v = 1,
                build = function(data)
                    local ret = {}
                    for _, item in pairs(data) do
                        table.insert(ret, {
                            name = item.name,
                            icon = item.icon,
                            source = 'unicode',
                            category = item.category,
                        })
                    end
                    return ret
                end,
            }
        end,
    },
}
