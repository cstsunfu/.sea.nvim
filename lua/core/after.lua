-- special setting
local timer = vim.loop.new_timer()
local hl_fun = require("util.highlight")
timer:start(
    1000,
    0,
    vim.schedule_wrap(function()
        vim.cmd("hi! link SignColumn LineNr") --set VertSplit color to black
        vim.cmd("autocmd ColorScheme, VimEnter * highlight! link SignColumn LineNr")

        vim.cmd("hi VertSplit ctermfg=black guifg=black") --set VertSplit color to black
        vim.cmd("hi StatusLine ctermfg=black guifg=black") --set HSplit color to black

        vim.cmd("highlight clear WhichKeyDesc")
        vim.cmd("highlight WhichKeyDesc guifg=#98be65")

        local normal = hl_fun.get_highlight_values("Normal")
        local darkbg = hl_fun.brighten(normal.background, -5) -- darken by 5%
        hl_fun.highlight("DarkNormal", { bg = darkbg, fg = normal.foreground })

        local telescope_border = "#9a95bf"
        hl_fun.highlight("TelescopePromptBorder", { bg = darkbg, fg = telescope_border })
        hl_fun.highlight("TelescopeResultsBorder", { bg = darkbg, fg = telescope_border })
        hl_fun.highlight("TelescopePreviewBorder", { bg = darkbg, fg = telescope_border })

        vim.cmd("highlight! link TelescopeNormal DarkNormal")
        vim.cmd("highlight WhichKeyDesc guifg=#98be65")
        vim.cmd("hi! link CodeActionNumber @keyword")
    end)
)

-- empty the message
--local empty_message_timer = vim.loop.new_timer()
--empty_message_timer:start(1500, 1500, function()
--    print(" ")
--end)
--
local configs = require("lspconfig.configs")
local util = require("lspconfig.util")
local capabilities = vim.lsp.protocol.make_client_capabilities()

configs.intc_lsp = {
    default_config = {
        cmd = { "intc-lsp" },

        root_dir = function(fname)
            local root = util.root_pattern(".intc.json*")(fname) -- or util.path.dirname(fname)
            if root == vim.g.HOME_PATH or root == nil then
                return nil
            end
            return root
        end,
        filetypes = { "jsonc", "hjson", "json" },
        single_file_support = true,
    },
    docs = {
        package_json = "",
        description = [[
       intc language server
       ]],
    },
}

local common_config = {
    capabilities = capabilities,
    on_attach = function(_, _) end,
}

require("lspconfig")["intc_lsp"].setup(common_config)
