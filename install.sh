#!/bin/bash

# =============================================================================
# Dotfiles Installation Script
# =============================================================================

set -e

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
                if [[ "$ID_LIKE" == *"rhel"* ]] || [[ "$ID_LIKE" == *"fedora"* ]]; then
                    echo "fedora"
                elif [[ "$ID_LIKE" == *"debian"* ]] || [[ "$ID_LIKE" == *"ubuntu"* ]]; then
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

# Function to create symlinks
create_symlinks() {
    local platform=$1
    
    print_status "Creating symlinks..."
    
    # Create .config directory
    if [[ ! -d ~/.config ]]; then
        mkdir -p ~/.config
    fi
    
    # Shell configuration
    if [[ -d "shell/zsh/modular" ]]; then
        # Remove existing zsh config directory if it exists
        rm -rf ~/.config/zsh 2>/dev/null || true
        ln -sf "$(pwd)/shell/zsh/modular" ~/.config/zsh
        ln -sf "$(pwd)/shell/zsh/modular/.zshrc" ~/.zshrc
        print_success "ZSH configuration linked"
    elif [[ -d "shell/zsh" ]]; then
        # Remove existing zsh config directory if it exists
        rm -rf ~/.config/zsh 2>/dev/null || true
        ln -sf "$(pwd)/shell/zsh" ~/.config/zsh
        ln -sf "$(pwd)/shell/zsh/.zshrc" ~/.zshrc
        print_success "ZSH configuration linked"
    fi
    
    # Starship configuration
    if [[ -f "apps/starship/starship.toml" ]]; then
        ln -sf "$(pwd)/apps/starship/starship.toml" ~/.config/starship.toml
        print_success "Starship configuration linked"
    fi
    
    # Fastfetch configuration
    if [[ -f "apps/fastfetch/config.jsonc" ]]; then
        mkdir -p ~/.config/fastfetch
        ln -sf "$(pwd)/apps/fastfetch/config.jsonc" ~/.config/fastfetch/config.jsonc
        print_success "Fastfetch configuration linked"
    fi
    
    # Neovim configuration
    if [[ -d "apps/nvim" ]]; then
        rm -rf ~/.config/nvim 2>/dev/null || true
        ln -sf "$(pwd)/apps/nvim" ~/.config/nvim
        print_success "Neovim configuration linked"
    fi

    # Wezterm configuration
    if [[ -d "apps/wezterm" ]]; then
        rm -rf ~/.config/wezterm 2>/dev/null || true
        ln -sf "$(pwd)/apps/wezterm" ~/.config/wezterm
        print_success "Wezterm configuration linked"
    fi

    # VSCode configuration
    if [[ -d "apps/vscode" ]]; then
        if [[ "$platform" == "macos" ]]; then
            mkdir -p "$HOME/Library/Application Support/Code/User"
            ln -sf "$(pwd)/apps/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json" 2>/dev/null || true
            ln -sf "$(pwd)/apps/vscode/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json" 2>/dev/null || true
        else
            mkdir -p ~/.config/Code/User
            ln -sf "$(pwd)/apps/vscode/settings.json" ~/.config/Code/User/settings.json 2>/dev/null || true
            ln -sf "$(pwd)/apps/vscode/keybindings.json" ~/.config/Code/User/keybindings.json 2>/dev/null || true
        fi
        print_success "VSCode configuration linked"
    fi

    # Zed configuration
    if [[ -d "apps/zed" ]]; then
        if [[ "$platform" == "macos" ]]; then
            mkdir -p "$HOME/.config/zed"
            ln -sf "$(pwd)/apps/zed/settings.json" "$HOME/.config/zed/settings.json" 2>/dev/null || true
            ln -sf "$(pwd)/apps/zed/keymap.json" "$HOME/.config/zed/keymap.json" 2>/dev/null || true
        else
            mkdir -p ~/.config/zed
            ln -sf "$(pwd)/apps/zed/settings.json" ~/.config/zed/settings.json 2>/dev/null || true
            ln -sf "$(pwd)/apps/zed/keymap.json" ~/.config/zed/keymap.json 2>/dev/null || true
        fi
        print_success "Zed configuration linked"
    fi
    
    # Git configuration
    if [[ -f "shell/common/.gitconfig" ]]; then
        ln -sf "$(pwd)/shell/common/.gitconfig" ~/.gitconfig
        print_success "Git configuration linked"
    fi
    
    # macOS-only: skhd and yabai
    if [[ "$platform" == "macos" ]]; then
        if [[ -f "apps/skhd/skhdrc" ]]; then
            mkdir -p ~/.config/skhd
            ln -sf "$(pwd)/apps/skhd/skhdrc" ~/.config/skhd/skhdrc
            print_success "skhd configuration linked"
        fi
        if [[ -f "apps/yabai/yabairc" ]]; then
            mkdir -p ~/.config/yabai
            ln -sf "$(pwd)/apps/yabai/yabairc" ~/.config/yabai/yabairc
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