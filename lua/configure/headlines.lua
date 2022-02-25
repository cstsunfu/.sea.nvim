local plugin = {}

plugin.core = {
    "lukas-reineke/headlines.nvim",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        --require("md-bullets").setup {
            --symbols = {"", "", "✸", "✿", ""}
                ------ or a function that receives the defaults and returns a list
                ----symbols = function(default_list)
                    ----table.insert(default_list, "♥")
                    ----return default_list
                ----end
        --}
        require("headlines").setup {
            markdown = {
                source_pattern_start = "^```",
                source_pattern_end = "^```$",
                dash_pattern = "^---+$",
                headline_pattern = "^#+",
                headline_highlights = { "Headline1", "Headline2"},
                codeblock_highlight = "CodeBlock",
                dash_highlight = "Dash",
                fat_headlines = true,
            },
            rmd = {
                source_pattern_start = "^```",
                source_pattern_end = "^```$",
                dash_pattern = "^---+$",
                headline_pattern = "^#+",
                headline_highlights = { "Headline1", "Headline2"},
                codeblock_sign = "CodeBlock",
                dash_highlight = "Dash",
                fat_headlines = true,
            },
            vimwiki = {
                source_pattern_start = "^{{{%a+",
                source_pattern_end = "^}}}$",
                dash_pattern = "^---+$",
                headline_pattern = "^=+",
                headline_highlights = { "Headline1", "Headline2"},
                codeblock_highlight = "CodeBlock",
                dash_highlight = "Dash",
                fat_headlines = true,
            },
            org = {
                source_pattern_start = "#%+[bB][eE][gG][iI][nN]_[sS][rR][cC]",
                source_pattern_end = "#%+[eE][nN][dD]_[sS][rR][cC]",
                dash_pattern = "^-----+$",
                headline_pattern = "^%*+",
                headline_highlights = { "Headline1", "Headline2"},
                codeblock_highlight = "CodeBlock",
                dash_highlight = "Dash",
                fat_headlines = true,
            },
        }
        vim.cmd [[highlight Headline1 guibg=#1e2718]]
        vim.cmd [[highlight Headline2 guibg=#21262d]]
        vim.cmd [[highlight CodeBlock guibg=#1c1c1c]]
        vim.cmd [[highlight Dash guibg=#D19A66 gui=bold]]
        --vim.cmd("hi MdHeadlineLevel1 guifg=#7388de")
        --vim.cmd("hi MdHeadlineLevel2 guifg=#7388de")
        --vim.cmd("hi MdHeadlineLevel3 guifg=#7388de")
        --vim.cmd("hi MdHeadlineLevel4 guifg=#7388de")
        --vim.cmd("hi MdHeadlineLevel5 guifg=#a373FF")
    end,
}

plugin.mapping = function()
end

return plugin
