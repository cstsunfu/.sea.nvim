local plugin = {}

plugin.core = {
    "ziontee113/syntax-tree-surfer",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        -- lua, default settings
        -- These are the default options:
        require("syntax-tree-surfer").setup({
            highlight_group = "STS_highlight",
            disable_no_instance_found_report = false,
            default_desired_types = {
                "else_clause",
                "else_statement",
                "if_statement",
                "while_statement",
                "elseif_statement",
                "switch_statement",
                "arrow_function",
                "function",
                "for_statement",
                "function_definition",
            },
            left_hand_side = "fdsawervcxqtzb",
            right_hand_side = "jkl;oiu.,mpy/n",
            icon_dictionary = {
                ["if_statement"] = "",
                ["else_clause"] = "",
                ["elseif_statement"] = "",
                ["for_statement"] = "ﭜ",
                ["while_statement"] = "ﯩ",
                ["switch_statement"] = "ﳟ",
                ["function"] = "",
                ["else_statement"] = "",
                ["function_definition"] = "",
                ["variable_declaration"] = "",
            },
        })
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    local opts = { noremap = true, silent = true }
    -- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
    vim.keymap.set("n", "vd", function()
        vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
        return "g@l"
    end, { silent = true, expr = true })
    vim.keymap.set("n", "vu", function()
        vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
        return "g@l"
    end, { silent = true, expr = true })

    -- Visual Selection from Normal Mode
    vim.keymap.set("n", "vx", "<cmd>STSSelectMasterNode<cr>", opts)
    vim.keymap.set("n", "vn", "<cmd>STSSelectCurrentNode<cr>", opts)

    -- Select Nodes in Visual Mode
    vim.keymap.set("x", "gn", "<cmd>STSSelectNextSiblingNode<cr>", opts)
    vim.keymap.set("x", "gp", "<cmd>STSSelectPrevSiblingNode<cr>", opts)
    --
    vim.keymap.set("x", "H", "<cmd>STSSelectParentNode<cr>", opts)
    vim.keymap.set("x", "L", "<cmd>STSSelectChildNode<cr>", opts)

    -- Swapping Nodes in Visual Mode
    if vim.fn.has("mac") == 1 then
        vim.keymap.set("x", "∆", "<cmd>STSSwapNextVisual<cr>", opts)
        vim.keymap.set("x", "˚", "<cmd>STSSwapPrevVisual<cr>", opts)
    else
        vim.keymap.set("x", "<A-j>", "<cmd>STSSwapNextVisual<cr>", opts)
        vim.keymap.set("x", "<A-k>", "<cmd>STSSwapPrevVisual<cr>", opts)
    end
end

return plugin
