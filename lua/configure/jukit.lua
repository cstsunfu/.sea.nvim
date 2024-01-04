local plugin = {}

plugin.core = {
    "luk400/vim-jukit",
    ft = "python",
    init = function() -- Specifies code to run before this plugin is loaded.
        vim.g.jukit_shell_cmd = "ipython3"
        --"    - Specifies the command used to start a shell in the output split. Can also be an absolute path. Can also be any other shell command, e.g. `R`, `julia`, etc. (note that output saving is only possible for ipython)
        vim.g.jukit_terminal = ""
        --"   - Terminal to use. Can be one of '', 'kitty', 'vimterm', or 'nvimterm'. If '' is given then will try to detect terminal
        vim.g.jukit_auto_output_hist = 0
        --"   - If set to 1, will create an autocmd with event `CursorHold` to show saved ipython output of current cell in output-history split. Might slow down (n)vim significantly, you can use `set updatetime=<number of milliseconds>` to control the time to wait until CursorHold events are triggered, which might improve performance if set to a higher number (e.g. `set updatetime=1000`).
        vim.g.jukit_use_tcomment = 0
        --"   - Whether to use tcomment plugin (https://github.com/tomtom/tcomment_vim) to comment out cell markers. If not, then cell markers will simply be prepended with `g:jukit_comment_mark`
        vim.g.jukit_comment_mark = "#"
        --"   - See description of `g:jukit_use_tcomment` above
        vim.g.jukit_mappings = 0
        --"   - If set to 0, none of the default function mappings (as specified further down) will be applied
    end,

    config = function() -- Specifies code to run after this plugin is loaded
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    mappings.register({
        mode = "n",
        key = { "<leader>", "n", "p" },
        action = ':call jukit#convert#notebook_convert("jupyter-notebook")<cr>',
        short_desc = "Jupyter Convert",
        silent = true,
    })
end

return plugin
