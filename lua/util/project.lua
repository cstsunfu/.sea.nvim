-- Project-name detection shared by the statusline and the pomodoro menu.
local M = {}

-- Markers that identify the top of a project. A caller can pass its own list
-- when it needs extra ones.
M.root_patterns = {
    ".git",
    "setup.py",
    "setup.cfg",
    "pyproject.toml",
    "requirements.txt",
    ".svn",
    ".root",
    ".project",
    ".hg",
    "__main__.py",
}

--- Name of the project that contains `dir` (default: the cwd).
---
--- Walks up from the directory until a root marker is found, stopping at
--- $HOME and "/". Installed python packages (`lib/pythonX.Y/site-packages`)
--- report the package name instead of the interpreter tree.
---@param dir? string
---@param patterns? string[]
---@return string|nil
M.name = function(dir, patterns)
    local Path = require("plenary.path")
    patterns = patterns or M.root_patterns

    local path = Path:new(dir or vim.fn.getcwd())
    local home_path = Path:new(vim.g.HOME_PATH)
    local root = Path:new("/")

    -- lib/python3.x/site-packages/<package>
    local split_path = {}
    local in_lib = false
    for _, value in pairs(path:_split()) do
        if value == "lib" then
            in_lib = true
        end
        if in_lib and value ~= nil and value ~= "" then
            table.insert(split_path, value)
        end
    end
    if #split_path >= 4 and string.find(split_path[2], "python") ~= nil and split_path[3] == "site-packages" then
        return split_path[4]
    end

    while path.filename ~= home_path.filename and path.filename ~= root.filename do
        for _, pattern in ipairs(patterns) do
            if path:joinpath(pattern):exists() then
                return path:_split()[#path:_split()]
            end
        end
        path = path:parent()
    end
    return nil
end

return M
