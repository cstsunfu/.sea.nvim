local plugin = {}

plugin.core = {
    "luukvbaal/statuscol.nvim",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        local builtin = require("statuscol.builtin")
        require("statuscol").setup({
            --ft_ignore = { "alpha", "neo-tree", "Trouble", "help" },
            ft_ignore = vim.g.no_number_filetypes_list,
            bt_ignore = { "terminal" },
            relculright = true,
            segments = {
                {
                    sign = { name = { "Diagnostic*" }, maxwidth = 1, auto = false, colwidth = 2 },
                    click = "v:lua.ScSa",
                },
                {
                    -- Dap Breakpoints
                    sign = { name = { "Dap*" }, maxwidth = 1, colwidth = 2, auto = true, fillchars = "" },
                    click = "v:lua.ScSa",
                },
                { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
                {
                    sign = { name = { "GitSigns*" }, maxwidth = 1, colwidth = 1, auto = false, fillchar = " " },
                    click = "v:lua.ScSa",
                },
                { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
                {
                    sign = { name = { ".*" }, maxwidth = 1, colwidth = 1, auto = true },
                    click = "v:lua.ScSa",
                },
            },
        })
    end,
}

plugin.mapping = function()

end

return plugin
