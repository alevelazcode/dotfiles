#!/bin/bash

# =============================================================================
# Simple ZSH Configuration Installer
# =============================================================================
# Simple and functional installer for macOS and WSL2

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Function to detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin*)
            echo "macos"
            ;;
        Linux*)
            if grep -qi Microsoft /proc/version 2>/dev/null; then
                echo "wsl"
            else
                echo "linux"
            fi
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Function to backup existing configuration
backup_existing_config() {
    local backup_dir="$HOME/.zsh_backup_$(date +%Y%m%d_%H%M%S)"
    
    print_status "Creating backup of existing configuration..."
    mkdir -p "$backup_dir"
    
    # Backup existing .zshrc
    if [[ -f "$HOME/.zshrc" ]]; then
        cp "$HOME/.zshrc" "$backup_dir/"
        print_status "Backed up $HOME/.zshrc"
    fi
    
    # Backup existing zsh config directory
    if [[ -d "$HOME/.config/zsh" ]]; then
        cp -r "$HOME/.config/zsh" "$backup_dir/"
        print_status "Backed up $HOME/.config/zsh"
    fi
    
    print_status "Backup created at: $backup_dir"
}

# Function to install configuration
install_configuration() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local config_dir="$HOME/.config/zsh"
    
    print_status "Installing ZSH configuration..."
    
    # Create config directory
    mkdir -p "$config_dir"
    
    # Copy all configuration files
    cp -r "$script_dir"/* "$config_dir/"
    
    # Remove install scripts from the config directory
    rm -f "$config_dir"/install*.sh
    rm -f "$config_dir"/*.md
    
    # Create symlink for .zshrc
    if [[ -f "$HOME/.zshrc" ]]; then
        mv "$HOME/.zshrc" "$HOME/.zshrc.old"
        print_status "Moved existing .zshrc to .zshrc.old"
    fi
    
    ln -sf "$config_dir/.zshrc" "$HOME/.zshrc"
    print_status "Created symlink for .zshrc"
    
    # Make init.zsh executable
    chmod +x "$config_dir/init.zsh"
    
    print_status "Configuration installed successfully!"
}

# Function to show recommended tools
show_recommended_tools() {
    local os=$(detect_os)
    
    print_status "Recommended tools for $os:"
    
    case "$os" in
        macos)
            echo "  Install with Homebrew:"
            echo "    brew install fzf starship zoxide"
            echo "    brew install --cask font-jetbrains-mono-nerd-font"
            echo ""
            echo "  Install Rust tools with cargo:"
            echo "    cargo install bat eza ripgrep fd-find bottom"
            ;;
        wsl|linux)
            echo "  Install essentials:"
            echo "    sudo apt update && sudo apt install -y curl git build-essential"
            echo ""
            echo "  Install Starship:"
            echo "    curl -sS https://starship.rs/install.sh | sh"
            echo ""
            echo "  Install Rust tools with cargo:"
            echo "    cargo install bat eza ripgrep fd-find bottom starship zoxide"
            ;;
        *)
            print_warning "Unknown operating system. Please install tools manually."
            ;;
    esac
}

# Function to create local configuration template
create_local_config() {
    local local_config="$HOME/.config/zsh/local.zsh"
    
    if [[ ! -f "$local_config" ]]; then
        print_status "Creating local configuration template..."
        
        cat > "$local_config" << 'EOF'
# =============================================================================
# Local Configuration
# =============================================================================
# This file is for machine-specific settings that should not be shared
# Add your personal configurations here

# Example local aliases
# alias myproject="cd ~/my-special-project"

# Example local environment variables
# export MY_API_KEY="your-api-key-here"

# Example local functions
# myfunction() {
#     echo "This is a local function"
# }

echo "Local configuration loaded"
EOF
        
        print_status "Local configuration template created at: $local_config"
    fi
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -b, --backup   Create backup of existing configuration"
    echo "  -f, --force    Force installation without confirmation"
    echo ""
    echo "Examples:"
    echo "  $0                    # Interactive installation"
    echo "  $0 --backup          # Install with backup"
    echo "  $0 --force           # Force installation"
}

# Main installation function
main() {
    local backup=false
    local force=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -b|--backup)
                backup=true
                shift
                ;;
            -f|--force)
                force=true
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    print_header "Simple ZSH Configuration Installer"
    
    # Detect OS
    local os=$(detect_os)
    print_status "Detected OS: $os"
    
    # Check if running as root
    if [[ $EUID -eq 0 ]]; then
        print_error "This script should not be run as root"
        exit 1
    fi
    
    # Interactive confirmation (unless --force is used)
    if [[ "$force" != true ]]; then
        echo ""
        print_warning "This will install a simple ZSH configuration."
        print_warning "Existing .zshrc will be moved to .zshrc.old"
        echo ""
        read -p "Do you want to continue? (y/N): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_status "Installation cancelled"
            exit 0
        fi
    fi
    
    # Create backup if requested
    if [[ "$backup" == true ]]; then
        backup_existing_config
    fi
    
    # Install configuration
    install_configuration
    
    # Create local configuration
    create_local_config
    
    print_header "Installation Complete!"
    print_status "Your ZSH configuration has been installed successfully!"
    echo ""
    print_status "Next steps:"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. Customize your configuration in ~/.config/zsh/local.zsh"
    echo ""
    show_recommended_tools
    echo ""
    print_status "Configuration directory: ~/.config/zsh"
    print_status "Local configuration: ~/.config/zsh/local.zsh"
}

# Run main function with all arguments
main "$@" 