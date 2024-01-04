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
    for _, key in pairs({ "foreground", "background", "special" }) do
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

func.colors = {
    Aliceblue = "#F0F8FF",
    Antiquewhite = "#FAEBD7",
    Aqua = "#00FFFF",
    Aquamarine = "#7FFFD4",
    Azure = "#F0FFFF",
    Beige = "#F5F5DC",
    Bisque = "#FFE4C4",
    Black = "#000000",
    Blanchedalmond = "#FFEBCD",
    Blue = "#0000FF",
    Blueviolet = "#8A2BE2",
    Brown = "#A52A2A",
    Burlywood = "#DEB887",
    Cadetblue = "#5F9EA0",
    Chartreuse = "#7FFF00",
    Chocolate = "#D2691E",
    Coral = "#FF7F50",
    Cornflowerblue = "#6495ED",
    Cornsilk = "#FFF8DC",
    Crimson = "#DC143C",
    Cyan = "#00FFFF",
    Darkblue = "#00008B",
    Darkcyan = "#008B8B",
    Darkgoldenrod = "#B8860B",
    Darkgray = "#A9A9A9",
    Darkgreen = "#006400",
    Darkkhaki = "#BDB76B",
    Darkmagenta = "#8B008B",
    Darkolivegreen = "#556B2F",
    Darkorange = "#FF8C00",
    Darkorchid = "#9932CC",
    Darkred = "#8B0000",
    Darksalmon = "#E9967A",
    Darkseagreen = "#8FBC8F",
    Darkslateblue = "#483D8B",
    Darkslategray = "#2F4F4F",
    Darkturquoise = "#00CED1",
    Darkviolet = "#9400D3",
    Deeppink = "#FF1493",
    Deepskyblue = "#00BFFF",
    Dimgray = "#696969",
    Dodgerblue = "#1E90FF",
    Firebrick = "#B22222",
    Floralwhite = "#FFFAF0",
    Forestgreen = "#228B22",
    Fuchsia = "#FF00FF",
    Gainsboro = "#DCDCDC",
    Ghostwhite = "#F8F8FF",
    Gold = "#FFD700",
    Goldenrod = "#DAA520",
    Gray = "#7F7F7F",
    Green = "#008000",
    Greenyellow = "#ADFF2F",
    Honeydew = "#F0FFF0",
    Hotpink = "#FF69B4",
    Indianred = "#CD5C5C",
    Indigo = "#4B0082",
    Ivory = "#FFFFF0",
    Khaki = "#F0E68C",
    Lavender = "#E6E6FA",
    Lavenderblush = "#FFF0F5",
    Lawngreen = "#7CFC00",
    Lemonchiffon = "#FFFACD",
    Lightblue = "#ADD8E6",
    Lightcoral = "#F08080",
    Lightcyan = "#E0FFFF",
    Lightgoldenrodyellow = "#FAFAD2",
    Lightgreen = "#90EE90",
    Lightgrey = "#D3D3D3",
    Lightpink = "#FFB6C1",
    Lightsalmon = "#FFA07A",
    Lightseagreen = "#20B2AA",
    Lightskyblue = "#87CEFA",
    Lightslategray = "#778899",
    Lightsteelblue = "#B0C4DE",
    Lightyellow = "#FFFFE0",
    Lime = "#00FF00",
    Limegreen = "#32CD32",
    Linen = "#FAF0E6",
    Magenta = "#FF00FF",
    Maroon = "#800000",
    Mediumaquamarine = "#66CDAA",
    Mediumblue = "#0000CD",
    Mediumorchid = "#BA55D3",
    Mediumpurple = "#9370DB",
    Mediumseagreen = "#3CB371",
    Mediumslateblue = "#7B68EE",
    Mediumspringgreen = "#00FA9A",
    Mediumturquoise = "#48D1CC",
    Mediumvioletred = "#C71585",
    Midnightblue = "#191970",
    Mintcream = "#F5FFFA",
    Mistyrose = "#FFE4E1",
    Moccasin = "#FFE4B5",
    Navajowhite = "#FFDEAD",
    Navy = "#000080",
    Navyblue = "#9FAFDF",
    Oldlace = "#FDF5E6",
    Olive = "#808000",
    Olivedrab = "#6B8E23",
    Orange = "#FFA500",
    Orangered = "#FF4500",
    Orchid = "#DA70D6",
    Palegoldenrod = "#EEE8AA",
    Palegreen = "#98FB98",
    Paleturquoise = "#AFEEEE",
    Palevioletred = "#DB7093",
    Papayawhip = "#FFEFD5",
    Peachpuff = "#FFDAB9",
    Peru = "#CD853F",
    Pink = "#FFC0CB",
    Plum = "#DDA0DD",
    Powderblue = "#B0E0E6",
    Purple = "#800080",
    Red = "#FF0000",
    Rosybrown = "#BC8F8F",
    Royalblue = "#4169E1",
    Saddlebrown = "#8B4513",
    Salmon = "#FA8072",
    Sandybrown = "#FA8072",
    Seagreen = "#2E8B57",
    Seashell = "#FFF5EE",
    Sienna = "#A0522D",
    Silver = "#C0C0C0",
    Skyblue = "#87CEEB",
    Slateblue = "#6A5ACD",
    Slategray = "#708090",
    Snow = "#FFFAFA",
    Springgreen = "#00FF7F",
    Steelblue = "#4682B4",
    Tan = "#D2B48C",
    Teal = "#008080",
    Thistle = "#D8BFD8",
    Tomato = "#FF6347",
    Turquoise = "#40E0D0",
    Violet = "#EE82EE",
    Wheat = "#F5DEB3",
    White = "#FFFFFF",
    Whitesmoke = "#F5F5F5",
    Yellow = "#FFFF00",
    Yellowgreen = "#9ACD32",
}
return func
