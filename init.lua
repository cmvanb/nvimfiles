--------------------------------------------------------------------------------
-- Neovim configuration
--------------------------------------------------------------------------------

-- Packer's compile target is in `.local/share/nvim`, so we need to include this
-- in the runtimepath to ensure NVIM can autoload Packer.
vim.opt.runtimepath:append(vim.fn.stdpath('data'))

-- Improve startup performance.
require('utils.disable_builtins')

-- Global utils.
require('utils.debug')
require('utils.do_load')
require('utils.reload')
require('utils.reload_config')

-- Load editor config.
require('editor.options')
require('editor.gui')
require('editor.highlights')

-- Load autocommands.
require('autocommands')

-- Load plugins. Will bootstrap Packer if necessary.
require('loader')
Loader.init()

-- Load key mappings last; some key mappings may depend on plugins.
require('editor.keymaps')

