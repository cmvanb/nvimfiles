--------------------------------------------------------------------------------
-- Path utilities
--------------------------------------------------------------------------------

local tbl = require('utils.table')

local PathUtils = {}

-- Private functions
--------------------------------------------------------------------------------

local function _get_package_paths()
    return vim.split(package.path, ';')
end

-- Append a path to package.path
--------------------------------------------------------------------------------

function PathUtils.append_to_package_path(path)
    local paths = _get_package_paths()

    if tbl.contains(paths, path) then
        return
    end

    package.path = package.path .. ';'.. path
end

-- Prepend a path to package.path
--------------------------------------------------------------------------------

function PathUtils.prepend_to_package_path(path)
    local paths = _get_package_paths()

    if tbl.contains(paths, path) then
        return
    end

    package.path = path .. ';' .. package.path
end

-- Normalize absolute file paths to relative
--------------------------------------------------------------------------------

function PathUtils.get_relative_path(file_path)
    if vim.startswith(file_path, "/")
        or vim.startswith(file_path, "\\")
        or file_path:match("^%a:")
    then
        -- This is an absolute path, make it relative to cwd
        file_path = vim.fn.fnamemodify(file_path, ":~:.")

        -- If fnamemodify didn't work (file outside CWD), use relative path from cwd
        if vim.startswith(file_path, "/")
            or vim.startswith(file_path, "\\")
            or file_path:match("^%a:")
        then
            file_path = vim.fs.normalize(vim.fn.resolve(file_path))
            local cwd = vim.fn.getcwd()
            local normalized_cwd = vim.fs.normalize(vim.fn.resolve(cwd))

            if vim.startswith(file_path, normalized_cwd) then
                -- NOTE: +2 to skip the trailing slash
                file_path = file_path:sub(#normalized_cwd + 2)
            end
        end
    end

    return file_path
end

return PathUtils
