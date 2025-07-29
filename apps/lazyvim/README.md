# LazyVim Configuration

This directory contains configuration and documentation for [LazyVim](https://www.lazyvim.org/), a modern Neovim configuration built on top of [LazyVim](https://github.com/LazyVim/LazyVim).

## What is LazyVim?

LazyVim is a Neovim setup for:

- **Lazy** people who want to achieve something without having to create a custom config from scratch
- **Lazy** people who want to focus on using Neovim rather than spending hours configuring it
- **Lazy** people who like the **sane defaults** that LazyVim provides out of the box

## Installation

LazyVim is automatically installed by the platform-specific setup scripts:

- **macOS**: Installed via the macOS setup script
- **Linux/WSL**: Installed via the respective setup scripts

The installation process:

1. Backs up any existing Neovim configuration
2. Clones the LazyVim starter configuration
3. Removes the git history to make it your own

## Customization

After installation, you can customize LazyVim by editing files in `~/.config/nvim/lua/config/`:

### Key Configuration Files

- `~/.config/nvim/lua/config/options.lua` - General Neovim options
- `~/.config/nvim/lua/config/keymaps.lua` - Custom keymaps
- `~/.config/nvim/lua/config/autocmds.lua` - Custom autocommands
- `~/.config/nvim/lua/plugins/` - Plugin configurations

### Adding Plugins

To add new plugins, create a new file in `~/.config/nvim/lua/plugins/`:

```lua
-- ~/.config/nvim/lua/plugins/example.lua
return {
  "example/plugin",
  config = function()
    -- Plugin configuration
  end,
}
```

### Modifying Existing Plugins

To modify existing plugins, create a file with the same name in `~/.config/nvim/lua/plugins/`:

```lua
-- ~/.config/nvim/lua/plugins/lsp.lua
return {
  "neovim/nvim-lspconfig",
  opts = {
    -- Your custom LSP options
  },
}
```

## Key Features

LazyVim comes with many features out of the box:

- **LSP Support** - Language Server Protocol for code completion and diagnostics
- **Treesitter** - Better syntax highlighting and code parsing
- **Telescope** - Fuzzy finder for files, buffers, and more
- **Which-key** - Key binding discovery and documentation
- **Lualine** - Status line
- **Nvim-tree** - File explorer
- **Trouble** - Quickfix and location list
- **Noice** - Modern UI components

## Key Mappings

- `<leader>` - Space key (default leader)
- `<leader>e` - Toggle file explorer
- `<leader>f` - Find files
- `<leader>g` - Find in files
- `<leader>b` - Switch buffers
- `<leader>w` - Switch windows
- `<leader>q` - Close buffer
- `<leader>s` - Save file

## Documentation

- [LazyVim Documentation](https://www.lazyvim.org/)
- [LazyVim GitHub](https://github.com/LazyVim/LazyVim)
- [Neovim Documentation](https://neovim.io/doc/)

## Troubleshooting

If you encounter issues:

1. **Check LazyVim logs**: `~/.local/state/nvim/lazy.log`
2. **Reset to defaults**: Delete `~/.config/nvim` and reinstall
3. **Update plugins**: Use `:Lazy sync` in Neovim
4. **Check health**: Use `:checkhealth` in Neovim

## Migration from Custom Config

If you're migrating from a custom Neovim configuration:

1. Backup your current config: `cp -r ~/.config/nvim ~/.config/nvim.backup`
2. Run the platform setup script to install LazyVim
3. Gradually migrate your customizations to the LazyVim structure
4. Test thoroughly before removing the backup
