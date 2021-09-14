local plugin = {}

plugin.core = {
    "git@github.com:shaunsingh/nord.nvim.git",
    as = "nord",

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
    vim.cmd("packadd nord")
    if theme == "light" then
        require('nord').set()
    else
        require('nord').set()
    end
    local timer = vim.loop.new_timer()
    timer:start(500, 0, vim.schedule_wrap(function()
        vim.cmd("hi! default link NormalFloat Pmenu")
    end))
end
return plugin
