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

local LIST_WIDTH = 40
local GAP = 4
local PREVIEW_WIDTH = 44
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
    local parts = {}
    local ok, lazy = pcall(require, 'lazy')
    if ok then
        local stats = lazy.stats()
        table.insert(parts, string.format('%d plugins in %.0f ms', stats.count, stats.startuptime))
    end
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

    local show_preview = width >= LIST_WIDTH + GAP + PREVIEW_WIDTH
    local body_w = show_preview and (LIST_WIDTH + GAP + PREVIEW_WIDTH) or LIST_WIDTH
    local preview = show_preview and preview_lines(state.rows[state.cursor]) or {}
    local body_h = math.max(#list, #preview)
    local show_logo = height >= #logo + 2 + body_h + 2 and width >= logo_w

    local block_h = (show_logo and #logo + 2 or 0) + body_h + 2
    local top = math.max(0, math.floor((height - block_h) / 2))
    local canvas = Canvas.new()
    for r = 1, top do canvas.lines[r] = '' end
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

    local left = math.floor((width - body_w) / 2)
    state.row_lines = {}
    for line = 1, body_h do
        local i = list[line]
        local row = i and state.rows[i]
        if row then
            local col = left
            local hl_sel = i == state.cursor
            local text = ''
            for _, c in ipairs(row_chunks(row)) do text = text .. c[1] end
            if hl_sel then
                canvas:put(r, col, pad(' ' .. text, LIST_WIDTH), 'StartupSelected')
            else
                canvas:put_chunks(r, col + 1, row_chunks(row), LIST_WIDTH - 1)
            end
            state.row_lines[i] = r
        end
        local p = preview[line]
        if p then
            canvas:put_chunks(r, left + LIST_WIDTH + GAP, p, PREVIEW_WIDTH)
        end
        canvas.lines[r] = canvas.lines[r] or ''
        r = r + 1
    end

    r = r + 1
    local foot = footer_text(state)
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
    vim.api.nvim_create_autocmd('User', {
        group = group,
        pattern = 'LazyVimStarted',
        callback = function() render(state) end,
    })
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
