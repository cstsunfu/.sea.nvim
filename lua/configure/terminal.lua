local plugin = {}

plugin.core = {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("toggleterm").setup({
            -- size can be a number or function which is passed the current terminal
            size = function(term)
                if term.direction == "horizontal" then
                    return 20
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.5
                end
            end,
            highlights = {
                -- highlights which map to a highlight group name and a table of it's values
                -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
                --Normal = {
                --    guibg = "<VALUE-HERE>",
                --},
                NormalFloat = {
                    link = "DarkNormal",
                },
                FloatBorder = {
                    link = "TelescopePromptBorder",
                },
            },
            --open_mapping = [[<c-t>]],
            hide_numbers = true, -- hide the number column in toggleterm buffers
            shade_filetypes = {},
            shade_terminals = false,
            shading_factor = 2, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
            start_in_insert = true,
            insert_mappings = false, -- whether or not the open mapping applies in insert mode
            persist_size = true,
            --direction = 'vertical',
            direction = "float",
            close_on_exit = true, -- close the terminal window when the process exits
            shell = vim.o.shell, -- change the default shell
            -- This field is only relevant if direction is set to 'float'
            winbar = {
                enabled = false,
                name_formatter = function(term) --  term: Terminal
                    return term.name
                end,
            },
        })
        --vim.api.nvim_exec([[
        --    let g:toggleterm_terminal_mapping = '<C-t>'
        --    autocmd TermEnter term://*toggleterm#* tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
        --    nnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
        --    inoremap <silent><c-t> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>
        --]], false)
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    --function _G.set_terminal_keymaps()
    --    local opts = { noremap = true }
    --    vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
    --    vim.api.nvim_buf_set_keymap(0, "t", "kj", [[<C-\><C-n>]], opts)
    --end
    --vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

    vim.g._recent_terminal_id = 0
    function _G._terminal_send_selection(visual)
        local id = vim.g._recent_terminal_id
        if id == 0 then
            vim.notify("No Terminal Opened")
            return
        end
        if visual then
            vim.cmd("ToggleTermSendVisualLines " .. id)
        else
            vim.cmd("ToggleTermSendCurrentLine " .. id)
        end
    end
    mappings.register({
        mode = { "v" },
        key = { "<C-s>" },
        action = ":lua _G._terminal_send_selection(true)<cr>",
        short_desc = "Send Select Text to First Terminal",
    })
    mappings.register({
        mode = { "n" },
        key = { "<C-s>" },
        action = ":lua _G._terminal_send_selection(false)<cr>",
        short_desc = "Send Current Line to First Terminal",
    })

    local terminal = require("toggleterm.terminal").Terminal
    vim.g._side_terminal_opened = false
    -- Side Terminal
    local side_terminal = terminal:new({
        direction = "vertical",
        close_on_exit = true,
        id = 6,
        -- function to run on opening the terminal
        on_open = function(term)
            vim.cmd("startinsert!")
        end,
        -- function to run on closing the terminal
        on_close = function(term)
            vim.cmd("stopinsert!")
        end,
    })
    vim.g._side_terminal_opened = false
    function _G._side_terminal_toggle()
        side_terminal:toggle()
        if vim.g._side_terminal_opened == false then
            vim.g._recent_terminal_id = 6
            vim.g._side_terminal_opened = true
        else
            vim.g._side_terminal_opened = false
        end
    end
    mappings.register({
        mode = { "n", "t", "i" },
        key = { "<C-\\>" },
        silent = true,
        action = "<C-\\><C-n>:lua _G._side_terminal_toggle()<cr>",
        short_desc = "Side Terminal",
    })

    -- IPython Terminal
    vim.g._ipython_terminal_opened = false
    local ipython = terminal:new({
        cmd = "ipython",
        direction = "vertical",
        close_on_exit = false,
        id = 8,
        -- function to run on opening the terminal
        on_open = function(term)
            vim.cmd("stopinsert!")
            --vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
        end,
        -- function to run on closing the terminal
        on_close = function(term)
            vim.cmd("stopinsert!")
        end,
    })
    function _G._ipython_terminal_toggle()
        ipython:toggle()
        if vim.g._ipython_terminal_opened == false then
            vim.g._recent_terminal_id = 8
            vim.g._ipython_terminal_opened = true
        else
            vim.g._ipython_terminal_opened = false
        end
    end

    mappings.register({
        mode = { "n", "t", "i" },
        key = { "<leader>", "t", "i" },
        silent = true,
        action = "<C-\\><C-n>:lua _G._ipython_terminal_toggle()<cr>",
        short_desc = "Terminal IPython",
    })

    -- Float Terminal
    local floatterm = terminal:new({
        direction = "float",
        id = 1,
        close_on_exit = false,
        -- function to run on opening the terminal
        on_open = function(term)
            vim.cmd("startinsert!")
        end,
        float_opts = {
            -- The border key is *almost* the same as 'nvim_open_win'
            -- see :h nvim_open_win for details on borders however
            -- the 'curved' border is a custom border type
            -- not natively supported but implemented in this plugin.
            border = "rounded",
            -- like `size`, width and height can be a number or function which is passed the current terminal
            width = math.floor(vim.o.columns * 0.7),
            height = math.floor(vim.o.lines * 0.7),
            winblend = 0,
            --zindex = <value>,
        },
        -- function to run on closing the terminal
        on_close = function(term) end,
    })
    function _G._float_terminal_toggle()
        floatterm:toggle()
    end

    local lazygit = terminal:new({
        cmd = "lazygit",
        hidden = true,
        float_opts = {
            -- The border key is *almost* the same as 'nvim_open_win'
            -- see :h nvim_open_win for details on borders however
            -- the 'curved' border is a custom border type
            -- not natively supported but implemented in this plugin.
            border = "rounded",
            -- like `size`, width and height can be a number or function which is passed the current terminal
            width = math.floor(vim.o.columns * 0.90),
            height = math.floor(vim.o.lines * 0.90),
            winblend = 0,
            --zindex = <value>,
        },
    })

    function _G._lazygit_toggle()
        lazygit:toggle()
    end

    mappings.register({
        mode = { "n" },
        key = { "<C-g>" },
        action = ":lua _G._lazygit_toggle()<cr>",
        silent = true,
        short_desc = "Float Terminal",
    })

    mappings.register({
        mode = { "n" },
        key = { "<C-t>" },
        action = ":lua _G._float_terminal_toggle()<cr>",
        silent = true,
        short_desc = "Float Terminal",
    })
    mappings.register({
        mode = { "t" },
        key = { "<C-t>" },
        silent = true,
        action = "<C-\\><C-n>:lua _G._float_terminal_toggle()<cr>",
        short_desc = "Float Terminal",
    })
end
return plugin
