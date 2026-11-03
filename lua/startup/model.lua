--------------------------------------------------------------------------------
-- Startup screen model: the rows a user can pick
--------------------------------------------------------------------------------

local Session = require('startup.session')
local icons = require('theme.symbols').startup

local Model = {}

---@alias startup.Row
---| { kind: 'session', label: string, detail: string, session: startup.Session }
---| { kind: 'worktree', label: string, detail: string, path: string }
---| { kind: 'action', label: string, icon: string, detail: string?, stay: boolean?, run: fun() }

local function home(path)
    return vim.fn.fnamemodify(path, ':~')
end

-- The project root first, then its other worktrees by branch name.
local function place_rows(project)
    local rows = {}
    local places = { { path = project.root, label = vim.fs.basename(project.root) } }
    for _, w in ipairs(project.worktrees) do
        if w.path ~= project.root then
            table.insert(places, { path = w.path, label = w.branch or vim.fs.basename(w.path) })
        end
    end

    for i, place in ipairs(places) do
        local session = Session.read(place.path)
        if session then
            table.insert(rows, { kind = 'session', label = place.label, detail = home(place.path), session = session })
        elseif i > 1 then
            table.insert(rows, { kind = 'worktree', label = place.label, detail = home(place.path), path = place.path })
        end
    end
    return rows
end

-- Actions in display order. `when` hides an action that does not apply here,
-- `stay` keeps the screen open and refreshes it afterwards.
local actions = {
    {
        label = 'Start session here',
        icon = icons.session,
        when = function(ctx) return not Session.read(ctx.project.root) end,
        run = function(ctx)
            vim.cmd.cd(vim.fn.fnameescape(ctx.project.root))
            vim.cmd.enew()
            require('session_manager').save_current_session()
        end,
    },
    {
        label = 'New buffer',
        icon = icons.new,
        run = function(ctx)
            vim.cmd.cd(vim.fn.fnameescape(ctx.project.root))
            vim.cmd.enew()
        end,
    },
    {
        label = 'Find files',
        icon = icons.find,
        run = function(ctx) Snacks.picker.files({ cwd = ctx.project.root }) end,
    },
    {
        label = 'Grep',
        icon = icons.grep,
        run = function(ctx) Snacks.picker.grep({ cwd = ctx.project.root }) end,
    },
    {
        label = 'Clean up stale sessions',
        icon = icons.clean,
        stay = true,
        when = function(ctx) return #ctx.stale > 0 end,
        detail = function(ctx) return tostring(#ctx.stale) end,
        run = function(ctx)
            for _, file in ipairs(ctx.stale) do
                vim.uv.fs_unlink(file)
            end
            vim.notify('Removed ' .. #ctx.stale .. ' stale sessions')
        end,
    },
}

---@param project startup.Project
---@return startup.Row[]
function Model.rows(project)
    local rows = place_rows(project)
    local ctx = { project = project, stale = Session.stale_files() }
    for _, action in ipairs(actions) do
        if not action.when or action.when(ctx) then
            table.insert(rows, {
                kind = 'action',
                label = action.label,
                icon = action.icon,
                detail = action.detail and action.detail(ctx),
                stay = action.stay,
                run = function() action.run(ctx) end,
            })
        end
    end
    return rows
end

return Model
