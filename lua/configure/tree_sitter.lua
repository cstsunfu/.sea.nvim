local plugin = {}

plugin.core = {
	"nvim-treesitter/nvim-treesitter",
	dependencies = { { "HiPhish/nvim-ts-rainbow2" } },
	build = ":TSUpdate",

	init = function() -- Specifies code to run before this plugin is loaded.
	end,

	config = function() -- Specifies code to run after this plugin is loaded
		local rainbow = require("ts-rainbow")
		require("nvim-treesitter.configs").setup({
			rainbow = { -- for rainbow pair
				enable = false,
				disable = {}, -- disable filetype
				query = {
					"rainbow-parens",
				},
				strategy = rainbow.strategy.global,
				hlgroups = {
					"TSRainbowGreen",
					"TSRainbowRed",
					"TSRainbowViolet",
					"TSRainbowOrange",
					"TSRainbowYellow",
					"TSRainbowCyan",
					"TSRainbowBlue",
				},
			},
			ensure_installed = {
				"bash",
				"bibtex",
				"c",
				"cmake",
				"cpp",
				"css",
				"dockerfile",
				"go",
				"hjson",
				"markdown",
				"markdown_inline",
				"html",
				"java",
				"javascript",
				"json",
				"json5",
				"jsonc",
				"latex",
				"lua",
				"make",
				"org",
				"perl",
				"python",
				"rust",
				"typescript",
				"scheme",
				"scss",
				"toml",
				"vim",
				"yaml",
			}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
			ignore_install = {}, -- List of parsers to ignore installing
			highlight = {
				enable = true, -- false will disable the whole extension
				--disable = {'org', "tex", "latex", 'markdown'},  -- list of language that will be disabled
				--disable = function(lang, bufnr) return (lang == 'markdown') or vim.b.large_buf end,
				disable = function(lang, bufnr)
					return vim.b.large_buf
				end,
				additional_vim_regex_highlighting = { "org", "tex" }, -- Required since TS highlighter doesn't support all syntax features (conceal)
				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
			},
			indent = {
				enable = false, -- enable when this is stable
			},
		})

		-- NOTE:  https://github.com/nvim-treesitter/nvim-treesitter/issues/2825
		-- overwrite markdown conceal (hopefully they change this)
		-- https://www.reddit.com/r/neovim/comments/weub7p/is_it_possible_to_overrideremove_default/
		-- delete the code conceal
		--;; Conceal backticks
		--(fenced_code_block
		--(fenced_code_block_delimiter) @conceal
		--(#set! conceal ""))
		--(fenced_code_block
		--(info_string (language) @conceal
		--(#set! conceal "")))

		require("vim.treesitter.query").set(
			"markdown",
			"highlights",
			[[
        ;From MDeiml/tree-sitter-markdown
        (setext_heading (paragraph) @text.title.1 (setext_h1_underline) @text.title.1.marker)
        (setext_heading (paragraph) @text.title.2 (setext_h2_underline) @text.title.2.marker)

        (atx_heading (atx_h1_marker) @text.title.1.marker (inline) @text.title.1)
        (atx_heading (atx_h2_marker) @text.title.2.marker (inline) @text.title.2)
        (atx_heading (atx_h3_marker) @text.title.3.marker (inline) @text.title.3)
        (atx_heading (atx_h4_marker) @text.title.4.marker (inline) @text.title.4)
        (atx_heading (atx_h5_marker) @text.title.5.marker (inline) @text.title.5)
        (atx_heading (atx_h6_marker) @text.title.6.marker (inline) @text.title.6)

        (link_title) @text.literal
        (indented_code_block) @text.literal.block
        ((fenced_code_block) @text.literal.block (#set! "priority" 90))

        (info_string) @label

        (pipe_table_header (pipe_table_cell) @text.title)

        (pipe_table_header "|" @punctuation.special)
        (pipe_table_row "|" @punctuation.special)
        (pipe_table_delimiter_row "|" @punctuation.special)
        (pipe_table_delimiter_cell) @punctuation.special

        [
        (fenced_code_block_delimiter)
        ] @punctuation.delimiter
        (code_fence_content) @none

        [
        (link_destination)
        ] @text.uri

        [
        (link_label)
        ] @text.reference

        [
        (list_marker_plus)
        (list_marker_minus)
        (list_marker_star)
        (list_marker_dot)
        (list_marker_parenthesis)
        (thematic_break)
        ] @punctuation.special


        (task_list_marker_unchecked) @text.todo.unchecked
        (task_list_marker_checked) @text.todo.checked

        ((block_quote) @text.quote (#set! "priority" 90))

        [
        (block_continuation)
        (block_quote_marker)
        ] @punctuation.special

        [
        (backslash_escape)
        ] @string.escape
        ]]
		)
	end,
}

plugin.mapping = function() end

return plugin
