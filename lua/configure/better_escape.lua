local plugin = {}

plugin.core = {
    "max397574/better-escape.nvim",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        -- lua, default settings
        require("better_escape").setup {
            timeout = vim.o.timeoutlen, -- after `timeout` passes, you can press the escape key and the plugin will ignore it
            default_mappings = false,   -- setting this to false removes all the default mappings
            mappings = {
                -- i for insert
                i = {
                    k = {
                        -- These can all also be functions
                        j = "<Esc>"
                    },
                },
                --c = {
                --    k = {
                --        j = "<C-c>",
                --    },
                --},
                t = {
                    k = {
                        j = "<C-\\><C-n>",
                    },
                },
                --v = {
                --    k = {
                --        j = "<Esc>",
                --    },
                --},
                s = {
                    k = {
                        j = "<Esc>",
                    },
                },
            },
        }
    end,
}

plugin.mapping = function() end

return plugin
