
local plugin = {}

plugin.core = {
    "ray-x/navigator.lua",
    --as = "navigator",
    requires = {{"ray-x/guihua.lua", run = 'cd lua/fzy && make'}},


    setup = function()  -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require'navigator'.setup({
        })
    end,

}
plugin.mapping = function()

end
return plugin
