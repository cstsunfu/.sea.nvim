local plugin = {}

plugin.core = {
    "git@github.com:cstsunfu/md-bullets.nvim.git",
    as = "md-bullets",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("md-bullets").setup {
            symbols = {"", "", "✸", "✿", ""}
                ---- or a function that receives the defaults and returns a list
                --symbols = function(default_list)
                    --table.insert(default_list, "♥")
                    --return default_list
                --end
        }
        vim.cmd("hi MdHeadlineLevel1 guifg=#7388de")
        vim.cmd("hi MdHeadlineLevel2 guifg=#7388de")
        vim.cmd("hi MdHeadlineLevel3 guifg=#7388de")
        vim.cmd("hi MdHeadlineLevel4 guifg=#7388de")
        vim.cmd("hi MdHeadlineLevel5 guifg=#a373FF")
    end,
}

plugin.mapping = function()
end

return plugin
