--------------------------------------------------------------------------------
-- Lualine configuration
--------------------------------------------------------------------------------

-- Highlights
local HighlightsUtils = require('utils.highlights')
local hi = HighlightsUtils.highlight

hi('LualineDiffAdd',     { fg = 'green_4', bg = 'primary_6', attrs = 'bold' },    { fg = 'ansi_green' })
hi('LualineDiffChange',  { fg = 'orange_6', bg = 'primary_6', attrs = 'bold' },   { fg = 'ansi_yellow' })
hi('LualineDiffDelete',  { fg = 'red_5', bg = 'primary_6', attrs = 'bold' },      { fg = 'ansi_red' })
hi('LualineDiagError',   { fg = 'red_5', bg = 'primary_6', attrs = 'bold' },      { fg = 'ansi_red' })
hi('LualineDiagWarn',    { fg = 'orange_6', bg = 'primary_6', attrs = 'bold' },   { fg = 'ansi_yellow' })
hi('LualineDiagInfo',    { fg = 'text_10', bg = 'primary_6', attrs = 'bold' },    { fg = 'ansi_white' })
hi('LualineDiagHint',    { fg = 'yellow_7', bg = 'primary_6', attrs = 'bold' },  { fg = 'ansi_brmagenta' })

-- Theme
local SystemTheme = require('theme.system')
local ThemeSymbols = require('theme.symbols')

local color
if is_linux_virtual_terminal() then
    color = function(_, ansi_name) return SystemTheme.color_name_to_ansi_index(ansi_name) end
else
    color = function(gui_name, _) return SystemTheme.color_hash(gui_name) end
end

local colors = {
    -- Bar colors
    outer = {
        bg = color('primary_8',  'ansi_blue'),
        fg = color('text_15',    'ansi_brwhite'),
    },
    middle = {
        bg = color('primary_6',  'ansi_blue'),
        fg = color('text_12',    'ansi_white'),
    },
    inner = {
        bg = color('primary_3',  'ansi_brblack'),
        fg = color('text_10',    'ansi_white'),
    },
    inactive = {
        bg = color('gray_2',     'ansi_black'),
        fg = color('text_8',     'ansi_brblack'),
    },

    -- Mode colors
    normal = {
        bg = color('primary_8',  'ansi_blue'),
        fg = color('text_15',    'ansi_brwhite'),
    },
    insert = {
        bg = color('green_3',    'ansi_green'),
        fg = color('green_8',    'ansi_brgreen'),
    },
    visual = {
        bg = color('magenta_4',  'ansi_magenta'),
        fg = color('magenta_9',  'ansi_brmagenta'),
    },
    command = {
        bg = color('orange_3',   'ansi_yellow'),
        fg = color('yellow_6',   'ansi_bryellow'),
    },
    replace = {
        bg = color('purple_4',   'ansi_magenta'),
        fg = color('purple_9',   'ansi_brmagenta'),
    },
}

return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'kyazdani42/nvim-web-devicons',
        },
        opts = {

            -- Theme
            --------------------------------------------------------------------
            options = {
                theme = {
                    normal = {
                        a = { bg = colors.normal.bg, fg = colors.normal.fg, gui = 'bold' },
                        b = { bg = colors.middle.bg, fg = colors.middle.fg },
                        c = { bg = colors.inner.bg, fg = colors.inner.fg },
                        x = { bg = colors.inner.bg, fg = colors.inner.fg },
                        y = { bg = colors.middle.bg, fg = colors.middle.fg },
                        z = { bg = colors.outer.bg, fg = colors.outer.fg },
                    },
                    insert = {
                        a = { bg = colors.insert.bg, fg = colors.insert.fg, gui = 'bold' },
                        b = { bg = colors.middle.bg, fg = colors.middle.fg },
                        c = { bg = colors.inner.bg, fg = colors.inner.fg },
                        x = { bg = colors.inner.bg, fg = colors.inner.fg },
                        y = { bg = colors.middle.bg, fg = colors.middle.fg },
                        z = { bg = colors.outer.bg, fg = colors.outer.fg },
                    },
                    visual = {
                        a = { bg = colors.visual.bg, fg = colors.visual.fg, gui = 'bold' },
                        b = { bg = colors.middle.bg, fg = colors.middle.fg },
                        c = { bg = colors.inner.bg, fg = colors.inner.fg },
                        x = { bg = colors.inner.bg, fg = colors.inner.fg },
                        y = { bg = colors.middle.bg, fg = colors.middle.fg },
                        z = { bg = colors.outer.bg, fg = colors.outer.fg },
                    },
                    replace = {
                        a = { bg = colors.replace.bg, fg = colors.replace.fg, gui = 'bold' },
                        b = { bg = colors.middle.bg, fg = colors.middle.fg },
                        c = { bg = colors.inner.bg, fg = colors.inner.fg },
                        x = { bg = colors.inner.bg, fg = colors.inner.fg },
                        y = { bg = colors.middle.bg, fg = colors.middle.fg },
                        z = { bg = colors.outer.bg, fg = colors.outer.fg },
                    },
                    command = {
                        a = { bg = colors.command.bg, fg = colors.command.fg, gui = 'bold' },
                        b = { bg = colors.middle.bg, fg = colors.middle.fg },
                        c = { bg = colors.inner.bg, fg = colors.inner.fg },
                        x = { bg = colors.inner.bg, fg = colors.inner.fg },
                        y = { bg = colors.middle.bg, fg = colors.middle.fg },
                        z = { bg = colors.outer.bg, fg = colors.outer.fg },
                    },
                    inactive = {
                        a = { bg = colors.inactive.bg, fg = colors.inactive.fg, gui = 'bold' },
                        b = { bg = colors.inactive.bg, fg = colors.inactive.fg },
                        c = { bg = colors.inactive.bg, fg = colors.inactive.fg },
                        x = { bg = colors.inactive.bg, fg = colors.inactive.fg },
                        y = { bg = colors.inactive.bg, fg = colors.inactive.fg },
                        z = { bg = colors.inactive.bg, fg = colors.inactive.fg },
                    }
                },
                component_separators = ' ',
                section_separators = {
                    left = ThemeSymbols.lualine.section_separator_left,
                    right = ThemeSymbols.lualine.section_separator_right,
                },
            },

            -- Buffer line
            --------------------------------------------------------------------
            tabline = {
                lualine_a = {
                    {
                        'buffers',
                        symbols = {
                            modified = ' ' .. ThemeSymbols.lualine.file_modified,
                            alternate_file = '',
                        },
                    },
                },
                lualine_b = {
                },
                lualine_c = {
                },
                lualine_x = {
                },
                lualine_y = {
                },
                lualine_z = {
                    {
                        'tabs',
                        mode = 1,
                        fmt = function(_, context)
                            return ThemeSymbols.lualine.tab_page .. context.tabnr
                        end,
                        show_modified_status = false,
                        separator = {
                            left = ThemeSymbols.lualine.section_separator_right,
                            right = ''
                        },
                        padding = { left = 1, right = 1 },
                        tabs_color = {
                            active = 'lualine_z_normal',
                            inactive = 'lualine_y_normal',
                        },
                    },
                }
            },

            -- Status line
            --------------------------------------------------------------------
            sections = {
                lualine_a = { 'mode' },
                lualine_b = {
                    {
                        'branch',
                        icon = ThemeSymbols.lualine.git_branch,
                    },
                    {
                        'diff',
                        colored = true,
                        diff_color = {
                            added    = 'LualineDiffAdd',
                            modified = 'LualineDiffChange',
                            removed  = 'LualineDiffDelete',
                        },
                        symbols = {
                            added = ThemeSymbols.diff_signs.added,
                            modified = ThemeSymbols.diff_signs.changed,
                            removed = ThemeSymbols.diff_signs.removed,
                        },
                    },
                },
                lualine_c = {
                    {
                        'filename',
                        path = 3,
                        separator = {
                            left = '',
                            right = ThemeSymbols.lualine.section_separator_left
                        },
                        padding = { left = 1, right = 1 },
                        symbols = {
                            modified = ThemeSymbols.lualine.file_modified,
                            readonly = ThemeSymbols.lualine.file_readonly,
                            unnamed = '[No Name]',
                            newfile = '',
                        }
                    },
                },
                lualine_x = {
                },
                lualine_y = {
                    {
                        'diagnostics',
                        colored = true,
                        diagnostics_color = {
                            error = 'LualineDiagError',
                            warn  = 'LualineDiagWarn',
                            info  = 'LualineDiagInfo',
                            hint  = 'LualineDiagHint',
                        },
                        symbols = {
                            error = ThemeSymbols.diagnostic_signs.error,
                            warn = ThemeSymbols.diagnostic_signs.warn,
                            hint = ThemeSymbols.diagnostic_signs.hint,
                            info = ThemeSymbols.diagnostic_signs.info,
                        },
                    },
                    {
                        'filetype',
                        icons_enabled = true,
                    },
                },
                lualine_z = {
                    {
                        'location',
                        padding = { left = 1, right = 1 },
                    },
                }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },

        },
    },
}
