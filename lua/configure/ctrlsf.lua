local plugin = {}

plugin.core = {
    "dyng/ctrlsf.vim",
    cmd = { "CtrlSF" },
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        vim.g.ctrlsf_mapping = {
            chgmode = "M",
            fzf = "",
            loclist = "",
            next = { "n", "N", "gn" },
            nfile = "gN",
            open = { "<CR>", "<2-LeftMouse>" },
            pfile = "gP",
            openb = "o",
            popen = "O",
            popenf = "gO",
            pquit = "q",
            prev = { "P", "gp" },
            quit = "q",
            split = "<C-O>",
            stop = "<C-C>",
            tab = "t",
            tabb = "T",
            vsplit = "",
        }
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
