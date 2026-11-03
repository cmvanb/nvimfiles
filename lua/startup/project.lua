--------------------------------------------------------------------------------
-- Project context: the anchor directory and its git worktrees
--------------------------------------------------------------------------------

local Project = {}

local function git(args, cwd)
    local result = vim.system(vim.list_extend({ 'git' }, args), { cwd = cwd, text = true }):wait()
    if result.code ~= 0 then
        return nil
    end
    return vim.trim(result.stdout)
end

-- A submodule's main worktree is listed by its git dir, not its checkout.
local function checkout_path(path)
    if vim.uv.fs_stat(path .. '/.git') then
        return path
    end
    return git({ '--git-dir=' .. path, 'rev-parse', '--show-toplevel' }) or path
end

local function list_worktrees(root)
    local out = git({ 'worktree', 'list', '--porcelain' }, root)
    if not out then
        return { { path = root } }
    end

    local worktrees = {}
    local current
    for line in vim.gsplit(out, '\n') do
        local path = line:match('^worktree (.+)$')
        if path then
            current = { path = checkout_path(path) }
            table.insert(worktrees, current)
        elseif current then
            current.branch = line:match('^branch refs/heads/(.+)$') or current.branch
            current.prunable = current.prunable or line:match('^prunable') ~= nil
        end
    end

    return vim.tbl_filter(function(w) return not w.prunable end, worktrees)
end

---@class startup.Worktree
---@field path string
---@field branch string?

---@class startup.Project
---@field cwd string
---@field root string     Directory that owns the session: git toplevel, or cwd outside git.
---@field branch string?
---@field worktrees startup.Worktree[]  Every worktree of the repo, the root included.

---@return startup.Project
function Project.detect(cwd)
    cwd = cwd or vim.uv.cwd()
    local root = git({ 'rev-parse', '--show-toplevel' }, cwd)
    if not root then
        return { cwd = cwd, root = cwd, worktrees = {} }
    end

    local worktrees = list_worktrees(root)
    local branch
    for _, w in ipairs(worktrees) do
        if w.path == root then
            branch = w.branch
        end
    end

    return { cwd = cwd, root = root, branch = branch, worktrees = worktrees }
end

return Project
