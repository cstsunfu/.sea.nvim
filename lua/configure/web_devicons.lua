local plugin = {}

plugin.core = {
    "kyazdani42/nvim-web-devicons",
    --opt = true,
    setup = function()  -- Specifies code to run before this plugin is loaded.
    end,
    config = function() -- Specifies code to run after this plugin is loaded
    end,

}
plugin.mapping = function()
    local mappings = require('core.mapping')

end
return plugin
