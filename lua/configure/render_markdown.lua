local plugin = {}

-- Renders markdown files (headings, code blocks, tables, lists) in place.
-- Replaces headlines.nvim, which has been feature-frozen since 2024 and only
-- decorates headings.
plugin.core = {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },

    opts = {
        file_types = { "markdown" },

        -- core/default.lua flags huge buffers through enable_large_buf() and
        -- disables treesitter for them; rendering those (or a preview buffer)
        -- would undo that and stall the editor.
        max_file_size = 2.0, -- MB
        ignore = function(buf)
            return vim.b[buf].large_buf == true or vim.bo[buf].buftype ~= ""
        end,

        -- Render in insert/visual mode as well; otherwise entering either mode
        -- clears every decoration in the buffer. anti_conceal below still
        -- reveals the raw source on the cursor line.
        render_modes = { "n", "c", "t", "i", "v" },

        heading = {
            -- Block keeps the heading text compact; the background colour is
            -- left to the colourscheme so it does not fight the syntax.
            width = "block",
            backgrounds = {},
            border = false,
        },

        code = {
            width = "block",
            border = "thin",
            left_pad = 1,
            right_pad = 1,
        },

        bullet = {
            icons = { "●", "○", "◆", "◇" },
        },

        -- While editing, show the raw markdown on the line the cursor is on so
        -- the source stays editable instead of being replaced by decorations.
        anti_conceal = {
            enabled = true,
            above = 1,
            below = 1,
        },

        win_options = {
            conceallevel = { default = 2, rendered = 3 },
            concealcursor = { default = "", rendered = "nc" },
        },

        debounce = 100,
    },
}

plugin.mapping = function() end

return plugin
