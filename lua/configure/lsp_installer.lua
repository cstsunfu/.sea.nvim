local plugin = {}

plugin.core = {
    "git@github.com:kabouzeid/nvim-lspinstall.git",
    as = "nvim-lspinstall",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded

        require'lspinstall'.setup() -- important

        local servers = require'lspinstall'.installed_servers()
        for _, server in pairs(servers) do
            require'lspconfig'[server].setup{}
        end

    end,
}

plugin.mapping = function()

end

return plugin
