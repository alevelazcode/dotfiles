local status, null_ls = pcall(require, "null-ls")
if (not status) then return end

local augroup_format = vim.api.nvim_create_augroup("Format", { clear = true })

local with_diagnostics_code = function(builtin)
  return builtin.with {
    diagnostics_format = "#{m} [#{c}]",
  }
end

local with_root_file = function(builtin, file)
  return builtin.with {
    condition = function(utils)
      return utils.root_has_file(file)
    end,
  }
end
local b = null_ls.builtins
-- you don't have to use these helpers and could do it yourself, too
null_ls.setup {
  sources = {
    b.diagnostics.eslint_d.with({
      diagnostics_format = '[eslint] #{m}\n(#{c})'
    }),
    b.diagnostics.fish,
    b.code_actions.eslint_d,
    b.diagnostics.flake8,
    b.formatting.eslint_d,
    b.formatting.prettierd,
    b.code_actions.gitsigns,
    b.code_actions.eslint_d,
    b.code_actions.gitrebase,
    with_root_file(b.formatting.stylua, "stylua.toml"),
    b.formatting.shfmt,
    b.formatting.fixjson,
    b.formatting.black.with { extra_args = { "--fast" } },
    b.formatting.isort,
    -- hover
    b.hover.dictionary,
    b.code_actions.refactoring,
  },
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_clear_autocmds { buffer = 0, group = augroup_format }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup_format,
        buffer = 0,
        callback = function() vim.lsp.buf.formatting_seq_sync() end
      })
    end
  end,
}

vim.api.nvim_create_user_command(
  'DisableLspFormatting',
  function()
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = 0 })
  end,
  { nargs = 0 }
)
