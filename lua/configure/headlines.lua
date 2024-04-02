local plugin = {}

plugin.core = {
    "lukas-reineke/headlines.nvim",
    ft = { "markdown", "vimwiki", "org" },
    after = "nvim-treesitter",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("headlines").setup({
            markdown = {
                query = vim.treesitter.query.parse(
                    --(atx_heading [
                    --(atx_h1_marker)
                    --(atx_h2_marker)
                    --] @headline)
                    "markdown",
                    [[

                (thematic_break) @dash


                (block_quote_marker) @quote
                (block_quote (paragraph (inline (block_continuation) @quote)))
                ]]
                ),
                --(fenced_code_block) @codeblock -- ignore the code block highlight
                headline_highlights = { "Headline" },
                codeblock_highlight = "CodeBlock",
                dash_highlight = "Dash",
                dash_string = "▔", --  󰝔 upper quarter block/ eight block
                --__', '▁▁', '▂▂', '▃▃', '▄▄', '▅▅', '▆▆', '▇▇', '██
                quote_highlight = "Quote",
                quote_string = "┃",
                fat_headlines = true,
                fat_headline_upper_string = "▃",
                fat_headline_lower_string = "▀",
            },
            org = {
                query = vim.treesitter.query.parse(
                    "org",
                    [[
                (headline (stars) @headline)

                (
                (expr) @dash
                (#match? @dash "^-----+$")
                )

                (block
                name: (expr) @_name
                (#eq? @_name "SRC")
                ) @codeblock

                (paragraph . (expr) @quote
                (#eq? @quote ">")
                )
                ]]
                ),
                headline_highlights = { "Headline" },
                codeblock_highlight = "CodeBlock",
                dash_highlight = "Dash",
                dash_string = "-",
                quote_highlight = "Quote",
                quote_string = "┃",
                fat_headlines = true,
                fat_headline_upper_string = "▃",
                fat_headline_lower_string = "▀",
            },
        })
    end,
}

plugin.mapping = function() end

return plugin
