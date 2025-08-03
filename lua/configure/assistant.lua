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
        "echasnovski/mini.pick",         -- for file_selector provider mini.pick
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
        "ibhagwan/fzf-lua",              -- for file_selector provider fzf
        "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua",        -- for providers='copilot'
        --{
        --    -- Make sure to set this up properly if you have lazy=true
        --    'MeanderingProgrammer/render-markdown.nvim',
        --    event = "VeryLazy",
        --    opts = {
        --        file_types = { "Avante" },
        --    },
        --    ft = { "Avante" },
        --},
    },

    opts = {
    },

    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require('avante_lib').load()
        require('avante').setup(
            {
                -- add any opts here
                -- for example
                provider = "openai",
                auto_suggestions_provider = 'openai',
                cursor_applying_provider = 'openai',
                openai = {
                    --endpoint = os.getenv("CODE_ASSISTANT_ENDPOINT"),
                    --model = os.getenv("CODE_ASSISTANT_MODEL"), -- your desired model (or use gpt-4o, etc.)
                    endpoint = "http://10.156.33.31:8000/v1",
                    model = "/workspace/Qwen2.5-Coder-32B-Instruct", -- your desired model (or use gpt-4o, etc.)
                    timeout = 30000,                                 -- timeout in milliseconds
                    disable_tools = true,
                    temperature = 0.5,                               -- adjust if needed
                    proxy = "socks5://10.157.82.18:1080",
                    max_tokens = 4096,
                },
                behaviour = {
                    auto_suggestions = false, -- Experimental stage
                    auto_set_highlight_group = true,
                    auto_set_keymaps = true,
                    auto_apply_diff_after_generation = false,
                    support_paste_from_clipboard = false,
                    minimize_diff = true,                        -- Whether to remove unchanged lines when applying a code block
                    enable_token_counting = false,               -- Whether to enable token counting. Default to true.
                    enable_cursor_planning_mode = false,         -- Whether to enable Cursor Planning Mode. Default to false.
                    enable_claude_text_editor_tool_mode = false, -- Whether to enable Claude Text Editor Tool Mode.
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
                        insert = "<CR>"
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
                        close_from_input = { normal = { "<C-c>", "q" }, insert = "<C-c>" }
                    },
                },
                hints = { enabled = false },
                windows = {
                    ---@type "right" | "left" | "top" | "bottom"
                    position = "right",   -- the position of the sidebar
                    wrap = true,          -- similar to vim.o.wrap
                    width = 40,           -- default % based on available width
                    sidebar_header = {
                        enabled = false,  -- true, false to enable/disable the header
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
                        floating = false,    -- Open the 'AvanteAsk' prompt in a floating window
                        start_insert = true, -- Start insert mode when opening the ask window
                        border = "rounded",
                        ---@type "ours" | "theirs"
                        focus_on_apply = "ours", -- which diff to focus after applying
                    },
                },
            }

        )
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
            local win_config = vim.api.nvim_win_get_config(win_id)
            if
                win_config ~= nil
                and win_config["relative"] == ""
                and win_config["focusable"] == true
                and win_config["split"] ~= "left"
            then
                local buf_id = vim.api.nvim_win_get_buf(win_id)
                local buftype = vim.api.nvim_buf_get_option(buf_id, "buftype")
                local filetype = vim.api.nvim_buf_get_option(buf_id, "filetype")
                if filetype == "Avante" and buftype == 'nofile' then
                    ai_win_id["output"] = win_id
                elseif filetype == "AvanteInput" and buftype == 'nofile' then
                    ai_win_id["input"] = win_id
                elseif filetype == "AvanteSelectedFiles" and buftype == "nofile" then
                    ai_win_id["file"] = win_id
                end
            end
        end
        return ai_win_id
    end

    _G.restart_avante = function()
        vim.cmd("AvanteClear")
        vim.cmd("AvanteRefresh")
        vim.cmd("AvanteClear")
        vim.cmd("AvanteFocus")
        vim.cmd("AvanteAsk 注意: 你需要使用中文回答后续所有问题, 并且生成的代码使用英文注释. 只需要回答收到就可以.")
        -- wait for 1 second by schedule
        vim.defer_fn(function()
            local ai_win_id = navigate_avante_window()
            if ai_win_id["input"] ~= nil then
                vim.api.nvim_set_current_win(ai_win_id["input"])
                -- start insert mode
                vim.api.nvim_command('startinsert')
            end
        end, 200)
    end

    _G.toggle_avante = function()
        local ai_win_id = navigate_avante_window()
        if ai_win_id["output"] == nil then
            vim.cmd("AvanteFocus")
        else
            vim.cmd("AvanteFocus")
            vim.cmd("AvanteToggle")
        end
    end


    mappings.register({
        mode = { "n" },
        key = { "<leader>", "a", "a" },
        action = ":lua toggle_avante()<cr>",
        short_desc = "AvanteToggle",
    })

    mappings.register({
        mode = { "n" },
        key = { "<leader>", "a", "i" },
        action = ":lua restart_avante()<cr>",
        short_desc = "AvanteRestart",
    })
end

return plugin
