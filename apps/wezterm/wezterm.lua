-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.font = wezterm.font("Dank Mono", { weight = "Bold" })

-- config.font_rules = {
--   {
--     italic = true,
--     intensity = "Bold",
--     font = wezterm.font("Dank Mono", { style = "Italic" }),
--   },
-- }
config.font_size = 19

config.enable_tab_bar = false

require("themes.monokai-pro").apply_to_config(config)

-- macOS-specific transparency + blur
if wezterm.target_triple == "x86_64-apple-darwin" or wezterm.target_triple == "aarch64-apple-darwin" then
  config.window_background_opacity = 0.8
  config.macos_window_background_blur = 30
end

config.enable_tab_bar = false
config.default_cursor_style = 'BlinkingBar'
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.window_decorations = "RESIZE"
config.enable_scroll_bar = false

config.keys = {
  { key = "Enter", mods = "CTRL",  action = wezterm.action({ SendString = "\x1b[13;5u" }) },
  { key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b[13;2u" }) },
  -- { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
}

-- This is used to make my foreground (text, etc) brighter than my background
-- config.foreground_text_hsb = {
--   hue = 1.0,
--   saturation = 1.2,
--   brightness = 1.5,
-- }

config.window_padding = {
  left = 30,
  right = 30,
  top = 20,
  bottom = 20,
}

config.window_frame = {
  border_left_width = '1px',
  border_right_width = '1px',
  border_bottom_height = '1px',
  border_top_height = '1px',
  border_left_color = '#3c4048',
  border_right_color = '#3c4048',
  border_bottom_color = '#3c4048',
  border_top_color = '#3c4048',
}

config.line_height = 1.7

-- from: https://akos.ma/blog/adopting-wezterm/
config.hyperlink_rules = {
  -- Matches: a URL in parens: (URL)
  {
    regex = "\\((\\w+://\\S+)\\)",
    format = "$1",
    highlight = 1,
  },
  -- Matches: a URL in brackets: [URL]
  {
    regex = "\\[(\\w+://\\S+)\\]",
    format = "$1",
    highlight = 1,
  },
  -- Matches: a URL in curly braces: {URL}
  {
    regex = "\\{(\\w+://\\S+)\\}",
    format = "$1",
    highlight = 1,
  },
  -- Matches: a URL in angle brackets: <URL>
  {
    regex = "<(\\w+://\\S+)>",
    format = "$1",
    highlight = 1,
  },
  -- Then handle URLs not wrapped in brackets
  {
    regex = "[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)",
    format = "$1",
    highlight = 1,
  },
}

-- config.background = {
-- 	{
-- 		source = {
-- 			File = "/Users/" .. os.getenv("USER") .. "/.config/wezterm/background/waterfall.jpeg",
-- 		},
--     opacity = 0.3,
-- 		hsb = {
-- 			hue = 1.0,
-- 			saturation = 1.02,
-- 			brightness = 0.25,
-- 		},
-- 		-- attachment = { Parallax = 0.3 },
-- 		-- width = "100%",
-- 		-- height = "100%",
-- 	},
-- }
-- and finally, return the configuration to wezterm
--
-- GPU auto-detection: Intel needs Wayland disabled; NVIDIA works with defaults
local function detect_gpu()
  local handle = io.popen("lspci 2>/dev/null | grep -i vga")
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result:match("[Nn]vidia") or result:match("[Gg]eforce") then
      return "nvidia"
    elseif result:match("[Ii]ntel") or result:match("[Ii]ris") then
      return "intel"
    end
  end
  return "unknown"
end

local gpu = detect_gpu()
wezterm.log_info("WezTerm detected GPU: " .. gpu)

if gpu == "nvidia" then
  -- NVIDIA: use OpenGL, allow Wayland
  config.front_end = "OpenGL"
else
  -- Intel (or unknown): disable Wayland to avoid blank/crash on launch
  config.enable_wayland = false
  config.front_end = "OpenGL"
end

-- ---------------------------------------------------------------------------
-- Windows / WSL: open WSL Ubuntu as the default domain
-- Wezterm auto-detects installed WSL distros and creates WSL:<Name> domains.
-- Using default_domain gives native integration (cwd tracking, multiplexing)
-- instead of just spawning wsl.exe as a child process.
-- ---------------------------------------------------------------------------
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.default_domain = "WSL:Ubuntu"

  -- Windows-specific overrides (optional)
  config.window_background_opacity = 1.0  -- acrylic not supported the same way
end

return config
