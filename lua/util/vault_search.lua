-- Fuzzy search over Obsidian note names *and* note contents.
--
-- telescope's find_files only lists files and live_grep only greps contents.
-- Here both are fed into one dynamic finder: every markdown file of the vault
-- (fuzzy matched on its path by the sorter) plus the ripgrep content matches
-- for the current query, so one prompt finds "qwen" by file name or by text.

local M = {}

-- Single source of truth for the vault, also used by lua/configure/obsidian.lua.
M.vault = "~/MyKB"

local function vault_dir()
    return (vim.fn.expand(M.vault):gsub("/+$", ""))
end

local function vault_relative(path)
    return (path:gsub("^" .. vim.pesc(vault_dir() .. "/"), ""))
end

-- Every markdown file in the vault, as absolute paths.
local function list_files()
    local ok, lines = pcall(vim.fn.systemlist, {
        "rg", "--no-config", "--type=md", "--files", "--color=never", vault_dir(),
    })
    if not ok then
        return {}
    end
    return lines
end

-- ripgrep content matches for `query`, as `path:line:col:text` lines.
local function grep_content(query)
    if query == "" then
        return {}
    end
    local ok, lines = pcall(vim.fn.systemlist, {
        "rg", "--no-config", "--type=md", "--fixed-strings", "--smart-case",
        "--column", "--line-number", "--no-heading", "--with-filename",
        "--color=never", "--max-count=5", "--", query, vault_dir(),
    })
    if not ok then
        return {}
    end
    return lines
end

local function make_entry(entry)
    local path, lnum, col, text = entry:match("^(.-):(%d+):(%d+):(.*)$")
    if path and path:sub(1, 1) == "/" then
        local rel = vault_relative(path)
        return {
            value = entry,
            display = rel .. ":" .. lnum .. ":" .. text,
            ordinal = rel .. " " .. text,
            filename = path,
            lnum = tonumber(lnum),
            col = tonumber(col),
        }
    end
    return {
        value = entry,
        display = vault_relative(entry),
        ordinal = vault_relative(entry),
        filename = entry,
        lnum = 1,
    }
end

function M.pick()
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values

    local files = list_files()

    pickers.new({}, {
        prompt_title = "Notes (name + content)",
        finder = finders.new_dynamic({
            fn = function(prompt)
                return vim.list_extend(vim.deepcopy(files), grep_content(prompt))
            end,
            entry_maker = make_entry,
        }),
        sorter = conf.generic_sorter({}),
        previewer = conf.grep_previewer({}),
    }):find()
end

return M
