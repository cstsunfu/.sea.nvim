local plugin = {}

plugin.core = {
	"hedyhli/outline.nvim", -- the fork version, casued by the original repo has some bugs and not active for a long time.
	--"simrat39/symbols-outline.nvim", -- when the original repo fix all the bugs, we will change back to the original repo. https://github.com/simrat39/symbols-outline.nvim/issues/176
	init = function() -- Specifies code to run before this plugin is loaded.
	end,

	config = function() -- Specifies code to run after this plugin is loaded
		local opts = {
			guides = {
				enabled = false,
			},
			keymaps = {
				close = { "q" },
				fold = "h",
				fold_all = "H",
				fold_reset = "R",
				goto_location = "<Cr>",
				hover_symbol = "s",
				peek_location = "o",
				rename_symbol = "r",
				toggle_preview = "K",
				unfold = "l",
				unfold_all = "L",
			},
			outline_items = {
				highlight_hovered_item = true,
				show_symbol_details = true,
			},
			outline_window = {
                auto_jump=true,
				auto_close = false,
				position = "left",
				relative_width = true,
				show_numbers = false,
				show_relative_numbers = false,
				width = 18,
				wrap = false,
			},
			preview_window = {
				auto_preview = false,
				border = "rounded",
				winhl = "Normal:Pmenu",
			},
			provider = {
				lsp = {
					blacklist_clients = {},
				},
			},
			symbol_folding = {
				auto_unfold_hover = true,
				markers = { "", "" },
			},
			symbols = {
				--filter = {
				--    exclude = true,
				--},
                filter = nil,
				icons = {
					Array = {
						hl = "@constant",
						icon = "",
					},
					Boolean = {
						hl = "@boolean",
						icon = "",
					},
					Component = {
						hl = "@function",
						icon = "",
					},
					Constant = {
						hl = "@constant",
						icon = "",
					},
					Constructor = {
						hl = "@constructor",
						icon = "",
					},
					Enum = {
						hl = "@type",
						icon = "ℰ",
					},
					EnumMember = {
						hl = "@field",
						icon = "",
					},
					Event = {
						hl = "@type",
						icon = "",
					},
					Field = {
						hl = "@field",
						icon = "",
					},
					File = {
						hl = "@text.uri",
						icon = "",
					},
					Fragment = {
						hl = "@constant",
						icon = "",
					},
					Function = {
						hl = "@function",
						icon = "ƒ",
					},
					Interface = {
						hl = "@type",
						icon = "ﰮ",
					},
					Key = {
						hl = "@type",
						icon = "",
					},
					Method = {
						hl = "@method",
						icon = "ƒ",
					},
					Module = {
						hl = "@namespace",
						icon = "",
					},
					Null = {
						hl = "@type",
						icon = " ",
					},
					Number = {
						hl = "@number",
						icon = "#",
					},
					Object = {
						hl = "@type",
						icon = "",
					},
					Operator = {
						hl = "@operator",
						icon = "",
					},
					Package = {
						hl = "@namespace",
						icon = "",
					},
					Property = {
						hl = "@method",
						icon = "",
					},
					String = {
						hl = "@string",
						icon = "𝓢",
					},
					Struct = {
						hl = "@type",
						icon = "ﴯ",
					},
					TypeParameter = {
						hl = "@parameter",
						icon = "",
					},
					Variable = {
						hl = "@constant",
						icon = "",
					},
				},
			},
		}

		require("outline").setup(opts)
	end,
}
plugin.mapping = function()
	local mappings = require("core.mapping")
	mappings.register({
		mode = "n",
		key = { "<leader>", "t", "l" },
		action = ":Outline<cr>",
		short_desc = "Tag List",
		silent = true,
	})
end
return plugin
