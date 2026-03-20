local plugin = {}

plugin.core = {
    "tanvirtin/vgit.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    -- Lazy loading on 'VimEnter' event is necessary.
    event = "VimEnter",
    config = function()
        require("vgit").setup()
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
end

return plugin
