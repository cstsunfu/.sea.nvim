-- REF: https://www.reddit.com/r/neovim/comments/qco76a/way_to_increase_decrease_brightness_of_selected/
local func = {}
local fmt = string.format
local function get_color_from_hl(name)
  local result = {}
  for k, v in pairs(vim.api.nvim_get_hl_by_name(name, true)) do
    result[k] = fmt("#%06x", v)
  end
  return result
end

local function to_rgb(color)
  return tonumber(color:sub(2, 3), 16), tonumber(color:sub(4, 5), 16), tonumber(color:sub(6), 16)
end

local function clamp_color(color)
  return math.max(math.min(color, 255), 0)
end

func.get_highlight_values = function(name)
    local ok, hl = pcall(vim.api.nvim_get_hl_by_name, name, true)
    if not ok then
        return {}
    end
    for _, key in pairs({"foreground", "background", "special"}) do
        if hl[key] then
            hl[key] = string.format("#%06x", hl[key])
        end
    end
    return hl
end

-- https://stackoverflow.com/a/13532993
func.brighten = function(color, percent)
  local r, g, b = to_rgb(color)
  r = clamp_color(math.floor(tonumber(r * (100 + percent) / 100)))
  g = clamp_color(math.floor(tonumber(g * (100 + percent) / 100)))
  b = clamp_color(math.floor(tonumber(b * (100 + percent) / 100)))

  return "#" .. fmt("%0x", r) .. fmt("%0x", g) .. fmt("%0x", b)
end

func.highlight = function(group, color)
  local style = color.style and "gui=" .. color.style or "gui=NONE"
  local fg = color.fg and "guifg=" .. color.fg or "guifg=NONE"
  local bg = color.bg and "guibg=" .. color.bg or "guibg=NONE"
  local sp = color.sp and "guisp=" .. color.sp or ""
  local hl = "highlight " .. group .. " " .. style .. " " .. fg .. " " .. bg .. " " .. sp
  vim.cmd(hl)
end

local function test_gen_hl()
  local normal = func.get_highlight_values("Normal")
  local darkbg = func.brighten(normal.background, -10) -- darken by 10%

  local groups = {
    DarkerBackground = { bg = darkbg },
  }

  for name, values in pairs(groups) do
    func.highlight(name, values)
  end
end

return func
