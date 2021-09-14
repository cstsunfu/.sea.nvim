
local plugin = {}

plugin.core = {
    "git@github.com:ray-x/navigator.lua.git",
    as = "navigator",
    requires = {{"git@github.com:ray-x/guihua.lua.git", as = "guihua", run = 'cd lua/fzy && make'}},


    setup = function()  -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require'navigator'.setup({
            pyls={filetype={}}
        })
        --require'navigator'.setup({
            --debug = false, -- log output
            --code_action_icon = " ",
            --width = 0.75, -- max width ratio (number of cols for the floating window) / (window width)
            --height = 0.3, -- max list window height, 0.3 by default
            --preview_height = 0.35, -- max height of preview windows
            --border = {"╭", "─", "╮", "│", "╯", "─", "╰", "│"}, -- border style, can be one of 'none', 'single', 'double',
            ---- 'shadow', or a list of chars which defines the border
            --on_attach = function(client, bufnr)
                ---- your hook
            --end,
            ---- put a on_attach of your own here, e.g
            ---- function(client, bufnr)
            ----   -- the on_attach will be called at end of navigator on_attach
            ---- end,
            ---- The attach code will apply to all LSP clients

            --default_mapping = true,  -- set to false if you will remap every key
            ----keymaps = {{key = "gD", func = "declaration()"}}, -- a list of key maps
            ---- this kepmap gK will override "gD" mapping function declaration()  in default kepmap
            ---- please check mapping.lua for all keymaps
            --treesitter_analysis = true, -- treesitter variable context
            --code_action_prompt = {enable = true, sign = true, sign_priority = 40, virtual_text = true},
            --icons = {
                ---- Code action
                --code_action_icon = " ",
                ---- Diagnostics
                --diagnostic_head = '🐛',
                --diagnostic_head_severity_1 = "🈲",
                ---- refer to lua/navigator.lua for more icons setups
            --},
            --languages = {
                --python = {python-flake8 },
            --},

            ----lsp = {
                ----format_on_save = true, -- set to false to disasble lsp code format on save (if you are using prettier/efm/formater etc)
                ------tsserver = {
                    ------filetypes = {'typescript'} -- disable javascript etc,
                    -------- set to {} to disable the lspclient for all filetypes
                ------},
                ------gopls = {   -- gopls setting
                    ------on_attach = function(client, bufnr)  -- on_attach for gopls
                        -------- your special on attach here
                        -------- e.g. disable gopls format because a known issue https://github.com/golang/go/issues/45732
                        ------print("i am a hook, I will disable document format")
                        ------client.resolved_capabilities.document_formatting = false
                    ------end,
                    ------settings = {
                        ------gopls = {gofumpt = false} -- disable gofumpt etc,
                    ------}
                ------},
                ----pyright = {
                    ----filetypes = {'python'}
                ----},
                ------sumneko_lua = {
                    ------sumneko_root_path = vim.fn.expand("$HOME") .. "/github/sumneko/lua-language-server",
                    ------sumneko_binary = vim.fn.expand("$HOME") .. "/github/sumneko/lua-language-server/bin/macOS/lua-language-server",
                ------},
            ----}
        --})
    end,

}
plugin.mapping = function()

end
return plugin
