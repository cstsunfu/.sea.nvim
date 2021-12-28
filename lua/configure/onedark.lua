local plugin = {}

plugin.core = {
    "git@github.com:olimorris/onedark.nvim.git",
    as = "onedark.nvim",
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
    vim.cmd("packadd onedark.nvim")
    local onedark = require('onedark')
    if vim.g.theme == "light" then
        onedark.setup({
          theme = 'onelight'
        })
    else
        onedark.setup({
          theme = 'onedark', -- Or
        })
    end
    onedark.load()
    local timer = vim.loop.new_timer()
    timer:start(500, 0, vim.schedule_wrap(function()
        vim.cmd("hi! default link NormalFloat Pmenu")
    end))
end

return plugin
