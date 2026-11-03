--------------------------------------------------------------------------------
-- Session files: lookup by directory and a cheap read of their contents
--------------------------------------------------------------------------------

local Session = {}

local function sessions_dir()
    return vim.fn.stdpath('data') .. '/sessions'
end

local function file_for(dir)
    local name = dir:gsub(':', '++'):gsub('/', '__')
    return sessions_dir() .. '/' .. name
end

local function dir_for(file)
    local name = vim.fs.basename(file)
    return (name:gsub('__', '/'):gsub('%+%+', ':'))
end

local function expand(path, cwd)
    path = vim.fn.expand(path)
    if path:sub(1, 1) ~= '/' then
        path = cwd .. '/' .. path
    end
    return vim.fs.normalize(path)
end

---@class startup.Buffer
---@field path string
---@field line integer
---@field exists boolean

---@class startup.Session
---@field dir string
---@field file string
---@field mtime integer
---@field buffers startup.Buffer[]
---@field current string?  Path of the buffer that had focus.

-- Reads the buffer list without sourcing the session.
---@return startup.Session?
function Session.read(dir)
    local file = file_for(dir)
    local stat = vim.uv.fs_stat(file)
    if not stat then
        return nil
    end

    local session = { dir = dir, file = file, mtime = stat.mtime.sec, buffers = {} }
    local cwd = dir
    for line in io.lines(file) do
        local cd = line:match('^cd (.+)$')
        local lnum, badd = line:match('^badd %+(%d+) (.+)$')
        local edit = line:match('^edit (.+)$')
        if cd then
            cwd = expand(cd, dir)
        elseif badd then
            local path = expand(badd, cwd)
            table.insert(session.buffers, {
                path = path,
                line = tonumber(lnum),
                exists = vim.uv.fs_stat(path) ~= nil,
            })
        elseif edit and not session.current then
            session.current = expand(edit, cwd)
        end
    end

    return session
end

-- Every session whose directory no longer exists.
---@return string[]
function Session.stale_files()
    local stale = {}
    for name, type in vim.fs.dir(sessions_dir()) do
        local file = sessions_dir() .. '/' .. name
        if type == 'file' and not vim.uv.fs_stat(dir_for(file)) then
            table.insert(stale, file)
        end
    end
    return stale
end

function Session.load(session)
    vim.cmd.cd(vim.fn.fnameescape(session.dir))
    require('session_manager.utils').load_session(session.file, false)
end

function Session.delete(session)
    require('session_manager.utils').delete_session(session.file)
end

return Session
