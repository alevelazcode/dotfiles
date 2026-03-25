-- cyberdream.lua - Cyberdream Theme Module for WezTerm
-- Based on scottmckendry/cyberdream.nvim

local module = {}

local function create_theme(palette)
  return {
    cursor_bg = palette.fg,
    cursor_fg = palette.bg,
    cursor_border = palette.fg,

    selection_fg = palette.fg,
    selection_bg = palette.bgHighlight,

    ansi = {
      palette.bg,     -- black
      palette.red,    -- red
      palette.green,  -- green
      palette.yellow, -- yellow
      palette.blue,   -- blue
      palette.purple, -- magenta
      palette.cyan,   -- cyan
      palette.fg,     -- white
    },
    brights = {
      palette.grey,   -- bright black
      palette.red,    -- bright red
      palette.green,  -- bright green
      palette.yellow, -- bright yellow
      palette.blue,   -- bright blue
      palette.purple, -- bright magenta
      palette.cyan,   -- bright cyan
      palette.fg,     -- bright white
    },

    foreground = palette.fg,
    background = palette.bg,

    -- Tab bar / scrollbar colors omitted — disabled in wezterm.lua

    split = palette.bgHighlight,
    visual_bell = palette.bgHighlight,
    compose_cursor = palette.orange,

    indexed = {
      [16] = palette.orange,
      [17] = palette.red,
    },
  }
end

local palettes = {
  default = {
    bg = "#16181a",
    bgHighlight = "#3c4048",
    fg = "#ffffff",
    grey = "#7b8496",
    blue = "#5ea1ff",
    green = "#5eff6c",
    cyan = "#5ef1ff",
    red = "#ff6e5e",
    yellow = "#f1ff5e",
    orange = "#ffbd5e",
    purple = "#bd5eff",
  },
  light = {
    bg = "#ffffff",
    bgHighlight = "#d0d0d0",
    fg = "#16181a",
    grey = "#7b8496",
    blue = "#1d73e8",
    green = "#008b0c",
    cyan = "#0087bd",
    red = "#d10000",
    yellow = "#b17b00",
    orange = "#c47200",
    purple = "#7100d1",
  },
}

function module.register_color_schemes(config)
  if not config.color_schemes then
    config.color_schemes = {}
  end
  for name, palette in pairs(palettes) do
    local scheme_name = "Cyberdream (" .. name:gsub("^%l", string.upper) .. ")"
    config.color_schemes[scheme_name] = create_theme(palette)
  end
end

function module.apply_to_config(config, variant)
  module.register_color_schemes(config)
  variant = variant or "default"
  local scheme_name = "Cyberdream (" .. variant:gsub("^%l", string.upper) .. ")"
  config.color_scheme = scheme_name
  config.inactive_pane_hsb = {
    saturation = 0.8,
    brightness = 0.7,
  }
end

return module
