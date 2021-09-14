local plugin = {}

plugin.core = {
    "git@github.com:marko-cerovac/material.nvim.git",
    as = "material",
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
    vim.cmd("packadd material")
    if vim.g.theme == "light" then
        vim.g.material_style = 'ocean'
    elseif vim.g.theme == 'midium' then
        vim.g.material_style = 'palenight'
    else
        vim.g.material_style = 'darker'
    end
    vim.cmd("colorscheme material")
end

return plugin
