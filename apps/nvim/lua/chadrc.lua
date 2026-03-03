-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "onedark",
  transparency = true,
}

M.ui = {
  statusline = {
    theme = "vscode_colored",
    separator_style = "round",
  },
  tabufline = {
    enabled = true,
    lazyload = false,
  },
}

return M
