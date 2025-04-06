--------------------------------------------------------------------------------
-- Plugin loader
--------------------------------------------------------------------------------

local M = {}

function M.load_plugins()
    local plugins = {}
    local plugin_dir = vim.fn.stdpath('config') .. '/lua/plugins'

    local function scan_dir(dir)
        local handle = vim.loop.fs_scandir(dir)
        if not handle then
            return
        end

        while true do
            local name, filetype = vim.loop.fs_scandir_next(handle)
            if not name then
                break
            end

            local path = dir .. '/' .. name

            if name == 'init.lua' then
                goto continue
            end

            if filetype == 'directory' then
                scan_dir(path)

            elseif filetype == 'file' and name:match('%.lua$') then
                local plugin_module = path:gsub(vim.fn.stdpath('config') .. '/lua/', ''):gsub('/', '.'):gsub('%.lua$', '')
                local ok, plugin_config = pcall(require, plugin_module)

                if ok and type(plugin_config) == 'table' then
                    for _, config in ipairs(plugin_config) do
                        table.insert(plugins, config)
                    end
                end
            end

            ::continue::
        end
    end

    scan_dir(plugin_dir)

    return plugins
end

return M
