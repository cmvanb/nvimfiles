--------------------------------------------------------------------------------
-- Symbols lookup
--------------------------------------------------------------------------------

local default_terminal_symbols = {
    borderchars = {
        '─', '│', '─', '│', '╭', '╮', '╯', '╰',
    },
    diagnostic_signs = {
        error = '󰅜 ',
        warn  = ' ',
        hint  = '󰌵 ',
        info  = ' ',
    },
    diff_signs = {
        added = '+',
        changed = '~',
        removed = '-',
    },
    git_signs = {
        add          = '┃',
        change       = '┃',
        delete       = '_',
        topdelete    = '‾',
        changedelete = '~',
        untracked    = '┆',
    },
    fillchars = {
        eob = '.',
        foldopen = '󰅀',
        foldclose = '󰅂',
        fold = ' ',
    },
    listchars = {
        lead = '·',
        tab = '>―',
        trail = '·',
    },
    lualine = {
        file_modified = '●',
        file_readonly = '󰌾',
        git_branch = '',
        section_separator_left = '🭬',
        section_separator_right = '🭮',
        tab_page = '  ',
    },
    picker = {
        prompt = '❱',
    },
    kinds = {
        Array         = ' ',
        Boolean       = '󰨙 ',
        Class         = ' ',
        Codeium       = '󰘦 ',
        Color         = ' ',
        Control       = ' ',
        Collapsed     = ' ',
        Constant      = '󰏿 ',
        Constructor   = ' ',
        Copilot       = ' ',
        Enum          = ' ',
        EnumMember    = ' ',
        Event         = ' ',
        Field         = ' ',
        File          = ' ',
        Folder        = ' ',
        Function      = '󰊕 ',
        Interface     = ' ',
        Key           = ' ',
        Keyword       = ' ',
        Method        = '󰊕 ',
        Module        = ' ',
        Namespace     = '󰦮 ',
        Null          = ' ',
        Number        = '󰎠 ',
        Object        = ' ',
        Operator      = ' ',
        Package       = ' ',
        Property      = ' ',
        Reference     = ' ',
        Snippet       = '󱄽 ',
        String        = ' ',
        Struct        = '󰆼 ',
        Supermaven    = ' ',
        TabNine       = '󰏚 ',
        Text          = ' ',
        TypeParameter = ' ',
        Unit          = ' ',
        Value         = ' ',
        Variable      = '󰀫 ',
    },
    -- indent_char = '▏',
    indent_char = '┋',
}

local linux_vt_symbols = {
    borderchars = {
        '─', '│', '─', '│', '┌', '┐', '┘', '└',
    },
    diagnostic_signs = {
        error = 'x',
        warn  = '!',
        hint  = '?',
        info  = 'i',
    },
    diff_signs = {
        added = '+',
        changed = '*',
        removed = '-',
    },
    git_signs = {
        add          = '│',
        change       = '│',
        delete       = '_',
        topdelete    = '─',
        changedelete = '~',
        untracked    = '░',
    },
    fillchars = {
        eob = '~',
        foldopen = '▼',
        foldclose = '▶',
        fold = ' ',
    },
    listchars = {
        lead = '·',
        tab = '>―',
        trail = '·',
    },
    lualine = {
        file_modified = '*',
        file_readonly = '[ro]',
        git_branch = '├',
        section_separator_left = '▌',
        section_separator_right = '▐',
        tab_page = '@',
    },
    picker = {
        prompt = '>',
    },
    indent_char = '│',
}

return is_linux_virtual_terminal()
    and linux_vt_symbols
    or default_terminal_symbols
