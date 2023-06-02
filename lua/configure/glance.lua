local plugin = {}

plugin.core = {
    "dnlhc/glance.nvim",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        local glance = require('glance')
        local actions = glance.actions
        glance.setup({
            height = 18, -- Height of the window
            zindex = 45,
            border = {
                enable = true, -- Show window borders. Only horizontal borders allowed
                top_char = '―',
                bottom_char = '―',
            },
            list = {
                position = 'right', -- Position of the list window 'left'|'right'
                width = 0.33, -- 33% width relative to the active window, min 0.1, max 0.5
            },
            theme = { -- This feature might not work properly in nvim-0.7.2
                enable = true, -- Will generate colors for the plugin based on your current colorscheme
                mode = 'auto', -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
            },
            mappings = {
                list = {
                    ['j'] = actions.next, -- Bring the cursor to the next item in the list
                    ['k'] = actions.previous, -- Bring the cursor to the previous item in the list
                    ['<Down>'] = actions.next,
                    ['<Up>'] = actions.previous,
                    ['<Tab>'] = actions.next_location, -- Bring the cursor to the next location skipping groups in the list
                    ['<S-Tab>'] = actions.previous_location, -- Bring the cursor to the previous location skipping groups in the list
                    ['<C-u>'] = actions.preview_scroll_win(5),
                    ['<C-d>'] = actions.preview_scroll_win(-5),
                    ['v'] = actions.jump_vsplit,
                    ['s'] = actions.jump_split,
                    ['t'] = actions.jump_tab,
                    ['<CR>'] = actions.jump,
                    ['o'] = actions.jump,
                    ['<leader>l'] = actions.enter_win('preview'), -- Focus preview window
                    ['q'] = actions.close,
                    ['Q'] = actions.close,
                    ['<Esc>'] = actions.close,
                    -- ['<Esc>'] = false -- disable a mapping
                },
                preview = {
                    ['Q'] = actions.close,
                    ['<Tab>'] = actions.next_location,
                    ['<S-Tab>'] = actions.previous_location,
                    ['<leader>l'] = actions.enter_win('list'), -- Focus list window
                },
            },
            hooks = {},
            folds = {
                fold_closed = '',
                fold_open = '',
                folded = true, -- Automatically fold list on startup
            },
            indent_lines = {
                enable = true,
                icon = '│',
            },
            winbar = {
                enable = true, -- Available strating from nvim-0.8+
            },
        })
    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = { "g", "G" },
        action = '<cmd>Glance definitions<cr>',
        short_desc = "Glance Definitions",
        silent = false
    })
    --mappings.register({
    --    mode = "n",
    --    key = { "g", "R" },
    --    action = '<cmd>Glance references<cr>',
    --    short_desc = "Glance References",
    --    silent = false
    --})
    --mappings.register({
    --    mode = "n",
    --    key = { "g", "Y" },
    --    action = '<CMD>Glance type_definitions<CR>',
    --    short_desc = "Glance Type Definitions",
    --    silent = false
    --})
    --mappings.register({
    --    mode = "n",
    --    key = { "g", "M" },
    --    action = '<CMD>Glance implementations<CR>',
    --    short_desc = "Glance Implementations",
    --    silent = false
    --})
end

return plugin
