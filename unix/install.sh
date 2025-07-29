#!/bin/bash

# =============================================================================
# Dotfiles Installation Script - Cross Platform (macOS ARM M1 & WSL2/Ubuntu Linux)
# =============================================================================

set -e  # Exit on any error

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

# Function to check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to install Rust tools
install_rust_tools() {
    print_status "Installing Rust tools..."
    
    # Check if Rust is installed
    if ! command_exists cargo; then
        print_warning "Rust is not installed. Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
        print_success "Rust installed"
    else
        print_success "Rust is already installed"
    fi
    
    # Install Rust tools
    local rust_tools=("eza" "bat" "fd" "ripgrep" "bottom")
    
    for tool in "${rust_tools[@]}"; do
        if ! command_exists "$tool"; then
            print_status "Installing $tool..."
            cargo install "$tool"
            print_success "$tool installed"
        else
            print_success "$tool is already installed"
        fi
    done
}

# Function to install Node.js tools
install_node_tools() {
    print_status "Installing Node.js tools..."
    
    # Check if Node.js is installed
    if ! command_exists node; then
        print_warning "Node.js is not installed. Please install Node.js first."
        if [[ "$OS" == "macos" ]]; then
            print_status "On macOS, you can install Node.js with: brew install node"
        elif [[ "$OS" == "linux" || "$OS" == "wsl" ]]; then
            print_status "On Ubuntu/Debian, you can install Node.js with: sudo apt install nodejs npm"
        fi
        return 1
    fi
    
    # Install pnpm
    if ! command_exists pnpm; then
        print_status "Installing pnpm..."
        npm install -g pnpm
        print_success "pnpm installed"
    else
        print_success "pnpm is already installed"
    fi
}

# Function to install Python tools
install_python_tools() {
    print_status "Installing Python tools..."
    
    # Check if Python is installed
    if ! command_exists python3; then
        print_warning "Python3 is not installed. Please install Python3 first."
        if [[ "$OS" == "macos" ]]; then
            print_status "On macOS, you can install Python3 with: brew install python"
        elif [[ "$OS" == "linux" || "$OS" == "wsl" ]]; then
            print_status "On Ubuntu/Debian, you can install Python3 with: sudo apt install python3 python3-pip"
        fi
        return 1
    fi
    
    # Install Jupyter
    if ! command_exists jupyter; then
        print_status "Installing Jupyter..."
        pip3 install jupyter
        print_success "Jupyter installed"
    else
        print_success "Jupyter is already installed"
    fi
}

# Function to install ZSH plugins
install_zsh_plugins() {
    print_status "Installing ZSH plugins..."
    
    # Create zsh plugins directory
    mkdir -p ~/.zsh
    
    # Install zsh-autosuggestions
    if [[ ! -d ~/.zsh/zsh-autosuggestions ]]; then
        print_status "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
        print_success "zsh-autosuggestions installed"
    else
        print_success "zsh-autosuggestions is already installed"
    fi
    
    # Install zsh-syntax-highlighting
    if [[ ! -d ~/.zsh/zsh-syntax-highlighting ]]; then
        print_status "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
        print_success "zsh-syntax-highlighting installed"
    else
        print_success "zsh-syntax-highlighting is already installed"
    fi
}

# Function to install system-specific tools
install_system_tools() {
    print_status "Installing system-specific tools..."
    
    if [[ "$OS" == "macos" ]]; then
        # Check if Homebrew is installed
        if ! command_exists brew; then
            print_warning "Homebrew is not installed. Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            print_success "Homebrew installed"
        else
            print_success "Homebrew is already installed"
        fi
        
        # Install additional macOS tools
        if ! command_exists starship; then
            print_status "Installing Starship..."
            brew install starship
            print_success "Starship installed"
        else
            print_success "Starship is already installed"
        fi
        
        # Install FZF
        if ! command_exists fzf; then
            print_status "Installing FZF..."
            brew install fzf
            print_success "FZF installed"
        else
            print_success "FZF is already installed"
        fi
        
    elif [[ "$OS" == "linux" || "$OS" == "wsl" ]]; then
        # Update package list
        print_status "Updating package list..."
        sudo apt update
        
        # Install additional Linux tools
        local linux_tools=("curl" "git" "wget" "unzip" "build-essential")
        
        for tool in "${linux_tools[@]}"; do
            if ! command_exists "$tool"; then
                print_status "Installing $tool..."
                sudo apt install -y "$tool"
                print_success "$tool installed"
            else
                print_success "$tool is already installed"
            fi
        done
        
        # Install Starship
        if ! command_exists starship; then
            print_status "Installing Starship..."
            curl -sS https://starship.rs/install.sh | sh
            print_success "Starship installed"
        else
            print_success "Starship is already installed"
        fi
        
        # Install FZF
        if ! command_exists fzf; then
            print_status "Installing FZF..."
            sudo apt install -y fzf
            print_success "FZF installed"
        else
            print_success "FZF is already installed"
        fi
    fi
}

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

print_status "Starting dotfiles installation..."
print_status "Dotfiles directory: $DOTFILES_DIR"

# =============================================================================
# Detect Operating System
# =============================================================================

print_status "Detecting operating system..."

if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    print_success "Detected macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if grep -qi Microsoft /proc/version 2>/dev/null; then
        OS="wsl"
        print_success "Detected WSL2"
    else
        OS="linux"
        print_success "Detected Linux"
    fi
else
    print_error "Unsupported operating system: $OSTYPE"
    exit 1
fi

# =============================================================================
# Check Prerequisites
# =============================================================================

print_status "Checking prerequisites..."

# Check if zsh is installed
if ! command_exists zsh; then
    print_error "ZSH is not installed. Please install ZSH first."
    if [[ "$OS" == "macos" ]]; then
        print_status "On macOS, you can install ZSH with: brew install zsh"
    elif [[ "$OS" == "linux" || "$OS" == "wsl" ]]; then
        print_status "On Ubuntu/Debian, you can install ZSH with: sudo apt install zsh"
    fi
    exit 1
fi

print_success "ZSH is installed"

# =============================================================================
# Backup Existing Configuration
# =============================================================================

print_status "Backing up existing configuration..."

# Backup existing .zshrc
if [[ -f "$HOME/.zshrc" ]]; then
    BACKUP_FILE="$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$HOME/.zshrc" "$BACKUP_FILE"
    print_success "Backed up existing .zshrc to $BACKUP_FILE"
fi

# Backup existing zsh config directory
if [[ -d "$HOME/.config/zsh" ]]; then
    BACKUP_DIR="$HOME/.config/zsh.backup.$(date +%Y%m%d_%H%M%S)"
    cp -r "$HOME/.config/zsh" "$BACKUP_DIR"
    print_success "Backed up existing zsh config to $BACKUP_DIR"
fi

# =============================================================================
# Create Directories
# =============================================================================

print_status "Creating configuration directories..."

mkdir -p ~/.config
mkdir -p ~/.config/zsh

print_success "Directories created"

# =============================================================================
# Install ZSH Configuration
# =============================================================================

print_status "Installing ZSH configuration..."

# Copy modular zsh configuration
if [[ -d "$DOTFILES_DIR/unix/zsh/modular" ]]; then
    cp -r "$DOTFILES_DIR/unix/zsh/modular"/* ~/.config/zsh/
    print_success "Modular ZSH configuration copied"
else
    print_error "Modular ZSH configuration not found at $DOTFILES_DIR/unix/zsh/modular"
    exit 1
fi

# Install main .zshrc
if [[ -f "$DOTFILES_DIR/unix/.zshrc" ]]; then
    cp "$DOTFILES_DIR/unix/.zshrc" ~/.zshrc
    print_success "Main .zshrc installed"
else
    print_error "Main .zshrc not found at $DOTFILES_DIR/unix/.zshrc"
    exit 1
fi

# =============================================================================
# Install Other Configuration Files
# =============================================================================

print_status "Installing other configuration files..."

# Neofetch configuration
if [[ -d "$DOTFILES_DIR/common/neofetch" ]]; then
    cp -r "$DOTFILES_DIR/common/neofetch" ~/.config/
    print_success "Neofetch configuration installed"
fi

# Starship configuration
if [[ -f "$DOTFILES_DIR/startship/starship.toml" ]]; then
    cp "$DOTFILES_DIR/startship/starship.toml" ~/.config/
    print_success "Starship configuration installed"
fi

# Neovim configuration
if [[ -d "$DOTFILES_DIR/nvim" ]]; then
    cp -r "$DOTFILES_DIR/nvim" ~/.config/
    print_success "Neovim configuration installed"
fi

# Ripgrep configuration
if [[ -f "$DOTFILES_DIR/unix/.ripgreprc" ]]; then
    cp "$DOTFILES_DIR/unix/.ripgreprc" ~/.ripgreprc
    print_success "Ripgrep configuration installed"
fi

# =============================================================================
# Install Recommended Tools
# =============================================================================

print_status "Installing recommended tools..."

# Install system-specific tools
install_system_tools

# Install Rust tools
install_rust_tools

# Install Node.js tools
install_node_tools

# Install Python tools
install_python_tools

# Install ZSH plugins
install_zsh_plugins

# =============================================================================
# Set Permissions
# =============================================================================

print_status "Setting permissions..."

chmod 755 ~/.config/zsh
chmod 644 ~/.zshrc

print_success "Permissions set"

# =============================================================================
# Installation Complete
# =============================================================================

print_success "Installation completed successfully!"
echo ""
print_status "Next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. If you're using WSL2, you might need to restart WSL: wsl --shutdown"
echo ""
print_status "All recommended tools have been installed automatically!"
print_status "If you encounter any issues, check the backup files created during installation." 