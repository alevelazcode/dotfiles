  local dashboard = require "alpha.themes.dashboard"
local is_unix = vim.fn.has("unix") == 1
local is_win32 = vim.fn.has("win32") == 1
local configure_path
if is_unix then
  configure_path = "~/.config/nvim/init.vim"
elseif is_win32 then
  configure_path = "~/AppData/Local/nvim/init.lua"
end
  dashboard.section.header.val = {
    [[　　　 　　/＾>》, -―‐‐＜＾}]],
    [[　　　 　./:::/,≠´::::::ヽ.]],
    [[　　　　/::::〃::::／}::丿ハ]],
    [[　　　./:::::i{l|／　ﾉ／ }::}]],
    [[　　 /:::::::瓜イ＞　´＜ ,:ﾉ]],
    [[　 ./::::::|ﾉﾍ.{､　(_ﾌ_ノﾉイ＿]],
    [[　 |:::::::|／}｀ｽ /          /]],
    [[.　|::::::|(_:::つ/ ThinkPad /　neovim!]],
    [[.￣￣￣￣￣￣￣＼/＿＿＿＿＿/￣￣￣￣￣]],
  }

  dashboard.section.buttons.val = {
 dashboard.button("l", "  Load last session", ":SessionLoadLast<CR>"),
  dashboard.button("s", "  Select sessions", ":Telescope persisted<CR>"),
  dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
  dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
  dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
  dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
  dashboard.button("c", "  Configuration", ":e" .. configure_path .. "<CR>"),
  dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
  }
  require("alpha").setup(dashboard.config)
