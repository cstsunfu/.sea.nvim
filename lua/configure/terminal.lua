local plugin = {}

plugin.core = {
    "akinsho/toggleterm.nvim",
    init = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("toggleterm").setup{
            -- size can be a number or function which is passed the current terminal
            size = function(term)
                if term.direction == "horizontal" then
                    return 20
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.5
                end
            end,
            open_mapping = [[<c-\>]],
            hide_numbers = true, -- hide the number column in toggleterm buffers
            shade_filetypes = {},
            shade_terminals = false,
            shading_factor = 2, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
            start_in_insert = true,
            insert_mappings = false, -- whether or not the open mapping applies in insert mode
            persist_size = true,
            direction = 'vertical',
            close_on_exit = true, -- close the terminal window when the process exits
            shell = vim.o.shell, -- change the default shell
            -- This field is only relevant if direction is set to 'float'
        }
        vim.api.nvim_exec([[
            let g:toggleterm_terminal_mapping = '<C-t>'
            autocmd TermEnter term://*toggleterm#* tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
            nnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
            inoremap <silent><c-t> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>
        ]], false)
    end,

}

plugin.mapping = function()
    local mappings = require('core.mapping')
    function _G.set_terminal_keymaps()
        local opts = {noremap = true}
        vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', 'kj', [[<C-\><C-n>]], opts)
    end
    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

    mappings.register({
        mode = {"t"},
        key = { '<esc>' },
        action = nil,
        short_desc = "Back to Normal Mode"
    })
    mappings.register({
        mode = {"t"},
        key = { 'k', 'j' },
        action = nil,
        short_desc = "Back to Normal Mode"
    })
    mappings.register({
        mode = {"v", 'x'},
        key = { '<C-s>' },
        action = ":ToggleTermSendVisualSelection<cr>",
        short_desc = "Send Select Text to First Termianl"
    })
    mappings.register({
        mode = {"n"},
        key = { '<C-s>' },
        action = ":ToggleTermSendCurrentLine<cr>",
        short_desc = "Send Current Line to First Termianl"
    })


    function _G._ipython_terminal_toggle()
        local Terminal  = require('toggleterm.terminal').Terminal
        local ipython = Terminal:new({
          cmd = "ipython",
          --dir = "git_dir",
          direction = "vertical",
          close_on_exit = false,
          -- function to run on opening the terminal
          on_open = function(term)
            vim.cmd("startinsert!")
            --vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
          end,
          -- function to run on closing the terminal
          on_close = function(term)
            vim.cmd("startinsert!")
          end,
        })
        ipython:toggle()
    end

    mappings.register({
        mode = {"n"},
        key = { '<leader>', 't', 'i' },
        action = ":lua _G._ipython_terminal_toggle()<cr>",
        short_desc = "Terminal IPython"
    })
end
return plugin
