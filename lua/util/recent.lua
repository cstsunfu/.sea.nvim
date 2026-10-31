-- "Recently used files" helpers built on telescope-frecency.
--
-- frecency keeps its database in $XDG_STATE_HOME/nvim (file_frecency*.bin), so
-- every Neovim instance on the machine writes to the same list, regardless of
-- tmux session or project, and instances reload it when the file changes.
local M = {}

--- Paths from the frecency database, most recently used first.
--- Entries that no longer exist on disk are dropped: frecency only prunes them
--- when its database check runs, and stale paths make the grep picker noisy.
---@param opts? { limit?: integer, root?: string } root: only paths under this dir
---@return string[]
M.files = function(opts)
    opts = opts or {}
    local ok, frecency = pcall(function()
        return require("telescope").extensions.frecency
    end)
    if not ok or not frecency then
        return {}
    end

    local data = { limit = opts.limit or 500, order = "score" }
    if opts.root then
        data.workspace = opts.root
    end
    local queried, paths = pcall(frecency.query, data)
    if not queried or type(paths) ~= "table" then
        return {}
    end

    local result = {}
    for _, path in ipairs(paths) do
        if type(path) == "string" and vim.fn.filereadable(path) == 1 then
            table.insert(result, path)
        end
    end
    return result
end

--- Live grep restricted to the most recently used files.
--- Falls back to a project-wide grep when there is nothing to search yet,
--- instead of letting ripgrep walk the whole directory tree by itself.
---@param opts? { limit?: integer, root?: string }
M.grep = function(opts)
    opts = opts or {}
    local files = M.files(opts)
    if #files == 0 then
        vim.notify("No recent files yet, searching the project instead", vim.log.levels.INFO, { title = "Recent" })
        return require("telescope.builtin").live_grep({ cwd = opts.root })
    end

    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local make_entry = require("telescope.make_entry")
    local conf = require("telescope.config").values
    local highlighter_only = require("telescope.sorters").highlighter_only

    pickers
        .new({}, {
            prompt_title = ("Recent files (%d)"):format(#files),
            finder = finders.new_job(function(prompt)
                if not prompt or prompt == "" then
                    return nil
                end
                local cmd = vim.deepcopy(conf.vimgrep_arguments)
                vim.list_extend(cmd, { "--no-messages", "--", prompt })
                vim.list_extend(cmd, files)
                return cmd
            end, make_entry.gen_from_vimgrep({}), 1000, vim.fn.getcwd()),
            previewer = conf.grep_previewer({}),
            sorter = highlighter_only({}),
        })
        :find()
end

return M
