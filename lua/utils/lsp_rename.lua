--------------------------------------------------------------------------------
-- LSP rename with floating window
--------------------------------------------------------------------------------

local M = {}

--- Creates a floating window for LSP rename at the cursor position
---@param opts table|nil Optional configuration
---   - position: 'cursor' (default) or 'center'
---   - width: number (default: 40)
---   - border: string (default from theme.config)
function M.rename(opts)
    opts = opts or {}
    local theme_config = require('theme.config')
    local border = opts.border or theme_config.border

    -- Store original window and position
    local orig_win = vim.api.nvim_get_current_win()
    local orig_pos = vim.api.nvim_win_get_cursor(orig_win)

    -- Get current word under cursor
    local curr_name = vim.fn.expand('<cword>')

    -- Calculate window position
    local win_width = opts.width or 40
    local win_height = 1

    local position_opts
    if opts.position == 'center' then
        -- Center of screen
        local ui = vim.api.nvim_list_uis()[1]
        local win_height_with_border = win_height + 2
        local win_width_with_border = win_width + 2

        position_opts = {
            relative = 'editor',
            row = math.floor((ui.height - win_height_with_border) / 2),
            col = math.floor((ui.width - win_width_with_border) / 2),
            width = win_width,
            height = win_height,
        }
    else
        -- At cursor position (default)
        position_opts = {
            relative = 'cursor',
            row = 1,
            col = 0,
            width = win_width,
            height = win_height,
        }
    end

    -- Create buffer
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

    -- Open floating window
    local win = vim.api.nvim_open_win(buf, true, vim.tbl_extend('force', position_opts, {
        style = 'minimal',
        border = border,
        title = ' Rename ',
        title_pos = 'center',
    }))

    -- Set up highlighting for the buffer
    vim.api.nvim_win_set_option(win, 'winhl', 'Normal:Normal,FloatBorder:FloatBorder')

    -- Pre-fill with current word and position cursor at the end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { curr_name })
    vim.api.nvim_win_set_cursor(win, { 1, #curr_name })

    -- Enter insert mode
    vim.cmd('startinsert!')

    -- Handle submission
    local function submit()
        local new_name = vim.trim(vim.fn.getline('.'))

        -- Close window first
        vim.api.nvim_win_close(win, true)

        -- Restore original window and buffer context
        vim.api.nvim_set_current_win(orig_win)
        vim.api.nvim_win_set_cursor(orig_win, orig_pos)

        -- Exit insert mode
        vim.cmd('stopinsert')

        if new_name ~= '' and new_name ~= curr_name then
            -- Perform rename with slight delay to ensure context is restored
            vim.schedule(function()
                vim.lsp.buf.rename(new_name)
            end)
        end
    end

    -- Handle cancellation
    local function cancel()
        vim.api.nvim_win_close(win, true)
        vim.cmd('stopinsert')
    end

    -- Set up keymaps for the prompt buffer
    local keymap_opts = { buffer = buf, noremap = true, silent = true }

    vim.keymap.set('i', '<CR>', submit, keymap_opts)
    vim.keymap.set('i', '<Esc>', cancel, keymap_opts)
    vim.keymap.set('n', '<CR>', submit, keymap_opts)
    vim.keymap.set('n', '<Esc>', cancel, keymap_opts)
    vim.keymap.set('n', 'q', cancel, keymap_opts)

    -- Auto-close on focus lost
    vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, {
        buffer = buf,
        once = true,
        callback = function()
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end
        end,
    })
end

return M
