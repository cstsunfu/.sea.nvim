local plugin = {}

plugin.core = {
    'shaunsingh/nord.nvim',

    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded

    end,
}

plugin.mapping = function()

end

plugin.light = {

}

plugin.dark = {

}
plugin.setup = function (theme)
    vim.cmd("packadd nord.nvim")
    if theme == "light" then
        require('nord').set()
    else
        require('nord').set()
    end
end
return plugin
