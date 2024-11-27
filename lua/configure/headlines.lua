local plugin = {}

plugin.core = {
    "lukas-reineke/headlines.nvim",
    ft = { "markdown", "vimwiki" },
    after = "nvim-treesitter",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("headlines").setup({
            markdown = {
                query = vim.treesitter.query.parse(
                    "markdown",
                    [[
                        (atx_heading [
                            (atx_h1_marker)
                            (atx_h2_marker)
                            (atx_h3_marker)
                            (atx_h4_marker)
                            (atx_h5_marker)
                            (atx_h6_marker)
                        ] @headline)

                        (thematic_break) @dash

                        (fenced_code_block) @codeblock

                        (block_quote_marker) @quote
                        (block_quote (paragraph (inline (block_continuation) @quote)))
                        (block_quote (paragraph (block_continuation) @quote))
                        (block_quote (block_continuation) @quote)
                    ]]
                ),
                headline_highlights = { "Headline" },
                bullet_highlights = {
                    "@text.title.1.marker.markdown",
                    "@text.title.2.marker.markdown",
                    "@text.title.3.marker.markdown",
                    "@text.title.4.marker.markdown",
                    "@text.title.5.marker.markdown",
                    "@text.title.6.marker.markdown",
                },
                bullets = { "◉", "○", "✸", "✿" },
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
            --org = {
            --    query = vim.treesitter.query.parse(
            --        "org",
            --        [[
            --    (headline (stars) @headline)

            --    (
            --    (expr) @dash
            --    (#match? @dash "^-----+$")
            --    )

            --    (block
            --    name: (expr) @_name
            --    (#eq? @_name "SRC")
            --    ) @codeblock

            --    (paragraph . (expr) @quote
            --    (#eq? @quote ">")
            --    )
            --    ]]
            --    ),
            --    headline_highlights = { "Headline" },
            --    codeblock_highlight = "CodeBlock",
            --    dash_highlight = "Dash",
            --    dash_string = "-",
            --    quote_highlight = "Quote",
            --    quote_string = "┃",
            --    fat_headlines = true,
            --    fat_headline_upper_string = "▃",
            --    fat_headline_lower_string = "▀",
            --},
        })
    end,
}

plugin.mapping = function() end

return plugin
