local plugin = {}

plugin.core = {
    "echasnovski/mini.animate",
    event = "BufEnter",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        local animate = require("mini.animate")
        local is_many_wins = function(sizes_from, sizes_to)
            return vim.tbl_count(sizes_from) >= 3
        end
        require("mini.animate").setup({
            -- Cursor path
            cursor = {
                -- Whether to enable this animation
                enable = false,

                -- Timing of animation (how steps will progress in time)
                timing = animate.gen_timing.linear({ duration = 200, unit = "total" }), --<function: implements linear total 250ms animation duration>,

                -- Path generator for visualized cursor movement
                path = animate.gen_path.line({
                    predicate = function()
                        return true
                    end,
                }), --<function: implements shortest line path>,
            },

            -- Vertical scroll
            scroll = {
                -- Whether to enable this animation
                enable = false,

                -- Timing of animation (how steps will progress in time)
                timing = animate.gen_timing.linear({ duration = 80, unit = "total" }), --<function: implements linear total 250ms animation duration>,

                -- Subscroll generator based on total scroll
                subscroll = animate.gen_subscroll.equal({ max_output_steps = 30 }), --<function: implements equal scroll with at most 60 steps>,
            },

            -- Window resize
            resize = {
                -- Whether to enable this animation
                enable = true,

                -- Timing of animation (how steps will progress in time)
                timing = animate.gen_timing.linear({ duration = 2000, unit = "total" }), --<function: implements linear total 250ms animation duration>,

                -- Subresize generator for all steps of resize animations
                subresize = animate.gen_subscroll.equal({ predicate = is_many_wins }), --<function: implements equal linear steps>,
            },

            -- Window open
            open = {
                -- Whether to enable this animation
                enable = true,

                -- Timing of animation (how steps will progress in time)
                timing = animate.gen_timing.linear({ duration = 10000, unit = "total" }), --<function: implements linear total 250ms animation duration>,

                -- Floating window config generator visualizing specific window
                winconfig = animate.gen_winconfig.wipe({ direction = "from_edge" }), --<function: implements static window for 25 steps>,

                -- 'winblend' (window transparency) generator for floating window
                winblend = animate.gen_winblend.linear({ from = 80, to = 100 }), --<function: implements equal linear steps from 80 to 100>,
            },

            -- Window close
            close = {
                -- Whether to enable this animation
                enable = true,

                -- Timing of animation (how steps will progress in time)
                timing = animate.gen_timing.linear({ duration = 500, unit = "total" }), --<function: implements linear total 250ms animation duration>,

                -- Floating window config generator visualizing specific window
                winconfig = animate.gen_winconfig.wipe({ direction = "from_edge" }), --<function: implements static window for 25 steps>,

                -- 'winblend' (window transparency) generator for floating window
                winblend = animate.gen_winblend.linear({ from = 80, to = 100 }), --<function: implements equal linear steps from 80 to 100>,
            },
        })
    end,
}

plugin.mapping = function() end
return plugin
