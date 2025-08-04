# 🔧 Dotfiles for Streamlined Dev Experience 🚀

Your one-stop repository for macOS 🍎, Fedora 🎩, WSL2 Ubuntu 🐧, and Linux Ubuntu 🐧 setups.

---

## 📑 Table of Contents

- [🔧 Dotfiles for Streamlined Dev Experience 🚀](#-dotfiles-for-streamlined-dev-experience-)
  - [📑 Table of Contents](#-table-of-contents)
  - [🌟 Features](#-features)
  - [🚀 Quick Start](#-quick-start)
  - [📁 Project Structure](#-project-structure)
  - [🔧 Platform-Specific Setup](#-platform-specific-setup)
    - [macOS Setup](#macos-setup)
    - [Fedora/RHEL Setup](#fedorarhel-setup)
    - [Linux Ubuntu Setup](#linux-ubuntu-setup)
    - [WSL2 Ubuntu Setup](#wsl2-ubuntu-setup)
  - [📝 Configuration Files](#-configuration-files)
  - [📦 Dependencies](#-dependencies)
    - [Common Dependencies](#common-dependencies)
    - [Platform-Specific Dependencies](#platform-specific-dependencies)
  - [📚 Documentation](#-documentation)

---

## 🌟 Features

- **ZSH with Oh My Zsh** - Complete shell setup with essential plugins
- **Essential ZSH Plugins** - autosuggestions, syntax highlighting, completions
- **Modern CLI Tools** - bat, eza, ripgrep, fd, dust, procs, and more
- **Cross-Platform Support** - macOS, Fedora, Ubuntu, WSL2
- **LazyVim** - Modern Neovim configuration (automatically installed)
- **Starship Prompt** - Fast and customizable shell prompt
- **Development Tools** - Node.js, Rust, Python with modern toolchains
- **NVIDIA Drivers** - Latest drivers for Fedora (auto-detected)
- **Smart Package Management** - Handles already installed packages gracefully

---

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles

# Run platform-specific setup
./install.sh
```

## 📁 Project Structure

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

## 🔧 Platform-Specific Setup

### macOS Setup

```bash
./install.sh macos
```

**Includes:**

- Homebrew package installation
- macOS-specific shell configuration
- Development tools (Node.js, Rust, Python)
- Modern Rust tools (bat, eza, ripgrep, fd, etc.)
- LazyVim installation

### Fedora/RHEL Setup

```bash
./install.sh fedora
```

**Includes:**

- DNF package installation
- RPM Fusion repositories setup
- Fedora/RHEL/CentOS/Rocky Linux support
- Development tools setup
- Modern Rust tools (bat, eza, ripgrep, fd, etc.)
- LazyVim installation

**Supported Distributions:**
- Fedora (all versions)
- Red Hat Enterprise Linux (RHEL)
- CentOS Stream
- Rocky Linux
- AlmaLinux

### Linux Ubuntu Setup

```bash
./install.sh linux
```

**Includes:**

- APT package installation
- Ubuntu/Debian-specific shell configuration
- Development tools setup
- Modern Rust tools (bat, eza, ripgrep, fd, etc.)
- LazyVim installation

### WSL2 Ubuntu Setup

```bash
./install.sh wsl
```

**Includes:**

- WSL2-optimized configuration
- Ubuntu package installation
- Development tools setup
- Modern Rust tools (bat, eza, ripgrep, fd, etc.)
- LazyVim installation

## 📝 Configuration Files

- `~/.zshrc` - Main ZSH configuration
- `~/.config/starship.toml` - Starship prompt configuration
- `~/.config/fastfetch/config.jsonc` - Fastfetch configuration
- `~/.config/Code/User/settings.json` - VSCode settings
- Platform-specific configurations as needed
- `~/.config/neofetch/config.conf` - NeoFetch configuration

## 📦 Dependencies

### Common Dependencies

- ZSH shell
- Git
- Starship prompt
- Fastfetch

### Platform-Specific Dependencies

- **macOS**: Homebrew
- **Linux/WSL**: APT package manager

---

## 📚 Documentation

- [Shell Configuration](./shell/README.md)
- [Fastfetch Setup](./apps/fastfetch/README.md)
- [LazyVim Setup](./apps/lazyvim/README.md)
- [Platform-Specific Notes](./platforms/README.md)
- [Rust Tools Documentation](./shell/common/rust-tools.md)
- [Python Setup Documentation](./shell/common/python-setup.md)
