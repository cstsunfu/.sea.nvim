local plugin = {}

plugin.core = {
    "kyazdani42/nvim-web-devicons",
    --opt = true,
    setup = function()  -- Specifies code to run before this plugin is loaded.
    end,
    config = function() -- Specifies code to run after this plugin is loaded
        --require'nvim-web-devicons'.setup {
            ---- your personnal icons can go here (to override)
            ---- you can specify color or cterm_color instead of specifying both of them
            ---- DevIcon will be appended to `name`
            --override = {
                --["py"] = {
                    --icon = "!",
                    --color = "#ffbc03",
                    --cterm_color = "61",
                    --name = "Py",
                --},
            --};
            ---- globally enable default icons (default to false)
            ---- will get overriden by `get_icons` option
            --default = false;
        --}
    end,

}
plugin.mapping = function()
    local mappings = require('core.mapping')

end
return plugin
