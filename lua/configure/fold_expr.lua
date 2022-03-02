local plugin = {}

plugin.core = {
    "pierreglaser/folding-nvim",
    --as = "folding-nvim",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded

        function on_attach_callback(client, bufnr)
            -- If you use completion-nvim/diagnostic-nvim, uncomment those two lines.
            -- require('diagnostic').on_attach()
            -- require('completion').on_attach()
            require('folding').on_attach()
        end

        require('lspconfig').pyright.setup{on_attach=on_attach_callback}

    end,
}

plugin.mapping = function()

end

return plugin
