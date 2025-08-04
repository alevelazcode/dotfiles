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
    sudo dnf install -y --skip-unavailable \
        dnf-plugins-core \
        dnf-automatic \
        snapd \
        flatpak
        
    print_success "Fedora-specific tools installed"
}

# Install NVIDIA drivers (latest)
install_nvidia_drivers() {
    print_status "Checking for NVIDIA GPU and installing drivers..."
    
    # Check if NVIDIA GPU is present
    if ! lspci | grep -i nvidia &> /dev/null; then
        print_warning "No NVIDIA GPU detected. Skipping NVIDIA driver installation."
        return 0
    fi
    
    print_status "NVIDIA GPU detected. Installing latest NVIDIA drivers..."
    
    # Ensure RPM Fusion non-free is available (required for NVIDIA drivers)
    if ! rpm -qa | grep -q rpmfusion-nonfree-release; then
        print_status "Installing RPM Fusion non-free repository (required for NVIDIA drivers)..."
        sudo dnf install -y \
            https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    fi
    
    # Update package database
    sudo dnf update -y
    
    # Install NVIDIA drivers
    print_status "Installing NVIDIA drivers (akmod-nvidia)..."
    sudo dnf install -y akmod-nvidia
    
    # Install NVIDIA CUDA drivers (for development/computing)
    print_status "Installing NVIDIA CUDA drivers..."
    sudo dnf install -y xorg-x11-drv-nvidia-cuda
    
    # Install additional NVIDIA packages
    print_status "Installing additional NVIDIA packages..."
    sudo dnf install -y --skip-unavailable \
        nvidia-vaapi-driver \
        nvidia-settings \
        vulkan \
        nvidia-container-toolkit
    
    # Build initial kernel modules
    print_status "Building initial NVIDIA kernel modules..."
    sudo akmods --force --rebuild
    
    # Regenerate initramfs
    print_status "Regenerating initramfs..."
    sudo dracut --force
    
    print_success "NVIDIA drivers installed successfully"
    print_warning "Please reboot your system for NVIDIA drivers to take effect"
    print_status "After reboot, you can verify installation with: nvidia-smi"
    
    # Additional recommendations
    print_status "Additional NVIDIA setup recommendations:"
    echo "  - Install nvidia-container-toolkit for Docker GPU support"
    echo "  - Run 'nvidia-settings' for GPU configuration"
    echo "  - Check 'nvidia-smi' for GPU status after reboot"
    echo "  - For gaming, consider installing steam and enabling Proton"
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
            sudo dnf install -y zsh
        fi
        if [[ "$SHELL" != "$(which zsh)" ]]; then
            chsh -s "$(which zsh)"
        fi
    fi
}

# Main function
main() {
    print_status "Starting comprehensive Fedora setup..."
    
    update_system
    install_essential_packages
    install_starship
    install_fastfetch
    install_rust
    setup_shell
    setup_zsh_complete
    install_dev_tools
    install_lazyvim
    install_fedora_tools
    install_nvidia_drivers
    enable_repositories
    
    print_success "Fedora setup complete!"
    print_status "Summary of what was installed:"
    echo "  ✅ System packages and development tools"
    echo "  ✅ ZSH with Oh My Zsh and essential plugins"
    echo "  ✅ Starship prompt and Fastfetch"
    echo "  ✅ Rust toolchain and modern CLI tools"
    echo "  ✅ Node.js, Python, and development packages"
    echo "  ✅ LazyVim (modern Neovim configuration)"
    echo "  ✅ RPM Fusion repositories and Flatpak"
    echo "  ✅ NVIDIA drivers (if GPU detected)"
    print_status ""
    print_warning "Please restart your terminal or reboot for all changes to take effect."
    print_status "You may also want to run 'sudo dnf upgrade' regularly to keep your system updated."
}

main "$@"