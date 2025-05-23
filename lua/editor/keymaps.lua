--------------------------------------------------------------------------------
-- Editor key mappings
--------------------------------------------------------------------------------

-- Imports
--------------------------------------------------------------------------------

local KeyMapUtils = reload('utils.keymaps')

-- Shortcuts
--------------------------------------------------------------------------------

local map, nmap, xmap, imap, unmap =
    KeyMapUtils.map,
    KeyMapUtils.nmap,
    KeyMapUtils.xmap,
    KeyMapUtils.imap,
    KeyMapUtils.unmap

local noremap, nnoremap, xnoremap, inoremap, onoremap, vnoremap =
    KeyMapUtils.noremap,
    KeyMapUtils.nnoremap,
    KeyMapUtils.xnoremap,
    KeyMapUtils.inoremap,
    KeyMapUtils.onoremap,
    KeyMapUtils.vnoremap

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

map('<C-o>', '<nop>')

map('<C-n>', '<nop>')
map('<C-p>', '<nop>')
imap('<C-n>', '<nop>')
imap('<C-p>', '<nop>')

map('<CR>', '<nop>')

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

-- Half page up/down
noremap(
    '<PageDown>',
    '<C-d>',
    { desc = 'Scroll half page down' })
noremap(
    '<PageUp>',
    '<C-u>',
    { desc = 'Scroll half page up' })

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

-- Insert line break
nnoremap('<Enter>', 'i<CR><esc>`^', { desc = 'Insert line break' })

-- Search
--------------------------------------------------------------------------------

-- Clear search highlight, clear command line and clear search pattern.
nnoremap('<C-y>', ':noh<cr>:let @/=""<cr>:echo ""<cr>', { desc = 'Clear search' })

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

-- LSP & diagnostics
--------------------------------------------------------------------------------

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
    ':wincmd |<cr>',
    { silent = true, desc = 'Maximize window width' })

-- Split windows
nnoremap(
    '<C-A-n>',
    ':belowright vnew<cr>',
    { silent = true, desc = 'Split window vertically' })
nnoremap(
    '<C-A-p>',
    ':belowright new<cr>',
    { silent = true, desc = 'Split window horizontally' })

-- Close window
nnoremap('<C-A-w>', ':close<cr>', { silent = true, desc = 'Close window' })

-- Git
--------------------------------------------------------------------------------

nnoremap('gm', ':GitMessenger<cr>', { desc = 'Show git log for line' })

-- Package management
--------------------------------------------------------------------------------

nnoremap('<leader>p', ':Lazy<cr>', { desc = 'Plugin manager' })
nnoremap('<leader>t', ':Mason<cr>', { desc = 'Tooling manager' })

-- Plugin management
--------------------------------------------------------------------------------

-- Reload config and plugins.
nnoremap('<leader>r', _G.reload_config, { silent = true, desc = 'Reload config' })
