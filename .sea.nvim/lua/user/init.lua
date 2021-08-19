local M = {}

M.setup = function(modules)
    for name,config in pairs(modules) do
        M[name] = require('user.'..name).setup(config)
    end

end

return M
