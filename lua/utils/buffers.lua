--------------------------------------------------------------------------------
-- Buffer utilities
--------------------------------------------------------------------------------

local BufferUtils = {}

-- Close all listed buffers and leave a single empty buffer active.
function BufferUtils.close_all()
    local bufs = vim.tbl_filter(
        function(b) return vim.bo[b].buflisted end,
        vim.api.nvim_list_bufs())
    vim.cmd('enew!')
    local enew_buf = vim.api.nvim_get_current_buf()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.tbl_contains(bufs, vim.api.nvim_win_get_buf(win)) then
            vim.api.nvim_win_set_buf(win, enew_buf)
        end
    end
    for _, buf in ipairs(bufs) do
        if buf ~= enew_buf and vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end
end

return BufferUtils
