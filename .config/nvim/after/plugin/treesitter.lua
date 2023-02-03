require 'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "typescript",
    "lua",
    "python",
    "go",
    'javascript',
    'tsx',
    "toml",
    "fish",
    "markdown",
    "php",
    "json",
    "yaml",
    "swift",
    "css",
    "html",
    "lua" },

  --[[ autotag = {
    enable = true,
  } ]]
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing (for "all")
  -- ignore_install = { "javascript" },

  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
    disable = {},
  },
  autotag = {
    enable = true,
  }
}
