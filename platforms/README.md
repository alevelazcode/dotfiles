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

### Linux Ubuntu (`linux/`)

**Features:**

- APT package management
- Ubuntu-specific optimizations
- Development tools setup

**Setup:**

```bash
./install.sh linux
```

**Key Files:**

- `setup.sh` - Main setup script

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
- **Linux**: Detected by checking `/etc/os-release` for Ubuntu

## Manual Platform Selection

You can also manually specify a platform:

```bash
./install.sh macos    # Force macOS setup
./install.sh linux    # Force Linux setup
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
