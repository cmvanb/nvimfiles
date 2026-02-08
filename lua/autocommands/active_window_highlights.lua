--------------------------------------------------------------------------------
-- The cursor line, fold/sign column and line numbers match the window's
-- active state
--------------------------------------------------------------------------------

local hi = reload('utils.highlights').highlight

local augroup = vim.api.nvim_create_augroup('SignColumnActive', { clear = true })

vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter' }, {
    group = augroup,
    callback = function()
        local wins = vim.api.nvim_list_wins()
        local current_win = vim.api.nvim_get_current_win()

        for _, win in ipairs(wins) do
            if vim.api.nvim_win_is_valid(win) then
                if win == current_win then
                   vim.wo[win].winhighlight =
                       'FoldColumn:SignColumnActive,'
                       .. 'LineNr:SignColumnActive,'
                       .. 'CursorLine:CursorLineActive,'
                       .. 'CursorLineNr:CursorLineSCActive,'
                       .. 'CursorLineFold:CursorLineSCActive,'
                       .. 'CursorLineSign:CursorLineSCActive'
                else
                   vim.wo[win].winhighlight =
                       'FoldColumn:SignColumnInactive,'
                       .. 'LineNr:SignColumnInactive,'
                       .. 'CursorLine:CursorLineInactive,'
                       .. 'CursorLineNr:CursorLineSCInactive,'
                       .. 'CursorLineFold:CursorLineSCInactive,'
                       .. 'CursorLineSign:CursorLineSCInactive'
                end
            end
        end
    end,
})
