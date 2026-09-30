local plugin = {}

plugin.core = {

    "skywind3000/asynctasks.vim",
    --"cstsunfu/asynctasks.vim", --FIXME: when this buf fix, change to the default repo. https://github.com/skywind3000/asynctasks.vim/issues/92
    cmd = { "AsyncTask", "AsyncRun", "AsyncStop" },

    dependencies = { {
        "skywind3000/asyncrun.vim",
    } },

    init = function() -- Specifies code to run before this plugin is loaded.
        vim.g.asynctasks_extra_config = { vim.g.CONFIG .. "/tasks.ini" }
        -- asynctasks defaults g:asynctasks_term_pos to "quickfix", which renders
        -- output=terminal tasks in the quickfix window. There ANSI colors are
        -- printed literally and nothing is highlighted, so use a real terminal.
        vim.g.asynctasks_term_pos = "bottom"
        vim.g.asynctasks_term_rows = 15
        -- asyncrun defaults bufhidden to "wipe" for terminal buffers once the job
        -- ends, and Neovim closes such a window as soon as any key is pressed in
        -- it. That deletes the output before it can be copied. Keep the buffer
        -- instead: hide it when switching away, wipe only on :bd.
        vim.g.asyncrun_term_wipe = 0
        vim.g.asynctasks_term_hidden = 1
        vim.env.NVIM_TYPESCRIPT_TOOLS = vim.fn.stdpath("data") .. "/typescript-tools"
        vim.g.asyncrun_rootmarks = {
            "package-lock.json",
            "yarn.lock",
            "pnpm-lock.yaml",
            "bun.lockb",
            "bun.lock",
            "tsconfig.json",
            "package.json",
            ".git",
            ".svn",
            ".root",
            ".project",
            ".hg",
        }
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        vim.g.asyncrun_open = 8
        vim.g.asyncrun_bell = 1

        -- Terminal output renders ANSI colors but has no jump targets. After the
        -- job ends, parse the (already de-colored) screen lines into the quickfix
        -- list, so colors and `:cnext` work together. Unmatched lines are dropped,
        -- and entries whose file cannot be found are filtered out.
        local function terminal_to_quickfix(buf)
            local name = vim.api.nvim_buf_get_name(buf)
            -- Neovim names terminal buffers "term://<cwd>//<id>:<cmd>"; the job
            -- ran in <cwd>, so relative paths in the output resolve there.
            local dir = name:match("^term://(.-)//%d+:")
            dir = dir and vim.fn.expand(dir) or vim.fn.getcwd()
            local use_dir = vim.fn.isdirectory(dir) == 1

            local ok, lines = pcall(vim.api.nvim_buf_get_lines, buf, 0, -1, false)
            if not ok then
                return
            end

            local task = vim.b[buf].asyncrun_name
            local title = (task and task ~= "") and ("AsyncRun: " .. task) or "AsyncRun"
            local efm = table.concat({
                "%f(%l\\,%c):\\ %m", -- tsc: src/a.ts(3,5): error TS2304: ...
                "%f:%l:%c:\\ %m", -- eslint / clang: src/a.ts:3:5: error: ...
                "%f:%l:%c\\ %m", -- go: a.go:3:5: message
                "%f:%l:%c\\ -\\ %m", -- tsc --pretty: src/a.ts:3:5 - error TS2304: ...
                "%f:%l:%c", -- vitest stack: ❯ src/a.test.ts:42:15
                "%f:%l:\\ %m", -- generic file:line: message
                "%-G%.%#", -- ignore everything else
            }, ",")

            -- Test runners prefix stack frames with "❯ " / "✗ ", which would end
            -- up inside the filename. Lua patterns are byte based, so strip any
            -- leading run that cannot start a path instead of naming the glyphs.
            local cleaned = {}
            for i, line in ipairs(lines) do
                cleaned[i] = (line:gsub("^[^%w%._~/%-]+", ""))
            end

            local before = {}
            for _, b in ipairs(vim.api.nvim_list_bufs()) do
                before[b] = true
            end

            -- %f resolves relative paths against the current directory; parse
            -- from the directory the task actually ran in.
            local previous = vim.fn.getcwd()
            if use_dir then
                vim.cmd("noautocmd lcd " .. vim.fn.fnameescape(dir))
            end
            vim.fn.setqflist({}, " ", { lines = cleaned, efm = efm, title = title })
            if use_dir then
                vim.cmd("noautocmd lcd " .. vim.fn.fnameescape(previous))
            end

            local items = {}
            for _, item in ipairs(vim.fn.getqflist({ items = 1 }).items) do
                local file = item.filename
                if (file == nil or file == "") and item.bufnr > 0 then
                    file = vim.api.nvim_buf_get_name(item.bufnr)
                end
                file = (file or ""):gsub("^[^%w%._~/%-]+", "")
                if file ~= "" and not file:match("^/") then
                    file = dir .. "/" .. file
                end
                if file ~= "" and vim.fn.filereadable(file) == 1 then
                    item.filename = file
                    item.bufnr = 0
                    item.valid = 1
                    items[#items + 1] = item
                elseif item.bufnr > 0 and not before[item.bufnr] then
                    -- Parsing created an empty buffer for a bogus path; drop it.
                    pcall(vim.api.nvim_buf_delete, item.bufnr, { force = true })
                end
            end
            -- setqflist() rejects a non-empty list together with a "what" dict,
            -- so the entries and the title go through the "items" key instead.
            vim.fn.setqflist({}, " ", { items = items, title = title })
            if #items > 0 then
                vim.notify(("%s: %d jump target(s), ;qo to open"):format(title, #items), vim.log.levels.INFO)
            end
        end

        -- asyncrun leaves you in terminal insert mode after the job exits, and
        -- Neovim throws away the window on the next keystroke typed into a
        -- finished terminal. Drop back to normal mode on exit so the output
        -- stays readable and yankable.
        vim.api.nvim_create_autocmd("TermClose", {
            callback = function(args)
                if not vim.b[args.buf].asyncrun_bid then
                    return
                end
                if vim.api.nvim_get_current_buf() == args.buf then
                    vim.cmd("stopinsert")
                end
                terminal_to_quickfix(args.buf)
            end,
        })
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    local function is_typescript()
        return vim.tbl_contains({ "typescript", "typescriptreact" }, vim.bo.filetype)
    end

    -- package.json / tsconfig.json mark a TypeScript project. The TS tasks work
    -- on the project root, so they are useful from these buffers too.
    local function manifest_name()
        local name = vim.fn.expand("%:t")
        if name == "package.json" or name == "tsconfig.json" then
            return name
        end
    end

    local function is_typescript_project()
        return is_typescript() or manifest_name() ~= nil
    end

    local function run_package_script()
        local file = vim.api.nvim_buf_get_name(0)
        local dir = vim.fn.fnamemodify(file, ":p:h")
        local ok, pkg = pcall(function()
            return vim.json.decode(table.concat(vim.fn.readfile(file), "\n"))
        end)
        local scripts = (ok and type(pkg) == "table" and type(pkg.scripts) == "table") and pkg.scripts or {}
        local names = vim.tbl_keys(scripts)
        table.sort(names)
        if #names == 0 then
            vim.notify("No scripts in " .. file, vim.log.levels.WARN)
            return
        end

        local function exists(name)
            return vim.fn.filereadable(dir .. "/" .. name) == 1
        end

        local pm = "npm"
        if exists("pnpm-lock.yaml") then
            pm = "pnpm"
        elseif exists("yarn.lock") then
            pm = "yarn"
        elseif exists("bun.lock") or exists("bun.lockb") then
            pm = "bun"
        end

        vim.ui.select(names, {
            prompt = pm .. " run",
            format_item = function(name)
                return name .. "  ->  " .. scripts[name]
            end,
        }, function(choice)
            if choice == nil then
                return
            end
            -- `PATH=...` must stay unquoted so the shell expands $PATH.
            vim.cmd(
                ("AsyncRun -mode=term -save=1 PATH=/opt/homebrew/opt/node@22/bin:$PATH; export PATH; cd %s && %s run %s"):format(
                    vim.fn.shellescape(dir),
                    pm,
                    vim.fn.shellescape(choice)
                )
            )
        end)
    end

    _G.async_file_build = function()
        vim.cmd("AsyncTask " .. (is_typescript_project() and "typescript-build" or "file-build"))
    end

    _G.async_file_run = function()
        if is_typescript() then
            vim.cmd("AsyncTask typescript-run")
        elseif manifest_name() == "package.json" then
            run_package_script()
        elseif manifest_name() == "tsconfig.json" then
            vim.notify("tsconfig.json has no run target, use <leader>qb to type-check", vim.log.levels.WARN)
        else
            vim.cmd("AsyncTask file-run")
        end
    end

    _G.async_file_test = function()
        if is_typescript_project() then
            vim.cmd("AsyncTask typescript-test")
        else
            vim.notify("No test task for filetype: " .. vim.bo.filetype, vim.log.levels.WARN)
        end
    end

    mappings.register({
        mode = "n",
        key = { "<leader>", "q", "b" },
        action = "<cmd>lua async_file_build()<cr>",
        short_desc = "Quick Build",
        silent = true,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "q", "r" },
        action = "<cmd>lua async_file_run()<cr>",
        short_desc = "Quick Run",
        silent = true,
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "q", "t" },
        action = "<cmd>lua async_file_test()<cr>",
        short_desc = "Quick Test",
        silent = true,
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "q", "g" },
        action = nil,
        short_desc = "Quick Grep",
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "q", "g", "c" },
        action = "<cmd>AsyncTask quickfix-rg-grep<cr>",
        short_desc = "Quick Grep Current Path",
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "q", "g", "p" },
        action = "<cmd>AsyncTask quickfix-rg-grep-project<cr>",
        short_desc = "Quick Grep Project Path",
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "q", "g", "f" },
        action = "<cmd>AsyncTask quickfix-rg-grep-filetype<cr>",
        short_desc = "Quick Grep Current Path File Types",
    })
end
return plugin
