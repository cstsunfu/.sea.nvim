local plugin = {}

plugin.core = {
    "git@github.com:eddiebergman/nvim-treesitter-pyfold.git",
    as = "nvim-treesitter-pyfold",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require('nvim-treesitter.configs').setup {
            pyfold = {
                enable = true,
                custom_foldtext = true -- Sets provided foldtext on window where module is active
            }
        }


    end,
}

plugin.mapping = function()

end

return plugin
