local plugin = {}

plugin.core = {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    build = "make",
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "echasnovski/mini.pick", -- for file_selector provider mini.pick
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
        "ibhagwan/fzf-lua", -- for file_selector provider fzf
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua", -- for providers='copilot'

        {
            -- Make sure to set this up properly if you have lazy=true
            "MeanderingProgrammer/render-markdown.nvim",
            opts = {
                --file_types = { "markdown", "Avante" },
                file_types = { "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },

    opts = {},

    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("avante_lib").load()
        require("avante").setup({
            -- add any opts here
            -- for example
            --provider = "openai",
            provider = "copilot",
            --auto_suggestions_provider = "openai",
            --cursor_applying_provider = "openai",
            providers = {
                copilot = {
                    endpoint = "https://api.githubcopilot.com",
                    model = "gpt-5.3-codex",
                    proxy = nil, -- [protocol://]host[:port] Use this proxy
                    allow_insecure = false, -- Allow insecure server connections
                    timeout = 30000, -- Timeout in milliseconds
                    context_window = 64000, -- Number of tokens to send to the model for context
                    --use_response_api = copilot_use_response_api, -- Automatically switch to Response API for GPT-5 Codex models
                    support_previous_response_id = false, -- Copilot doesn't support previous_response_id, must send full history
                    -- NOTE: Copilot doesn't support previous_response_id, always sends full conversation history including tool_calls
                    -- NOTE: Response API doesn't support some parameters like top_p, frequency_penalty, presence_penalty
                    extra_request_body = {
                        -- temperature is not supported by Response API for reasoning models
                        max_tokens = 20480,
                    },
                },
                openai = {
                    __inherited_from = "openai",
                    endpoint = os.getenv("AVANTE_ENDPOINT") or "http://llmapi.bilibili.co/v1",
                    model = os.getenv("AVANTE_MODEL") or "gemini-3.0-flash",
                    timeout = 30000, -- timeout in milliseconds
                    api_key_name = os.getenv("AVANTE_API_KEY_NAME") or "BSK_KEY",
                    disable_tools = false,
                    extra_request_body = {
                        max_tokens = 4096,
                        temperature = 0.7,
                        stream = true,
                    },
                },
            },
            behaviour = {
                auto_suggestions = false, -- Experimental stage
                auto_set_highlight_group = true,
                auto_set_keymaps = true,
                auto_apply_diff_after_generation = false,
                support_paste_from_clipboard = false,
                minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
                enable_token_counting = false, -- Whether to enable token counting. Default to true.
            },
            mappings = {
                --- @class AvanteConflictMappings
                diff = {
                    ours = "co",
                    theirs = "ct",
                    all_theirs = "ca",
                    both = "cb",
                    cursor = "cc",
                    next = "]x",
                    prev = "[x",
                },
                suggestion = {
                    accept = "¬",
                    next = "∆",
                    prev = "˚",
                    dismiss = "<C-]>",
                },
                jump = {
                    next = "]]",
                    prev = "[[",
                },
                submit = {
                    normal = "<CR>",
                    insert = "<CR>",
                },
                cancel = {
                    normal = { "<C-c>", "<Esc>", "q" },
                    insert = { "<C-c>" },
                },
                sidebar = {
                    apply_all = "A",
                    apply_cursor = "a",
                    retry_user_request = "r",
                    edit_user_request = "e",
                    switch_windows = "<Tab>",
                    reverse_switch_windows = "<S-Tab>",
                    remove_file = "d",
                    add_file = "@",
                    close = { "<Esc>", "q" },
                    --close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
                    close_from_input = { normal = { "<C-c>", "q" }, insert = "<C-c>" },
                },
            },
            selection = {
                enabled = false,
                hint_display = "delayed",
            },
            windows = {
                ---@type "right" | "left" | "top" | "bottom"
                position = "right", -- the position of the sidebar
                wrap = false, -- similar to vim.o.wrap
                width = 45, -- default % based on available width
                sidebar_header = {
                    enabled = false, -- true, false to enable/disable the header
                    align = "center", -- left, center, right for title
                    rounded = false,
                },
                input = {
                    prefix = "> ",
                    height = 8, -- Height of the input window in vertical layout
                },
                edit = {
                    border = "rounded",
                    start_insert = true, -- Start insert mode when opening the edit window
                },
                ask = {
                    floating = false, -- Open the 'AvanteAsk' prompt in a floating window
                    start_insert = true, -- Start insert mode when opening the ask window
                    border = "rounded",
                    ---@type "ours" | "theirs"
                    focus_on_apply = "ours", -- which diff to focus after applying
                },
            },
        })
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")

    -- get the avante window ids by the window config
    _G.navigate_avante_window = function()
        local ai_win_id = {
            input = nil,
            output = nil,
            file = nil,
            code = nil,
        }
        local windows = vim.api.nvim_list_wins()
        for _, win_id in ipairs(windows) do
            local buf_id = vim.api.nvim_win_get_buf(win_id)
            local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf_id })

            if filetype == "Avante" then
                ai_win_id.output = ai_win_id.output or win_id
            elseif filetype == "AvanteInput" then
                ai_win_id.input = ai_win_id.input or win_id
            elseif filetype == "AvanteSelectedFiles" then
                ai_win_id.file = ai_win_id.file or win_id
            end
        end
        return ai_win_id
    end

    _G.restart_avante = function()
        -- Use pcall to ignore error if Avante is not initialized (AvanteClear will fail)
        pcall(function()
            vim.cmd("AvanteClear")
        end)

        vim.cmd("AvanteRefresh")
        vim.cmd("AvanteFocus")

        -- wait for 200ms to ensure the window is ready
        vim.defer_fn(function()
            -- Send the initial prompt to set the language and response style
            vim.cmd(
                "AvanteAsk 注意: 你需要使用中文回答后续所有问题, 并且生成的代码使用google风格的英文注释. 对于本条消息只需要回答收到就可以."
            )

            -- Wait another bit to ensure the input window is focused
            vim.defer_fn(function()
                local ai_win_id = navigate_avante_window()
                if ai_win_id.input then
                    vim.api.nvim_set_current_win(ai_win_id.input)
                    vim.cmd("startinsert")
                end
            end, 200)
        end, 200)
    end

    mappings.register({
        mode = { "n" },
        key = { "<leader>", "a", "a" },
        action = ":AvanteToggle<cr>",
        short_desc = "AvanteToggle",
    })

    mappings.register({
        mode = { "n" },
        key = { "<leader>", "a", "i" },
        action = ":lua restart_avante()<cr>",
        short_desc = "AvanteRestart",
    })

    mappings.register({
        mode = { "n", "v" },
        key = { "<leader>", "a", "q" },
        action = ":AvanteAsk<cr>",
        short_desc = "AvanteAsk",
    })
end

return plugin
