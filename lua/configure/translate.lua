local plugin = {}

plugin.core = {
    "voldikss/vim-translator",
    --as = "vim-translator",
    --cmd = {'<Plug>TranslateW', '<Plug>TranslateWV'},
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        if vim.g['global_proxy_port'] then
            vim.g.translator_proxy_url = vim.g.global_proxy_port
        end
    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = {"<leader>", "t", "w"},
        action = '<Plug>TranslateW',
        short_desc = "Translate Current Word.",
        silent = true
    })

    mappings.register({
        mode = "v",
        key = {"<leader>", "t", "w"},
        action = '<Plug>TranslateWV',
        short_desc = "Translate Current Vision Word.",
        silent = true
    })


end

return plugin
