local plugin = {}

plugin.core = {
    "akinsho/org-bullets.nvim",
    as = "org-bullets",
    ft = { "org" },
    setup = function() -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("org-bullets").setup {
            symbols = { "", "", "✸", "✿", "" }
            ---- or a function that receives the defaults and returns a list
            --symbols = function(default_list)
            --table.insert(default_list, "♥")
            --return default_list
            --end
        }
        --vim.cmd("hi OrgHeadlineLevel1 guifg=#E37FFF")
        --vim.cmd("hi OrgHeadlineLevel2 guifg=#E37FFF")
        --vim.cmd("hi OrgHeadlineLevel3 guifg=#E37FFF")
        --vim.cmd("hi OrgHeadlineLevel4 guifg=#E37FFF")
        --vim.cmd("hi OrgHeadlineLevel5 guifg=#FC6262")

    end,
}

plugin.mapping = function()
end

return plugin
