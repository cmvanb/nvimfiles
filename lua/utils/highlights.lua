--------------------------------------------------------------------------------
-- Highlights utilities
--------------------------------------------------------------------------------

local HighlightsUtils = {}

-- Imports
--------------------------------------------------------------------------------

local theme = reload('theme.system')

-- Every applied group is recorded so a system theme switch can replay it.
-- Global, because modules reload this file and would otherwise split it.
_G._highlights_registry = _G._highlights_registry or { order = {}, groups = {} }
local registry = _G._highlights_registry

local function _record(group, entry)
    if registry.groups[group] == nil then
        table.insert(registry.order, group)
    end
    registry.groups[group] = entry
end

-- Private functions
--------------------------------------------------------------------------------

local function _get_24bit_theme_color(color_name)
    local ok, result = pcall(theme.color_hash, color_name)
    if not ok then
        vim.notify('[highlights] color `' .. color_name .. '` not found in theme, using NONE', vim.log.levels.WARN)
        return 'NONE'
    end
    return result
end

local function _get_ansi_theme_color(color_name)
    local ok, result = pcall(theme.color_name_to_ansi_index, color_name)
    if not ok then
        vim.notify('[highlights] color `' .. color_name .. '` not found in theme, using NONE', vim.log.levels.WARN)
        return 'NONE'
    end
    return result
end

local function _construct_gui_options(foreground_color, background_color, special_color, attributes)
    foreground_color = foreground_color or 'NONE'
    if foreground_color ~= 'NONE' then
        foreground_color = _get_24bit_theme_color(foreground_color)
    end

    background_color = background_color or 'NONE'
    if background_color ~= 'NONE' then
        background_color = _get_24bit_theme_color(background_color)
    end

    special_color = special_color or 'NONE'
    if special_color ~= 'NONE' then
        special_color = _get_24bit_theme_color(special_color)
    end

    attributes = attributes or 'NONE'

    return {
        guifg = foreground_color,
        guibg = background_color,
        guisp = special_color,
        gui = attributes,
    }
end

local function _construct_terminal_options(foreground_color, background_color, attributes)
    foreground_color = foreground_color or 'NONE'
    if foreground_color ~= 'NONE' then
        foreground_color = _get_ansi_theme_color(foreground_color)
    end

    background_color = background_color or 'NONE'
    if background_color ~= 'NONE' then
        background_color = _get_ansi_theme_color(background_color)
    end

    attributes = attributes or 'NONE'

    return {
        ctermfg = foreground_color,
        ctermbg = background_color,
        cterm = attributes,
    }
end

-- Create a highlight group
--------------------------------------------------------------------------------

function HighlightsUtils.highlight(group, gui_options, terminal_options)
    _record(group, { gui = gui_options, terminal = terminal_options })

    gui_options = gui_options or {}
    gui_options = _construct_gui_options(
        gui_options.fg,
        gui_options.bg,
        gui_options.sp,
        gui_options.attrs
    )

    terminal_options = terminal_options or {}
    terminal_options = _construct_terminal_options(
        terminal_options.fg,
        terminal_options.bg,
        terminal_options.attrs
    )

    local command =
        'hi! ' .. group
        .. ' guifg=' .. gui_options.guifg
        .. ' guibg=' .. gui_options.guibg
        .. ' guisp=' .. gui_options.guisp
        .. ' gui=' .. gui_options.gui
        .. ' ctermfg=' .. terminal_options.ctermfg
        .. ' ctermbg=' .. terminal_options.ctermbg
        .. ' cterm=' .. terminal_options.cterm

    local ok, result = pcall(vim.cmd, command)
    if not ok then
        error('Cannot create highlight group `' .. group .. '` because of the following error: ' .. result)
    end
end

-- Link a highlight group
--------------------------------------------------------------------------------

function HighlightsUtils.link(group, target)
    _record(group, { target = target })

    local ok, result = pcall(
        vim.cmd,
        'hi! link ' .. group .. ' ' .. target
    )
    if not ok then
        error('Cannot link highlight group `' .. group .. '` to `' .. target .. '` because of the following error: ' .. result)
    end
end

-- Reload the system theme and replay every recorded group
--------------------------------------------------------------------------------

function HighlightsUtils.reload_theme()
    package.loaded['theme-data'] = nil
    package.loaded['theme'] = nil
    theme = reload('theme.system')

    for _, group in ipairs(registry.order) do
        local entry = registry.groups[group]
        if entry.target then
            HighlightsUtils.link(group, entry.target)
        else
            HighlightsUtils.highlight(group, entry.gui, entry.terminal)
        end
    end
end

return HighlightsUtils
