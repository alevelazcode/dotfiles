-- Monokai Pro colorscheme with Dank Mono italic cursive styling
return {
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("monokai-pro").setup({
        transparent_background = true,
        terminal_colors = true,
        devicons = true,
        filter = "spectrum",

        -- Dank Mono italic cursive - all "operator" cursive groups
        styles = {
          comment = { italic = true },
          keyword = { italic = true },
          type = { italic = true },
          storageclass = { italic = true },
          structure = { italic = true },
          parameter = { italic = true },
          annotation = { italic = true },
          tag_attribute = { italic = true },
        },

        inc_search = "background",

        -- Transparent backgrounds for floating UIs
        background_clear = {
          "telescope",
          "notify",
          "toggleterm",
          "renamer",
          "nvim-tree",
        },

        plugins = {
          indent_blankline = {
            context_highlight = "pro",
            context_start_underline = false,
          },
        },

        -- Extra LSP semantic token italics not covered by `styles`
        override = function(scheme)
          return {
            -- ── Modules / Namespaces ──────────────────────────────
            ["@module"] = { fg = scheme.base.accent6, italic = true },
            ["@namespace"] = { fg = scheme.base.accent6, italic = true },
            ["@lsp.type.namespace"] = { fg = scheme.base.accent6, italic = true },

            -- ── Functions (calls get italic too) ──────────────────
            ["@function.call"] = { fg = scheme.base.accent5, italic = true },
            ["@method.call"] = { fg = scheme.base.accent5, italic = true },
            ["@lsp.type.function"] = { fg = scheme.base.accent5, italic = true },
            ["@lsp.type.method"] = { fg = scheme.base.accent5, italic = true },

            -- ── Parameters / Type parameters ──────────────────────
            ["@lsp.type.parameter"] = { fg = scheme.base.accent1, italic = true },
            ["@lsp.type.typeParameter"] = { fg = scheme.base.accent3, italic = true },

            -- ── this / self ───────────────────────────────────────
            ["@variable.builtin"] = { fg = scheme.base.accent1, italic = true },

            -- ── Constructors ──────────────────────────────────────
            ["@constructor"] = { fg = scheme.base.accent3, italic = true },

            -- ── LSP modifiers ─────────────────────────────────────
            ["@lsp.mod.readonly"] = { italic = true },
            ["@lsp.mod.defaultLibrary"] = { fg = scheme.base.accent5 },
            ["@lsp.mod.deprecated"] = { strikethrough = true },
          }
        end,
      })
    end,
  },
}
