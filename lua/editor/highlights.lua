--------------------------------------------------------------------------------
-- Neovim highlights
--------------------------------------------------------------------------------

-- Imports
--------------------------------------------------------------------------------

local HighlightsUtils = reload('utils.highlights')

-- Shortcuts
--------------------------------------------------------------------------------

local hi = HighlightsUtils.highlight
local ln = HighlightsUtils.link

-- Basic configuration
--------------------------------------------------------------------------------

-- Use 24bit color if we are not in the linux terminal.
vim.opt.termguicolors = not is_linux_virtual_terminal()

-- Reset any pre-existing syntax highlighting
vim.cmd('syntax reset')

-- NVIM UI highlights
--------------------------------------------------------------------------------

-- Highlights
hi('Normal',                    { fg = 'editor_text_normal', bg = 'NONE' },                            { fg = 'ansi_cyan', bg = 'ansi_black' })
hi('NormalFloat',               { fg = 'editor_text_normal', bg = 'NONE' },                            { fg = 'ansi_cyan', bg = 'ansi_black' })
hi('NonText',                   { fg = 'ansi_red' },                                                   { fg = 'ansi_brwhite' })
hi('EndOfBuffer',               { fg = 'primary_4' },                                                  { })
hi('LineNr',                    { fg = 'primary_12' },                                                 { fg = 'ansi_blue' })
hi('Cursor',                    { fg = 'black', bg = 'text_15' },                                      { fg = 'ansi_black', bg = 'ansi_brwhite' })
hi('CursorLine',                { bg = 'primary_8' },                                                  { bg = 'ansi_blue' })
hi('CursorLineNr',              { fg = 'primary_12', bg = 'primary_8' },                               { fg = 'ansi_brblue', bg = 'ansi_blue' })
hi('CursorLineFold',            { fg = 'primary_8', bg = 'primary_8' },                                { fg = 'ansi_brblue', bg = 'ansi_blue' })
hi('CursorLineSign',            { fg = 'ansi_brwhite', bg = 'primary_8' },                             { bg = 'ansi_blue' })

hi('StatusLine',                { fg = 'text_10', bg = 'primary_1', attrs = 'bold' },                  { fg = 'ansi_white', bg = 'ansi_blue', attrs = 'none' })
hi('StatusLineNC',              { fg = 'text_6', bg = 'primary_1' },                                   { fg = 'ansi_brblack', bg = 'ansi_black' })
hi('TabLine',                   { fg = 'primary_5', bg = 'primary_1', attrs = 'bold' },                { fg = 'ansi_white', bg = 'ansi_blue' })
hi('TabLineSel',                { fg = 'primary_11', bg = 'primary_3', attrs = 'bold' },               { fg = 'ansi_white', bg = 'ansi_blue', attrs = 'none' })
hi('TabLineFill',               { bg = 'primary_1', attrs = 'bold' },                                  { fg = 'ansi_white', bg = 'ansi_blue', attrs = 'none' })

hi('MsgArea',                   { fg = 'text_10', bg = 'NONE' },                                       { fg = 'ansi_white', bg = 'ansi_black' })
hi('ErrorMsg',                  { fg = 'red_6', bg = 'red_1', attrs = 'bold' },                        { fg = 'ansi_brred', bg = 'ansi_red' })
hi('WarningMsg',                { fg = 'yellow_6', bg = 'orange_3', attrs = 'bold' },                  { fg = 'ansi_bryellow', bg = 'ansi_yellow' })
hi('MoreMsg',                   { fg = 'gray_15', bg = 'gray_5', attrs = 'bold' },                     { fg = 'ansi_white', bg = 'ansi_brblack' })

hi('Visual',                    { fg = 'selection_fg', bg = 'selection_bg' },                          { fg = 'ansi_white', bg = 'ansi_blue' })
hi('IncSearch',                 { fg = 'search_active_fg', bg = 'search_active_bg', attrs = 'bold' },  { fg = 'ansi_black', bg = 'ansi_green' })
hi('Search',                    { fg = 'search_fg', bg = 'search_bg', attrs = 'bold' },                { fg = 'ansi_black', bg = 'ansi_blue', attrs = 'none' })
hi('CurSearch',                 { fg = 'search_active_fg', bg = 'search_active_bg', attrs = 'bold' },  { fg = 'ansi_black', bg = 'ansi_green', attrs = 'none' })

hi('Folded',                    { bg = 'primary_1' },                                                  { bg = 'ansi_blue' })
hi('FoldColumn',                { fg = 'gray_4', attrs = 'bold' },                                     { fg = 'ansi_blue' })

hi('Title',                     { fg = 'text_15', attrs = 'bold' },                                    { fg = 'ansi_brwhite' })
hi('PMenu',                     { fg = 'text_8', bg = 'editor_bg' },                                   { fg = 'ansi_white', bg = 'ansi_black' })
hi('PMenuSel',                  { fg = 'yellow_6', bg = 'primary_5', attrs = 'bold' },                 { fg = 'ansi_white', bg = 'ansi_black', attrs = 'bold' })
hi('WinSeparator',              { fg = 'primary_6' },                                                  { fg = 'ansi_blue' })
hi('MatchParen',                { fg = 'text_15', attrs = 'bold' },                                    { fg = 'ansi_brwhite' })

hi('DiffAdd',                   { fg = 'green_6', attrs = 'bold' },                                    { fg = 'ansi_green' })
hi('DiffChange',                { fg = 'orange_5', attrs = 'bold' },                                   { fg = 'ansi_yellow' })
hi('DiffDelete',                { fg = 'red_5', attrs = 'bold' },                                      { fg = 'ansi_red' })
hi('Added',                     { fg = 'green_4', attrs = 'bold' },                                    { fg = 'ansi_green' })
hi('Changed',                   { fg = 'orange_3', attrs = 'bold' },                                   { fg = 'ansi_yellow' })
hi('Removed',                   { fg = 'red_3', attrs = 'bold' },                                      { fg = 'ansi_red' })

hi('File',                      { fg = 'primary_15' },                                                 { fg = 'ansi_brcyan', bg = 'ansi_black' })
hi('Directory',                 { fg = 'primary_10' },                                                 { fg = 'ansi_cyan', bg = 'ansi_black' })
hi('SpecialKey',                { fg = 'debug' },                                                      { fg = 'ansi_brmagenta' })

hi('DiagnosticError',           { fg = 'red_5', attrs = 'bold' },                                      { fg = 'ansi_red' })
hi('DiagnosticWarn',            { fg = 'orange_6', attrs = 'bold' },                                   { fg = 'ansi_yellow' })
hi('DiagnosticInfo',            { fg = 'text_12', attrs = 'bold' },                                    { fg = 'ansi_white' })
hi('DiagnosticHint',            { fg = 'yellow_7', attrs = 'bold' },                                   { fg = 'ansi_brmagenta' })
hi('DiagnosticUnderlineError',  { sp = 'red_5', attrs = 'undercurl' },                                 { fg = 'ansi_red' })
hi('DiagnosticUnderlineWarn',   { sp = 'orange_6', attrs = 'undercurl' },                              { fg = 'ansi_yellow' })
hi('DiagnosticUnderlineInfo',   { sp = 'text_8', attrs = 'undercurl' },                                { fg = 'ansi_white' })
hi('DiagnosticUnderlineHint',   { sp = 'yellow_7', attrs = 'undercurl' },                              { fg = 'ansi_brmagenta' })
hi('SpellBad',                  { sp = 'red_5', attrs = 'undercurl' },                                 { fg = 'ansi_red' })

-- Links
ln('CursorColumn',         'CursorLine')
ln('FloatBorder',          'WinSeparator')
ln('Question',             'MoreMsg')
ln('ModeMsg',              'MoreMsg')
ln('Error',                'ErrorMsg')
ln('healthSuccess',        'MoreMsg')
ln('VertSplit',            'WinSeparator')
ln('Whitespace',           'NonText')
ln('DiagnosticSignError',  'DiagnosticError')
ln('DiagnosticSignWarn',   'DiagnosticWarn')
ln('DiagnosticSignInfo',   'DiagnosticInfo')
ln('DiagnosticSignHint',   'DiagnosticHint')

-- Custom UI highlights
--------------------------------------------------------------------------------

-- Highlights
hi('CMenuNormal',           { fg = 'debug', bg = 'primary_2' },                                      { fg = 'ansi_cyan', bg = 'ansi_black' })
hi('CMenuSelection',        { fg = 'menu_selection_fg', bg = 'menu_selection_bg', attrs = 'bold' },  { fg = 'ansi_brwhite', bg = 'ansi_black', attrs = 'bold' })
hi('CMenuItem',             { fg = 'text_10' },                                                      { fg = 'ansi_brblue' })
hi('CMenuItemMatch',        { fg = 'yellow_6', attrs = 'bold' },                                     { fg = 'ansi_bryellow' })

hi('FloatMenuNormal',       { fg = 'text_10', bg = 'NONE' },                                         { fg = 'ansi_cyan', bg = 'ansi_black' })
hi('FloatMenuSelection',    { fg = 'menu_selection_fg', bg = 'menu_selection_bg', attrs = 'bold' },  { fg = 'ansi_brwhite', bg = 'ansi_black', attrs = 'bold' })
hi('FloatMenuItemMatch',    { fg = 'magenta_5', attrs = 'bold' },                                    { fg = 'ansi_cyan', bg = 'ansi_blue' })

-- see: `active_window_highlights.lua`
hi('SignColumnActive',      { fg = 'primary_12', bg = 'NONE' },                                      { fg = 'ansi_brblue', bg = 'NONE' })
hi('SignColumnInactive',    { fg = 'gray_6', bg = 'NONE' },                                          { fg = 'ansi_brblack', bg = 'NONE' })
hi('CursorLineActive',      { bg = 'primary_8' },                                                    { fg = 'ansi_brcyan', bg = 'ansi_blue' })
hi('CursorLineInactive',    { bg = 'gray_2' },                                                       { fg = 'ansi_brblack', bg = 'ansi_black' })
hi('CursorLineSCActive',    { fg = 'primary_12', bg = 'primary_8' },                                 { fg = 'ansi_brcyan', bg = 'ansi_blue' })
hi('CursorLineSCInactive',  { fg = 'gray_10', bg = 'gray_2' },                                       { fg = 'ansi_brblack', bg = 'ansi_black' })

-- Links
ln('QuickFixLine',  'FloatMenuSelection')

-- Syntax highlights
--------------------------------------------------------------------------------

-- Highlights
hi('Identifier',     { fg = 'syn_identifier' },                                       { fg = 'ansi_cyan' })
hi('Statement',      { fg = 'green_6', attrs = 'bold' },                              { fg = 'ansi_brgreen', attrs = 'bold' })
hi('Comment',        { fg = 'syn_comment', attrs = 'italic' },                        { fg = 'ansi_brblack' })
hi('Type',           { fg = 'syn_type' },                                             { fg = 'ansi_brcyan', attrs = 'bold' })
hi('Constant',       { fg = 'syn_constant' },                                         { fg = 'ansi_brmagenta' })
hi('Special',        { fg = 'yellow_5', attrs = 'bold' },                             { fg = 'ansi_yellow' })
hi('SpecialText',    { fg = 'yellow_7', attrs = 'bold' },                             { fg = 'ansi_brblack' })
hi('Underlined',     { fg = 'web_link', attrs = 'underline' },                        { fg = 'ansi_blue' })
hi('Delimiter',      { fg = 'green_4' },                                              { fg = 'ansi_green' })
hi('String',         { fg = 'syn_string' },                                           { fg = 'ansi_yellow' })
hi('Keyword',        { fg = 'green_6', attrs = 'bold' },                              { fg = 'ansi_brgreen', attrs = 'bold' })
hi('Function',       { fg = 'syn_function', attrs = 'bold' },                         { fg = 'ansi_brcyan', attrs = 'bold' })
hi('Number',         { fg = 'red_6' },                                                { fg = 'ansi_brred' })
hi('Boolean',        { fg = 'red_5' },                                                { fg = 'ansi_red' })
hi('Ignore',         { fg = 'text_3', attrs = 'bold' },                               { fg = 'ansi_brblack' })
hi('Todo',           { fg = 'text_10', bg = 'text_3', attrs = 'bold,nocombine' },  { fg = 'ansi_brcyan', bg = 'ansi_blue', attrs = 'bold' })
hi('@markup.quote',  { fg = 'text_10', attrs = 'italic' },                            { fg = 'ansi_brblack' })

-- Links
ln('vimCommentTitle',                   'Comment')
ln('vimOption',                         'Identifier')
ln('Operator',                          'Keyword')
ln('PreProc',                           'Special')
ln('@attribute',                        'Special')
ln('@constant.builtin',                 'Constant')
ln('@constant.builtin.python',          'Constant')
ln('@constructor',                      'Function')
ln('@function.builtin',                 'Special')
ln('@function.call',                    'Function')
ln('@function.macro',                   'Special')
ln('@punctuation.delimiter',            'Delimiter')
ln('@markup.list',                      'Delimiter')
ln('@markup.heading.1',                 'Title')
ln('@markup.heading.2',                 'Title')
ln('@markup.heading.3',                 'Title')
ln('@markup.heading.4',                 'Title')
ln('@markup.heading.5',                 'Title')
ln('@markup.heading.6',                 'Title')
ln('@markup.raw.block',                 'Identifier')
ln('@markup.raw.markdown_inline',       'Identifier')
ln('@string.documentation',             'Comment')
ln('@string.special',                   'Special')
ln('@string.regex',                     'Special')
ln('@tag.attribute',                    'Type')
ln('@tag.delimiter',                    'Delimiter')
ln('@text.literal',                     'String')
ln('@type.builtin',                     'Special')
ln('@type.qualifier',                   'Keyword')
ln('@variable',                         'Identifier')
ln('@variable.builtin',                 'Identifier')
ln('@lsp.mod.defaultLibrary',           'Type')
ln('@lsp.type.macro',                   'Special')
ln('@markup.link.markdown_inline',      'Underlined')
ln('@markup.link.url.markdown_inline',  'Comment')

-- Special snowflakes
--------------------------------------------------------------------------------
-- Markdown highlights all underscores as errors, just disable it.
hi('markdownError', { fg = 'NONE', bg = 'NONE' }, { fg = 'NONE', bg = 'NONE' })

-- Highlight notes everywhere, just like todos.
vim.api.nvim_create_augroup('HighlightNotes', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'FileType' }, {
    group = 'HighlightNotes',
    callback = function()
        vim.fn.matchadd('Todo', 'TODO:\\|NOTE:\\|SEE:\\|QUESTION:\\|FIXME:\\|todo:\\|note:\\|see:\\|question:\\|fixme:')
    end,
})
