local plugin = {}

plugin.core = {
    "kiyoon/jupynium.nvim",
    event = "VeryLazy",
    build = "pip3 install --user .",

    dependencies = {
        "rcarriga/nvim-notify", -- optional
        "stevearc/dressing.nvim", -- optional, UI for :JupyniumKernelSelect
    },
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        local note_port = "8888"
        ---- get system environment JUPYTER_PORT
        local env_note_port = os.getenv("JUPYTER_PORT")
        if env_note_port ~= nil then
            note_port = env_note_port
        end
        local note_url = "localhost:" .. note_port .. "/nbclassic"
        local jupyter_command = "jupyter"
        local jupyter_token = os.getenv("JUPYTER_TOKEN")
        if jupyter_token ~= nil and jupyter_token ~= "" then
            jupyter_command = jupyter_command .. " --NotebookApp.token=" .. jupyter_token
            note_url = note_url .. "?token=" .. jupyter_token
        end

        -- get current python interpreter path
        local python_path = io.popen("which python"):read("*all")

        python_path = string.gsub(python_path, "^(.-)%s*\n*$", "%1")

        require("jupynium").setup({
            --- For Conda environment named "jupynium",
            python_host = python_path,

            default_notebook_URL = note_url,

            -- Write jupyter command but without "notebook"
            -- When you call :JupyniumStartAndAttachToServer and no notebook is open,
            -- then Jupynium will open the server for you using this command. (only when notebook_URL is localhost)
            jupyter_command = jupyter_command,
            --- For Conda, maybe use base environment
            --- then you can `conda install -n base nb_conda_kernels` to switch environment in Jupyter Notebook
            -- jupyter_command = { "conda", "run", "--no-capture-output", "-n", "base", "jupyter" },

            -- Used when notebook is launched by using jupyter_command.
            -- If nil or "", it will open at the git directory of the current buffer,
            -- but still navigate to the directory of the current buffer. (e.g. localhost:8888/nbclassic/tree/path/to/buffer)
            notebook_dir = nil,

            -- Used to remember the last session (password etc.).
            -- e.g. '~/.mozilla/firefox/profiles.ini'
            -- or '~/snap/firefox/common/.mozilla/firefox/profiles.ini'
            --firefox_profiles_ini_path = nil,
            firefox_profiles_ini_path = nil,
            -- nil means the profile with Default=1
            -- or set to something like 'default-release'
            firefox_profile_name = nil,

            -- Open the Jupynium server if it is not already running
            -- which means that it will open the Selenium browser when you open this file.
            -- Related command :JupyniumStartAndAttachToServer
            auto_start_server = {
                enable = false,
                file_pattern = { "*.ju.py" },
            },

            -- Attach current nvim to the Jupynium server
            -- Without this step, you can't use :JupyniumStartSync
            -- Related command :JupyniumAttachToServer
            auto_attach_to_server = {
                enable = false,
                file_pattern = { "*.ju.py", "*.md" },
            },

            -- Automatically open an Untitled.ipynb file on Notebook
            -- when you open a .ju.py file on nvim.
            -- Related command :JupyniumStartSync
            auto_start_sync = {
                enable = false,
                file_pattern = { "*.ju.py", "*.md" },
            },

            -- Automatically keep filename.ipynb copy of filename.ju.py
            -- by downloading from the Jupyter Notebook server.
            -- WARNING: this will overwrite the file without asking
            -- Related command :JupyniumDownloadIpynb
            auto_download_ipynb = false,

            -- Automatically close tab that is in sync when you close buffer in vim.
            auto_close_tab = true,

            -- Always scroll to the current cell.
            -- Related command :JupyniumScrollToCell
            autoscroll = {
                enable = true,
                mode = "always", -- "always" or "invisible"
                cell = {
                    top_margin_percent = 20,
                },
            },

            scroll = {
                page = { step = 0.5 },
                cell = {
                    top_margin_percent = 20,
                },
            },

            -- Files to be detected as a jupynium file.
            -- Add highlighting, keybindings, commands (e.g. :JupyniumStartAndAttachToServer)
            -- Modify this if you already have lots of files in Jupytext format, for example.
            jupynium_file_pattern = { "*.ju.py" },

            use_default_keybindings = false,
            textobjects = {
                use_default_keybindings = false,
            },

            syntax_highlight = {
                enable = true,
            },

            -- Dim all cells except the current one
            -- Related command :JupyniumShortsightedToggle
            shortsighted = false,

            -- Configure floating window options
            -- Related command :JupyniumKernelHover
            kernel_hover = {
                floating_win_opts = {
                    max_width = 84,
                    border = "none",
                },
            },
        })
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    mappings.register({
        mode = { "n" },
        key = { "<leader>", "j", "s" },
        action = ":JupyniumStartSync<cr>",
        short_desc = "JupyniumStartSync",
    })
    mappings.register({
        mode = { "n" },
        key = { "<leader>", "j", "e" },
        action = ":JupyniumExecuteSelectedCells<cr>",
        short_desc = "JupyniumExecuteSelectedCells",
    })
end

return plugin
