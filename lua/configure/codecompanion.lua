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
        -- Same environment knobs as the avante providers (see configure/avante.lua):
        -- AVANTE_ENDPOINT / AVANTE_MODEL / AVANTE_API_KEY_NAME.
        local endpoint = os.getenv("AVANTE_ENDPOINT") or "https://api.deepseek.com/v1"
        local base_url = endpoint:gsub("/v1/?$", "")
        local key_name = os.getenv("AVANTE_API_KEY_NAME") or "DEEPSEEK_API_KEY"

        require("codecompanion").setup({
            adapters = {
                http = {
                    openai_env = function()
                        return require("codecompanion.adapters").extend("openai_compatible", {
                            env = {
                                api_key = key_name,
                                chat_url = "/v1/chat/completions",
                                url = base_url,
                            },
                            schema = {
                                model = {
                                    default = os.getenv("AVANTE_MODEL") or "deepseek-chat",
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
                    adapter = "openai_env",
                },
                inline = {
                    adapter = "openai_env",
                },
            },
        })
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
end

return plugin
