local plugin = {}

plugin.core = {
    "neovim/nvim-lspconfig",
    build = ":MasonUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    dependencies = {
        "plenary.nvim",
        "williamboman/mason.nvim",
        { "williamboman/mason-lspconfig.nvim", enabled = vim.g.feature_groups.lsp == "builtin" },
        { "hrsh7th/nvim-cmp", enabled = vim.g.feature_groups.lsp == "builtin" },
    },
    init = function() -- Specifies code to run before this plugin is loaded.
    end,
    config = function() -- Specifies code to run after this plugin is loaded
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }

        local Path = require("plenary.path")
        local global_fun = require("util.global")
        local mason_lspconfig = require("mason-lspconfig")
        local lspconfig = require("lspconfig")
        local configs = require("lspconfig.configs")
        local util = require("lspconfig.util")

        require("mason").setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
                border = "single",
            },
        })

        if not configs.intc_lsp then
            configs.intc_lsp = {
                default_config = {
                    cmd = { "intc-lsp" },
                    filetypes = { "json", "jsonc", "hjson" },
                    root_dir = function(fname)
                        return util.root_pattern(".intc.json", ".intc.jsonc")(fname)
                    end,
                    single_file_support = false,
                },
                docs = {
                    description = [[ intc language server ]],
                },
            }
        end

        local mason_servers = {
            bashls = {
                cmd = { "bash-language-server", "start" },
                filetypes = { "sh" },
                single_file_support = true,
                autostart = false,
            },
            lua_ls = {
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                    },
                },
                filetypes = { "lua" },
                autostart = false,
            },
            jsonls = {
                autostart = false,
            },
            pyright = {
                autostart = true,
                root_dir = function(fname)
                    local root = util.root_pattern(
                        "pyproject.toml",
                        "setup.py",
                        "setup.cfg",
                        "requirements.txt",
                        "Pipfile",
                        ".git"
                    )(fname)
                    if root then
                        return root
                    end
                    local file_dir = vim.fs.dirname(fname)
                    if file_dir and file_dir ~= "" then
                        return file_dir
                    end
                    return vim.loop.cwd()
                end,
                settings = {
                    python = {
                        analysis = {
                            autoImportCompletions = true,
                            autoSearchPaths = true,
                            diagnosticMode = "openFilesOnly",
                            useLibraryCodeForTypes = true,
                        },
                        linting = { enabled = false },
                    },
                },
            },
            sqlls = {
                cmd = { "sql-language-server", "up", "--method", "stdio" },
                filetypes = { "sql", "mysql" },
                single_file_support = true,
                autostart = false,
            },
            clangd = {
                autostart = false,
            },
            ts_ls = {
                autostart = false,
            },
            --gopls = {
            --    autostart = false,
            --},
        }

        mason_lspconfig.setup({
            ensure_installed = vim.tbl_keys(mason_servers),
            automatic_enable = false,
        })

        local common_config = {
            capabilities = capabilities,
            on_attach = function(_, _) end,
        }

        for server_name, server_config in pairs(mason_servers) do
            server_config = vim.tbl_deep_extend("force", common_config, server_config)
            lspconfig[server_name].setup(server_config)
        end

        lspconfig.intc_lsp.setup(common_config)

        require("configure.lsp_config.default_setting")
    end,
}
plugin.mapping = function()
    local mappings = require("core.mapping")

    -- Centralized filetype to server mapping.
    local filetype_servers = {
        sh = { "bashls" },
        lua = { "lua_ls" },
        json = { "jsonls", "intc_lsp" },
        jsonc = { "jsonls", "intc_lsp" },
        hjson = { "intc_lsp" },
        python = { "pyright" },
        sql = { "sqlls" },
        mysql = { "sqlls" },
        c = { "clangd" },
        cpp = { "clangd" },
        objc = { "clangd" },
        objcpp = { "clangd" },
        javascript = { "ts_ls" },
        javascriptreact = { "ts_ls" },
        typescript = { "ts_ls" },
        typescriptreact = { "ts_ls" },
        go = { "gopls" },
    }

    -- Commands and keymaps for manual LSP lifecycle control in multi-instance workflow.
    local function stop_all_lsp_clients(silent)
        local clients = vim.lsp.get_clients()
        for _, client in ipairs(clients) do
            vim.lsp.stop_client(client.id)
        end
        if not silent then
            vim.notify("Stopped all active LSP clients.", vim.log.levels.INFO)
        end
    end

    local function stop_inactive_lsp_clients()
        local attached = {}
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) then
                for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
                    attached[client.id] = true
                end
            end
        end
        for _, client in ipairs(vim.lsp.get_clients()) do
            if not attached[client.id] then
                vim.lsp.stop_client(client.id)
            end
        end
        vim.notify("Stopped all inactive LSP clients.", vim.log.levels.INFO)
    end

    vim.api.nvim_create_user_command("LspStopAll", function()
        stop_all_lsp_clients()
    end, { desc = "Stop all active LSP clients in current buffer" })

    vim.api.nvim_create_user_command("LspStopInactive", function()
        stop_inactive_lsp_clients()
    end, { desc = "Stop all inactive LSP clients" })

    mappings.register({
        mode = { "n" },
        key = { ";", "l", "s" },
        action = ":LspStartCurrent<cr>",
        short_desc = "LSP Start Current",
    })

    mappings.register({
        mode = { "n" },
        key = { ";", "l", "S" },
        action = ":LspStopAll<cr>",
        short_desc = "LSP Stop Current Buffer",
    })

    vim.api.nvim_create_user_command("LspStartCurrent", function()
        local ft = vim.bo.filetype
        local filetype_servers = {
            sh = { "bashls" },
            lua = { "lua_ls" },
            json = { "jsonls", "intc_lsp" },
            jsonc = { "jsonls", "intc_lsp" },
            hjson = { "intc_lsp" },
            python = { "pyright" },
            sql = { "sqlls" },
            mysql = { "sqlls" },
            c = { "clangd" },
            cpp = { "clangd" },
            objc = { "clangd" },
            objcpp = { "clangd" },
            javascript = { "ts_ls" },
            javascriptreact = { "ts_ls" },
            typescript = { "ts_ls" },
            typescriptreact = { "ts_ls" },
            go = { "gopls" },
        }

        local server_names = filetype_servers[ft] or {}
        if #server_names == 0 then
            vim.notify("No configured LSP server for current filetype: " .. ft, vim.log.levels.WARN)
            return
        end

        local lspconfig = require("lspconfig")
        local started_count = 0

        for _, server_name in ipairs(server_names) do
            local server = lspconfig[server_name]
            if server and server.manager and server.manager.try_add then
                server.manager:try_add(0)
                started_count = started_count + 1
            end
        end

        if started_count == 0 then
            vim.notify("Failed to start LSP for current buffer.", vim.log.levels.ERROR)
            return
        end

        vim.notify("LSP start requested for filetype: " .. ft, vim.log.levels.INFO)
    end, { desc = "Start configured LSP clients for current buffer" })

    local idle_ms = 30 * 60 * 1000
    local idle_timer = vim.uv.new_timer()
    local lsp_suspended_by_idle = false

    local function stop_all_lsp_clients(silent)
        local clients = vim.lsp.get_clients()
        for _, client in ipairs(clients) do
            vim.lsp.stop_client(client.id)
        end
        if not silent then
            vim.notify("Stopped all active LSP clients.", vim.log.levels.INFO)
        end
    end

    -- Function to start LSP for a specific buffer.
    local function start_lsp_for_buffer(bufnr)
        local ft = vim.bo[bufnr].filetype
        local server_names = filetype_servers[ft] or {}
        local success = false

        local lspconfig = require("lspconfig")
        for _, server_name in ipairs(server_names) do
            local server = lspconfig[server_name]
            if server and server.manager and server.manager.try_add then
                server.manager:try_add(bufnr)
                success = true
            end
        end

        -- Explicitly restart Copilot for the buffer using its internal API.
        local copilot_ok, copilot_client = pcall(require, "copilot.client")
        if copilot_ok and copilot_client then
            -- Make sure Copilot is globally enabled before trying to attach.
            pcall(function()
                local cmd_ok, copilot_cmd = pcall(require, "copilot.command")
                if cmd_ok and copilot_cmd.enable then
                    copilot_cmd.enable()
                end
            end)
            if type(copilot_client.buf_attach) == "function" then
                -- Use force=true to ensure it re-attaches even if it was previously stopped.
                copilot_client.buf_attach(true, bufnr)
                success = true
            end
        end

        return success
    end

    vim.api.nvim_create_user_command("LspStartCurrent", function()
        if start_lsp_for_buffer(0) then
            vim.notify("LSP start requested for current buffer (including Copilot).", vim.log.levels.INFO)
        else
            vim.notify("No configured LSP server for current filetype.", vim.log.levels.WARN)
        end
    end, { desc = "Start configured LSP clients for current buffer" })

    local function start_lsp_for_loaded_buffers(silent)
        local started_any = false
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) then
                if start_lsp_for_buffer(buf) then
                    started_any = true
                end
            end
        end

        if not silent then
            if started_any then
                vim.notify("Requested LSP start for loaded buffers (including Copilot).", vim.log.levels.INFO)
            else
                vim.notify("No configured LSP server for loaded buffers.", vim.log.levels.WARN)
            end
        end

        return started_any
    end

    local function maybe_resume_lsp_after_idle()
        if not lsp_suspended_by_idle then
            return
        end
        start_lsp_for_loaded_buffers(true)
        lsp_suspended_by_idle = false
        vim.notify("Resumed LSP clients after idle suspension.", vim.log.levels.INFO)
    end

    local function reset_idle_timer()
        if not idle_timer then
            return
        end
        vim.notify("Resetting LSP idle timer.", vim.log.levels.DEBUG)
        idle_timer:stop()
        idle_timer:start(
            idle_ms,
            0,
            vim.schedule_wrap(function()
                stop_all_lsp_clients(true)
                lsp_suspended_by_idle = true
                vim.notify("Stopped all LSP clients due to long idle.", vim.log.levels.INFO)
            end)
        )
    end

    vim.api.nvim_create_autocmd({ "InsertEnter" }, {
        callback = function()
            maybe_resume_lsp_after_idle()
            reset_idle_timer()
        end,
    })

    vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
            stop_all_lsp_clients(true)
            lsp_suspended_by_idle = true
            vim.notify("Stopped all LSP clients on focus lost.", vim.log.levels.INFO)
        end,
    })

    vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
            if idle_timer then
                idle_timer:stop()
                idle_timer:close()
            end
        end,
    })

    reset_idle_timer()
    mappings.register({
        mode = "n",
        key = { "<leader>", "l", "c" },
        action = "<cmd>Mason<cr>",
        short_desc = "Lsp Config",
        silent = false,
    })

    mappings.register({
        mode = "n",
        key = { "g", "d" },
        action = "<cmd>lua vim.lsp.buf.definition()<cr>",
        short_desc = "Goto Definition",
        silent = false,
    })
    --mappings.register({
    --    mode = "n",
    --    key = { "g", "D" },
    --    action = '<cmd>lua vim.lsp.buf.declaration()<cr>',
    --    short_desc = "Goto Declaration",
    --    silent = false
    --})
    mappings.register({
        mode = "n",
        key = { "g", "r" },
        action = "<cmd>lua vim.lsp.buf.references()<cr>",
        short_desc = "Goto References",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "g", "i" },
        action = "<cmd>lua vim.lsp.buf.implementation()<cr>",
        short_desc = "Goto Implementation",
        silent = false,
    })

    --mappings.register({
    --    mode = "n",
    --    key = { "K" },
    --    action = '<cmd>lua vim.lsp.buf.hover()<cr>',
    --    short_desc = "Displays Hover",
    --    desc = "Displays hover information about the symbol under the cursor in a floating window. Calling the function twice will jump into the floating window.",
    --    silent = false
    --})
    mappings.register({
        mode = "n",
        key = { "<leader>", "s", "n" },
        action = "<cmd>lua vim.diagnostic.goto_next()<cr>",
        short_desc = "Prev Diagnostic",
        silent = true,
    })
    mappings.register({
        mode = "n",
        key = { "]", "e" },
        action = "<cmd>lua vim.diagnostic.goto_next()<cr>",
        short_desc = "Next Diagnostic",
        silent = true,
    })
    mappings.register({
        mode = "n",
        key = { "[", "e" },
        action = "<cmd>lua vim.diagnostic.goto_prev()<cr>",
        short_desc = "Prev Diagnostic",
        silent = true,
    })
    mappings.register({
        mode = "n",
        key = { "<C-p>" },
        action = "<cmd>lua vim.diagnostic.goto_prev()<cr>",
        short_desc = "Next Diagnostic",
        silent = false,
    })
end
return plugin
