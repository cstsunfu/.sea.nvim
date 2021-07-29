local plugin = {}

plugin.core = {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',

    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require'nvim-treesitter.configs'.setup {
            ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
            ignore_install = {}, -- List of parsers to ignore installing
            highlight = {
                enable = true,              -- false will disable the whole extension
                disable = {},  -- list of language that will be disabled
                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = true,
            },
            indent = {
                enable = true
            }
        }
    end,
}

plugin.mapping = function()

end

return plugin
