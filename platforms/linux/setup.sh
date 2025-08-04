#!/bin/bash

# =============================================================================
# Linux Ubuntu Setup Script
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

# Update system packages
update_system() {
    print_status "Updating system packages..."
    
    # Set up locale
    print_status "Setting up locale..."
    sudo locale-gen en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
    
    sudo apt update
    sudo apt upgrade -y
    print_success "System updated"
}

# Install essential packages
install_essential_packages() {
    print_status "Installing essential packages..."
    
    sudo apt install -y \
        git \
        curl \
        wget \
        zsh \
        build-essential \
        cmake \
        pkg-config \
        libssl-dev \
        libreadline-dev \
        zlib1g-dev \
        libbz2-dev \
        libsqlite3-dev \
        libncursesw5-dev \
        xz-utils \
        tk-dev \
        libxml2-dev \
        libxmlsec1-dev \
        libffi-dev \
        liblzma-dev \
        unzip \
        htop \
        tree \
        fzf \
        tmux \
        jq \
        yq \
        neovim \
        python3 \
        python3-pip \
        python3-venv \
        nodejs \
        npm
}

# Install Starship
install_starship() {
    print_status "Installing Starship prompt..."
    
    if ! command -v starship &> /dev/null; then
        curl -sS https://starship.rs/install.sh | sh
        print_success "Starship installed"
    else
        print_success "Starship is already installed"
    fi
}

# Install Fastfetch
install_fastfetch() {
    print_status "Installing Fastfetch..."
    
    if ! command -v fastfetch &> /dev/null; then
        # Download and install fastfetch
        wget -qO- https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-x64.tar.gz | tar -xz
        sudo mv fastfetch /usr/local/bin/
        print_success "Fastfetch installed"
    else
        print_success "Fastfetch is already installed"
    fi
}

# Install Rust
install_rust() {
    print_status "Installing Rust..."
    
    if ! command -v rustc &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source ~/.cargo/env
        print_success "Rust installed"
    else
        print_success "Rust is already installed"
    fi
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
        sudo npm install -g \
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
            # Install pipx if not available
            pip3 install --user pipx
            pipx ensurepath
            print_success "pipx PATH configured"
            
            pipx install black
            pipx install flake8
            pipx install mypy
            pipx install pytest
            pipx install ipython
            pipx install jupyterlab
            print_success "Python applications installed via pipx"
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
            sudo apt install -y zsh
        fi
        if [[ "$SHELL" != "$(which zsh)" ]]; then
            chsh -s "$(which zsh)"
        fi
    fi
}

# Main function
main() {
    print_status "Starting comprehensive Linux Ubuntu setup..."
    
    update_system
    install_essential_packages
    install_starship
    install_fastfetch
    install_rust
    setup_shell
    setup_zsh_complete
    install_dev_tools
    install_lazyvim
    
    print_success "Linux Ubuntu setup complete!"
    print_status "Summary of what was installed:"
    echo "  ✅ System packages and development tools"
    echo "  ✅ ZSH with Oh My Zsh and essential plugins"
    echo "  ✅ Starship prompt and Fastfetch"
    echo "  ✅ Rust toolchain and modern CLI tools"
    echo "  ✅ Node.js, Python, and development packages"
    echo "  ✅ LazyVim (modern Neovim configuration)"
    print_status ""
    print_warning "Please restart your terminal for all changes to take effect."
}

main "$@" 