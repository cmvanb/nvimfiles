--------------------------------------------------------------------------------
-- Neovim highlights
--------------------------------------------------------------------------------

-- Retrieve system colors
local theme = reload('system/theme')

-- Helpers
--------------------------------------------------------------------------------

local cmd = vim.cmd
local opt = vim.opt

-- TODO: Extract utility.
local function hi(group, guifg, guibg, guiprops, termfg, termbg, termprops)
    if guifg ~= 'NONE' then
        guifg = theme.color_hash(guifg)
    end
    if guibg ~= 'NONE' then
        guibg = theme.color_hash(guibg)
    end
    if termfg ~= 'NONE' then
        termfg = theme.color_name_to_ansi_index(termfg)
    end
    if termbg ~= 'NONE' then
        termbg = theme.color_name_to_ansi_index(termbg)
    end

    cmd('hi! ' .. group ..
        ' guifg=' .. guifg ..
        ' guibg=' .. guibg ..
        ' gui=' .. guiprops ..
        ' ctermfg=' .. termfg ..
        ' ctermbg=' .. termbg ..
        ' cterm=' .. termprops)
end

-- TODO: Extract utility.
local function ln(group, target)
    cmd('hi! link ' .. group .. ' ' .. target)
end

-- Settings
--------------------------------------------------------------------------------

-- Use 24bit colors
opt.termguicolors = true

-- Reset any pre-existing syntax highlighting
cmd('syntax reset')

-- NVIM UI highlights
--------------------------------------------------------------------------------

-- group                   | guifg              | guibg         | guiprops | termfg           | termbg           | termprops
hi('Normal',               'editor_text_normal', 'editor_bg',    'NONE',    'ansi_cyan',       'ansi_black',      'NONE')
hi('NonText',              'text_8',             'NONE',         'NONE',    'ansi_brwhite',    'NONE',            'NONE')
hi('EndOfBuffer',          'primary_4',          'NONE',         'NONE',    'NONE',            'NONE',            'NONE')
hi('Cursor',               'text_0',             'text_15',      'NONE',    'ansi_black',      'ansi_white',      'NONE')
hi('CursorLine',           'NONE',               'primary_1',    'NONE',    'NONE',            'ansi_brblack',    'bold')
hi('CursorLineNr',         'primary_10',         'primary_1',    'NONE',    'ansi_cyan',       'ansi_black',      'NONE')
hi('LineNr',               'primary_6',          'NONE',         'NONE',    'ansi_brblack',    'NONE',            'NONE')
hi('SignColumn',           'primary_15',         'primary_0',    'NONE',    'ansi_white',      'ansi_black',      'NONE')

hi('StatusLine',           'text_12',            'primary_6',    'bold',    'ansi_white',      'ansi_blue',       'bold')
hi('StatusLineNC',         'text_8',             'primary_1',    'NONE',    'ansi_brblack',    'ansi_black',      'NONE')
hi('TabLine',              'primary_5',          'primary_1',    'bold',    'ansi_white',      'ansi_blue',       'NONE')
hi('TabLineSel',           'primary_11',         'primary_3',    'bold',    'ansi_white',      'ansi_blue',       'bold')
hi('TabLineFill',          'NONE',               'primary_1',    'bold',    'ansi_white',      'ansi_blue',       'bold')

hi('MsgArea',              'text_12',            'primary_0',    'NONE',    'ansi_white',      'ansi_brblack',    'NONE')
hi('ErrorMsg',             'red_6',              'red_1',        'bold',    'ansi_brred',      'ansi_red',        'bold')
hi('WarningMsg',           'yellow_6',           'orange_3',     'bold',    'ansi_bryellow',   'ansi_yellow',     'bold')
hi('MoreMsg',              'gray_15',            'gray_5',       'bold',    'ansi_brgreen',    'ansi_green',      'bold')

hi('Visual',               'gray_0',             'primary_15',   'NONE',    'ansi_black',      'ansi_brcyan',     'NONE')
hi('IncSearch',            'gray_0',             'green_4',      'bold',    'ansi_black',      'ansi_brgreen',    'NONE')
hi('Search',               'gray_0',             'magenta_5',    'bold',    'ansi_black',      'ansi_brmagenta',  'NONE')

hi('Title',                'text_15',            'NONE',         'bold',    'ansi_brwhite',    'NONE',            'bold')
hi('PMenu',                'text_8',             'primary_0',    'NONE',    'ansi_white',      'ansi_black',      'NONE')
hi('PMenuSel',             'yellow_6',           'primary_5',    'bold',    'ansi_white',      'ansi_black',      'bold')
hi('WinSeparator',         'primary_2',          'NONE',         'NONE',    'ansi_brblack',    'NONE',            'NONE')
hi('MatchParen',           'text_8',             'NONE',         'bold',    'ansi_brwhite',    'NONE',            'bold,underline')
hi('DiffAdd',              'green_5',            'NONE',         'bold',    'ansi_green',      'NONE',            'NONE')
hi('DiffChange',           'yellow_5',           'NONE',         'bold',    'ansi_yellow',     'NONE',            'NONE')
hi('DiffDelete',           'red_5',              'NONE',         'bold',    'ansi_red',        'NONE',            'NONE')
hi('DiagnosticSignError',  'red_5',              'NONE',         'bold',    'ansi_red',        'NONE',            'NONE')
hi('DiagnosticSignWarn',   'yellow_5',           'NONE',         'bold',    'ansi_yellow',     'NONE',            'NONE')
hi('DiagnosticSignInfo',   'text_12',            'NONE',         'bold',    'ansi_white',      'NONE',            'NONE')
hi('DiagnosticSignHint',   'purple_7',           'NONE',         'bold',    'ansi_magenta',    'NONE',            'NONE')
hi('SpecialKey',           'debug',              'NONE',         'NONE',    'ansi_brmagenta',  'NONE',            'NONE')
hi('Directory',            'primary_8',          'NONE',         'NONE',    'ansi_cyan',       'ansi_black',      'NONE')
hi('Folded',               'purple_8',           'purple_5',     'NONE',    'ansi_cyan',       'ansi_black',      'bold')

hi('SpellBad',             'red_5',              'NONE',         'NONE',    'ansi_red',        'NONE',            'NONE')

-- group             | target
ln('CursorColumn',   'CursorLine')
ln('Question',       'MoreMsg')
ln('ModeMsg',        'MoreMsg')
ln('Error',          'ErrorMsg')
ln('healthSuccess',  'MoreMsg')
ln('VertSplit',      'WinSeparator')
ln('Whitespace',     'NonText')

-- Custom UI highlights
--------------------------------------------------------------------------------

-- group                  | guifg        | guibg       | guiprops | termfg          | termbg       | termprops
hi('CMenuNormal',         'debug',       'primary_1',  'NONE',    'ansi_cyan',      'ansi_blue',   'NONE')
hi('CMenuSelection',      'text_15',     'primary_8',  'bold',    'ansi_brwhite',   'ansi_black',  'bold')
hi('CMenuItem',           'text_12',     'NONE',       'NONE',    'ansi_brblue',    'NONE',        'NONE')

hi('CMenuItemMatch',      'yellow_6',    'NONE',       'bold',    'ansi_bryellow',  'NONE',        'NONE')
hi('FloatMenuNormal',     'text_12',     'primary_0',  'NONE',    'ansi_cyan',      'ansi_blue',   'NONE')
hi('FloatMenuSelection',  'text_15',     'primary_7',  'bold',    'ansi_brwhite',   'ansi_black',  'bold')
hi('FloatMenuItemMatch',  'yellow_6',    'NONE',       'bold',    'ansi_cyan',      'ansi_blue',   'NONE')

-- group            | target
ln('QuickFixLine',  'FloatMenuSelection')

-- Plugin highlights
--------------------------------------------------------------------------------
-- group                     | guifg         | guibg        | guiprops         | termfg           | termbg       | termprops
hi('LeapMatch',              'debug',        'NONE',        'bold',            'ansi_magenta',    'NONE',        'NONE')
hi('LeapLabelPrimary',       'gray_0',       'primary_15',  'bold',            'ansi_magenta',    'NONE',        'NONE')
hi('LeapLabelSecondary',     'primary_2',    'primary_11',  'bold',            'ansi_brmagenta',  'NONE',        'bold')
hi('LeapLabelSelected',      'debug',        'NONE',        'bold',            'ansi_brmagenta',  'NONE',        'bold')
hi('MiniCursorword',         'NONE',         'NONE',        'bold,underline',  'NONE',            'NONE',        'bold,underline')
hi('MiniIndentscopeSymbol',  'primary_3',    'NONE',        'NONE',            'ansi_brblack',    'NONE',        'NONE')
hi('LualineDiffAdd',         'green_4',      'primary_4',   'bold',            'ansi_green',      'NONE',        'NONE')
hi('LualineDiffChange',      'yellow_5',     'primary_4',   'bold',            'ansi_yellow',     'NONE',        'NONE')
hi('LualineDiffDelete',      'red_5',        'primary_4',   'bold',            'ansi_red',        'NONE',        'NONE')
hi('LualineDiagError',       'red_5',        'primary_4',   'bold',            'ansi_red',        'NONE',        'NONE')
hi('LualineDiagWarn',        'yellow_5',     'primary_4',   'bold',            'ansi_yellow',     'NONE',        'NONE')
hi('LualineDiagInfo',        'primary_15',   'primary_4',   'bold',            'ansi_white',      'NONE',        'NONE')
hi('LualineDiagHint',        'purple_7',     'primary_4',   'bold',            'ansi_magenta',    'NONE',        'NONE')

-- group                      | target
ln('CmpMenuBackground',       'CMenuNormal')
ln('CmpMenuSelect',           'CMenuSelection')
ln('CmpItemAbbr',             'CMenuItem')
ln('CmpItemAbbrMatch',        'CMenuItemMatch')
ln('CmpItemKind',             'Type')
ln('TelescopeNormal',         'FloatMenuNormal')
ln('TelescopeBorder',         'WinSeparator')
ln('TelescopeTitle',          'Title')
ln('TelescopePromptCounter',  'TelescopeTitle')
ln('TelescopePromptPrefix',   'TelescopeTitle')
ln('TelescopeMatching',       'FloatMenuItemMatch')
ln('TelescopeSelection',      'FloatMenuSelection')
ln('TelescopePreviewNormal',  'Normal')

-- Syntax highlights
--------------------------------------------------------------------------------

-- group          | guifg         | guibg        | guiprops         | termfg           | termbg | termprops
hi('Identifier',  'secondary_9',  'NONE',        'NONE',            'ansi_cyan',       'NONE',  'NONE')
hi('Statement',   'green_4',      'NONE',        'bold',            'ansi_brgreen',    'NONE',  'bold')
hi('Comment',     'text_8',       'NONE',        'italic',          'ansi_brblack',    'NONE',  'NONE')
hi('Type',        'secondary_12', 'NONE',        'NONE',            'ansi_magenta',    'NONE',  'NONE')
hi('PreProc',     'yellow_6',     'NONE',        'NONE',            'ansi_bryellow',   'NONE',  'NONE')
hi('Constant',    'magenta_6',    'NONE',        'NONE',            'ansi_brmagenta',  'NONE',  'NONE')
hi('Special',     'yellow_5',     'NONE',        'bold',            'ansi_yellow',     'NONE',  'NONE')
hi('Underlined',  'blue_5',       'NONE',        'underline',       'ansi_blue',       'NONE',  'underline')
hi('Delimiter',   'green_4',      'NONE',        'NONE',            'ansi_green',      'NONE',  'NONE')
hi('String',      'orange_6',     'NONE',        'NONE',            'ansi_yellow',     'NONE',  'NONE')
hi('Keyword',     'green_4',      'NONE',        'bold',            'ansi_brgreen',    'NONE',  'bold')
hi('Function',    'secondary_15', 'NONE',        'bold',            'ansi_brcyan',     'NONE',  'bold')
hi('Number',      'red_6',        'NONE',        'NONE',            'ansi_brred',      'NONE',  'NONE')
hi('Boolean',     'red_5',        'NONE',        'NONE',            'ansi_red',        'NONE',  'NONE')
hi('Ignore',      'text_4',       'NONE',        'bold',            'ansi_brblack',    'NONE',  'NONE')
hi('Todo',        'secondary_15', 'secondary_5', 'bold,nocombine',  'ansi_brwhite',    'NONE',  'bold')

-- group               | target
ln('vimCommentTitle',  'Comment')
ln('vimOption',        'Identifier')
ln('Operator',         'Keyword')
ln('@text.literal',    'String')

-- Special snowflakes
--------------------------------------------------------------------------------

-- Highlight notes everywhere, just like todos.
vim.api.nvim_create_augroup('HighlightNotes', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'FileType' }, {
    group = 'HighlightNotes',
    callback = function()
        vim.fn.matchadd('Todo', 'TODO:\\|NOTE:\\|see:')
    end,
})

