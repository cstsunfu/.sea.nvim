local plugin = {}

plugin.core = {
    "dyng/ctrlsf.vim",
    cmd = { "CtrlSF" },
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        vim.g.ctrlsf_mapping = {
            open = { "<CR>", "<2-LeftMouse>" },
        }
        vim.api.nvim_create_autocmd({ "FileType" }, {
            callback = function()
                -- There is an unkonwn bug in CtrlSF
                vim.notify("Do not edit the CtrlSF file.", "warn", { title = "CtrlSF" })
            end,
            pattern = "ctrlsf",
        })
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    mappings.register({
        mode = "n",
        key = { "<leader>", "s", "f" },
        action = ":CtrlSF<cr>",
        short_desc = "Search Current Word",
        silent = true,
    })
end
return plugin
