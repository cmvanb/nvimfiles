--------------------------------------------------------------------------------
-- Startup screen
--------------------------------------------------------------------------------

local HighlightsUtils = require('utils.highlights')
local Logo = require('startup.logo')
local Model = require('startup.model')
local Project = require('startup.project')
local Session = require('startup.session')
local icons = require('theme.symbols').startup

local hi = HighlightsUtils.highlight
local ln = HighlightsUtils.link

local Startup = {}

-- Highlights
--------------------------------------------------------------------------------

-- Logo rows, top to bottom: a vertical gradient through the primary palette.
local LOGO_COLORS = {
    { 'primary_15', 'ansi_brblue' },
    { 'primary_14', 'ansi_brblue' },
    { 'primary_13', 'ansi_brblue' },
    { 'primary_12', 'ansi_brblue' },
    { 'primary_11', 'ansi_blue' },
    { 'primary_10', 'ansi_blue' },
    { 'primary_9',  'ansi_blue' },
}

for i, color in ipairs(LOGO_COLORS) do
    hi('StartupLogo' .. i, { fg = color[1] }, { fg = color[2] })
end

hi('StartupItem',     { fg = 'text_12' },                                   { fg = 'ansi_white' })
hi('StartupSelected', { fg = 'yellow_6', bg = 'primary_3', attrs = 'bold' }, { fg = 'ansi_bryellow', bg = 'ansi_blue' })
hi('StartupDetail',   { fg = 'secondary_11' },                              { fg = 'ansi_brblack' })
hi('StartupIcon',     { fg = 'orange_6' },                                  { fg = 'ansi_yellow' })
hi('StartupHeading',  { fg = 'primary_13', attrs = 'bold' },                { fg = 'ansi_brblue' })
hi('StartupFile',     { fg = 'text_13' },                                   { fg = 'ansi_white' })
hi('StartupDir',      { fg = 'secondary_10' },                              { fg = 'ansi_brblack' })
hi('StartupMissing',  { fg = 'red_7', attrs = 'strikethrough' },            { fg = 'ansi_red' })
ln('StartupFooter',   'Comment')

-- Layout
--------------------------------------------------------------------------------

local COLUMN_WIDTH = 44
-- Fraction of the window height to lower the centered logo and menu by.
local TOP_SHIFT = 0.1
-- Menu rows kept before the logo gives way on short windows.
local MIN_LIST_HEIGHT = 8
-- Blank lines always kept above the logo and menu.
local MIN_TOP_MARGIN = 2
local ns = vim.api.nvim_create_namespace('startup')

local function ago(sec)
    local d = os.time() - sec
    if d < 3600 then return math.max(1, math.floor(d / 60)) .. 'm ago' end
    if d < 86400 then return math.floor(d / 3600) .. 'h ago' end
    return math.floor(d / 86400) .. 'd ago'
end

local function pad(s, width)
    local w = vim.fn.strdisplaywidth(s)
    if w >= width then
        return vim.fn.strcharpart(s, 0, width - 1) .. icons.ellipsis
    end
    return s .. string.rep(' ', width - w)
end

-- A canvas of lines plus highlight spans, built in display cells.
local Canvas = {}
Canvas.__index = Canvas

function Canvas.new() return setmetatable({ lines = {}, marks = {} }, Canvas) end

function Canvas:put(row, col, text, hl)
    local line = self.lines[row] or ''
    local w = vim.fn.strdisplaywidth(line)
    if w < col then
        line = line .. string.rep(' ', col - w)
    end
    local start = #line
    self.lines[row] = line .. text
    if hl then
        table.insert(self.marks, { row = row, start = start, finish = start + #text, hl = hl })
    end
    return col + vim.fn.strdisplaywidth(text)
end

-- Writes highlighted chunks, truncating them to `width` cells.
function Canvas:put_chunks(row, col, chunks, width)
    for _, c in ipairs(chunks) do
        if width <= 0 then break end
        local text = vim.fn.strdisplaywidth(c[1]) > width and pad(c[1], width) or c[1]
        col = self:put(row, col, text, c[2])
        width = width - vim.fn.strdisplaywidth(text)
    end
end

local function preview_lines(row)
    if not row or row.kind ~= 'session' then
        return {}
    end
    local s = row.session
    local out = { { { 'Session', 'StartupHeading' }, { '  ' .. #s.buffers .. (#s.buffers == 1 and ' buffer' or ' buffers') .. ' · saved ' .. ago(s.mtime), 'StartupDetail' } }, {} }
    for _, b in ipairs(s.buffers) do
        local rel = b.path:sub(1, #s.dir + 1) == s.dir .. '/' and b.path:sub(#s.dir + 2) or vim.fn.fnamemodify(b.path, ':~')
        local name = vim.fs.basename(rel)
        local dir = vim.fs.dirname(rel)
        dir = dir == '.' and '' or ' ' .. dir
        local mark = b.path == s.current and icons.current .. ' ' or '  '
        table.insert(out, {
            { mark, 'StartupIcon' },
            { name, b.exists and 'StartupFile' or 'StartupMissing' },
            { dir, 'StartupDir' },
        })
    end
    return out
end

local function row_chunks(row)
    if row.kind == 'action' then
        return { { row.icon .. '  ', 'StartupIcon' }, { row.label, 'StartupItem' }, { row.detail and ('  ' .. row.detail) or '', 'StartupDetail' } }
    end
    local icon = (row.kind == 'session' and icons.session or icons.worktree) .. '  '
    local detail = row.kind == 'worktree' and '  start here' or ''
    return { { icon, 'StartupIcon' }, { row.label, 'StartupItem' }, { detail, 'StartupDetail' } }
end

local function footer_text(state)
    local parts = { vim.fn.fnamemodify(vim.uv.cwd(), ':~') }
    if state.project.branch then
        table.insert(parts, icons.branch .. ' ' .. state.project.branch)
    end
    return table.concat(parts, '   ')
end

local function render(state)
    local buf, win = state.buf, state.win
    if not vim.api.nvim_win_is_valid(win) then return end
    local width = vim.api.nvim_win_get_width(win)
    local height = vim.api.nvim_win_get_height(win)

    local logo = is_linux_virtual_terminal() and Logo.ascii or Logo.lines
    local logo_w = 0
    for _, l in ipairs(logo) do logo_w = math.max(logo_w, vim.fn.strdisplaywidth(l)) end

    -- List lines hold a row index, or false for the gap between places and actions.
    local list = {}
    for i, row in ipairs(state.rows) do
        if row.kind == 'action' and i > 1 and state.rows[i - 1].kind ~= 'action' then
            table.insert(list, false)
        end
        table.insert(list, i)
    end

    -- Reserve room for the longest preview so the menu holds still while moving.
    local preview_h = 0
    for _, row in ipairs(state.rows) do
        preview_h = math.max(preview_h, #preview_lines(row))
    end

    -- The footer owns the last line; the rest is centered above it. Space goes to
    -- the menu first, then a short preview, then the logo; a menu that still
    -- does not fit scrolls in place.
    local room = height - 2
    local space = room - MIN_TOP_MARGIN
    local preview_min = preview_h > 0 and 1 + math.min(preview_h, 3) or 0
    local show_logo = #logo + 2 + math.min(#list, MIN_LIST_HEIGHT) + preview_min <= space and width >= logo_w
    local logo_h = show_logo and #logo + 2 or 0
    local list_h = math.max(1, math.min(#list, space - logo_h - preview_min))
    preview_h = math.max(0, math.min(preview_h, space - logo_h - list_h - 1))

    -- Keep the selected row inside the visible slice of the menu.
    local cursor_line = 1
    for line, i in ipairs(list) do
        if i == state.cursor then cursor_line = line end
    end
    -- An overflowing menu gives its first and last line to scroll indicators.
    local overflow = #list > list_h and list_h >= 3
    local view_h = overflow and list_h - 2 or list_h
    state.scroll = math.min(state.scroll or 0, cursor_line - 1)
    state.scroll = math.max(state.scroll, cursor_line - view_h)
    state.scroll = math.max(0, math.min(state.scroll, #list - view_h))

    local block_h = logo_h + list_h + (preview_h > 0 and 1 + preview_h or 0)
    -- Centered, then lowered by TOP_SHIFT, short of the footer.
    local top = math.floor((room - block_h) / 2) + math.floor(height * TOP_SHIFT)
    top = math.max(MIN_TOP_MARGIN, math.min(top, room - block_h))
    local canvas = Canvas.new()
    local r = top + 1

    if show_logo then
        local left = math.floor((width - logo_w) / 2)
        for y, line in ipairs(logo) do
            local col = left
            local hl = 'StartupLogo' .. math.min(math.floor((y - 1) * #LOGO_COLORS / #logo) + 1, #LOGO_COLORS)
            for ch in line:gmatch('[%z\1-\127\194-\244][\128-\191]*') do
                col = canvas:put(r, col, ch, ch ~= ' ' and hl or nil)
            end
            r = r + 1
        end
        r = r + 2
    end

    local left = math.max(0, math.floor((width - COLUMN_WIDTH) / 2))
    local function rows_in(from, to)
        local n = 0
        for line = from, to do
            if list[line] then n = n + 1 end
        end
        return n
    end
    local function indicator(icon, n)
        if n > 0 then
            canvas:put_chunks(r, left + 1, { { icon .. '  ' .. n .. ' more', 'StartupDetail' } }, COLUMN_WIDTH - 1)
        end
        r = r + 1
    end

    state.row_lines = {}
    if overflow then
        indicator(icons.more_up, rows_in(1, state.scroll))
    end
    for line = state.scroll + 1, state.scroll + view_h do
        local i = list[line]
        local row = i and state.rows[i]
        if row then
            if i == state.cursor then
                local text = ''
                for _, c in ipairs(row_chunks(row)) do text = text .. c[1] end
                canvas:put(r, left, pad(' ' .. text, COLUMN_WIDTH), 'StartupSelected')
            else
                canvas:put_chunks(r, left + 1, row_chunks(row), COLUMN_WIDTH - 1)
            end
            state.row_lines[i] = r
        end
        r = r + 1
    end
    if overflow then
        indicator(icons.more_down, rows_in(state.scroll + view_h + 1, #list))
    end

    if preview_h > 0 then
        r = r + 1
        local preview = preview_lines(state.rows[state.cursor])
        if #preview > preview_h then
            local hidden = #preview - preview_h + 1
            preview = vim.list_slice(preview, 1, preview_h - 1)
            table.insert(preview, { { '  ' .. icons.ellipsis .. ' ' .. hidden .. ' more', 'StartupDetail' } })
        end
        for _, p in ipairs(preview) do
            canvas:put_chunks(r, left + 1, p, COLUMN_WIDTH - 1)
            r = r + 1
        end
    end

    local foot = footer_text(state)
    r = height
    canvas:put(r, math.floor((width - vim.fn.strdisplaywidth(foot)) / 2), foot, 'StartupFooter')

    for i = 1, r do canvas.lines[i] = canvas.lines[i] or '' end
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, canvas.lines)
    vim.bo[buf].modifiable = false
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    for _, m in ipairs(canvas.marks) do
        vim.api.nvim_buf_set_extmark(buf, ns, m.row - 1, m.start, { end_col = m.finish, hl_group = m.hl })
    end
    local line = state.row_lines[state.cursor]
    if line then
        vim.api.nvim_win_set_cursor(win, { line, left + 1 })
    end
    -- A resize scrolls the view to keep the cursor visible before this render
    -- runs; pin it back to the origin so the layout stays centered.
    vim.api.nvim_win_call(win, function() vim.fn.winrestview({ topline = 1, leftcol = 0 }) end)
end

-- Interaction
--------------------------------------------------------------------------------

local saved_ui

vim.api.nvim_set_hl(0, 'StartupHiddenCursor', { blend = 100, nocombine = true })

local function lualine(hide)
    local ok, lualine = pcall(require, 'lualine')
    if ok then
        lualine.hide({ unhide = not hide })
    end
end

local function apply_hidden_ui()
    lualine(true)
    vim.o.laststatus = 0
    vim.o.showtabline = 0
    vim.o.ruler = false
    vim.o.guicursor = 'a:StartupHiddenCursor'
end

local function hide_ui()
    if saved_ui then return end
    saved_ui = { laststatus = vim.o.laststatus, showtabline = vim.o.showtabline, ruler = vim.o.ruler, guicursor = vim.o.guicursor }
    apply_hidden_ui()
end

local function restore_ui()
    if not saved_ui then return end
    vim.o.laststatus = saved_ui.laststatus
    vim.o.showtabline = saved_ui.showtabline
    vim.o.ruler = saved_ui.ruler
    vim.o.guicursor = saved_ui.guicursor
    saved_ui = nil
    lualine(false)
end

local function refresh(state)
    state.rows = Model.rows(state.project)
    state.cursor = math.min(state.cursor, #state.rows)
    render(state)
end

local function activate(state)
    local row = state.rows[state.cursor]
    if not row then return end
    if row.kind == 'session' then
        Session.load(row.session)
    elseif row.kind == 'worktree' then
        vim.cmd.cd(vim.fn.fnameescape(row.path))
        vim.cmd.enew()
    else
        row.run()
        if row.stay then
            refresh(state)
        end
    end
end

local function delete(state)
    local row = state.rows[state.cursor]
    if not row or row.kind ~= 'session' then return end
    local choice = vim.fn.confirm('Delete session for ' .. row.detail .. '?', '&Yes\n&No', 2)
    if choice ~= 1 then return end
    Session.delete(row.session)
    refresh(state)
end

function Startup.open()
    local project = Project.detect()
    local previous = vim.api.nvim_get_current_buf()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, buf)
    local win = vim.api.nvim_get_current_win()
    if vim.api.nvim_buf_get_name(previous) == '' and not vim.bo[previous].modified
        and vim.api.nvim_buf_line_count(previous) == 1 and vim.api.nvim_buf_get_lines(previous, 0, 1, false)[1] == '' then
        vim.api.nvim_buf_delete(previous, {})
    end

    vim.bo[buf].bufhidden = 'wipe'
    vim.bo[buf].filetype = 'startup'
    for opt, value in pairs({
        number = false, relativenumber = false, signcolumn = 'no', foldcolumn = '0',
        statuscolumn = '', cursorline = false, list = false, spell = false, wrap = false,
        fillchars = 'eob: ', scrolloff = 0, sidescrolloff = 0,
    }) do
        -- Like :setlocal, so the editor's own window settings stay untouched.
        vim.api.nvim_set_option_value(opt, value, { scope = 'local', win = win })
    end

    local state = { buf = buf, win = win, project = project, rows = Model.rows(project), cursor = 1 }
    hide_ui()

    local function move(delta)
        state.cursor = (state.cursor - 1 + delta) % #state.rows + 1
        render(state)
    end

    local map = function(lhs, fn) vim.keymap.set('n', lhs, fn, { buffer = buf, nowait = true, silent = true }) end
    map('j', function() move(1) end)
    map('k', function() move(-1) end)
    map('<Down>', function() move(1) end)
    map('<Up>', function() move(-1) end)
    map('<CR>', function() activate(state) end)
    map('dd', function() delete(state) end)
    map('q', function() vim.cmd.quitall() end)

    local group = vim.api.nvim_create_augroup('startup_screen', { clear = true })
    vim.api.nvim_create_autocmd({ 'VimResized', 'WinResized' }, {
        group = group,
        callback = function() render(state) end,
    })
    -- Lualine re-runs its setup when 'background' changes, which happens
    -- after startup once the terminal reports its colors.
    vim.api.nvim_create_autocmd('OptionSet', {
        group = group,
        pattern = 'background',
        callback = function()
            vim.schedule(function()
                if saved_ui then apply_hidden_ui() end
            end)
        end,
    })
    vim.api.nvim_create_autocmd('BufEnter', { group = group, buffer = buf, callback = hide_ui })
    vim.api.nvim_create_autocmd('BufLeave', { group = group, buffer = buf, callback = restore_ui })
    vim.api.nvim_create_autocmd('BufWipeout', {
        group = group,
        buffer = buf,
        callback = function()
            restore_ui()
            vim.api.nvim_del_augroup_by_id(group)
        end,
    })

    render(state)
end

return Startup
