#!/bin/bash

# =============================================================================
# macOS Setup Script
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Install Homebrew
install_homebrew() {
    print_status "Checking Homebrew installation..."
    
    if ! command -v brew &> /dev/null; then
        print_status "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        print_success "Homebrew is already installed"
    fi
    
    # Update Homebrew
    print_status "Updating Homebrew..."
    brew update
    brew upgrade
}

# Install packages from Brewfile
install_packages() {
    print_status "Installing packages from Brewfile..."
    
    if [[ -f "Brewfile" ]]; then
        brew bundle --file=Brewfile
        print_success "Packages installed from Brewfile"
    else
        print_warning "Brewfile not found, installing common packages..."
        
        # Install common packages
        brew install \
            git \
            zsh \
            starship \
            fastfetch \
            node \
            rust \
            python \
            pipx \
            fzf \
            tmux \
            htop \
            wget \
            curl \
            jq \
            yq \
            tree \
            neovim
    fi
}

# Install macOS-specific tools
install_macos_tools() {
    print_status "Installing macOS-specific tools..."
    
    # Note: Yabai and SKHD removed from automatic installation
    # If you want to install them manually, run:
    # brew install yabai skhd
    print_status "macOS-specific tools installation complete"
}

# Setup shell configuration
setup_shell() {
    print_status "Setting up shell configuration..."
    
    # Make sure zsh is the default shell
    if [[ "$SHELL" != "/bin/zsh" ]]; then
        print_status "Setting zsh as default shell..."
        chsh -s /bin/zsh
    fi
}

# Install development tools
install_dev_tools() {
    print_status "Installing development tools..."
    
    # Install Node.js packages
    if command -v npm &> /dev/null; then
        npm install -g \
            typescript \
            ts-node \
            nodemon \
            eslint \
            prettier \
            yarn
        print_success "Node.js packages installed"
    fi
    
    # Install Rust packages
    if command -v cargo &> /dev/null; then
        cargo install \
            ripgrep \
            fd-find \
            bat \
            eza \
            tokei \
            cargo-watch \
            cargo-edit \
            du-dust \
            procs \
            sd \
            tealdeer \
            cargo-update
        print_success "Rust packages installed"
    fi
    
    # Install Python packages
    if command -v pip3 &> /dev/null; then
        # Install pipx for Python applications
        if command -v pipx &> /dev/null; then
            # Ensure pipx PATH is set up
            pipx ensurepath
            print_success "pipx PATH configured"
            
            # Install Python applications via pipx
            pipx install black
            pipx install flake8
            pipx install mypy
            pipx install pytest
            pipx install ipython
            pipx install jupyterlab
            print_success "Python applications installed via pipx"
        else
            print_warning "pipx not found, skipping Python application installation"
        fi
        
        # Create a development virtual environment for additional packages
        if [[ ! -d ~/.venv/dev ]]; then
            python3 -m venv ~/.venv/dev
            print_success "Development virtual environment created"
        fi
        
        # Install development packages in virtual environment
        if [[ -d ~/.venv/dev ]]; then
            source ~/.venv/dev/bin/activate
            pip install --upgrade pip
            pip install \
                black \
                flake8 \
                mypy \
                pytest \
                ipython \
                jupyter
            deactivate
            print_success "Python development packages installed in virtual environment"
        fi
    fi
}

# Install LazyVim
install_lazyvim() {
    print_status "Installing LazyVim..."
    
    # Backup existing Neovim configuration
    if [[ -d ~/.config/nvim ]]; then
        print_warning "Backing up existing Neovim configuration..."
        mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)
    fi
    
    # Install LazyVim
    git clone https://github.com/LazyVim/starter ~/.config/nvim
    rm -rf ~/.config/nvim/.git
    
    print_success "LazyVim installed successfully"
    print_status "You can now customize LazyVim by editing ~/.config/nvim/lua/config/"
}

# Setup ZSH with Oh My Zsh
setup_zsh_complete() {
    print_status "Setting up ZSH with Oh My Zsh and essential plugins..."
    
    # Source the common ZSH setup script
    if [[ -f "$(dirname "$0")/../../shell/common/zsh-setup.sh" ]]; then
        source "$(dirname "$0")/../../shell/common/zsh-setup.sh"
        setup_zsh
    elif [[ -f "./shell/common/zsh-setup.sh" ]]; then
        source "./shell/common/zsh-setup.sh"
        setup_zsh
    else
        print_warning "ZSH setup script not found. Installing ZSH manually..."
        # Fallback: ensure ZSH is installed and set as default
        if ! command -v zsh &> /dev/null; then
            brew install zsh
        fi
        if [[ "$SHELL" != "$(which zsh)" ]]; then
            chsh -s "$(which zsh)"
        fi
    fi
}

# Main function
main() {
    print_status "Starting comprehensive macOS setup..."
    
    install_homebrew
    install_packages
    install_macos_tools
    setup_shell
    setup_zsh_complete
    install_dev_tools
    install_lazyvim
    
    print_success "macOS setup complete!"
    print_status "Summary of what was installed:"
    echo "  ✅ Homebrew and essential packages"
    echo "  ✅ ZSH with Oh My Zsh and essential plugins"
    echo "  ✅ Development tools and modern CLI utilities"
    echo "  ✅ Node.js, Python, and Rust packages"
    echo "  ✅ LazyVim (modern Neovim configuration)"
    print_status ""
    print_warning "Please restart your terminal for all changes to take effect."
}

main "$@"
