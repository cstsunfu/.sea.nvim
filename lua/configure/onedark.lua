local plugin = {}

plugin.core = {
    "navarasu/onedark.nvim",
    as = 'onedark',
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
    vim.cmd("packadd onedark")
    local onedark = require('onedark')
    if vim.g.theme == "light" then
        onedark.setup({
          style = 'light'
        })
    else
        onedark.setup({
          style = 'light', -- Or
        })
    end
    onedark.load()
    local timer = vim.loop.new_timer()
    timer:start(500, 0, vim.schedule_wrap(function()
        vim.cmd("hi! default link NormalFloat Pmenu")
    end))
end

return plugin
