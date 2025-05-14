--------------------------------------------------------------------------------
-- Neovim configuration
--------------------------------------------------------------------------------

-- Improve startup performance.
require('utils.disable_builtins')

-- Global utils.
require('utils.debug')
require('utils.reload')
require('utils.reload_config')
require('utils.terminal')

-- Load editor config.
require('editor.gui')
require('editor.options')
require('editor.highlights')

-- Load plugins. Will bootstrap Lazy.nvim if necessary.
require('plugins')

-- Load autocommands.
require('autocommands')

-- Load key mappings last.
require('editor.keymaps')
