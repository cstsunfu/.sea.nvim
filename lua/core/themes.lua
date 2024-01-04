-- there are some my favor colorschemes
local themes = {}
themes["configs"] = {
    one_light = {
        colorscheme = "onedarkpro",
        style = "light",
        name = "one_light",
    },
    gruvbox_dark = {
        colorscheme = "gruvbox_material",
        style = "dark",
        name = "gruvbox_dark",
    },
    gruvbox_light = {
        colorscheme = "gruvbox_material",
        style = "light",
        name = "gruvbox_light",
    },
    nord = {
        colorscheme = "nord",
        style = "dark",
        name = "nord",
    },
    material_light = {
        colorscheme = "material",
        style = "light",
        name = "material_light",
    },
    material_oceanic = {
        colorscheme = "material",
        style = "oceanic",
        name = "material_oceanic",
    },
    material_palenight = {
        colorscheme = "material",
        style = "palenight",
        name = "material_palenight",
    },
    material_deep_ocean = {
        colorscheme = "material",
        style = "deep ocean",
        name = "material_deep_ocean",
    },
    material_dark = {
        colorscheme = "material",
        style = "dark",
        name = "material_dark",
    },
    vscode_dark = { -- use material_dark
        colorscheme = "vscode_theme",
        style = "dark",
        name = "vscode_dark",
    },
}

themes["setting"] = function(theme_config)
    vim.g.colorscheme_name = theme_config.name
    vim.g.colorscheme = theme_config.colorscheme
    vim.g.style = theme_config.style
end

return themes
