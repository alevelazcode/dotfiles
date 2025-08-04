# Fedora/RHEL Platform Setup

This directory contains Fedora and RHEL-family specific configurations and setup scripts.

## Supported Distributions

The Fedora platform setup supports the following distributions:

- **Fedora** (all versions including Fedora 42+)
- **Red Hat Enterprise Linux (RHEL)** (7, 8, 9+)
- **CentOS Stream** (8, 9+)
- **Rocky Linux** (8, 9+)
- **AlmaLinux** (8, 9+)
- Any distribution with `ID_LIKE="rhel"` or `ID_LIKE="fedora"` in `/etc/os-release`

## Automatic Detection

The main installation script automatically detects your system as Fedora-compatible by checking:

1. **Direct ID match**: `fedora`, `centos`, `rhel`, `rocky`, `almalinux`
2. **Family compatibility**: `ID_LIKE` contains `rhel` or `fedora`

Examples of automatic detection:

```bash
# On Fedora 42
./install.sh  # Automatically detects as 'fedora'

# On Rocky Linux 9
./install.sh  # Automatically detects as 'fedora' (uses Fedora setup)

# Manual override if needed
./install.sh fedora
```

## Package Management

This setup uses **DNF** (Dandified YUM) as the primary package manager, which is the default on:

- Fedora 22+
- RHEL 8+
- CentOS 8+
- Rocky Linux 8+
- AlmaLinux 8+

For older systems still using YUM, most DNF commands are compatible.

## Key Features

### Repository Management

- **RPM Fusion** repositories (free and non-free)
- **PowerTools/CRB** repository (for RHEL-compatible distributions)
- **Flathub** repository for Flatpak applications

### Package Installation

- Essential development tools (`gcc`, `gcc-c++`, `make`, `cmake`)
- Development libraries (`openssl-devel`, `readline-devel`, etc.)
- Modern tools (`htop`, `tree`, `fzf`, `tmux`, `jq`)
- Programming runtimes (`python3`, `nodejs`, `npm`)

### Rust Tools Installation

All modern Rust tools are installed via Cargo for the latest versions:

- `ripgrep` - Better grep
- `fd-find` - Better find
- `bat` - Better cat
- `eza` - Better ls (replaces deprecated exa)
- `du-dust` - Better du
- `procs` - Better ps
- `sd` - Better sed
- `tealdeer` - Better man pages
- `cargo-update` - Update Rust tools

### Python Environment

- **pipx** for global Python applications
- **Virtual environments** for development packages
- Automatic PATH configuration

### Development Setup

- **LazyVim** - Modern Neovim configuration
- **Starship** - Cross-shell prompt
- **Fastfetch** - System information display
- **ZSH** configuration with modern plugins

## Installation Process

The setup script performs these steps:

1. **System Update**: `sudo dnf update -y`
2. **Essential Packages**: Install development tools and libraries (with `--skip-unavailable`)
3. **Starship**: Install the modern shell prompt
4. **Fastfetch**: Install system information tool (tries DNF repo first, then manual)
5. **Rust**: Install Rust toolchain and modern CLI tools
6. **Shell Setup**: Configure ZSH as default shell
7. **Development Tools**: Install Node.js, Python, and Rust packages (skip if already installed)
8. **LazyVim**: Install modern Neovim configuration
9. **Fedora Tools**: Install DNF plugins, Flatpak, Snapd
10. **Repositories**: Enable RPM Fusion, Flathub, PowerTools/CRB

### Smart Package Management

The script intelligently handles packages:

- **Skip Already Installed**: Checks if packages are already installed before attempting installation
- **Handle Package Name Changes**: Uses `--skip-unavailable` for renamed/missing packages
- **Graceful Failures**: Continues installation even if some packages fail
- **DNF vs Manual**: Tries system packages first, falls back to manual installation

## Special Considerations

### SELinux

Fedora and RHEL systems have SELinux enabled by default. The setup script is designed to work with SELinux in enforcing mode, but if you encounter permission issues:

```bash
# Check SELinux status
sestatus

# If needed, check for denials
sudo ausearch -m AVC -ts recent
```

### Firewall

Fedora uses `firewalld` by default. If you're setting up development servers, you may need to configure ports:

```bash
# Example: Allow development server on port 3000
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --reload
```

### DNF Configuration

The setup enables automatic updates and installs DNF plugins for enhanced functionality:

```bash
# Enable automatic security updates
sudo systemctl enable --now dnf-automatic.timer

# Use DNF plugins for enhanced features
sudo dnf install dnf-plugins-core
```

## Troubleshooting

### Common Issues

1. **"Package is already installed" or "No match for argument"**

   ```bash
   # The script handles this automatically with --skip-unavailable
   # If you see these messages, they're informational and safe to ignore
   # The script will continue and complete successfully
   ```

2. **Package Name Changes (Fedora 42+ specific)**

   ```bash
   # The script now uses correct Fedora 42+ package names:
   # - pkg-config → pkgconf-devel
   # - zlib-devel → zlib-ng-compat-devel
   # - liblzma-devel → xz-devel
   # - util-linux-user → util-linux
   ```

3. **Repository Access Issues**

   ```bash
   # Refresh repository metadata
   sudo dnf clean all
   sudo dnf makecache
   ```

4. **Package Not Found**

   ```bash
   # Search for package
   dnf search <package-name>

   # Check available repositories
   dnf repolist
   ```

5. **Permission Errors**

   ```bash
   # Ensure user is in wheel group
   groups $USER | grep wheel

   # If not, add to wheel group
   sudo usermod -aG wheel $USER
   ```

6. **Rust Tools Update**

   ```bash
   # Update all Rust tools
   cargo install-update -a

   # Or update individually
   cargo install --force ripgrep bat eza
   ```

7. **Python/Node.js Package Conflicts**

   ```bash
   # The script now checks if packages are already installed
   # and skips them gracefully to avoid conflicts
   ```

## Manual Installation

If you prefer manual installation:

```bash
# Clone repository
git clone <your-repo> ~/dotfiles
cd ~/dotfiles

# Run Fedora setup directly
bash platforms/fedora/setup.sh

# Create symlinks manually
ln -sf ~/dotfiles/shell/zsh/modular ~/.config/zsh
ln -sf ~/dotfiles/shell/zsh/modular/.zshrc ~/.zshrc
ln -sf ~/dotfiles/apps/starship/starship.toml ~/.config/starship.toml
ln -sf ~/dotfiles/apps/fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc
```

## Customization

### Adding Packages

Edit `platforms/fedora/setup.sh` and add packages to the DNF install command:

```bash
sudo dnf install -y \
    your-package-here \
    another-package
```

### Repository Management

Add custom repositories in the `enable_repositories()` function:

```bash
# Add custom repository
sudo dnf config-manager --add-repo https://example.com/repo
```

### Environment Variables

Platform-specific environment variables can be added to shell configuration files in `shell/zsh/`.

## Testing

Use the provided test script to verify platform detection:

```bash
# Test platform detection
./test-platform-detection.sh

# Expected output for Fedora systems:
# [SUCCESS] Detected platform: fedora
# [INFO] This system will use: platforms/fedora/setup.sh
# [INFO] Package manager: DNF
```

## Support

For Fedora-specific issues:

- Check the [Fedora Documentation](https://docs.fedoraproject.org/)
- Visit [Fedora Ask](https://ask.fedoraproject.org/)
- For RHEL: [Red Hat Customer Portal](https://access.redhat.com/)
- For Rocky Linux: [Rocky Linux Documentation](https://docs.rockylinux.org/)
- For AlmaLinux: [AlmaLinux Wiki](https://wiki.almalinux.org/)
