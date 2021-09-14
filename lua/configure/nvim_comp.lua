local plugin = {}

plugin.core = {
    "git@github.com:hrsh7th/nvim-compe.git",
    as = "nvim-compe",
    setup = function()  -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require'compe'.setup {
            enabled = true;
            autocomplete = true;
            debug = false;
            min_length = 1;
            preselect = 'enable';
            throttle_time = 80;
            source_timeout = 200;
            resolve_timeout = 800;
            incomplete_delay = 400;
            max_abbr_width = 100;
            max_kind_width = 100;
            max_menu_width = 100;
            documentation = {
                border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
                winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
                max_width = 120,
                min_width = 60,
                max_height = math.floor(vim.o.lines * 0.3),
                min_height = 1,
            };

            source = {
                path = true,
                buffer = true,
                calc = true,
                nvim_lsp = true,
                nvim_lua = true,
                ultisnips = true,
                emoji = true
            };
        }

    end
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    local is_prior_char_whitespace = function()
        local col = vim.fn.col('.') - 1
        if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
            return true
        else
            return false
        end
    end

    -- Use (shift-)tab to:
    -- move to prev/next item in completion menu
    -- jump to the prev/next snippet placeholder
    -- insert a simple tab
    -- start the completion menu
    _G.tab_completion = function()
        if vim.fn.pumvisible() == 1 then
            return vim.api.nvim_replace_termcodes("<C-n>", true, true, true)

        elseif vim.fn["UltiSnips#CanExpandSnippet"]() == 1 or vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
            return vim.api.nvim_replace_termcodes("<C-R>=UltiSnips#ExpandSnippetOrJump()<CR>", true, true, true)

        elseif is_prior_char_whitespace() then
            return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)

        else
            return vim.fn['compe#complete']()
        end
    end
    _G.shift_tab_completion = function()
        if vim.fn.pumvisible() == 1 then
            return vim.api.nvim_replace_termcodes("<C-p>", true, true, true)

        elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
            return vim.api.nvim_replace_termcodes("<C-R>=UltiSnips#JumpBackwards()<CR>", true, true, true)

        else
            return vim.api.nvim_replace_termcodes("<S-Tab>", true, true, true)
        end
    end
    mappings.register({
        mode = "i",
        key = {"<Tab>"},
        action = 'v:lua.tab_complete()',
        short_desc = "complete",
        expr = true
    })
    mappings.register({
        mode = "s",
        key = {"<Tab>"},
        action = 'v:lua.tab_complete()',
        short_desc = "complete",
        expr = true
    })
    mappings.register({
        mode = "i",
        key = {"<S-Tab>"},
        action = 'v:lua.s_tab_complete()',
        short_desc = "complete",
        expr = true
    })
    mappings.register({
        mode = "s",
        key = {"<S-Tab>"},
        action = 'v:lua.s_tab_complete()',
        short_desc = "complete",
        expr = true
    })
end
return plugin
