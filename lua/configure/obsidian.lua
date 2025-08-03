local plugin = {}

plugin.core = {
    "epwalsh/obsidian.nvim",
    ft = { "vimwiki", "markdown" },
    cmd = { "ObsidianNew", "ObsidianSearch", "ObsidianToday", "ObsidianDailies" },
    dependencies = {
        -- Required.
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
        -- see below for full list of optional dependencies 👇
    },
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("obsidian").setup({
            dir = "~/MyKB",
            new_notes_location = "current_dir",
            completion = {
                -- If using nvim-cmp, otherwise set to false
                nvim_cmp = true,
                -- Trigger completion at 1 chars
                min_chars = 1,
            },
            notes_subdir = "Draft",
            --note_frontmatter_func = nil, -- disable note note_frontmatter_func
            disable_frontmatter = true, -- disable note note_frontmatter_func
            -- Optional, key mappings.
            mappings = {
                -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
                --["gf"] = require("obsidian.mapping").gf_passthrough(),
            },
            note_id_func = function(title)
                -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
                local suffix = ""
                if title ~= nil then
                    -- If title is given, transform it into valid file name.
                    suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
                else
                    -- If title is nil, just add 4 random uppercase letters to the suffix.
                    for _ in 1, 4 do
                        suffix = suffix .. string.char(math.random(65, 90))
                    end
                end
                return tostring(os.date("%y%m%d")) .. "_" .. suffix
            end,
            -- Optional, customize how wiki links are formatted. You can set this to one of:
            --  * "use_alias_only", e.g. '[[Foo Bar]]'
            --  * "prepend_note_id", e.g. '[[foo-bar|Foo Bar]]'
            --  * "prepend_note_path", e.g. '[[foo-bar.md|Foo Bar]]'
            --  * "use_path_only", e.g. '[[foo-bar.md]]'
            -- Or you can set it to a function that takes a table of options and returns a string, like this:
            wiki_link_func = function(opts)
                return require("obsidian.util").wiki_link_id_prefix(opts)
            end,

            -- Optional, customize how markdown links are formatted.
            markdown_link_func = function(opts)
                return require("obsidian.util").markdown_link(opts)
            end,

            -- Either 'wiki' or 'markdown'.
            preferred_link_style = "wiki",
            -- Specify how to handle attachments.
            attachments = {
                -- The default folder to place images in via `:ObsidianPasteImg`.
                -- If this is a relative path it will be interpreted as relative to the vault root.
                -- You can always override this per image by passing a full path to the command instead of just a filename.
                img_folder = "Images" -- This is the default

            }
        })
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    mappings.register({
        mode = "n",
        key = { "<leader>", "f", "o" },
        action = ":ObsidianSearch<cr>",
        short_desc = "ObsidianSearch",
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "n" },
        action = ":ObsidianNew ",
        short_desc = "New Draft Obsidian",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "a" },
        action = ":ObsidianToday<CR>",
        short_desc = "Obsidian Today ",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "d" },
        action = ":ObsidianDailies<CR>",
        short_desc = "Obsidian Daily List",
        silent = false,
    })
end

return plugin
