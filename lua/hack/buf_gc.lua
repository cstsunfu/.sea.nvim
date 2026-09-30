-- Wipe orphaned scratch buffers leaked by plugins.
--
-- nvim-notify creates a scratch buffer per notification before rendering it.
-- If rendering throws (e.g. E849 once highlight groups are exhausted), the
-- buffer is never deleted. bufferline calls getbufinfo() on every tabline
-- redraw, so cost grows with the number of leaked buffers.
local M = {}

-- Only act when the leak is clearly happening; healthy instances have ~0.
M.threshold = 50

-- Matches buffers created by nvim_create_buf(false, true) and never used:
-- unlisted, unnamed, nofile, no filetype, empty, untouched, not in any window.
local function is_orphan(buf)
    local bo = vim.bo[buf]
    return not bo.buflisted
        and bo.buftype == "nofile"
        and bo.filetype == ""
        and not bo.modified
        and vim.b[buf].changedtick <= 2
        and vim.api.nvim_buf_get_name(buf) == ""
        and vim.api.nvim_buf_line_count(buf) == 1
        and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == ""
        and #vim.fn.win_findbuf(buf) == 0
end

---@param force boolean? ignore the threshold
---@return integer wiped
function M.collect(force)
    local orphans = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if is_orphan(buf) then
            orphans[#orphans + 1] = buf
        end
    end
    if not force and #orphans < M.threshold then
        return 0
    end
    local wiped = 0
    for _, buf in ipairs(orphans) do
        if pcall(vim.api.nvim_buf_delete, buf, { force = true }) then
            wiped = wiped + 1
        end
    end
    return wiped
end

M.setup = function(config)
    for name, val in pairs(config or {}) do
        M[name] = val
    end
    -- Run when the instance goes idle; stays silent because notifications
    -- themselves are what leak buffers.
    vim.api.nvim_create_autocmd("FocusLost", {
        group = vim.api.nvim_create_augroup("hack_buf_gc", { clear = true }),
        callback = function()
            M.collect(false)
        end,
    })
    vim.api.nvim_create_user_command("BufGc", function()
        print(string.format("BufGc: wiped %d orphaned scratch buffers", M.collect(true)))
    end, { desc = "Wipe leaked empty scratch buffers" })
end

M.create_mapping = function() end

return M
