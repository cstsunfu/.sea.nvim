local plugin = {}

plugin.core = {
    "git@github.com:chipsenkbeil/distant.nvim.git",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        local actions = require('distant.nav.actions')

        require('distant').setup {
            -- Apply these settings to the specific host
            ['example.com'] = {
                launch = {
                    -- Specify a specific location for the distant binary on the remote machine
                    distant = '/path/to/distant',
                },
                lsp = {
                    -- Specify an LSP to run for a specific project
                    ['My Project'] = {
                        cmd = '/path/to/rust-analyzer',
                        root_dir = '/path/to/project/root',

                        -- Do your on_attach with keybindings like you would with
                        -- nvim-lspconfig
                        on_attach = function() 
                            -- Apply some general bindings for every buffer supporting lsp
                        end,
                    },
                },
            },

            -- Apply these settings to any remote host
            ['*'] = {
                -- Apply these launch settings to all hosts
                launch = {
                    -- Apply additional CLI options to the listening server, such as
                    -- shutting down when there is no connection to it after 30 seconds
                    extra_server_args = '"--shutdown-after 30"',
                },

                -- Specify mappings to apply on remote file buffers
                -- Presently, the only one you would want is some way to trigger
                -- file navigation
                file = {
                    mappings = {
                        ['-']         = actions.up,
                    },
                },

                -- Specify mappings to apply on remote directory bufffers
                dir = {
                    mappings = {
                        ['<Return>']  = actions.edit,
                        ['-']         = actions.up,
                        ['K']         = actions.mkdir,
                        ['N']         = actions.newfile,
                        ['R']         = actions.rename,
                        ['D']         = actions.remove,
                    }
                },
            }
        }
    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = {"<leader>", "t", "o"},
        action = ':ZenMode<cr>',
        short_desc = "Toggle Only Window(ZenMode)",
        silent = true
    })

end

return plugin
