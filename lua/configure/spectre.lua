local plugin = {}

plugin.core = {
    "windwp/nvim-spectre",
    --as = "nvim-spectre",
    after = {
        "popup.nvim",
        "plenary.nvim"
    },
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        if not packer_plugins['plenary.nvim'].loaded then
            vim.cmd [[packadd plenary.nvim]]
        end
        require('spectre').setup()
    end,

}

plugin.mapping = function()
    local mappings = require('core.mapping')
    --nnoremap <leader>S :lua require('spectre').open()<CR>
    mappings.register({
        mode = "n",
        key = {"<leader>", "s", "r"},
        action = ":lua require('spectre').open()<CR>",
        short_desc = "Search By Reg Exp.",
        silent = true
    })

end
return plugin
