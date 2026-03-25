# Platform-Specific Configurations

This directory contains platform-specific configurations and setup scripts for different operating systems.

## Supported Platforms

### macOS (`macos/`)

**Features:**

- Homebrew package management
- macOS-specific shell optimizations
- Development tools setup

**Setup:**

```bash
./install.sh macos
```

**Key Files:**

- `setup.sh` - Main setup script
- `Brewfile` - Homebrew packages (if exists)

### Linux Ubuntu/Debian (`linux/`)

**Features:**

- APT package management
- Ubuntu/Debian-specific optimizations
- Development tools setup

**Setup:**

```bash
./install.sh linux
```

**Key Files:**

- `setup.sh` - Main setup script

### Fedora/RHEL (`fedora/`)

**Features:**

- DNF package management
- Fedora/RHEL/CentOS/Rocky Linux support
- RPM Fusion repositories
- Development tools setup

**Setup:**

```bash
./install.sh fedora
```

**Supported Distributions:**

- Fedora (all versions)
- Red Hat Enterprise Linux (RHEL)
- CentOS Stream
- Rocky Linux
- AlmaLinux

**Key Files:**

- `setup.sh` - Main setup script

### Arch Linux (`arch/`)

**Features:**

- Pacman + paru (AUR helper) package management
- Performance-optimized configurations
- SOLID principles implementation
- Arch/EndeavourOS/Manjaro support
- Parallel downloads enabled
- Modern CLI tools from repos and AUR

**Setup:**

```bash
./install.sh arch
```

**Supported Distributions:**

- Arch Linux (official)
- EndeavourOS
- Manjaro
- Garuda Linux
- Artix Linux
- Any Arch-based distribution

**Key Files:**

- `setup.sh` - Main setup script (SOLID principles)
- `README.md` - Detailed documentation

**Performance Features:**

- ✓ Automatic paru installation and configuration
- ✓ Parallel package downloads
- ✓ Pre-compiled binaries via cargo-binstall
- ✓ Optimized pacman configuration
- ✓ Smart package caching

### WSL2 Ubuntu (`wsl/`)

**Features:**

- WSL2-specific optimizations
- Windows integration
- SSH server setup
- Performance configurations

**Setup:**

```bash
./install.sh wsl
```

**Key Files:**

- `setup.sh` - Main setup script

## Platform Detection

The main installation script automatically detects your platform:

- **macOS**: Detected by `$OSTYPE == "darwin*"`
- **WSL2**: Detected by checking `/proc/version` for Microsoft
- **Arch Linux**: Detected by checking `/etc/os-release` for `ID=arch|endeavouros|manjaro|garuda|artix` or `ID_LIKE=*arch*`
- **Fedora/RHEL**: Detected by checking `/etc/os-release` for `ID=fedora|centos|rhel|rocky|almalinux` or `ID_LIKE=*rhel*|*fedora*`
- **Linux Ubuntu/Debian**: Detected by checking `/etc/os-release` for `ID=ubuntu|debian` or `ID_LIKE=*debian*|*ubuntu*`

## Manual Platform Selection

You can also manually specify a platform:

```bash
./install.sh macos    # Force macOS setup
./install.sh linux    # Force Ubuntu/Debian setup
./install.sh fedora   # Force Fedora/RHEL setup
./install.sh arch     # Force Arch Linux setup
./install.sh wsl      # Force WSL setup
```

## Customization

Each platform directory can be customized for your specific needs:

1. **Add platform-specific packages** to the respective `setup.sh`
2. **Modify configurations** in platform-specific directories
3. **Add custom scripts** for platform-specific tasks

## Troubleshooting

### macOS Issues

- Ensure you have administrator privileges for Homebrew installation
- Grant accessibility permissions to Yabai and SKHD in System Preferences

### Linux/WSL Issues

- Ensure you have sudo privileges
- For WSL, make sure you're running WSL2 (not WSL1)
- Check that your system is up to date before running the setup
