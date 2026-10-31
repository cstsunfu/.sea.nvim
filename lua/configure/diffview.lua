local plugin = {}

plugin.core = {
    "sindrets/diffview.nvim",
    dependencies = {
        "telescope.nvim",
    },
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },

    config = function() -- Specifies code to run after this plugin is loaded
        local RevType = require("diffview.vcs.rev").RevType
        local FileHistoryView = require("diffview.scene.views.file_history.file_history_view").FileHistoryView

        ---Is this the view opened by ;gh?
        ---@param view diffview.View?
        ---@return boolean
        local function is_history_view(view)
            return view ~= nil and view:instanceof(FileHistoryView)
        end

        -- Files whose right side D has swapped to the working tree, mapped to
        -- the revision it showed before (so the next D can put it back).
        local swapped = setmetatable({}, { __mode = "k" })

        -- Toggle the selected file of the history view between "parent vs
        -- commit" (what <cr> shows) and "parent vs working tree". The view,
        -- its windows and its layout stay exactly as they are; only the right
        -- side's revision changes. diffview's own <C-A-d> only diffs the two
        -- sides of the commit itself.
        local function toggle_worktree(view)
            view = view or require("diffview.lib").get_current_view()
            if not is_history_view(view) then
                vim.notify("diffview: D works in the file history view", vim.log.levels.WARN)
                return
            end

            -- The file under the panel cursor, or the open one from a diff window.
            local file = view:infer_cur_file()
            if not file then
                vim.notify(
                    "diffview: no commit here, move to a commit line in the history panel first",
                    vim.log.levels.WARN
                )
                return
            end

            local side = file.layout.b.file
            local target = swapped[file]
            if target then
                swapped[file] = nil
            else
                if side.rev.type == RevType.LOCAL then
                    return
                end
                swapped[file] = side.rev
                target = view.adapter.Rev(RevType.LOCAL)
            end

            -- A working tree buffer is the user's own: let go of it without
            -- deleting it. The commit side is a scratch diffview:// buffer.
            if side.rev.type == RevType.LOCAL then
                side:detach_buffer()
                side.bufnr = nil
            else
                side:dispose_buffer()
            end
            side.rev = target
            file.revs.b = target
            view:set_file(file)
        end

        local close_map = { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } }
        local toggle_map = { "n", "D", toggle_worktree, { desc = "Toggle: parent vs working tree" } }

        -- Everything else (layout, icons, panel sizes, log options) stays at
        -- diffview's defaults; only real changes are listed here.
        require("diffview").setup({
            enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
            file_history_panel = {
                log_options = {
                    git = {
                        -- Single-file history keeps the default 256.
                        multi_file = {
                            max_count = 100,
                        },
                    },
                },
            },
            keymaps = {
                view = { close_map, toggle_map },
                file_panel = { close_map },
                file_history_panel = { close_map, toggle_map },
            },
        })
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")

    -- ;gh, ;gv and ;gd all close the diffview that is already open instead of
    -- stacking something on top of it.
    ---@return boolean closed
    local function close_if_open()
        if not require("diffview.lib").get_current_view() then
            return false
        end
        vim.cmd("DiffviewClose")
        return true
    end

    ---Override telescope's default selection with a diffview command.
    ---@param picker fun(opts: table)
    ---@param command string command name, the selected entry is appended
    ---@param field string entry field holding the argument
    ---@param opts table
    local function pick_and_run(picker, command, field, opts)
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        opts.attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                local entry = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd(command .. " " .. vim.fn.fnameescape(entry[field]))
            end)
            return true
        end
        picker(opts)
    end

    _G.plugin_diffview__toggle_diffview_branch = function()
        if close_if_open() then
            return
        end
        pick_and_run(require("telescope.builtin").git_branches, "DiffviewOpen", "name", {
            prompt_title = "Diff against branch",
        })
    end

    _G.plugin_diffview__file_history = function()
        if close_if_open() then
            return
        end
        -- Absolute paths: autochdir keeps nvim's cwd at the current file's
        -- directory, which is not necessarily where the history is opened.
        pick_and_run(require("telescope.builtin").find_files, "DiffviewFileHistory", "path", {
            prompt_title = "File history",
            cwd = require("util.project").root(),
        })
    end

    _G.plugin_diffview__toggle_diffview = function()
        if not close_if_open() then
            vim.cmd("DiffviewOpen")
        end
    end

    mappings.register({
        mode = "n",
        key = { "<leader>", "g", "v" },
        action = ":lua _G.plugin_diffview__toggle_diffview_branch()<cr>",
        short_desc = "Git Diff View(Branch)",
        noremap = true,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "g", "h" },
        action = ":lua _G.plugin_diffview__file_history()<cr>",
        short_desc = "Git History",
        noremap = true,
        silent = true,
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "g", "d" },
        action = ":lua _G.plugin_diffview__toggle_diffview()<cr>",
        short_desc = "Git Diff View",
        silent = true,
        noremap = true,
    })
end
return plugin
