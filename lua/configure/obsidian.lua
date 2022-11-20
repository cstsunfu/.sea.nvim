local plugin = {}

plugin.core = {
    "epwalsh/obsidian.nvim",
    setup = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("obsidian").setup({
            dir = "~/MyKB",
            completion = {
                nvim_cmp = true, -- if using nvim-cmp, otherwise set to false
            },
            notes_subdir = "Draft",
            note_frontmatter_func = nil, -- disable note note_frontmatter_func
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
                return tostring(os.date("%Y%m%d%H%M")) .. " " .. suffix
            end
        })
    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = { "<leader>", 'f', 'o' },
        action = ":ObsidianSearch<cr>",
        short_desc = "ObsidianSearch"
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", 'o', 'n' },
        action = ":ObsidianNew ",
        short_desc = "New Draft Obsidian",
        silent = false,
    })
end

return plugin
