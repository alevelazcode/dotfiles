# Package Mapping: Debian/Ubuntu → Arch Linux

This document maps packages from Ubuntu/Debian to their Arch Linux equivalents.

## Core Differences

### 1. No `-dev` Packages
**Arch Linux does NOT split packages into separate `-dev` packages.** Headers and development files are included in the main package.

```
Debian: libssl-dev     →  Arch: openssl
Debian: zlib1g-dev     →  Arch: zlib
```

### 2. Python Naming
**Python 3 is just called "python" in Arch** (Python 2 has been removed)

```
Debian: python3        →  Arch: python
Debian: python3-pip    →  Arch: python-pip
Debian: python3-pipx   →  Arch: python-pipx
Debian: python3-venv   →  Arch: (built-in, use python -m venv)
```

### 3. Build Tools
```
Debian: build-essential  →  Arch: base-devel (package group)
Debian: pkg-config       →  Arch: pkgconf
```

## Complete Package Mapping

### Essential Packages

| Category | Debian/Ubuntu | Arch Linux | Notes |
|----------|---------------|------------|-------|
| **Version Control** | git | git | Same |
| **Network Tools** | curl | curl | Same |
| | wget | wget | Same |
| **Shell** | zsh | zsh | Same |
| **Build Tools** | build-essential | base-devel | Package group (gcc, make, etc.) |
| | cmake | cmake | Same |
| | pkg-config | pkgconf | Different name, provides compatibility |
| **Compression** | unzip | unzip | Same |
| | xz-utils | xz | Simpler name |
| **System Monitoring** | htop | htop | Same |
| | tree | tree | Same |
| **Terminal Tools** | fzf | fzf | Same |
| | tmux | tmux | Same |
| | jq | jq | Same |

### Development Libraries

| Debian/Ubuntu (with -dev) | Arch Linux (no -dev) | Notes |
|---------------------------|---------------------|-------|
| libssl-dev | openssl | Headers included |
| libreadline-dev | readline | Headers included |
| zlib1g-dev | zlib | Headers included |
| libbz2-dev | bzip2 | Headers included |
| libsqlite3-dev | sqlite | Headers included |
| libncursesw5-dev | ncurses | Headers included |
| tk-dev | tk | Headers included |
| libxml2-dev | libxml2 | Headers included |
| libxmlsec1-dev | xmlsec | Headers included |
| libffi-dev | libffi | Headers included |
| liblzma-dev | xz | Headers included |

### Modern CLI Tools

**Key Difference**: In Ubuntu, these are installed via cargo. **In Arch, ALL are in official repos!**

| Tool | Ubuntu Method | Arch Package | Installation Speed |
|------|---------------|--------------|-------------------|
| ripgrep | cargo install | ripgrep | 100x faster (pacman) |
| fd | cargo install fd-find | fd | 100x faster (pacman) |
| bat | cargo install | bat | 100x faster (pacman) |
| eza | cargo install | eza | 100x faster (pacman) |
| zoxide | cargo install | zoxide | 100x faster (pacman) |
| du-dust | cargo install | dust | 100x faster (pacman) |
| procs | cargo install | procs | 100x faster (pacman) |
| sd | cargo install | sd | 100x faster (pacman) |
| tealdeer | cargo install | tealdeer | 100x faster (pacman) |
| tokei | cargo install | tokei | 100x faster (pacman) |
| bottom | cargo install | bottom | 100x faster (pacman) |
| git-delta | cargo install | git-delta | 100x faster (pacman) |

**Install all at once:**
```bash
sudo pacman -S ripgrep fd bat eza zoxide dust procs sd tealdeer tokei bottom git-delta
```

### Cargo Development Tools

**Another Key Difference**: In Ubuntu, these need cargo install. **In Arch, they're in repos!**

| Tool | Ubuntu Method | Arch Package |
|------|---------------|--------------|
| cargo-watch | cargo install | cargo-watch |
| cargo-edit | cargo install | cargo-edit |
| cargo-update | cargo install | cargo-update |
| cargo-binstall | curl script | cargo-binstall |

**Install all at once:**
```bash
sudo pacman -S cargo-watch cargo-edit cargo-update cargo-binstall
```

### Programming Languages

#### Java
| Ubuntu | Arch | Notes |
|--------|------|-------|
| openjdk-17-jdk | jdk17-openjdk | Java 17 LTS |
| openjdk-11-jdk | jdk11-openjdk | Java 11 LTS |
| default-jdk | jdk-openjdk | Latest JDK |

#### Rust
| Ubuntu | Arch | Notes |
|--------|------|-------|
| curl script | rustup | Install via: `sudo pacman -S rustup` then `rustup default stable` |

#### Node.js
| Ubuntu | Arch | Notes |
|--------|------|-------|
| via FNM | fnm | In official repos! `sudo pacman -S fnm` |

### GUI Applications

#### Official Repos vs AUR

| Application | Ubuntu (snap) | Arch Method | Package Name |
|-------------|---------------|-------------|--------------|
| **Telegram** | snap install | **pacman** ⭐ | telegram-desktop |
| **Firefox** | apt/snap | **pacman** ⭐ | firefox |
| **Android Studio** | snap install | **AUR** | android-studio |
| **Teams for Linux** | snap install | **AUR** | teams-for-linux-bin |
| **Postman** | snap install | **AUR** | postman-bin |
| **MongoDB Compass** | snap install | **AUR** | mongodb-compass-bin |
| **VSCode** | apt/snap | **AUR** | visual-studio-code-bin |

**Installation:**
```bash
# Official repos
sudo pacman -S telegram-desktop firefox

# AUR (requires paru or yay)
paru -S android-studio teams-for-linux-bin postman-bin mongodb-compass-bin visual-studio-code-bin
```

## Installation Method Priority

For Arch Linux, follow this priority order:

### 1. Official Repositories (pacman) 🥇
- **Fastest** installation
- **Best** system integration
- **Most** reliable updates
- **Examples**: telegram-desktop, ripgrep, fd, python, cargo-watch

```bash
sudo pacman -S package-name
```

### 2. AUR via paru/yay 🥈
- **Good** integration with pacman
- Access to **thousands** of packages
- Community maintained
- **Examples**: android-studio, postman-bin, vscode-bin

```bash
paru -S package-name
# or
yay -S package-name
```

### 3. Cargo (only when needed) 🥉
- Use **only** for packages not in repos/AUR
- Much slower (compilation required)
- Less integrated with package manager

```bash
cargo install package-name
```

### 4. Flatpak 🏅
- **Sandboxed** applications
- Good for proprietary apps you want isolated
- Universal across distros

```bash
flatpak install flathub app.name
```

### 5. Snap (avoid) ❌
- **Least** common on Arch
- Slower startup times
- Less community support
- Use only as last resort

```bash
snap install app-name
```

## Quick Reference

### Install Everything for Development

```bash
# System update
sudo pacman -Syu

# Build tools
sudo pacman -S base-devel cmake pkgconf

# Development libraries
sudo pacman -S openssl readline zlib bzip2 sqlite ncurses xz tk libxml2 xmlsec libffi

# Python
sudo pacman -S python python-pip python-pipx

# Modern CLI tools (all at once!)
sudo pacman -S ripgrep fd bat eza zoxide dust procs sd tealdeer tokei bottom git-delta

# Cargo tools
sudo pacman -S cargo-watch cargo-edit cargo-update cargo-binstall

# Languages
sudo pacman -S rustup jdk17-openjdk fnm

# Initialize Rust
rustup default stable

# GUI apps from official repos
sudo pacman -S telegram-desktop firefox

# GUI apps from AUR (after installing paru)
paru -S android-studio teams-for-linux-bin postman-bin mongodb-compass-bin visual-studio-code-bin
```

## Performance Comparison

### Rust CLI Tools Installation Time

| Method | Time | Notes |
|--------|------|-------|
| `cargo install ripgrep` | ~3-5 minutes | Compiles from source |
| `sudo pacman -S ripgrep` | ~3-5 seconds | Pre-compiled binary |
| **Speed Improvement** | **60-100x faster** | Arch advantage! |

### Multiple Packages

| Method | Ubuntu (cargo) | Arch (pacman) |
|--------|----------------|---------------|
| Install 12 CLI tools | 30-60 minutes | 1-2 minutes |
| Install cargo tools | 10-20 minutes | 30 seconds |

**Total time saved: ~40-80 minutes** on a fresh install!

## Summary

Arch Linux provides **superior package availability** compared to Ubuntu/Debian:

✅ **No -dev split**: Simpler, fewer packages to install
✅ **Rust tools in repos**: 60-100x faster installation
✅ **Cargo tools in repos**: No compilation needed
✅ **Rolling release**: Always latest stable versions
✅ **AUR**: Huge community repository for everything else
✅ **Better naming**: Simpler, more intuitive package names

This makes Arch Linux **significantly faster to set up** for development compared to Ubuntu/Debian, despite the common perception that Arch is "harder."
