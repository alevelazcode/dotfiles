# Dotfiles Current State

## Overview

Your dotfiles project has been completely reorganized and optimized for modern development workflows across macOS, Linux Ubuntu, and WSL2 Ubuntu.

## Key Features

### 🚀 **Modern Tool Stack**

- **Fastfetch** instead of Neofetch for system information
- **LazyVim** for modern Neovim experience
- **Starship** for beautiful shell prompts
- **Modern Rust tools** installed via Cargo for latest versions

### 🛠️ **Optimized Installation**

- **Rust tools via Cargo**: bat, eza, ripgrep, fd-find, du-dust, procs, sd, tealdeer
- **Platform-specific setups**: macOS (Homebrew), Linux/WSL (APT)
- **Automatic platform detection** with manual override options
- **Comprehensive backup system** for existing configurations

## Directory Structure

```
dotfiles/
├── platforms/           # Platform-specific configurations
│   ├── macos/          # macOS-specific setup and configs
│   ├── linux/          # Linux Ubuntu-specific setup
│   └── wsl/            # WSL2 Ubuntu-specific setup
├── apps/               # Application-specific configurations
│   ├── fastfetch/      # Fastfetch configuration
│   ├── lazyvim/        # LazyVim documentation and configs
│   ├── starship/       # Starship prompt configuration
│   └── vscode/         # VSCode settings and keybindings
├── shell/              # Shell configurations (shared)
│   ├── zsh/            # ZSH configuration modules
│   └── common/         # Common shell utilities
├── scripts/            # Installation and utility scripts
└── install.sh          # Main installation script
```

## Installation

### Automatic Setup

```bash
./install.sh
```

### Manual Platform Selection

```bash
./install.sh macos    # Force macOS setup
./install.sh linux    # Force Linux setup
./install.sh wsl      # Force WSL setup
```

## Platform-Specific Features

### macOS

- Homebrew package management
- macOS-specific optimizations
- LazyVim installation
- Modern Rust tools via Cargo

### Linux Ubuntu

- APT package management
- Ubuntu-specific optimizations
- Development tools setup
- LazyVim installation
- Modern Rust tools via Cargo

### WSL2 Ubuntu

- WSL2-specific optimizations
- Windows integration
- SSH server setup
- Performance configurations
- LazyVim installation
- Modern Rust tools via Cargo

## Rust Tools Installed

### Core Development

- **ripgrep** - Fast grep replacement
- **fd-find** - Fast find replacement
- **bat** - Cat with syntax highlighting
- **eza** - Modern ls replacement

### Development Utilities

- **tokei** - Code counting
- **cargo-watch** - File watching
- **cargo-edit** - Dependency management
- **cargo-update** - Update installed tools

### System Tools

- **du-dust** - Disk usage
- **procs** - Process viewing
- **sd** - Find & replace
- **tealdeer** - Command examples

## Benefits of Current Setup

1. **Latest Versions**: Rust tools installed via Cargo ensure up-to-date versions
2. **Better Performance**: Rust tools are significantly faster than traditional Unix tools
3. **Cross-Platform**: Consistent experience across macOS, Linux, and WSL
4. **Modern Workflow**: LazyVim provides a feature-rich development environment
5. **Easy Maintenance**: Clear separation of platform-specific and shared configurations
6. **Comprehensive**: Includes all essential development tools and configurations

## Next Steps

1. **Test the installation** on each platform you use
2. **Customize LazyVim** by editing `~/.config/nvim/lua/config/`
3. **Add any missing tools** to the appropriate platform setup scripts
4. **Update Rust tools** periodically with `cargo install-update -a` (after installing `cargo-update`)

## Documentation

- [Shell Configuration](./shell/README.md)
- [Fastfetch Setup](./apps/fastfetch/README.md)
- [LazyVim Setup](./apps/lazyvim/README.md)
- [Platform-Specific Notes](./platforms/README.md)
- [Rust Tools Documentation](./shell/common/rust-tools.md)

The setup is now optimized for modern development with the latest tools and best practices! 🎉
