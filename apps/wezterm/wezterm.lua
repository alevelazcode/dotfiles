local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- OpenGL is the only backend that supports transparency + Acrylic/blur on all platforms.
-- prefer_egl avoids "OpenGL too old" panic on Windows (uses EGL instead of WGL).
config.front_end = "OpenGL"
config.prefer_egl = true

-- Font
config.font = wezterm.font_with_fallback({
  { family = "DankMono Nerd Font Mono", weight = "Regular" },
})
config.font_size = 19
config.line_height = 1.7

-- Theme
require("themes.monokai-pro").apply_to_config(config)

-- Transparency + blur (platform-aware)
local is_mac = wezterm.target_triple:find("apple") ~= nil
local is_win = wezterm.target_triple:find("windows") ~= nil

config.window_background_opacity = 0.8

if is_mac then
  config.macos_window_background_blur = 30
elseif is_win then
  -- Acrylic: blur-behind available on Windows 10+.
  -- Mica/Tabbed need Win 11 build 22621+ and opacity = 0.
  config.win32_system_backdrop = "Acrylic"
  config.window_background_opacity = 0.3
else
  -- KDE Wayland compositor blur
  config.kde_window_background_blur = true
end

-- Window chrome
if is_win then
  config.window_decorations = "TITLE | RESIZE"
else
  config.window_decorations = "NONE"
end
config.enable_tab_bar = false
config.enable_scroll_bar = false
config.adjust_window_size_when_changing_font_size = false
config.window_close_confirmation = "NeverPrompt"

config.window_padding = {
  left = 30,
  right = 30,
  top = 20,
  bottom = 20,
}

local border_color = "#3c4048"
config.window_frame = {
  border_left_width = "1px",
  border_right_width = "1px",
  border_bottom_height = "1px",
  border_top_height = "1px",
  border_left_color = border_color,
  border_right_color = border_color,
  border_bottom_color = border_color,
  border_top_color = border_color,
}

-- Cursor
config.default_cursor_style = "BlinkingBar"

-- Keys
config.keys = {
  { key = "Enter", mods = "CTRL",  action = wezterm.action({ SendString = "\x1b[13;5u" }) },
  { key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b[13;2u" }) },
}

-- Windows / WSL (auto-detected domain for native shell integration)
if is_win then
  config.default_domain = "WSL:Ubuntu"
end

return config
