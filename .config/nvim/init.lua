require("config.base")
require("config.highlights")
require("config.maps" )
require ("config.plugins")

local has = function(x)
  return vim.fn.has(x) == 1
end
local is_mac = has "macunix"
local is_win = has "win32"

if is_mac then
  require('config.macos')
end
