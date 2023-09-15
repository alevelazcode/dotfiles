require("config.base")
require("config.highlights")
require("config.maps")
require("config.plugins")

local has = vim.fn.has
local is_mac = has "macunix"
local is_win = has "win32"
local is_linux = has "unix" and not has "macunix"
local is_wsl = has 'wsl'

if is_mac == 1 then
  require('config.macos')
end

if is_linux == 1 then
  require('config.linux')
end

if is_win == 1 then
  require('config.win')
end

if is_wsl == 1 then
  require("config.wsl")
end
