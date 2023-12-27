local plugin = {}

plugin.core = {
	"neovim/nvim-lspconfig",
	build = ":MasonUpdate",
	dependencies = {
		"plenary.nvim",
		"williamboman/mason.nvim",
		{ "williamboman/mason-lspconfig.nvim", enabled = vim.g.feature_groups.lsp == "builtin" },
		{ "hrsh7th/nvim-cmp", enabled = vim.g.feature_groups.lsp == "builtin" },
	},
	init = function() -- Specifies code to run before this plugin is loaded.
	end,

	config = function() -- Specifies code to run after this plugin is loaded
		-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}
		local Path = require("plenary.path")
		local global_fun = require("util.global")
		-- Ensure the servers above are installed
		local mason_lspconfig = require("mason-lspconfig")
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
		local servers = {
			bashls = {
				cmd = { "bash-language-server", "start" },
				filetypes = { "sh" },
				single_file_support = true,
			},
			lua_ls = {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
				filetypes = { "lua" },
			},
			grammarly = {
				filetypes = { "markdown", "vimwiki", "vimwiki.markdown.pandoc", "pandoc" },
			},
			pyright = {
				root_dir = function(fname)
					local split_path = {}
					local path = Path:new(fname)
					local lib_flag = false
					for _, value in pairs(path:_split()) do
						if value == "lib" then
							lib_flag = true
						end
						if value ~= nil and value ~= "" and lib_flag then
							table.insert(split_path, value)
						end
					end
					if
						#split_path >= 4
						and string.find(split_path[2], "python") ~= nil
						and split_path[3] == "site-packages"
					then
						for _ = 1, #split_path - 4, 1 do
							path = path:parent()
						end
						return path.filename
					end
					local root =
						util.root_pattern(".git", "setup.py", "setup.cfg", "pyproject.toml", "requirements.txt")(fname) -- or util.path.dirname(fname)
					if root == vim.g.HOME_PATH or root == nil then
						return nil
					end
					return root
				end,
				cmd = { "pyright-langserver", "--stdio" },
				filetypes = { "python" },
				flags = {
					debounce_text_changes = 150,
				},
				settings = {
					python = {
						analysis = {
							autoImportCompletions = true,
							autoSearchPaths = true,
							diagnosticMode = "openFilesOnly", -- or "workspace"
							stubPath = "typings", --or ""
							typeshedPaths = {},
							useLibraryCodeForTypes = true,
						},
						linting = {
							enabled = false,
						},
						pythonPath = global_fun.which_python(),
						--venvPath = "/home/sun/anaconda3/envs/dlkit",
					},
				},
				single_file_support = true,
			},
			sqlls = {
				cmd = { "sql-language-server", "up", "--method", "stdio" },
				filetypes = { "sql", "mysql" },
				single_file_support = true,
			},
			clangd = {
				capabilities = { offsetEncoding = { "utf-16" } },
			},
			tsserver = {},
		}
		mason_lspconfig.setup({
			ensure_installed = vim.tbl_keys(servers),
		})
		for server_name, server_config in pairs(servers) do
			local common_config = {
				capabilities = capabilities,
				on_attach = function(_, _) end,
			}
			server_config = vim.tbl_deep_extend("force", common_config, server_config)
			require("lspconfig")[server_name].setup(server_config)
		end
		require("configure.lsp_config.default_setting")
	end,
}

plugin.mapping = function()
	local mappings = require("core.mapping")
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
