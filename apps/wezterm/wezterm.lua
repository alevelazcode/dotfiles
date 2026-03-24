local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ---------------------------------------------------------------------------
-- Font
-- ---------------------------------------------------------------------------
-- Use font_with_fallback so WezTerm's built-in fallback chain
-- (JetBrains Mono, Nerd Font Symbols, Noto Color Emoji) is appended automatically.
config.font = wezterm.font_with_fallback({
  { family = "DankMono Nerd Font Mono", weight = "Regular" },
})
config.font_size = 19
config.line_height = 1.7

-- ---------------------------------------------------------------------------
-- Theme
-- ---------------------------------------------------------------------------
require("themes.monokai-pro").apply_to_config(config)

-- ---------------------------------------------------------------------------
-- Transparency + blur (platform-aware)
-- ---------------------------------------------------------------------------
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

-- ---------------------------------------------------------------------------
-- Window chrome
-- ---------------------------------------------------------------------------
-- RESIZE alone removes the title bar but keeps the ability to resize/minimize.
-- Docs warn against using NONE (breaks resize and minimize).
config.window_decorations = "RESIZE"
config.enable_tab_bar = false
config.enable_scroll_bar = false
config.adjust_window_size_when_changing_font_size = false
config.window_close_confirmation = "NeverPrompt"
config.automatically_reload_config = true

config.window_padding = {
  left = 30,
  right = 30,
  top = 20,
  bottom = 20,
}

config.window_frame = {
  border_left_width = "1px",
  border_right_width = "1px",
  border_bottom_height = "1px",
  border_top_height = "1px",
  border_left_color = "#3c4048",
  border_right_color = "#3c4048",
  border_bottom_color = "#3c4048",
  border_top_color = "#3c4048",
}

-- ---------------------------------------------------------------------------
-- Cursor
-- ---------------------------------------------------------------------------
config.default_cursor_style = "BlinkingBar"

-- ---------------------------------------------------------------------------
-- Keys
-- ---------------------------------------------------------------------------
config.keys = {
  { key = "Enter", mods = "CTRL",  action = wezterm.action({ SendString = "\x1b[13;5u" }) },
  { key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b[13;2u" }) },
}

-- ---------------------------------------------------------------------------
-- Hyperlink rules
-- ---------------------------------------------------------------------------
-- Start from WezTerm's built-in defaults, then add custom patterns.
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- ---------------------------------------------------------------------------
-- Windows / WSL
-- ---------------------------------------------------------------------------
-- WezTerm auto-detects installed WSL distros via `wsl -l -v` and creates
-- WSL:<Name> domains. Using default_domain gives native shell integration
-- (cwd tracking when splitting panes/tabs) instead of spawning wsl.exe.
-- wsl_domains can be customised if needed (username, default_cwd, etc.),
-- but the auto-detected defaults (with default_cwd = "~") are fine.
if is_win then
  config.default_domain = "WSL:Ubuntu"
end

return config
