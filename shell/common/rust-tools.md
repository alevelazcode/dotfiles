# Rust Tools Installation

This document explains the Rust-based tools that are installed via Cargo instead of package managers to ensure the latest versions.

## Why Cargo Installation?

Rust tools are installed via Cargo rather than package managers (apt, brew) because:

- **Latest Versions**: Cargo provides the most up-to-date releases
- **Better Performance**: Rust tools are compiled for your specific system
- **Consistent Installation**: Same installation method across all platforms
- **Active Development**: Rust tools are actively maintained and updated frequently

## Installed Tools

### Core Development Tools

- **`ripgrep`** - Fast grep replacement for searching files
- **`fd-find`** - Fast find replacement for file discovery
- **`bat`** - Cat replacement with syntax highlighting
- **`eza`** - Modern ls replacement (successor to exa)

### Development Utilities

- **`tokei`** - Fast code counting tool
- **`cargo-watch`** - Watch files and run Cargo commands
- **`cargo-edit`** - Add/remove dependencies from Cargo.toml

### System Tools

- **`du-dust`** - Modern du replacement for disk usage
- **`procs`** - Modern ps replacement for process viewing
- **`sd`** - Intuitive find & replace CLI
- **`tealdeer`** - Fast tldr client for command examples

## Usage Examples

### File Operations

```bash
# Search for files
fd "pattern"

# Search in files
rg "pattern"

# View files with syntax highlighting
bat file.txt

# List files with details
eza -la
```

### System Information

```bash
# Disk usage
dust

# Process information
procs

# Code statistics
tokei
```

### Development

```bash
# Watch for changes and run tests
cargo watch -x test

# Add a dependency
cargo add serde

# Get command help
tldr git
```

## Installation

These tools are automatically installed when you run the platform setup scripts:

```bash
# macOS
./install.sh macos

# Linux
./install.sh linux

# WSL
./install.sh wsl
```

## Updating

To update all Rust tools to their latest versions, first install the cargo-update tool:

```bash
cargo install cargo-update
```

Then you can update all tools:

```bash
cargo install-update -a
```

Or update individual tools:

```bash
cargo install-update ripgrep bat eza
```

Alternatively, you can manually update individual tools:

```bash
cargo install --force ripgrep
cargo install --force bat
cargo install --force eza
```

## Configuration

Most of these tools work out of the box, but you can customize them:

- **ripgrep**: `~/.ripgreprc`
- **bat**: `~/.config/bat/config`
- **eza**: Use command line flags or aliases
- **fd**: Use command line flags

## Benefits

Using these Rust tools provides:

1. **Speed**: Significantly faster than traditional Unix tools
2. **Modern Features**: Better defaults and additional functionality
3. **Cross-platform**: Consistent behavior across macOS, Linux, and WSL
4. **Active Maintenance**: Regular updates and bug fixes
