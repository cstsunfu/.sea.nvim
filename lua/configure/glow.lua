local plugin = {}

plugin.core = {

    "ellisonleao/glow.nvim",
    cmd = { "Glow" }, -- should install glow binary like `brew install glow`

    init = function() -- Specifies code to run before this plugin is loaded.
        local style = nil
        if vim.g.style == "light" then
            style = "light"
        else
            style = "dark"
        end
        require("glow").setup({
            style = style,
            border = "rounded",
            width = vim.fn.winwidth(0),
        })
    end,

    config = function() -- Specifies code to run after this plugin is loaded
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    mappings.register({
        mode = "n",
        key = { "<leader>", "m", "t" },
        action = ":Glow<cr>:resize +1000<cr>:vertical resize +1000<cr>",
        short_desc = "Glow Markdown Preview",
        silent = true,
    })
end
return plugin
