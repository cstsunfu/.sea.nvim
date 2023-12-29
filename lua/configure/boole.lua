local plugin = {}

plugin.core = {
	"monaqa/dial.nvim",
	init = function() -- Specifies code to run before this plugin is loaded.
	end,

	config = function() -- Specifies code to run after this plugin is loaded
		local augend = require("dial.augend")
		require("dial.config").augends:register_group({
			default = {
				augend.integer.alias.decimal_int,
				augend.integer.alias.hex,
				augend.date.alias["%Y/%m/%d"],
				augend.date.alias["%Y-%m-%d"],
				augend.date.alias["%m/%d"],
				augend.date.alias["%H:%M"],
				augend.constant.alias.de_weekday,
				augend.semver.alias.semver,
				augend.constant.alias.bool,
				augend.date.alias["%Y年%-m月%-d日"],
				augend.constant.new({
					elements = { "and", "or" },
					word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
					cyclic = true, -- "or" is incremented into "and".
				}),
				augend.constant.new({
					elements = { "&&", "||" },
					word = false,
					cyclic = true,
				}),
				augend.constant.new({
					elements = { "True", "False" },
					word = true,
					cyclic = true,
				}),
				augend.constant.new({
					elements = { "Enable", "Disable" },
					word = true,
					cyclic = true,
				}),
				augend.constant.new({
					elements = { "enable", "disable" },
					word = true,
					cyclic = true,
				}),
				augend.constant.new({
					elements = { "ENABLE", "DISABLE" },
					word = true,
					cyclic = true,
				}),
				augend.constant.new({
					elements = { "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun" },
					word = true,
					cyclic = true,
				}),
			},
		})
	end,
}

plugin.mapping = function()
	vim.keymap.set("n", "<C-a>", function()
		require("dial.map").manipulate("increment", "normal")
	end)
	vim.keymap.set("n", "<C-x>", function()
		require("dial.map").manipulate("decrement", "normal")
	end)
	vim.keymap.set("n", "g<C-a>", function()
		require("dial.map").manipulate("increment", "gnormal")
	end)
	vim.keymap.set("n", "g<C-x>", function()
		require("dial.map").manipulate("decrement", "gnormal")
	end)
	vim.keymap.set("v", "<C-a>", function()
		require("dial.map").manipulate("increment", "visual")
	end)
	vim.keymap.set("v", "<C-x>", function()
		require("dial.map").manipulate("decrement", "visual")
	end)
	vim.keymap.set("v", "g<C-a>", function()
		require("dial.map").manipulate("increment", "gvisual")
	end)
	vim.keymap.set("v", "g<C-x>", function()
		require("dial.map").manipulate("decrement", "gvisual")
	end)
end

return plugin
