local plugin = {}

-- 'conceallevel' / 'concealcursor' as set up in core/default.lua, captured
-- before any preview plugin gets a chance to change them for a window.
local conceal_defaults = { level = vim.o.conceallevel, cursor = vim.o.concealcursor }

plugin.core = {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    build = "make",
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "echasnovski/mini.pick", -- for file_selector provider mini.pick
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
        "ibhagwan/fzf-lua", -- for file_selector provider fzf
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua", -- for providers='copilot'

        {
            -- Renders the chat answer as markdown. avante registers the markdown
            -- treesitter parser for the "Avante" filetype, so any renderer that works
            -- off treesitter can attach to the sidebar buffer.
            "OXY2DEV/markview.nvim",
            ft = "Avante",
            dependencies = {
                -- Fits tables that are wider than the sidebar into it by
                -- shrinking columns and wrapping the cell text. markview
                -- itself just gives up on those (see the wrap patch below).
                {
                    "gunasekar/markview-smart-tables.nvim",
                    opts = { wrap_width = 0.98, wrap_minwidth = 6 },
                },
            },
            opts = {
                renderers = {
                    markdown_table = function(buffer, item)
                        require("markview-smart-tables").render(buffer, item)
                    end,
                },
                -- Same as the editor: keep the literal '#' headings and the
                -- '-' / '*' / '+' list markers in the chat preview.
                markdown = {
                    headings = { enable = false },
                    list_items = { enable = false },
                },
                preview = {
                    filetypes = { "Avante" },
                    -- Belt and braces: markview's default condition lets it
                    -- attach to regular markdown files too.
                    condition = function(buf)
                        return vim.bo[buf].filetype == "Avante"
                    end,
                    -- The sidebar buffer is 'nofile', which markview ignores by
                    -- default; without this it never attaches, so nothing is
                    -- rendered and 'concealcursor' is left alone.
                    ignore_buftypes = {},
                    -- Hybrid mode reveals the raw text of the line the cursor
                    -- sits on, which makes the sidebar flip between rendered
                    -- and raw while reading. Keep the whole preview rendered.
                    enable_hybrid_mode = false,
                    -- The sidebar is rewritten on every streamed chunk; re-render at
                    -- most every 300 ms instead of the 150 ms default.
                    debounce = 300,
                    -- Below this line count markview parses and decorates the whole
                    -- buffer on every render; above it only the range around the
                    -- cursor. A long conversation is unreadable if it pays the full
                    -- parse on each resize/mode change, so keep the limit low
                    -- enough that long chats take the cheap path.
                    max_buf_lines = 2000,
                    -- Only the modes the sidebar is actually used in. markview derives
                    -- 'concealcursor' from this list, so "n" keeps the cursor line
                    -- concealed in normal mode: no backticks or ** pop up under the
                    -- cursor the way render-markdown's anti_conceal did.
                    modes = { "n", "no", "c" },
                },
            },
            config = function(_, opts)
                require("markview").setup(opts)

                -- markview is loaded by the FileType autocmd, i.e. after avante
                -- has already switched the sidebar to "Avante", so its own
                -- attach hook never sees that event and the buffer stays
                -- unattached (no rendering, no 'concealcursor'). Attach the
                -- buffers that are already there and every later one.
                local markview = require("markview")
                local actions = require("markview.actions")
                local filetypes = opts.preview.filetypes

                -- markview rewrites the *global* markdown highlight query when
                -- it attaches (a workaround for codecompanion): it reads the
                -- query file from disk and installs that, throwing away the
                -- custom query from configure/tree_sitter.lua for the rest of
                -- the session. Put ours back after every rewrite.
                local original_set_query = actions.set_query
                if original_set_query then
                    actions.set_query = function(buffer)
                        local result = original_set_query(buffer)
                        pcall(vim.treesitter.query.set, "markdown", "highlights", require("util.markdown_query"))
                        return result
                    end
                end

                -- markview is meant for the sidebar only, but it ends up
                -- attaching to plain markdown buffers as well: it then forces
                -- 'conceallevel' = 3 / 'concealcursor' = "nc" on them and drops
                -- back to 0 in insert mode, which makes headings and emphasis
                -- look different in every mode and fight render-markdown.nvim.
                -- Detach it from anything that is not the sidebar.
                local function detach_non_avante(buf)
                    if not vim.api.nvim_buf_is_valid(buf) then
                        return
                    end
                    if vim.tbl_contains(filetypes, vim.bo[buf].filetype) then
                        return
                    end
                    local ok, state = pcall(require, "markview.state")
                    if not ok or not state.buf_attached(buf) then
                        return
                    end
                    pcall(actions.detach, buf)
                    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
                        vim.wo[win].conceallevel = conceal_defaults.level
                        vim.wo[win].concealcursor = conceal_defaults.cursor
                    end
                end
                vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "ModeChanged" }, {
                    group = vim.api.nvim_create_augroup("markview_avante_only", { clear = true }),
                    callback = function(args)
                        detach_non_avante(args.buf)
                    end,
                })
                -- markview may already have grabbed the buffer that was open
                -- when it was loaded, before the autocmd above existed.
                vim.schedule(function()
                    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                        detach_non_avante(buf)
                    end
                end)

                -- avante rewrites the whole answer buffer for every streamed
                -- chunk, and markview's extmarks are invalidated by that rewrite,
                -- so a render per chunk would only flicker. Render once the
                -- buffer has been quiet for a moment instead.
                -- Rendering in the middle of a stream is wasted work anyway:
                -- the next chunk invalidates every extmark again, and a table
                -- that grows a row reflows the whole answer below it. Wait
                -- until avante stops generating.
                local function still_generating(buf)
                    for _, sidebar in pairs(require("avante").sidebars or {}) do
                        local result = sidebar.containers and sidebar.containers.result
                        if result and result.bufnr == buf then
                            local state = sidebar.current_state
                            return state == "generating"
                                or state == "thinking"
                                or state == "tool calling"
                                or state == "compacting"
                        end
                    end
                    return false
                end

                -- One timer per sidebar buffer: several tabs can generate at
                -- the same time and must not cancel each other's render.
                local render_timers = {}
                local function render_later(buf)
                    local entry = render_timers[buf]
                    if not entry then
                        entry = { timer = vim.uv.new_timer() }
                        render_timers[buf] = entry
                    end
                    entry.timer:stop()
                    entry.timer:start(400, 0, vim.schedule_wrap(function()
                        if not vim.api.nvim_buf_is_valid(buf) or vim.fn.bufwinid(buf) == -1 then
                            return
                        end
                        if still_generating(buf) then
                            render_later(buf)
                            return
                        end
                        pcall(markview.render, buf)
                    end))
                end

                -- markview only sets the conceal options for the windows that
                -- already display the buffer when it attaches. Depending on when
                -- avante opens the sidebar that window list is still empty, so
                -- set them here (and again whenever a window shows the buffer).
                local concealcursor = {}
                for _, mode in ipairs(opts.preview.modes) do
                    if vim.list_contains({ "n", "v", "i", "c" }, mode) then
                        table.insert(concealcursor, mode)
                    end
                end
                concealcursor = table.concat(concealcursor)

                local function set_window_options(buf)
                    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
                        vim.wo[win].conceallevel = 3
                        vim.wo[win].concealcursor = concealcursor
                    end
                end

                local watched = {}
                local function attach(buf)
                    if not vim.tbl_contains(filetypes, vim.bo[buf].filetype) then
                        return
                    end

                    -- avante re-sets 'filetype' on every streamed chunk, so
                    -- FileType fires ~8 times a second for the same buffer.
                    -- Only do the work once; windows opened later still need
                    -- the conceal options, which is all a repeat visit needs.
                    if watched[buf] then
                        set_window_options(buf)
                        return
                    end

                    actions.attach(buf)
                    set_window_options(buf)
                    render_later(buf)

                    if vim.api.nvim_buf_is_valid(buf) then
                        watched[buf] = true
                        vim.api.nvim_buf_attach(buf, false, {
                            on_lines = function()
                                render_later(buf)
                            end,
                            on_detach = function()
                                watched[buf] = nil
                                local entry = render_timers[buf]
                                if entry then
                                    entry.timer:stop()
                                    if not entry.timer:is_closing() then entry.timer:close() end
                                    render_timers[buf] = nil
                                end
                            end,
                        })
                    end
                end
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    attach(buf)
                end
                vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
                    group = vim.api.nvim_create_augroup("markview_avante_attach", { clear = true }),
                    callback = function(args)
                        attach(args.buf)
                    end,
                })

                -- markview refuses to draw the box characters of a table while
                -- 'wrap' is on (renderers/markdown.lua: "BUG, wrap breaks table
                -- rendering") and falls back to raw "|" separators. The sidebar
                -- wraps, so flip 'wrap' off for the duration of the render, but
                -- only when the table actually fits in the window: a wider table
                -- would wrap anyway and lose the alignment.
                local renderers = require("markview.renderers.markdown")
                local render_table = renderers.table
                renderers.table = function(buffer, item)
                    local win = vim.fn.bufwinid(buffer)
                    if win == -1 then
                        return render_table(buffer, item)
                    end

                    local width = 0
                    for _, line in ipairs(
                        vim.api.nvim_buf_get_lines(buffer, item.range.row_start, item.range.row_end, false)
                    ) do
                        width = math.max(width, vim.fn.strdisplaywidth(line))
                    end
                    if width > vim.api.nvim_win_get_width(win) - 1 then
                        return
                    end

                    local wrapped = vim.wo[win].wrap
                    if not wrapped then
                        return render_table(buffer, item)
                    end

                    vim.api.nvim_win_call(win, function()
                        vim.cmd("noautocmd setlocal nowrap")
                    end)
                    local ok, err = pcall(render_table, buffer, item)
                    vim.api.nvim_win_call(win, function()
                        vim.cmd("noautocmd setlocal wrap")
                    end)
                    if not ok then
                        error(err)
                    end
                end

                -- While the answer streams the buffer is rewritten several
                -- times per second; rendering it mid-flight only makes the
                -- decorations flash, and the next chunk invalidates every
                -- extmark anyway. The idle render above draws the final state.
                -- (markview itself already skips CursorMoved renders when
                -- hybrid mode is off, so nothing else has to be filtered.)
                local original_actions_render = actions.render
                actions.render = function(buffer, state, config)
                    if type(buffer) == "number" and vim.tbl_contains(filetypes, vim.bo[buffer].filetype) then
                        if still_generating(buffer) then
                            return
                        end
                    end
                    return original_actions_render(buffer, state, config)
                end
            end,
        },
    },

    keys = {
        {
            "<leader>a+",
            function()
                local tree_ext = require("avante.extensions.nvim_tree")
                tree_ext.add_file()
            end,
            desc = "Select file in NvimTree",
            ft = "NvimTree",
        },
        {
            "<leader>a-",
            function()
                local tree_ext = require("avante.extensions.nvim_tree")
                tree_ext.remove_file()
            end,
            desc = "Deselect file in NvimTree",
            ft = "NvimTree",
        },
    },

    opts = {},

    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        -- Monkeypatch vim.ui.select to handle cases where items might not be a list-like table
        -- which causes dressing.nvim to throw an error (validate items: expected list-like table)
        local original_select = vim.ui.select
        vim.ui.select = function(items, opts, on_choice)
            -- Handle call signature vim.ui.select(items, on_choice)
            if type(opts) == "function" then
                on_choice = opts
                opts = {}
            end

            if items == nil or type(items) ~= "table" then
                return original_select(items, opts, on_choice)
            end

            -- Check if it's a list-like table (has index 1)
            -- If not, convert it or pass an empty list to prevent dressing crash
            if #items == 0 and next(items) ~= nil then
                local list = {}
                for _, v in pairs(items) do
                    table.insert(list, v)
                end
                return original_select(list, opts, on_choice)
            end

            return original_select(items, opts, on_choice)
        end

        require("avante_lib").load()

        -- avante derives message uuids from Lua's math.random, which is never
        -- seeded: every Neovim start replays the same sequence. Reopening an
        -- old chat therefore hands the new messages the same uuids as the old
        -- ones, and Sidebar:add_history_messages (uuid match -> replace) writes
        -- them on top of the existing entries instead of appending. That is
        -- what scrambles a resumed conversation. Use Neovim's own random uuid,
        -- and seed math.random for the ids that still use it (tool call ids).
        math.randomseed(tonumber(tostring(vim.uv.hrtime()):sub(-9)) + vim.uv.os_getpid())
        local Utils = require("avante.utils")
        Utils.uuid = function()
            local hash = vim.fn.sha256(
                table.concat({ tostring(vim.uv.hrtime()), tostring(vim.uv.os_getpid()), tostring(math.random()) })
            )
            return string.format(
                "%s-%s-4%s-%s-%s",
                hash:sub(1, 8),
                hash:sub(9, 12),
                hash:sub(14, 16),
                hash:sub(17, 20),
                hash:sub(21, 32)
            )
        end

        -- Fix Issue #2: Add better error handling for submit
        -- The plugin's is_generating flag is never set to true, which is a bug
        -- but setting it manually can cause issues if on_stop is not called
        -- Instead, we add a timeout-based safety mechanism
        local Sidebar = require("avante.sidebar")

        -- When metadata.json has no latest_filename, avante counts the files in
        -- the history dir to guess the name -- but metadata.json itself is in
        -- that glob, so the guess can point at a file that does not exist and
        -- the chat loads empty. Pick the highest numbered chat instead.
        local Path = require("avante.path")
        local History = Path.history
        History.get_latest_filename = function(bufnr, new)
            local history_dir = History.get_history_dir(bufnr)
            local metadata_filepath = History.get_metadata_filepath(bufnr)
            local filename
            if metadata_filepath:exists() and not new then
                local ok, metadata = pcall(vim.json.decode, metadata_filepath:read())
                -- A JSON null decodes to vim.NIL, which is truthy but not a
                -- table; indexing it raises.
                if ok and type(metadata) == "table" then
                    local latest = metadata.latest_filename
                    if type(latest) == "string" and latest ~= "" then
                        filename = latest
                    end
                end
            end
            if not filename or filename == "" then
                local best
                for _, file in ipairs(vim.fn.glob(tostring(history_dir:joinpath("*.json")), true, true)) do
                    local number = tonumber(vim.fn.fnamemodify(file, ":t"):match("^(%d+)%.json$"))
                    if number and (not best or number > best) then
                        best = number
                    end
                end
                filename = ((best and (new and best + 1 or best)) or (new and 1 or 0)) .. ".json"
            end
            return filename
        end

        -- The chat history is loaded once, when the sidebar instance is first
        -- opened. If that happens before avante can resolve the project (or
        -- after the code buffer was replaced) it loads an empty history and
        -- the sidebar stays blank until the next open. Coming back to the
        -- avante window is a good moment to notice that: if the answer buffer
        -- is still empty but the chat on disk is not, load it again.
        vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
            group = vim.api.nvim_create_augroup("avante_reload_empty_history", { clear = true }),
            callback = function(args)
                if vim.bo[args.buf].filetype ~= "Avante" then
                    return
                end
                local sidebar
                for _, candidate in pairs(require("avante").sidebars or {}) do
                    local result = candidate.containers and candidate.containers.result
                    if result and result.bufnr == args.buf then
                        sidebar = candidate
                        break
                    end
                end
                if not sidebar then
                    return
                end
                local history = sidebar.chat_history
                if history and next(history.messages or {}) then
                    return
                end
                -- A new chat saves its (empty) file first, so reloading here
                -- cannot resurrect an older conversation.
                sidebar:reload_chat_history()
                if sidebar.chat_history and next(sidebar.chat_history.messages or {}) then
                    pcall(function()
                        sidebar:update_content("")
                    end)
                end
            end,
        })

        local original_submit_input = Sidebar.submit_input
        Sidebar.submit_input = function(self)
            -- If somehow stuck in generating state, force reset after timeout
            if self.is_generating then
                vim.notify("Avante is still generating, please wait or press <C-c> to cancel", vim.log.levels.WARN)
                return
            end
            -- A failure here clears the input box and then stops: the message
            -- never reaches the chat and nothing is reported. Say something
            -- instead of losing the prompt silently.
            local ok, err = pcall(original_submit_input, self)
            if not ok then
                vim.notify("Avante submit failed: " .. tostring(err), vim.log.levels.ERROR)
            end
        end

        -- avante repaints the answer every 50 ms while streaming, and each pass
        -- ends in a forced :redraw, so the sidebar is redrawn ~20 times per
        -- second. 120 ms reads just as smoothly and halves the flashing.
        Sidebar.throttled_update_content = require("avante.utils").throttle(function(self, ...)
            self:update_content(...)
        end, 120)

        -- avante redraws the answer by replacing everything from the first line
        -- to the end of the buffer on every streamed chunk, then runs :redraw.
        -- In a conversation of a few thousand lines that repaints the whole
        -- window ~20 times per second and is what makes streaming flicker.
        -- Keep the common prefix untouched and only write the lines that
        -- actually changed (in practice: the tail of the answer).
        local original_update_buffer_lines = Utils.update_buffer_lines
        Utils.update_buffer_lines = function(ns_id, bufnr, old_lines, new_lines, skip_line_count)
            skip_line_count = skip_line_count or 0
            new_lines = new_lines or {}

            -- Flatten the new content the same way avante does, remembering
            -- which item each flat line came from.
            local flat, owner, item_start = {}, {}, {}
            for idx, line in ipairs(new_lines) do
                item_start[idx] = #flat
                for _, piece in ipairs(vim.split(tostring(line), "\n")) do
                    table.insert(flat, piece)
                    owner[#flat] = idx
                end
            end

            local existing = vim.api.nvim_buf_get_lines(bufnr, skip_line_count, -1, false)
            local prefix = 0
            while prefix < #flat and prefix < #existing and existing[prefix + 1] == flat[prefix + 1] do
                prefix = prefix + 1
            end

            if prefix == #flat then
                -- Nothing new to draw; drop any lines the old render left
                -- behind. Unbind the disappearing rows first: their
                -- ButtonGroupLine handlers live in a per-buffer registry that
                -- only unbind_events can clean up.
                if #existing > #flat then
                    local flat_seen = 0
                    for _, line in ipairs(old_lines) do
                        local start = flat_seen
                        flat_seen = flat_seen + #vim.split(tostring(line), "\n")
                        if start >= #flat and type(line.unbind_events) == "function" then
                            pcall(line.unbind_events, line, bufnr, skip_line_count + start + 1)
                        end
                    end
                    vim.api.nvim_buf_set_lines(bufnr, skip_line_count + #flat, -1, false, {})
                end
                return
            end

            local first = owner[prefix + 1]
            -- Skip the forced :redraw at the end of the original function:
            -- Neovim repaints on its own once the event loop is idle, and
            -- batching the updates this way is what removes the flashing.
            local _cmd = vim.cmd
            vim.cmd = function(c, ...)
                if c == "redraw" then
                    return
                end
                return _cmd(c, ...)
            end
            local ok, err = pcall(
                original_update_buffer_lines,
                ns_id,
                bufnr,
                vim.list_slice(old_lines or {}, first),
                vim.list_slice(new_lines, first),
                skip_line_count + item_start[first]
            )
            vim.cmd = _cmd
            if not ok then error(err) end
        end

        -- <CR> in the input box is nvim-cmp's confirm mapping; with the popup
        -- closed it falls back to a plain newline. avante itself only submits on
        -- <CR> in normal mode (and <C-s> in insert mode), so typing a message
        -- and hitting Enter silently adds a line break instead of sending it.
        -- Make Enter send, keep <S-CR> for a line break and let the popup win
        -- while it is open.
        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("avante_input_enter", { clear = true }),
            pattern = "AvanteInput",
            callback = function(args)
                vim.keymap.set("i", "<CR>", function()
                    local has_cmp, cmp = pcall(require, "cmp")
                    if has_cmp
                        and cmp.visible()
                        and cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                    then
                        return
                    end

                    local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
                    if table.concat(lines, ""):match("^%s*$") then
                        -- Empty prompt: keep the usual behaviour.
                        vim.api.nvim_feedkeys(
                            vim.api.nvim_replace_termcodes("<CR>", true, false, true),
                            "n",
                            false
                        )
                        return
                    end

                    local sidebar = require("avante").get()
                    if sidebar then sidebar:submit_input() end
                end, { buffer = args.buf, desc = "Avante: send message" })

                vim.keymap.set("i", "<S-CR>", "<CR>", { buffer = args.buf, desc = "Avante: newline" })
            end,
        })

        -- State indicator ("generating", "thinking", ...). Avante draws it as a virt_lines
        -- extmark inside the text and rebuilds it on every streamed chunk: it flashes,
        -- pushes the text below it around, restarts its spinner at the first glyph, and
        -- its 160 ms timer keeps ticking (several at once) even when nothing is running.
        -- Show it in the result window's winbar instead, with one timer that only runs
        -- while the state is animated. The winbar belongs to sidebar_header when that
        -- is enabled, so then keep avante's own implementation.
        local original_render_state = Sidebar.render_state
        local original_clear_state = Sidebar.clear_state
        local animated_states = { generating = true, ["tool calling"] = true, thinking = true, compacting = true }
        local state_highlights = {
            ["tool calling"] = "AvanteStateSpinnerToolCalling",
            failed = "AvanteStateSpinnerFailed",
            succeeded = "AvanteStateSpinnerSucceeded",
            searching = "AvanteStateSpinnerSearching",
            thinking = "AvanteStateSpinnerThinking",
            compacting = "AvanteStateSpinnerCompacting",
        }
        local function winbar_state_enabled()
            return not require("avante.config").windows.sidebar_header.enabled
        end
        local function stop_state_timer(self)
            if self.state_timer then
                pcall(function()
                    self.state_timer:stop()
                end)
                self.state_timer = nil
            end
        end
        Sidebar.clear_state = function(self)
            if not winbar_state_enabled() then
                return original_clear_state(self)
            end
            -- Called on every streamed update: only stop the timer, keep the spinner position.
            stop_state_timer(self)
        end
        Sidebar.render_state = function(self)
            if not winbar_state_enabled() then
                return original_render_state(self)
            end
            stop_state_timer(self)
            local container = self.containers.result
            if not require("avante.utils").is_valid_container(container) then
                return
            end
            local winid = container.winid
            local state = self.current_state
            if not state then
                vim.api.nvim_set_option_value("winbar", "", { win = winid })
                return
            end
            local label = state
            if animated_states[state] then
                local chars = state == "thinking" and self.thinking_spinner_chars or self.state_spinner_chars
                self.state_spinner_idx = (self.state_spinner_idx or 0) % #chars + 1
                label = chars[self.state_spinner_idx] .. " " .. state
            end
            -- Blend the bar into the sidebar background.
            local winhighlight = vim.wo[winid].winhighlight
            if not winhighlight:find("WinBar:", 1, true) then
                vim.wo[winid].winhighlight = winhighlight
                    .. ",WinBar:AvanteSidebarNormal,WinBarNC:AvanteSidebarNormal"
            end
            local hl = state_highlights[state] or "AvanteStateSpinnerGenerating"
            vim.api.nvim_set_option_value("winbar", "%=%#" .. hl .. "# " .. label .. " %*%=", { win = winid })
            if animated_states[state] then
                self.state_timer = vim.defer_fn(function()
                    self:render_state()
                end, 160)
            end
        end

        -- Full replacement for avante's built-in "agentic" system prompt: the
        -- template is Cline/Cursor flavoured, ~250 lines of compulsory todos,
        -- "explain before every tool call" and contradictory tool rules that
        -- fight any appended guidance. Everything the agent actually needs to
        -- know is below; the tool schemas travel with the request, so nothing
        -- else has to be described in the prompt.
        local SYSTEM_PROMPT = [[
You are a coding agent running inside the user's Neovim editor, working for one user on one code base.

You act by calling tools, one step at a time. The user reads your answer in a narrow sidebar next to the code they are editing, and every file you change is visible to them immediately.

# Working
- Act as soon as you have enough information. Do not re-derive or re-ask what the conversation already established.
- Locate code with grep/glob/ls, then read only the parts you need with view. Anything you have not read in this session is unknown to you; re-read a file before editing it if it may have changed.
- Edit with str_replace using exact, minimal context. Use write_to_file for new files or full rewrites. Read a file before you edit it.
- Match the surrounding code: naming, formatting, comment density, idioms, error handling. Write comments in English, Google style, and only where the code cannot explain itself.
- Use bash for the project's real commands (build, tests, lints) and for file operations that have no dedicated tool.
- For work with three or more distinct steps, keep a short todo list with write_todos and update it as steps complete. Skip the list for simple questions.
- Independent lookups can be issued in the same turn.
- EVERY turn must end with a call to attempt_completion carrying the final answer; it is what closes the turn and what the user reads. Never finish a turn with plain text only: avante will re-ask you (up to three times) and the run is wasted.

# Answering
- Always answer in the language the user writes in.
- Start with the answer: no preamble, no restating the question, no recap of what you did.
- Prefer a few sentences and short lists; headings only when the answer truly has sections. No emoji.
- Refer to code as `path:line` instead of quoting long blocks, and never paste back a whole file you just edited.
- End with the answer, not with a question or an offer to continue.
- If a command or test fails, quote the relevant output and say what is still broken. Never claim success you did not verify.
- Do not commit, push, or run destructive commands unless the user explicitly asked.
]]

        local original_render_mode = Path.prompts.render_mode
        Path.prompts.render_mode = function(mode, opts)
            -- A project (or the rules dirs) may ship its own agentic template;
            -- avante announces it, so honour it instead of overriding blindly.
            if mode ~= "agentic" or (Path.prompts.custom_prompts_contents or {})["agentic"] then
                return original_render_mode(mode, opts)
            end
            local parts = { SYSTEM_PROMPT }
            -- Platform / shell / date / project root / git, rendered by avante.
            local environment = Path.prompts.render_file("_environments.avanterules", opts)
            if environment and environment ~= "" then
                table.insert(parts, environment)
            end
            return table.concat(parts, "\n")
        end

        require("avante").setup({
            provider = "ds41f",
            -- Tools that only duplicate what bash already does (git, mv, mkdir,
            -- python, undo) or that have no counterpart in the way this editor
            -- agent is used. Keeping them only gives the model more ways to
            -- wander; avante's own slash commands still work (they call the
            -- functions directly, not through the tool list).
            -- add_file_to_context / remove_file_from_context cannot be turned
            -- off here: avante appends them after the filter has run.
            disabled_tools = {
                "run_python",
                "git_diff",
                "git_commit",
                "move_path",
                "copy_path",
                "delete_path",
                "create_dir",
                "undo_edit",
                "insert",
                "think",
                "read_definitions",
                "read_file_toplevel_symbols",
                "delete_tool_use_messages",
            },
            --provider = "claude-code-acp",
            --provider = "copilot",
            --auto_suggestions_provider = "openai",
            --cursor_applying_provider = "openai",
            providers = {
                copilot = {
                    endpoint = "https://api.githubcopilot.com",
                    --model = "gpt-5.3-codex",
                    --model = "gpt-5-mini",
                    model = "gpt-4.1",
                    proxy = "http://127.0.0.1:7893", -- [protocol://]host[:port] Use this proxy
                    allow_insecure = false, -- Allow insecure server connections
                    timeout = 30000, -- Timeout in milliseconds
                    context_window = 64000, -- Number of tokens to send to the model for context
                    use_response_api = false, -- Automatically switch to Response API for GPT-5 Codex models
                    disable_tools = false,
                    use_ReAct_prompt = false,
                    support_previous_response_id = false,
                    extra_request_body = {
                        -- temperature is not supported by Response API for reasoning models
                        max_tokens = 20480,
                    },
                },
                gemini_flash = {
                    __inherited_from = "openai",
                    endpoint = os.getenv("AVANTE_ENDPOINT") or "http://llmapi.bilibili.co/v1",
                    model = os.getenv("AVANTE_MODEL") or "gemini-3.0-flash",
                    max_tokens = 102400,
                    timeout = 30000,
                    use_ReAct_prompt = false,
                    api_key_name = os.getenv("AVANTE_API_KEY_NAME") or "BSK_KEY",
                    disable_tools = false,
                    extra_request_body = {
                        max_tokens = 10240,
                        temperature = 1.0,
                        --stream = true,
                    },
                },
                ds41f = {
                    __inherited_from = "openai",
                    endpoint = os.getenv("AVANTE_ENDPOINT") or "http://llmapi.bilibili.co/v1",
                    model = os.getenv("AVANTE_MODEL") or "deepseek-v4.1-flash",
                    max_tokens = 102400,
                    timeout = 30000,
                    -- The model takes 1M tokens; avante compacts (summarises and
                    -- rewrites) the history once it passes 90% of this. At the
                    -- 128k default a long chat got compacted on submit, which
                    -- shrinks the answer buffer mid-stream and makes the window
                    -- jump around.
                    context_window = 1048576,
                    use_ReAct_prompt = false,
                    api_key_name = os.getenv("AVANTE_API_KEY_NAME") or "BSK_KEY",
                    disable_tools = false,
                    -- plenary curl never passes --no-buffer, so curl buffers the SSE
                    -- body into 16 KB pipe chunks: the answer arrives in a few bursts
                    -- and the buffer is rewritten from scratch each time. Ask curl to
                    -- flush every chunk so avante can render it as it is produced.
                    parse_curl_args = function(self, opts)
                        local spec = require("avante.providers").openai.parse_curl_args(self, opts)
                        if spec then
                            spec.rawArgs = vim.list_extend(spec.rawArgs or {}, { "--no-buffer" })
                        end
                        return spec
                    end,
                    -- avante drops reasoning_effort unless the model is o* / gpt-5*.
                    -- Keep the rest of its cleanup and skip only that step.
                    set_allowed_params = function(_, body)
                        if body.max_tokens then
                            body.max_completion_tokens = nil
                        end
                    end,
                    extra_request_body = {
                        max_tokens = 10240,
                        temperature = 1.0, -- ignored while thinking is enabled
                        thinking = { type = "enabled" },
                        reasoning_effort = "high", -- low | high | max
                        --stream = true,
                    },
                },
            },
            acp_providers = {
                ["claude-code-acp"] = {
                    command = "npx",
                    args = { "-y", "-g", "@zed-industries/claude-code-acp" },
                    env = {
                        NODE_NO_WARNINGS = "1",
                        ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY"),
                        ANTHROPIC_BASE_URL = os.getenv("ANTHROPIC_BASE_URL"),
                        ACP_PATH_TO_CLAUDE_CODE_EXECUTABLE = vim.fn.exepath("claude"),
                        ACP_PERMISSION_MODE = "bypassPermissions",
                    },
                    -- MCP Servers Configuration
                    -- Format: mcpServers is an ARRAY, each server config has a "name" field
                    -- Uncomment and configure the MCP servers you want to use
                    mcp_servers = {
                        -- Example 1: Filesystem MCP for file operations
                        -- {
                        --     name = "filesystem",
                        --     type = "stdio",
                        --     command = "npx",
                        --     args = { "-y", "@modelcontextprotocol/server-filesystem", vim.fn.expand("~") },
                        --     env = {},
                        -- },

                        -- Example 2: GitHub MCP for GitHub operations
                        -- {
                        --     name = "github",
                        --     type = "stdio",
                        --     command = "npx",
                        --     args = { "-y", "@modelcontextprotocol/server-github" },
                        --     env = {
                        --         GITHUB_PERSONAL_ACCESS_TOKEN = os.getenv("GITHUB_TOKEN"),
                        --     },
                        -- },

                        -- Example 3: Playwright MCP for browser automation
                        {
                            name = "playwright",
                            type = "stdio",
                            command = "npx",
                            args = { "@playwright/mcp@latest", "--isolated", "--browser=chrome" },
                            env = {},
                        },

                        -- Example 4: Brave Search MCP for web search
                        -- {
                        --     name = "brave-search",
                        --     type = "stdio",
                        --     command = "npx",
                        --     args = { "-y", "@modelcontextprotocol/server-brave-search" },
                        --     env = {
                        --         BRAVE_API_KEY = os.getenv("BRAVE_API_KEY"),
                        --     },
                        -- },

                        -- Example 5: PostgreSQL MCP for database operations
                        -- {
                        --     name = "postgres",
                        --     type = "stdio",
                        --     command = "npx",
                        --     args = { "-y", "@modelcontextprotocol/server-postgres", "postgresql://user:pass@localhost/dbname" },
                        --     env = {},
                        -- },

                        -- Example 6: SSE MCP server (remote)
                        -- {
                        --     name = "my-sse-server",
                        --     type = "sse",
                        --     url = "https://example.com/sse",
                        --     headers = {
                        --         Authorization = "Bearer your-api-key",
                        --     },
                        -- },

                        -- Example 7: HTTP MCP server (remote)
                        -- {
                        --     name = "my-http-server",
                        --     type = "http",
                        --     url = "https://example.com/mcp",
                        --     headers = {
                        --         Authorization = "Bearer your-api-key",
                        --     },
                        -- },
                    },
                },
            },
            slash_commands = {
                {
                    -- Runtime switch for the ds41f request body; resets on restart.
                    name = "effort",
                    description = "/effort low|high|max|on|off",
                    details = "Set DeepSeek reasoning effort, or switch thinking on/off",
                    callback = function(sidebar, args, cb)
                        local arg = vim.trim(args or "")
                        local body = require("avante.providers").ds41f.extra_request_body
                        local msg
                        if arg == "off" then
                            body.thinking = { type = "disabled" }
                            -- Keep the request consistent: effort is meaningless
                            -- with thinking disabled and some gateways reject it.
                            body.reasoning_effort = nil
                            msg = "thinking: off"
                        elseif arg == "on" then
                            body.thinking = { type = "enabled" }
                            msg = "thinking: on"
                        elseif arg == "low" or arg == "high" or arg == "max" then
                            body.thinking = { type = "enabled" }
                            body.reasoning_effort = arg
                            msg = "thinking: on, effort: " .. arg
                        else
                            msg = ("thinking: %s, effort: %s (usage: /effort low|high|max|on|off)"):format(
                                body.thinking and body.thinking.type or "default",
                                body.reasoning_effort or "default"
                            )
                        end
                        sidebar:update_content(msg, { focus = false, scroll = false })
                        -- avante clears the input box through this callback when
                        -- the command comes from the completion menu.
                        if cb then cb() end
                    end,
                },
            },
            behaviour = {
                auto_suggestions = false, -- Experimental stage
                auto_set_highlight_group = true,
                auto_set_keymaps = true,
                auto_apply_diff_after_generation = true,
                auto_approve_tool_permissions = true,
                support_paste_from_clipboard = false,
                minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
                enable_token_counting = false, -- Whether to enable token counting. Default to true.
                -- Do not shove the whole current file into every request; let the
                -- model locate and read what it needs.
                auto_add_current_file = false,
            },
            mappings = {
                --- @class AvanteConflictMappings
                diff = {
                    ours = "co",
                    theirs = "ct",
                    all_theirs = "ca",
                    both = "cb",
                    cursor = "cc",
                    next = "]x",
                    prev = "[x",
                },
                suggestion = {
                    accept = "¬",
                    next = "∆",
                    prev = "˚",
                    dismiss = "<C-]>",
                },
                jump = {
                    next = "]]",
                    prev = "[[",
                },
                submit = {
                    normal = "<CR>",
                    insert = "<C-s>",
                },
                cancel = {
                    normal = { "<C-c>", "<Esc>", "q" },
                    insert = { "<C-c>" },
                },
                sidebar = {
                    apply_all = "A",
                    apply_cursor = "a",
                    retry_user_request = "r",
                    edit_user_request = "e",
                    switch_windows = "<Tab>",
                    reverse_switch_windows = "<S-Tab>",
                    remove_file = "d",
                    add_file = "@",
                    close = { "<Esc>", "q" },
                    --close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
                    close_from_input = { normal = { "<C-c>", "q" }, insert = "<C-c>" },
                },
            },
            selection = {
                enabled = false,
                hint_display = "delayed",
            },
            windows = {
                ---@type "right" | "left" | "top" | "bottom"
                position = "right", -- the position of the sidebar
                wrap = true, -- similar to vim.o.wrap
                width = 45, -- default % based on available width
                sidebar_header = {
                    enabled = false, -- true, false to enable/disable the header
                    align = "center", -- left, center, right for title
                    rounded = false,
                },
                input = {
                    prefix = "> ",
                    height = 8, -- Height of the input window in vertical layout
                },
                edit = {
                    border = "rounded",
                    start_insert = true, -- Start insert mode when opening the edit window
                },
                ask = {
                    floating = false, -- Open the 'AvanteAsk' prompt in a floating window
                    start_insert = true, -- Start insert mode when opening the ask window
                    border = "rounded",
                    ---@type "ours" | "theirs"
                    focus_on_apply = "ours", -- which diff to focus after applying
                },
            },
        })
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")

    -- get the avante window ids by the window config
    _G.navigate_avante_window = function()
        local ai_win_id = {
            input = nil,
            output = nil,
            file = nil,
            code = nil,
        }
        local windows = vim.api.nvim_list_wins()
        for _, win_id in ipairs(windows) do
            local buf_id = vim.api.nvim_win_get_buf(win_id)
            local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf_id })

            if filetype == "Avante" then
                ai_win_id.output = ai_win_id.output or win_id
            elseif filetype == "AvanteInput" then
                ai_win_id.input = ai_win_id.input or win_id
            elseif filetype == "AvanteSelectedFiles" then
                ai_win_id.file = ai_win_id.file or win_id
            end
        end
        return ai_win_id
    end

    _G.restart_avante = function()
        -- Use pcall to ignore error if Avante is not initialized
        pcall(function()
            vim.cmd("AvanteClear")
        end)

        vim.cmd("AvanteRefresh")
        vim.cmd("AvanteFocus")
    end
    mappings.register({
        mode = { "n" },
        key = { "<leader>", "a", "a" },
        action = ":AvanteToggle<cr>",
        short_desc = "AvanteToggle",
    })

    mappings.register({
        mode = { "n" },
        key = { "<leader>", "a", "i" },
        action = ":lua restart_avante()<cr>",
        short_desc = "AvanteRestart",
    })
end

return plugin
