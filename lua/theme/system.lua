--------------------------------------------------------------------------------
-- System theme colors
--------------------------------------------------------------------------------

local path = require('utils.path')

path.prepend_to_package_path(
    os.getenv('XDG_OPT_HOME') .. [[/theme/?.lua]]
)

return require('theme')
