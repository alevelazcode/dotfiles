require("config.base")
require("config.highlights")
require("config.maps")
require("config.plugins")

local has = vim.fn.has
local is_mac = has "macunix"
local is_win = has "win32"
local is_linux = has "unix" and not has "macunix"

if is_mac then
  require('config.macos')
end

if is_linux then
  require('config.macos')
end
