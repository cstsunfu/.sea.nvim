M = {}

-- Helper function for transparency formatting
local alpha = function()
  return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
end

M.setup = function()
    vim.o.guifont = "Source Code Pro:h14"
    vim.opt.linespace = 0
    vim.g.neovide_scale_factor = 1.0

    -- padding surrounding the neovide window
    vim.g.neovide_padding_top = 0
    vim.g.neovide_padding_bottom = 0
    vim.g.neovide_padding_right = 0
    vim.g.neovide_padding_left = 0

    vim.g.neovide_fullscreen = true

    -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
    vim.g.neovide_transparency = 1.0
    vim.g.transparency = 1.0
    --vim.g.neovide_background_color = "#0f1117" .. alpha()

    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0

    -- animation
    vim.g.neovide_scroll_animation_length = 0.3
    vim.g.neovide_cursor_vfx_mode = "railgun"

    vim.g.neovide_hide_mouse_when_typing = false

    vim.g.neovide_underline_automatic_scaling = false
    vim.g.neovide_theme = 'auto'
    vim.g.neovide_refresh_rate = 60

end

return M
