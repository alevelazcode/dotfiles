#!/bin/bash

# =============================================================================
# Dotfiles Installation Script
# =============================================================================

set -euo pipefail

# Allow non-critical commands to fail without killing the script
safe_run() { "$@" || print_warning "Command failed (non-critical): $*"; }

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to detect platform
detect_platform() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ -f /proc/version ]] && grep -q Microsoft /proc/version; then
        echo "wsl"
    elif [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case "$ID" in
            "ubuntu")
                echo "linux"
                ;;
            "fedora")
                echo "fedora"
                ;;
            "centos"|"rhel"|"rocky"|"almalinux")
                echo "fedora"  # Use Fedora setup for RHEL-based distros
                ;;
            "debian")
                echo "linux"  # Use Ubuntu/Debian setup for Debian-based distros
                ;;
            *)
                # Fallback: check ID_LIKE for family compatibility
                if [[ "${ID_LIKE:-}" == *"rhel"* ]] || [[ "${ID_LIKE:-}" == *"fedora"* ]]; then
                    echo "fedora"
                elif [[ "${ID_LIKE:-}" == *"debian"* ]] || [[ "${ID_LIKE:-}" == *"ubuntu"* ]]; then
                    echo "linux"
                else
                    echo "linux"  # Default to linux for unknown distributions
                fi
                ;;
        esac
    else
        echo "unknown"
    fi
}

# Create a symlink only if it doesn't already point to the correct target.
# For directories: removes existing dir/symlink and creates fresh symlink.
# For files: uses ln -sf which overwrites atomically.
ensure_link() {
    local target="$1" link="$2"

    # Already correct — skip
    if [[ -L "$link" ]] && [[ "$(readlink "$link")" == "$target" ]]; then
        return 0
    fi

    # Remove stale symlink or existing dir at link path
    if [[ -L "$link" ]] || [[ -e "$link" ]]; then
        rm -rf "$link"
    fi

    mkdir -p "$(dirname "$link")"
    ln -sf "$target" "$link"
}

# Function to create symlinks
create_symlinks() {
    local platform=$1

    print_status "Creating symlinks..."
    mkdir -p ~/.config

    # Shell configuration
    if [[ -d "shell/zsh/modular" ]]; then
        ensure_link "$(pwd)/shell/zsh/modular" ~/.config/zsh
        ensure_link "$(pwd)/shell/zsh/modular/.zshrc" ~/.zshrc
        print_success "ZSH configuration linked"
    fi

    # Starship
    if [[ -f "apps/starship/starship.toml" ]]; then
        ensure_link "$(pwd)/apps/starship/starship.toml" ~/.config/starship.toml
        print_success "Starship configuration linked"
    fi

    # Fastfetch
    if [[ -f "apps/fastfetch/config.jsonc" ]]; then
        ensure_link "$(pwd)/apps/fastfetch/config.jsonc" ~/.config/fastfetch/config.jsonc
        print_success "Fastfetch configuration linked"
    fi

    # Neovim
    if [[ -d "apps/nvim" ]]; then
        ensure_link "$(pwd)/apps/nvim" ~/.config/nvim
        print_success "Neovim configuration linked"
    fi

    # Wezterm
    if [[ -d "apps/wezterm" ]]; then
        ensure_link "$(pwd)/apps/wezterm" ~/.config/wezterm
        print_success "Wezterm configuration linked"
    fi

    # VSCode
    if [[ -d "apps/vscode" ]]; then
        if [[ "$platform" == "macos" ]]; then
            local vscode_dir="$HOME/Library/Application Support/Code/User"
        else
            local vscode_dir="$HOME/.config/Code/User"
        fi
        ensure_link "$(pwd)/apps/vscode/settings.json" "$vscode_dir/settings.json"
        ensure_link "$(pwd)/apps/vscode/keybindings.json" "$vscode_dir/keybindings.json"
        print_success "VSCode configuration linked"
    fi

    # Zed
    if [[ -d "apps/zed" ]]; then
        ensure_link "$(pwd)/apps/zed/settings.json" ~/.config/zed/settings.json
        ensure_link "$(pwd)/apps/zed/keymap.json" ~/.config/zed/keymap.json
        print_success "Zed configuration linked"
    fi

    # Git
    if [[ -f "shell/common/.gitconfig" ]]; then
        ensure_link "$(pwd)/shell/common/.gitconfig" ~/.gitconfig
        print_success "Git configuration linked"
    fi

    # macOS-only: skhd and yabai
    if [[ "$platform" == "macos" ]]; then
        if [[ -f "apps/skhd/skhdrc" ]]; then
            ensure_link "$(pwd)/apps/skhd/skhdrc" ~/.config/skhd/skhdrc
            print_success "skhd configuration linked"
        fi
        if [[ -f "apps/yabai/yabairc" ]]; then
            ensure_link "$(pwd)/apps/yabai/yabairc" ~/.config/yabai/yabairc
            print_success "yabai configuration linked"
        fi
    fi
}

# Function to install platform-specific packages
install_platform_packages() {
    local platform=$1
    
    print_status "Installing platform-specific packages for $platform..."
    
    if [[ "$platform" == "macos" ]]; then
        if [[ -f "platforms/macos/setup.sh" ]]; then
            bash "platforms/macos/setup.sh"
        fi
    elif [[ "$platform" == "linux" ]]; then
        if [[ -f "platforms/linux/setup.sh" ]]; then
            bash "platforms/linux/setup.sh"
        fi
    elif [[ "$platform" == "fedora" ]]; then
        if [[ -f "platforms/fedora/setup.sh" ]]; then
            bash "platforms/fedora/setup.sh"
        fi
    elif [[ "$platform" == "wsl" ]]; then
        if [[ -f "platforms/wsl/setup.sh" ]]; then
            bash "platforms/wsl/setup.sh"
        fi
    fi
}

# Function to install fonts from the fonts/ directory
install_fonts() {
    local platform=$1
    local fonts_dir="$(pwd)/fonts"

    if [[ ! -d "$fonts_dir" ]]; then
        print_warning "fonts/ directory not found, skipping font installation"
        return 0
    fi

    print_status "Installing fonts..."

    if [[ "$platform" == "macos" ]]; then
        local dest="$HOME/Library/Fonts"
    else
        local dest="$HOME/.local/share/fonts"
        mkdir -p "$dest"
    fi

    local installed=0
    local skipped=0

    # Iterate all font files (.otf and .ttf) in any subfolder
    while IFS= read -r -d '' font_file; do
        local font_name
        font_name="$(basename "$font_file")"

        if [[ -f "$dest/$font_name" ]]; then
            (( skipped++ )) || true
        else
            cp "$font_file" "$dest/$font_name"
            (( installed++ )) || true
        fi
    done < <(find "$fonts_dir" -type f \( -name "*.otf" -o -name "*.ttf" \) -print0)

    if [[ "$platform" != "macos" ]] && (( installed > 0 )); then
        fc-cache -fv "$dest" > /dev/null 2>&1
        print_success "Font cache refreshed"
    fi

    print_success "Fonts: $installed installed, $skipped already present"
}

# Function to install common development tools
install_dev_tools() {
    print_status "Installing common development tools..."
    
    # Source common development scripts
    if [[ -f "shell/common/node.sh" ]]; then
        print_status "Installing Node.js packages..."
        source "shell/common/node.sh" || print_warning "Node.js script had issues, but Node.js is already installed"
    fi
    
    if [[ -f "shell/common/rust.sh" ]]; then
        print_status "Installing additional Rust packages..."
        source "shell/common/rust.sh" || print_warning "Rust script had issues, but Rust tools are already installed"
    fi
}

# Main installation function
main() {
    print_status "Starting dotfiles installation..."
    
    # Get the directory where this script is located
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cd "$SCRIPT_DIR"
    
    # Detect platform
    PLATFORM=$(detect_platform)
    print_status "Detected platform: $PLATFORM"
    
    if [[ "$PLATFORM" == "unknown" ]]; then
        print_error "Could not detect platform. Please run manually with platform argument."
        print_status "Usage: $0 [macos|linux|wsl]"
        exit 1
    fi
    
    # Create symlinks
    create_symlinks "$PLATFORM"
    
    # Install platform-specific packages
    install_platform_packages "$PLATFORM"

    # Install fonts
    install_fonts "$PLATFORM"

    # Install common development tools
    install_dev_tools

    print_success "Installation complete!"
    print_status "Please restart your terminal or run 'source ~/.zshrc'"
}

# Check if platform argument is provided
if [[ $# -eq 1 ]]; then
    PLATFORM=$1
    case $PLATFORM in
        macos|linux|fedora|wsl)
            print_status "Using specified platform: $PLATFORM"
            create_symlinks "$PLATFORM"
            install_platform_packages "$PLATFORM"
            install_fonts "$PLATFORM"
            install_dev_tools
            print_success "Installation complete!"
            print_status "Please restart your terminal or run 'source ~/.zshrc'"
            ;;
        *)
            print_error "Invalid platform: $PLATFORM"
            print_status "Valid platforms: macos, linux, fedora, wsl"
            exit 1
            ;;
    esac
else
    main
fi 