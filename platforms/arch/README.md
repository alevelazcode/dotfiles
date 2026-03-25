# Arch Linux / EndeavourOS Setup

Complete setup script for Arch-based distributions following SOLID principles and best practices.

## Supported Distributions

- **Arch Linux** (official)
- **EndeavourOS**
- **Manjaro**
- **Garuda Linux**
- **Artix Linux**
- Any other Arch-based distribution

## Features

### Package Management
- **Primary**: `paru` (AUR helper) - Optimized for performance
- **Fallback**: `pacman` (official repositories)
- **Automatic**: Installs paru if not present
- **Performance**: Parallel downloads enabled by default

### SOLID Principles Implementation

#### Single Responsibility Principle (SRP)
- Each function has a single, well-defined purpose
- Separate functions for system updates, package installation, and configuration
- Modular design allows easy maintenance and testing

#### Open/Closed Principle (OCP)
- Extensible architecture for adding new packages
- No need to modify core functions when adding new tools
- Easy to extend with custom packages

#### Liskov Substitution Principle (LSP)
- All platform setup scripts follow the same interface
- Can be swapped without breaking the main installer
- Consistent behavior across different distributions

#### Interface Segregation Principle (ISP)
- Generic `install_packages()` function that works with both paru and pacman
- No forced dependencies on specific package managers
- Minimal, focused interfaces

#### Dependency Inversion Principle (DIP)
- High-level installation logic doesn't depend on low-level package manager details
- Abstractions allow switching between paru and pacman seamlessly
- Easy to add support for other AUR helpers

## Installed Components

### System Optimization
- ✓ Parallel downloads enabled in pacman
- ✓ Colored output and Pac-Man progress bar
- ✓ Multilib repository enabled (32-bit support)
- ✓ Optimized paru configuration

### Development Tools
- ✓ **base-devel** (gcc, make, autoconf, etc.)
- ✓ **Neovim** (latest stable)
- ✓ **Rust** toolchain (via rustup)
- ✓ **Node.js** LTS (via FNM from official repos)
- ✓ **Java 17** JDK (OpenJDK LTS)
- ✓ **Docker** + Docker Compose
- ✓ **Python** + pip + pipx

### Modern CLI Tools (ALL from official repos!)
⚡ **60-100x faster than cargo install** - Pre-compiled binaries

- ✓ `ripgrep` - Fast grep alternative
- ✓ `fd` - Fast find alternative (not fd-find)
- ✓ `bat` - Better cat with syntax highlighting
- ✓ `eza` - Modern ls replacement
- ✓ `zoxide` - Smarter cd command
- ✓ `dust` - Better du (not du-dust)
- ✓ `procs` - Modern ps
- ✓ `sd` - Intuitive sed alternative
- ✓ `tealdeer` - Fast tldr client
- ✓ `tokei` - Code statistics
- ✓ `bottom` - System monitor
- ✓ `git-delta` - Better git diff

**Key Advantage**: Unlike Ubuntu where these need cargo compilation (30-60 minutes),
Arch installs all of them in under 2 minutes via pacman!

### Shell & Prompt
- ✓ **ZSH** as default shell
- ✓ **Zinit** plugin manager
- ✓ **Starship** prompt
- ✓ **Fastfetch** system info

### Node.js Packages (Global)
- ✓ TypeScript + ts-node
- ✓ Prettier + ESLint
- ✓ Yarn + pnpm

### Python Tools (via pipx)
- ✓ Black (formatter)
- ✓ Flake8 (linter)
- ✓ Mypy (type checker)
- ✓ IPython (enhanced REPL)
- ✓ Poetry (dependency manager)

### GUI Applications (Optional)

**Official Repos (pacman):**
- ✓ Firefox
- ✓ Telegram Desktop

**AUR (paru):**
- ✓ Visual Studio Code (binary)
- ✓ Android Studio (matching Ubuntu snap)
- ✓ Teams for Linux (matching Ubuntu snap)
- ✓ Postman (matching Ubuntu snap)
- ✓ MongoDB Compass (matching Ubuntu snap)

## Performance Optimizations

### Parallel Package Installation
The script leverages pacman's parallel download feature and paru's batch installation:
- Multiple packages downloaded simultaneously
- Reduced installation time
- Optimized mirror selection

### Pre-compiled Binaries (Huge Advantage!)
**Arch packages ALL Rust CLI tools in official repos!**

| Setup Time | Ubuntu/Debian | Arch Linux |
|------------|---------------|------------|
| Modern CLI tools (12 packages) | 30-60 min (cargo compile) | 1-2 min (pacman) |
| Cargo dev tools (4 packages) | 10-20 min (cargo compile) | 30 sec (pacman) |
| **Total Time Saved** | - | **40-80 minutes!** |

### Smart Caching
- Checks if tools are already installed before attempting installation
- Skips unnecessary steps
- Idempotent execution (safe to run multiple times)

### Optimized Package Manager
- `paru` configured for maximum performance
- Batch installations reduce overhead
- No need for cargo compilation for standard tools

## Best Practices

### Error Handling
- `set -euo pipefail` for strict error handling
- Graceful fallbacks for non-critical failures
- Clear error messages with color-coded output

### User Experience
- Color-coded output (INFO, SUCCESS, WARNING, ERROR)
- Progress indicators for each step
- Helpful warnings and instructions

### Security
- No sudo password required after initial setup
- Package verification through official repos and AUR
- Docker group membership handled safely

### Maintainability
- Well-documented functions
- Consistent naming conventions
- Modular structure for easy updates

## Usage

### Automatic Detection
```bash
cd ~/dotfiles
./install.sh
```

The installer will automatically detect Arch-based distributions.

### Manual Platform Selection
```bash
cd ~/dotfiles
./install.sh arch
```

## Post-Installation

### Required Actions
1. **Restart terminal** or run:
   ```bash
   source ~/.zshrc
   ```

2. **For Docker**: Log out and back in for group membership to take effect

### Optional Configuration
- Customize paru settings in `~/.config/paru/paru.conf`
- Configure pacman mirrors with `reflector`:
  ```bash
  paru -S reflector
  sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
  ```

## Troubleshooting

### paru Installation Fails
If paru installation fails, the script will fall back to pacman for all installations. You can manually install paru later:
```bash
cd /tmp
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si
```

### Package Conflicts
Some packages might conflict with existing installations. Use:
```bash
paru -Scc  # Clear cache
paru -Syu  # Update system
```

### Docker Permission Denied
If you get permission errors with Docker after installation:
```bash
# Verify group membership
groups $USER

# If docker is listed, restart session
# Otherwise, add manually:
sudo usermod -aG docker $USER
```

## Customization

### Adding Custom Packages
Edit `platforms/arch/setup.sh` and add packages to the relevant array:

```bash
# For system packages (pacman/paru)
install_essential_packages() {
    local essential_packages=(
        # ... existing packages ...
        your-package-name
    )
    install_packages "${essential_packages[@]}"
}
```

### Modifying Configuration
The script includes optimization functions:
- `optimize_pacman()` - Customize pacman.conf
- `configure_paru()` - Customize paru.conf
- `enable_multilib()` - Enable/disable 32-bit support

## Contributing

When adding new features, follow these principles:
1. **SRP**: One function, one responsibility
2. **DRY**: Don't repeat yourself - use helper functions
3. **Error Handling**: Always check command success
4. **Performance**: Prefer batch operations over loops
5. **Documentation**: Add comments for complex logic

## References

- [Arch Linux Wiki](https://wiki.archlinux.org/)
- [paru Documentation](https://github.com/Morganamilo/paru)
- [EndeavourOS Documentation](https://discovery.endeavouros.com/)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)
