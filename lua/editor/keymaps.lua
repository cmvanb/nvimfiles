--------------------------------------------------------------------------------
-- Editor key mappings
--------------------------------------------------------------------------------

-- Imports
--------------------------------------------------------------------------------

local keys = reload('utils.keymaps')

-- Shortcuts
--------------------------------------------------------------------------------

local map, nmap, xmap, imap, unmap =
    keys.map,
    keys.nmap,
    keys.xmap,
    keys.imap,
    keys.unmap

local noremap, nnoremap, xnoremap, inoremap, onoremap, vnoremap, tnoremap =
    keys.noremap,
    keys.nnoremap,
    keys.xnoremap,
    keys.inoremap,
    keys.onoremap,
    keys.vnoremap,
    keys.tnoremap

-- Remove some default mappings
--------------------------------------------------------------------------------

map('q', '<nop>')
map('Q', '<nop>')

map('H', '<nop>')
map('J', '<nop>')
map('K', '<nop>')
map('L', '<nop>')

map('<C-h>', '<nop>')
map('<C-j>', '<nop>')
map('<C-k>', '<nop>')
map('<C-l>', '<nop>')

map('<C-d>', '<nop>')
map('<C-f>', '<nop>')
map('<C-u>', '<nop>')

map('<C-o>', '<nop>')

map('<C-n>', '<nop>')
map('<C-p>', '<nop>')
imap('<C-n>', '<nop>')
imap('<C-p>', '<nop>')

map('ga', '<nop>')
map('gd', '<nop>')
map('ge', '<nop>')
map('gD', '<nop>')
map('gh', '<nop>')
map('gH', '<nop>')
map('gi', '<nop>')
map('go', '<nop>')
map('gr', '<nop>')

-- Leader key
--------------------------------------------------------------------------------

nnoremap(' ', '')
xnoremap(' ', '')
vim.g.mapleader = ' '

-- Navigation
--------------------------------------------------------------------------------

-- Smooth scroll with neoscroll
local neoscroll = require('neoscroll')

local function scroll_up()   neoscroll.ctrl_u({ duration = 40 }) end
local function scroll_down() neoscroll.ctrl_d({ duration = 40 }) end

nnoremap('<C-d>',      scroll_up,   { desc = 'Scroll half-page up' })
xnoremap('<C-d>',      scroll_up,   { desc = 'Scroll half-page up' })
nnoremap('<C-f>',      scroll_down, { desc = 'Scroll half-page down' })
xnoremap('<C-f>',      scroll_down, { desc = 'Scroll half-page down' })
nnoremap('<PageUp>',   scroll_up,   { desc = 'Scroll half-page up' })
xnoremap('<PageUp>',   scroll_up,   { desc = 'Scroll half-page up' })
nnoremap('<PageDown>', scroll_down, { desc = 'Scroll half-page down' })
xnoremap('<PageDown>', scroll_down, { desc = 'Scroll half-page down' })

-- Top/bottom
noremap('<Home>', '0', { desc = 'Start of line' })
noremap('<End>', '$', { desc = 'End of line' })

-- Start/end of line
-- nnoremap('H', '0')
-- xnoremap('H', '0')
-- onoremap('H', '0')
-- nnoremap('L', '$')
-- xnoremap('L', '$')
-- onoremap('L', '$')

-- Leap
noremap(
    '<leader>j',
    function() require('leap').leap({}) end,
    { desc = 'Leap forward' })
noremap(
    '<leader>k',
    function() require('leap').leap({ backward = true }) end,
    { desc = 'Leap backward' })

-- Selection
--------------------------------------------------------------------------------

-- Select all
noremap('<C-a>', 'gg0vG$', { desc = 'Select all' })

-- Visual block select
noremap('<A-v>', '<C-v>', { desc = 'Visual block select' })

-- Editing
-------------------------------------------------------------------------------

-- Copy, paste
-- NOTE: These are only working because the terminal (Alacritty) is configured for it.
if not is_linux_virtual_terminal() then
    noremap('<C-c>', '"+y', { desc = 'Copy' })
    noremap('<C-v>', '"+p', { desc = 'Paste' })
end

-- Cut
noremap('<C-x>', 'x', { desc = 'Cut' })

-- Undo
nnoremap('<C-z>', 'u', { desc = 'Undo' })

-- Swap lines
nnoremap('J', '<esc>:m .+1<cr>==', { silent = true }, { desc = 'Move line down' })
nnoremap('K', '<esc>:m .-2<cr>==', { silent = true }, { desc = 'Move line up' })

-- Indentation
nnoremap('H', '<<', { desc = 'Indent left' })
nnoremap('L', '>>', { desc = 'Indent right' })
vnoremap('H', '<gv', { desc = 'Indent left' })
vnoremap('L', '>gv', { desc = 'Indent right' })

-- Formatting
nnoremap(';', '=', { desc = 'Format selected' })
xnoremap(';', '=', { desc = 'Format selected' })
nnoremap('<F17>', 'gg=G', { desc = 'Format buffer' })
nnoremap('<F16>', ':TSJToggle<cr>', { desc = 'Split/join formatting' })

-- Increment/decrement numbers
xnoremap('+', '<C-a>')
xnoremap('-', '<C-x>')

-- Search
--------------------------------------------------------------------------------

-- Clear search highlight, search pattern and command line.
nnoremap('<C-y>',
    function()
        vim.fn.setreg('/', '')
        vim.opt.hlsearch = false
        vim.cmd('echo ""')
    end,
    { desc = 'Clear search' })

-- View
--------------------------------------------------------------------------------

-- -- Folds
-- local ufo = require('ufo')
-- nnoremap('zR', ufo.openAllFolds)
-- nnoremap('zM', ufo.closeAllFolds)

-- Toggle indent guides & whitespace
-- TODO: Consider cycling through an option to toggle the EOL character.
nnoremap('<leader>n',
    function()
        if vim.wo.list then
            vim.cmd('IBLDisable')
            vim.cmd('tabdo windo set nolist')
        else
            vim.cmd('IBLEnable')
            vim.cmd('tabdo windo set list')
        end
    end,
    { silent = true, desc = 'Toggle indentation guides' })

-- Toggle linebreaks
nnoremap('<leader>m',
    function()
        if vim.wo.linebreak then
            vim.cmd('tabdo windo set nowrap')
            vim.cmd('tabdo windo set nolinebreak')
        else
            vim.cmd('tabdo windo set wrap')
            vim.cmd('tabdo windo set linebreak')
        end
    end,
    { desc = 'Toggle linebreaks' })

-- Toggle linebreaks for all buffers
nnoremap('<leader>M',
    function()
        local enable = not vim.wo.linebreak
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            vim.wo[win].wrap = enable
            vim.wo[win].linebreak = enable
        end
        vim.g.linebreak_synced = enable
    end,
    { desc = 'Toggle linebreaks for all buffers' })

vim.api.nvim_create_autocmd('BufWinEnter', {
    callback = function()
        if vim.g.linebreak_synced ~= nil then
            vim.wo.wrap = vim.g.linebreak_synced
            vim.wo.linebreak = vim.g.linebreak_synced
        end
    end,
})

-- LSP & diagnostics
--------------------------------------------------------------------------------

nnoremap(
    '<leader>l',
    function()
        local format =
            function(item)
                return {{ item.text }}
            end

        local confirm =
            function(picker, item)
                picker:close()
                if item and item.action then
                    vim.schedule(item.action)
                end
            end

        Snacks.picker.pick({
            title = 'LSP',
            items = {
                {
                    text = 'LSP Start',
                    action = function()
                        vim.lsp.stop_client(vim.lsp.get_clients({ bufnr = 0 }), true)
                        vim.cmd('edit')
                    end,
                },
                {
                    text = 'LSP Stop',
                    action = function()
                        vim.lsp.stop_client(vim.lsp.get_clients({ bufnr = 0 }), true)
                    end,
                },
                {
                    text = 'LSP Info',
                    action = function()
                        vim.cmd('checkhealth lsp')
                    end,
                },
                {
                    text = 'LSP Log',
                    action = function()
                        vim.cmd.edit(vim.lsp.get_log_path())
                    end,
                },
            },
            format = format,
            confirm = confirm,
            layout = { preset = 'smallmenu' },
        })
    end,
    { desc = 'LSP commands' })

nnoremap(
    'gd',
    function() Snacks.picker.lsp_definitions() end,
    { desc = 'LSP: Go to definition' })
nnoremap(
    'ge',
    function() Snacks.picker.diagnostics() end,
    { desc = 'LSP: Show diagnostics' })
nnoremap(
    'gt',
    function() Snacks.picker.lsp_type_definitions() end,
    { desc = 'LSP: Go to type definition' })
nnoremap(
    'gi',
    function() Snacks.picker.lsp_implementations() end,
    { desc = 'LSP: Go to implementation' })
nnoremap(
    'gr',
    function() Snacks.picker.lsp_references() end,
    { desc = 'LSP: Find references' })

-- Buffer management
--------------------------------------------------------------------------------

-- Save all buffers
nnoremap('<leader>s', ':wa!<cr>', { desc = 'Save all buffers' })
nnoremap('<C-s>', ':wa!<cr>', { desc = 'Save all buffers' })
xnoremap('<C-s>', '<esc>:wa!<cr>', { desc = 'Save all buffers' })
inoremap('<C-s>', '<esc>:wa!<cr>', { desc = 'Save all buffers' })

-- Cycle buffers
nnoremap('<C-h>', ':bprev<cr>', { silent = true, desc = 'Previous buffer' })
nnoremap('<C-l>', ':bnext<cr>', { silent = true, desc = 'Next buffer' })

-- Last focused buffer
nnoremap('<C-Tab>', '<C-6>', { desc = 'Last focused buffer' })

-- Close buffer
nnoremap('<C-w>', ':Bdelete<cr>', { silent = true, desc = 'Close buffer' })

-- Quit NVIM
noremap('<leader>w', ':wqa!<cr>', { desc = 'Quit NVIM' })

-- Tab management
--------------------------------------------------------------------------------

-- Open new tab
noremap('<C-A-t>', ':tabnew<cr>', { silent = true, desc = 'New tab' })

-- Next tab
nnoremap('<C-A-Right>', ':tabnext<cr>', { silent = true, desc = 'Next tab' })

-- Prev tab
nnoremap('<C-A-Left>', ':tabprev<cr>', { silent = true, desc = 'Previous tab' })

-- Window management
--------------------------------------------------------------------------------

-- Change window focus
nnoremap('<C-A-h>', '<C-w>h', { desc = 'Focus window left' })
nnoremap('<C-A-j>', '<C-w>j', { desc = 'Focus window down' })
nnoremap('<C-A-k>', '<C-w>k', { desc = 'Focus window up' })
nnoremap('<C-A-l>', '<C-w>l', { desc = 'Focus window right' })

-- Cycle windows
nnoremap('<C-A-s>', '<C-w>R<C-w>l', { desc = 'Cycle windows left' })
nnoremap('<C-A-g>', '<C-w>r<C-w>h', { desc = 'Rotate windows right' })

-- Change window size
nnoremap(
    '<C-A-a>',
    ':wincmd =<cr>',
    { silent = true, desc = 'Equalize window width' })
nnoremap(
    '<C-A-d>',
    ':100wincmd |<cr>',
    { silent = true, desc = 'Enlarge window width' })
nnoremap(
    '<C-A-f>',
    ':wincmd |<cr>:wincmd _<cr>',
    { silent = true, desc = 'Maximize window width and height' })

-- Split windows
local function split_with_next_buf(vertical)
    local bufs = vim.tbl_filter(
        function(b)
            return vim.bo[b].buflisted and vim.api.nvim_buf_is_loaded(b)
        end,
        vim.api.nvim_list_bufs()
    )

    local cur = vim.api.nvim_get_current_buf()
    local idx = 1
    for i, b in ipairs(bufs) do
        if b == cur then idx = i; break end
    end

    local target = bufs[(idx % #bufs) + 1] or cur
    vim.cmd('belowright ' .. (vertical and 'vsplit' or 'split'))
    vim.api.nvim_set_current_buf(target)
end

nnoremap(
    '<C-A-n>',
    function() split_with_next_buf(true) end,
    { silent = true, desc = 'Split window vertically (+ next buffer)' })
nnoremap(
    '<C-A-p>',
    function() split_with_next_buf(false) end,
    { silent = true, desc = 'Split window horizontally (+ next buffer)' })

-- Close window
nnoremap('<C-A-w>', ':close<cr>', { silent = true, desc = 'Close window' })

-- Terminal
--------------------------------------------------------------------------------

nnoremap('<C-A-t>', ':belowright new +terminal<cr>', { silent = true, desc = 'Open terminal' })
tnoremap('<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Git
--------------------------------------------------------------------------------

nnoremap('gm', ':GitMessenger<cr>', { desc = 'Show git log for line' })

-- Package management
--------------------------------------------------------------------------------

nnoremap('<leader>p', ':Lazy<cr>', { desc = 'Plugin manager' })
nnoremap('<leader>t', ':Mason<cr>', { desc = 'Tooling manager' })

-- Session reset
--------------------------------------------------------------------------------

-- Close all buffers without saving, reset layout, clear search, marks, and jumplist.
nnoremap('<leader>x',
    function()
        -- Stop all LSP clients.
        vim.lsp.stop_client(vim.lsp.get_clients(), true)
        -- Clear search highlight and pattern.
        vim.fn.setreg('/', '')
        vim.opt.hlsearch = false
        -- Clear marks.
        vim.cmd('delmarks!')
        -- Clear jumplist.
        vim.cmd('clearjumps')
        -- Clear the command line.
        vim.cmd('echo ""')
        -- Force-delete every listed buffer.
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
                require('bufdelete').bufwipeout(buf, true)
            end
        end
        -- Reset to a single empty window.
        vim.cmd('only')
    end,
    { silent = true, desc = 'Reset session' })

-- Plugin management
--------------------------------------------------------------------------------

-- Reload config and plugins.
nnoremap('<leader>r', _G.reload_config, { silent = true, desc = 'Reload config' })
