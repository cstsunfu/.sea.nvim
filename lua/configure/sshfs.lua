local plugin = {}

plugin.core = {
    "nosduco/remote-sshfs.nvim",

    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("remote-sshfs").setup({
            connections = {
                ssh_configs = { -- which ssh configs to parse for hosts list
                    vim.fn.expand("$HOME") .. "/.ssh/config",
                    "/etc/ssh/ssh_config",
                },
                ssh_known_hosts = vim.fn.expand("$HOME") .. "/.ssh/known_hosts",
                -- NOTE: Can define ssh_configs similarly to include all configs in a folder
                -- ssh_configs = vim.split(vim.fn.globpath(vim.fn.expand "$HOME" .. "/.ssh/configs", "*"), "\n")
                sshfs_args = { -- arguments to pass to the sshfs command
                    "-o reconnect",
                    "-o ConnectTimeout=5",
                },
            },
            mounts = {
                base_dir = vim.fn.expand("$HOME") .. "/.sshfs/", -- base directory for mount points
                unmount_on_exit = true, -- run sshfs as foreground, will unmount on vim exit
            },
            handlers = {
                on_connect = {
                    change_dir = true, -- when connected change vim working directory to mount point
                },
                on_disconnect = {
                    clean_mount_folders = false, -- remove mount point folder on disconnect/unmount
                },
                on_edit = {}, -- not yet implemented
            },
            ui = {
                select_prompts = false, -- not yet implemented
                confirm = {
                    connect = true, -- prompt y/n when host is selected to connect to
                    change_dir = false, -- prompt y/n to change working directory on connection (only applicable if handlers.on_connect.change_dir is enabled)
                },
            },
            log = {
                enabled = false, -- enable logging
                truncate = false, -- truncate logs
                types = { -- enabled log types
                    all = false,
                    util = false,
                    handler = false,
                    sshfs = false,
                },
            },
        })
    end,
}

plugin.mapping = function()
    --local mappings = require("core.mapping")
    --mappings.register({
    --    mode = "n",
    --    key = { "<leader>", "r", "c" },
    --    action = ":MirrorConfig<cr>",
    --    short_desc = "Remote Configure",
    --    silent = true,
    --})
end

return plugin
