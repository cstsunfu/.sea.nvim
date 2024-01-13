local plugin = {}

plugin.core = {
    "mg979/vim-visual-multi",
    event = "BufEnter",
    init = function() -- Specifies code to run before this plugin is loaded.
        vim.g.VM_default_mappings = 0
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        vim.g.VM_default_mappings = 0
    end,
}

plugin.mapping = function() end
return plugin
