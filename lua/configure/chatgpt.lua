local plugin = {}

plugin.core = {
	"jackMort/ChatGPT.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	init = function() -- Specifies code to run before this plugin is loaded.
	end,

	config = function() -- Specifies code to run after this plugin is loaded

		require("chatgpt").setup({
			api_key_cmd = nil,
			yank_register = "+",
			edit_with_instructions = {
				diff = false,
				keymaps = {
					close = "<C-c>",
					accept = "<C-y>",
					toggle_diff = "<C-d>",
					toggle_settings = "<C-o>",
					cycle_windows = "<Tab>",
					use_output_as_input = "<C-r>",
				},
			},
			chat = {
				loading_text = "Loading, please wait ...",
				question_sign = "", -- 🙂
				answer_sign = "ﮧ", -- 🤖
				max_line_length = 120,
				sessions_window = {
					border = {
						style = "rounded",
						text = {
							top = " Sessions ",
						},
					},
					win_options = {
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
					},
				},
				keymaps = {
					close = { "<C-c>" },
					yank_last = "<C-y>",
					yank_last_code = "<C-k>",
					scroll_up = "<C-u>",
					scroll_down = "<C-d>",
					new_session = "<C-n>",
					cycle_windows = "<Tab>",
					cycle_modes = "<C-f>",
					next_message = "<C-j>",
					prev_message = "<C-k>",
					select_session = "<C-l>",
					rename_session = "r",
					delete_session = "d",
					draft_message = "<C-d>",
					edit_message = "e",
					delete_message = "d",
					toggle_settings = "<C-o>",
					toggle_message_role = "<C-r>",
					toggle_system_role_open = "<C-s>",
					stop_generating = "<C-x>",
				},
			},
			popup_layout = {
				default = "center",
				center = {
					width = "80%",
					height = "80%",
				},
				right = {
					width = "30%",
					width_settings_open = "50%",
				},
			},
			popup_window = {
				border = {
					highlight = "FloatBorder",
					style = "rounded",
					text = {
						top = " ChatGPT ",
					},
				},
				win_options = {
					wrap = true,
					linebreak = true,
					foldcolumn = "1",
					winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
				},
				buf_options = {
					filetype = "markdown",
				},
			},
			system_window = {
				border = {
					highlight = "FloatBorder",
					style = "rounded",
					text = {
						top = " SYSTEM ",
					},
				},
				win_options = {
					wrap = true,
					linebreak = true,
					foldcolumn = "2",
					winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
				},
			},
			popup_input = {
				prompt = "  ",
				border = {
					highlight = "FloatBorder",
					style = "rounded",
					text = {
						top_align = "center",
						top = " Prompt ",
					},
				},
				win_options = {
					winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
				},
				submit = "<C-Enter>",
				submit_n = "<Enter>",
				max_visible_lines = 20,
			},
			settings_window = {
				border = {
					style = "rounded",
					text = {
						top = " Settings ",
					},
				},
				win_options = {
					winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
				},
			},
			openai_params = {
				model = "gpt-3.5-turbo",
				frequency_penalty = 0,
				presence_penalty = 0,
				max_tokens = 800,
				temperature = 0,
				top_p = 1,
				n = 1,
			},
			openai_edit_params = {
				model = "gpt-3.5-turbo",
				frequency_penalty = 0,
				presence_penalty = 0,
				temperature = 0,
				top_p = 1,
				n = 1,
			},
			use_openai_functions_for_edits = false,
			actions_paths = {},
			show_quickfixes_cmd = "Trouble quickfix",
			predefined_chat_gpt_prompts = "https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv",
		})
	end,
}

plugin.mapping = function()
	local mappings = require("core.mapping")
    mappings.register({
        mode = {"n"},
        key = { "<leader>", 'a', 'c' },
        action = ":ChatGPTCompleteCode<cr>",
        short_desc = "ChatGPT CompleteCode"
    })
    mappings.register({
        mode = {"n"},
        key = { "<leader>", 'a', 'i' },
        action = ":ChatGPT<cr>",
        short_desc = "ChatGPT"
    })
    mappings.register({
        mode = {"n", "v"},
        key = { "<leader>", 'a', 'e' },
        action = ":ChatGPTEditWithInstruction<cr>",
        short_desc = "Edit with instruction"
    })
    mappings.register({
        mode = {"n", "v"},
        key = { "<leader>", 'a', 'g' },
        action = ":ChatGPTRun grammar_correction<cr>",
        short_desc = "Grammar Correction"
    })
    mappings.register({
        mode = {"n", "v"},
        key = { "<leader>", 'a', 't' },
        action = ":ChatGPTRun translate<cr>",
        short_desc = "Translate"
    })
    mappings.register({
        mode = {"n", "v"},
        key = { "<leader>", 'a', 'k' },
        action = ":ChatGPTRun keywords<cr>",
        short_desc = "Keywords"
    })
    mappings.register({
        mode = {"n", "v"},
        key = { "<leader>", 'a', 'd' },
        action = ":ChatGPTRun docstring<cr>",
        short_desc = "Docstring"
    })
    mappings.register({
        mode = {"n", "v"},
        key = { "<leader>", 'a', 'a' },
        action = ":ChatGPTRun add_tests<cr>",
        short_desc = "Add Tests"
    })
    mappings.register({
        mode = {"n", "v"},
        key = { "<leader>", 'a', 'o' },
        action = ":ChatGPTRun optimize_code<cr>",
        short_desc = "Optimize Code"
    })
    mappings.register({
        mode = {"n", "v"},
        key = { "<leader>", 'a', 's' },
        action = ":ChatGPTRun summarize<cr>",
        short_desc = "Summarize"
    })
    mappings.register({
        mode = {"n", "v"},
        key = { "<leader>", 'a', 'f' },
        action = ":ChatGPTRun fix_bugs<cr>",
        short_desc = "Fix Bugs"
    })
    mappings.register({
        mode = {"n", "v"},
        key = { "<leader>", 'a', 'x' },
        action = ":ChatGPTRun explain_code<cr>",
        short_desc = "Explain Code"
    })
    mappings.register({
        mode = {"n", "v"},
        key = { "<leader>", 'a', 'r' },
        action = ":ChatGPTRun roxygen_edit<cr>",
        short_desc = "Roxygen Edit"
    })
    mappings.register({
        mode = {"n", "v"},
        key = { "<leader>", 'a', 'l' },
        action = ":ChatGPTRun code_readability_analysis<cr>",
        short_desc = "Code Readability Analysis"
    })

end

return plugin
