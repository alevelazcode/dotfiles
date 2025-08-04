#!/bin/bash

# =============================================================================
# Fedora Setup Script
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
    
    # Update package repository
    sudo dnf update -y
    print_success "System updated"
}

# Install essential packages
install_essential_packages() {
    print_status "Installing essential packages..."
    
    # Install packages with --skip-unavailable to handle missing/renamed packages
    sudo dnf install -y --skip-unavailable \
        git \
        curl \
        wget \
        zsh \
        gcc \
        gcc-c++ \
        make \
        cmake \
        pkgconf-devel \
        openssl-devel \
        readline-devel \
        zlib-ng-compat-devel \
        bzip2-devel \
        sqlite-devel \
        ncurses-devel \
        xz-devel \
        tk-devel \
        libxml2-devel \
        xmlsec1-devel \
        libffi-devel \
        xz-devel \
        unzip \
        htop \
        tree \
        fzf \
        tmux \
        jq \
        neovim \
        python3 \
        python3-pip \
        nodejs \
        npm \
        util-linux
        
    # Install packages that might have different names or be optional
    print_status "Installing additional development packages..."
    sudo dnf install -y --skip-unavailable \
        python3-venv \
        python3-pipx \
        development-tools \
        @development-tools
        
    print_success "Essential packages installed"
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
        # Try DNF repository first
        if sudo dnf list fastfetch 2>/dev/null | grep -q "Available Packages"; then
            sudo dnf install -y fastfetch
            print_success "Fastfetch installed from DNF repository"
        else
            # Download and install fastfetch manually
            wget -qO- https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-x64.tar.gz | tar -xz
            sudo mv fastfetch /usr/local/bin/
            print_success "Fastfetch installed manually"
        fi
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
        print_status "Installing Node.js global packages..."
        for package in typescript ts-node nodemon eslint prettier yarn; do
            if ! npm list -g "$package" &>/dev/null; then
                sudo npm install -g "$package" || print_warning "Failed to install $package"
            else
                print_status "$package is already installed globally"
            fi
        done
        print_success "Node.js packages processed"
    fi
    
    # Install Rust packages
    if command -v cargo &> /dev/null; then
        print_status "Installing Rust packages..."
        for package in ripgrep fd-find bat eza tokei cargo-watch cargo-edit du-dust procs sd tealdeer cargo-update; do
            if ! cargo install --list | grep -q "^$package "; then
                cargo install "$package" || print_warning "Failed to install $package"
            else
                print_status "$package is already installed"
            fi
        done
        print_success "Rust packages processed"
    fi
    
    # Install Python packages
    if command -v pip3 &> /dev/null; then
        # Install pipx for Python applications
        if command -v pipx &> /dev/null; then
            # Ensure pipx PATH is set up
            pipx ensurepath
            print_success "pipx PATH configured"
            
            # Install Python applications via pipx (skip if already installed)
            print_status "Installing Python applications via pipx..."
            for app in black flake8 mypy pytest ipython jupyterlab; do
                if ! pipx list | grep -q "^  package $app "; then
                    pipx install "$app" || print_warning "Failed to install $app via pipx"
                else
                    print_status "$app is already installed via pipx"
                fi
            done
            print_success "Python applications processed via pipx"
        else
            # Install pipx if not available (try DNF first, then pip)
            if ! sudo dnf install -y python3-pipx 2>/dev/null; then
                print_status "Installing pipx via pip..."
                pip3 install --user pipx
            fi
            pipx ensurepath
            print_success "pipx PATH configured"
            
            # Install Python applications via pipx (skip if already installed)
            print_status "Installing Python applications via pipx..."
            for app in black flake8 mypy pytest ipython jupyterlab; do
                if ! pipx list | grep -q "^  package $app "; then
                    pipx install "$app" || print_warning "Failed to install $app via pipx"
                else
                    print_status "$app is already installed via pipx"
                fi
            done
            print_success "Python applications processed via pipx"
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

# Install Fedora-specific tools
install_fedora_tools() {
    print_status "Installing Fedora-specific tools..."
    
    # Install RPM Fusion repositories for additional packages
    if ! rpm -qa | grep -q rpmfusion-free-release; then
        print_status "Installing RPM Fusion repositories..."
        sudo dnf install -y \
            https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
            https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
        print_success "RPM Fusion repositories installed"
    fi
    
    # Install additional development tools
    sudo dnf install -y \
        dnf-plugins-core \
        dnf-automatic \
        snapd \
        flatpak
        
    print_success "Fedora-specific tools installed"
}

# Enable additional repositories
enable_repositories() {
    print_status "Enabling additional repositories..."
    
    # Enable Flathub
    if command -v flatpak &> /dev/null; then
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        print_success "Flathub repository enabled"
    fi
    
    # Enable PowerTools/CRB repository if available
    if sudo dnf repolist --all | grep -q powertools; then
        sudo dnf config-manager --set-enabled powertools
        print_success "PowerTools repository enabled"
    elif sudo dnf repolist --all | grep -q crb; then
        sudo dnf config-manager --set-enabled crb
        print_success "CRB repository enabled"
    fi
}

# Main function
main() {
    print_status "Starting Fedora setup..."
    
    update_system
    install_essential_packages
    install_starship
    install_fastfetch
    install_rust
    setup_shell
    install_dev_tools
    install_lazyvim
    install_fedora_tools
    enable_repositories
    
    print_success "Fedora setup complete!"
    print_status "Please restart your terminal for all changes to take effect."
    print_status "You may also want to run 'sudo dnf upgrade' regularly to keep your system updated."
}

main "$@"