local M = {}
M.loaded = {}

M.setup = function(modules)
    for name, config in pairs(modules) do
        require("hack." .. name).setup(config)
        M.loaded[#M.loaded + 1] = name
    end
end

M.create_mapping = function()
    for _, name in ipairs(M.loaded) do
        require("hack." .. name).create_mapping()
    end
end

return M
