local plugin = {}

plugin.core = {
    -- DO NOT USE IT IN VIM. USE IN TERMINAL INSTEAD
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
    },
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("telescope").load_extension("lazygit")
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
end

return plugin
