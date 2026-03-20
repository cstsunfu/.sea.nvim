local plugin = {}

plugin.core = {
    "amitds1997/remote-nvim.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim", -- For standard functions
        "MunifTanjim/nui.nvim", -- To build the plugin UI
        "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
    },
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("remote-nvim").setup({
            offline_mode = {
                enabled = false,
                no_github = false,
            },
            remote = {
                copy_dirs = {

                    data = {
                        base = vim.fn.stdpath("data"), -- Path from where data has to be copied. You can choose to copy entire path or subdirectories inside using `dirs`
                        dirs = { "lazy" }, -- Directories inside `base` to copy over. If this is set to string "*"; it means entire `base` should be copied over
                        compression = {
                            enabled = true, -- Should data be compressed before uploading
                            additional_opts = { "--exclude-vcs" }, -- Any arguments that can be passed to `tar` for compression can be specified here to improve your compression
                        },
                    },
                },
            },
        })
    end,
}

plugin.mapping = function()
    --local mappings = require("core.mapping")
    --mappings.register({
    --    mode = "n",
    --    key = { "<leader>", "r", "e" },
    --    action = ":MirrorEdit<cr>",
    --    short_desc = "Remote Edit",
    --    silent = true,
    --})

    --mappings.register({
    --    mode = "n",
    --    key = { "<leader>", "r", "c" },
    --    action = ":MirrorConfig<cr>",
    --    short_desc = "Remote Configure",
    --    silent = true,
    --})
end

return plugin
