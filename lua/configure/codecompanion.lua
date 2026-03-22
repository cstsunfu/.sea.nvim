local plugin = {}

plugin.core = {
    "olimorris/codecompanion.nvim",
    --version = "^18.7.0",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    event = "CmdlineEnter",

    config = function() -- Specifies code to run after this plugin is loaded
        require("codecompanion").setup({
            adapters = {
                http = {
                    openai_bsk = function()
                        return require("codecompanion.adapters").extend("openai_compatible", {
                            env = {
                                api_key = "BSK_KEY",
                                chat_url = "/v1/chat/completions",
                                url = "http://llmapi.bilibili.co",
                            },
                            schema = {
                                model = {
                                    default = "gemini-3.0-flash",
                                },
                            },
                        })
                    end,
                    opts = {
                        allow_insecure = true,
                        --proxy = "socks5://127.0.0.1:9999",
                    },
                },
            },
            interactions = {
                chat = {
                    adapter = "openai_bsk",
                },
                inline = {
                    adapter = "openai_bsk",
                },
            },
        })
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
end

return plugin
