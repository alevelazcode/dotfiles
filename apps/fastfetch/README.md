# Fastfetch Configuration

This directory contains the configuration for [Fastfetch](https://github.com/fastfetch-cli/fastfetch), a fast system information display tool.

## What is Fastfetch?

Fastfetch is a modern alternative to Neofetch that displays system information in a fast and customizable way. It's written in C and provides better performance than Neofetch.

## Configuration

The configuration file `config.jsonc` includes:

- **System Information**: OS, kernel, packages
- **Hardware Information**: CPU, GPU, memory, disk
- **Software Information**: Shell, terminal
- **System Status**: Uptime

## Installation

Fastfetch is automatically installed by the platform-specific setup scripts:

- **macOS**: Installed via Homebrew
- **Linux/WSL**: Downloaded from GitHub releases

## Usage

After installation, you can run:

```bash
fastfetch
```

## Customization

You can customize the display by editing `~/.config/fastfetch/config.jsonc`. The configuration supports:

- Different logo types (small, large, none)
- Custom color schemes
- Module selection and ordering
- Format customization

## Documentation

For more information about configuration options, visit the [Fastfetch documentation](https://github.com/fastfetch-cli/fastfetch/wiki/Configuration).
