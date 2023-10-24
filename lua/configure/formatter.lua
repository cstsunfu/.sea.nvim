local plugin = {}

plugin.core = {
	"stevearc/conform.nvim",
	dependencies = { "williamboman/mason.nvim" },
	init = function() -- Specifies code to run before this plugin is loaded.
	end,

	config = function() -- Specifies code to run after this plugin is loaded
		-- Utilities for creating configurations
		-- After add a formatter should update the mason.lua file to install the formatter
		require("conform").setup({
            formatters = {
                sqlformatter = {
                    command = "sql-formatter",
                    args = { "--config", "/Users/fu.sun/.sea.nvim/sql-formatter.json" }
                }
            },
			formatters_by_ft = {
				lua = { "stylua" },
				sql = { "pg_format" },
				--sql = { "pg_format" },
				-- Conform will run multiple formatters sequentially
				python = { "isort", "black" },
				-- Use a sub-list to run only the first available formatter
				javascript = { { "prettierd", "prettier" } },
				["*"] = { "codespell" },
				-- Use the "_" filetype to run formatters on filetypes that don't
				-- have other formatters configured.
				["_"] = { "trim_whitespace" },
			},
		})
		--require("conform").formatters.sql_formatter.args = { "--config", vim.g.CONFIG .. "/sql-formmater.sql" }
        --require("conform.formatters.sql_formatter").args = { "--config", "/Users/fu.sun/.sea.nvim/sql-formatter.json" }
        --require("conform.formatters.sql_formatter").args = function(ctx)
        --    local args = { "--stdin-filepath", "$FILENAME" }
        --    local found = vim.fs.find(".custom-config.json", { upward = true, path = ctx.dirname })[1]
        --    if found then
        --        vim.list_extend(args, { "--config", found })
        --    end
        --    return args
        --end
	end,
}

plugin.mapping = function()
	local mappings = require("core.mapping")

	mappings.register({
		mode = { "v", "x", "n" },
		key = { "<leader>", "=" },
		action = ':lua require("conform").format({ async = true, lsp_fallback = true })<cr>',
		short_desc = "Auto Format",
	})
end

return plugin
