#!/bin/bash

# =============================================================================
# Fedora/RHEL Setup Script
# =============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status()  { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

# Update system
update_system() {
    print_status "Updating system packages..."
    sudo dnf update -y
    print_success "System updated"
}

# Install essential packages
install_essential_packages() {
    print_status "Installing essential packages..."

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
        unzip \
        htop \
        tree \
        fzf \
        tmux \
        jq \
        neovim \
        python3 \
        python3-pip \
        util-linux

    sudo dnf install -y --skip-unavailable \
        python3-pipx \
        @development-tools

    print_success "Essential packages installed"
}

# Install Zinit
install_zinit() {
    print_status "Installing Zinit..."
    if [[ ! -d "${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git" ]]; then
        bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
        print_success "Zinit installed"
    else
        print_success "Zinit is already installed"
    fi
}

# Install Starship
install_starship() {
    print_status "Installing Starship prompt..."
    if ! command -v starship &> /dev/null; then
        curl -sS https://starship.rs/install.sh | sh -s -- -y
        print_success "Starship installed"
    else
        print_success "Starship is already installed"
    fi
}

# Install Fastfetch
install_fastfetch() {
    print_status "Installing Fastfetch..."
    if ! command -v fastfetch &> /dev/null; then
        sudo dnf install -y fastfetch 2>/dev/null || {
            wget -qO- https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-x64.tar.gz | tar -xz
            sudo mv fastfetch /usr/local/bin/
        }
        print_success "Fastfetch installed"
    else
        print_success "Fastfetch is already installed"
    fi
}

# Install Rust
install_rust() {
    print_status "Installing Rust..."
    if ! command -v rustc &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
        source "$HOME/.cargo/env"
        print_success "Rust installed"
    else
        print_success "Rust is already installed"
    fi
}

# Install FNM
install_fnm() {
    print_status "Installing FNM..."
    if ! command -v fnm &> /dev/null; then
        curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
        export PATH="$HOME/.local/share/fnm:$PATH"
        eval "$(fnm env --use-on-cd)"
        print_success "FNM installed"
    else
        print_success "FNM is already installed"
    fi

    if command -v fnm &> /dev/null; then
        fnm install --lts
        fnm default lts-latest
        print_success "Node.js LTS installed via FNM"
    fi
}

# Setup shell
setup_shell() {
    print_status "Setting up shell configuration..."
    local zsh_path
    zsh_path="$(command -v zsh)"
    if [[ "$SHELL" != "$zsh_path" ]]; then
        chsh -s "$zsh_path"
    fi
    print_success "ZSH is the default shell"
}

# Install Rust CLI tools via cargo-binstall
install_rust_tools() {
    print_status "Installing Rust CLI tools..."
    if ! command -v cargo &> /dev/null; then
        print_warning "Cargo not found, skipping Rust tools"
        return 0
    fi

    # Install cargo-binstall for faster binary installations
    if ! command -v cargo-binstall &> /dev/null; then
        curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
        print_success "cargo-binstall installed"
    fi

    local -a installer=(cargo binstall -y)
    if ! command -v cargo-binstall &> /dev/null; then
        installer=(cargo install)
    fi

    for pkg in ripgrep fd-find bat eza zoxide du-dust procs sd tealdeer tokei bottom git-delta cargo-watch cargo-edit cargo-update; do
        "${installer[@]}" "$pkg" || print_warning "Failed to install $pkg"
    done
    print_success "Rust CLI tools installed"
}

# Install dev tools
install_dev_tools() {
    print_status "Installing development tools..."

    if command -v npm &> /dev/null; then
        npm install -g typescript ts-node prettier yarn pnpm \
            || print_warning "Some npm packages failed to install"
        print_success "Node.js global packages installed"
    fi

    if command -v pipx &> /dev/null; then
        pipx ensurepath 2>/dev/null || true
        for app in black flake8 mypy ipython; do
            pipx install "$app" 2>/dev/null || true
        done
        print_success "Python tools installed via pipx"
    fi
}

# Fedora-specific: RPM Fusion, Flatpak
install_fedora_extras() {
    print_status "Installing Fedora-specific extras..."

    if ! rpm -qa | grep -q rpmfusion-free-release; then
        sudo dnf install -y \
            "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
            "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
        print_success "RPM Fusion repositories installed"
    fi

    sudo dnf install -y --skip-unavailable flatpak
    if command -v flatpak &> /dev/null; then
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        print_success "Flathub enabled"
    fi
}

# NVIDIA drivers
install_nvidia_drivers() {
    if ! lspci | grep -i nvidia &> /dev/null; then
        print_status "No NVIDIA GPU detected, skipping drivers"
        return 0
    fi

    print_status "NVIDIA GPU detected. Installing drivers..."
    sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda
    sudo dnf install -y --skip-unavailable nvidia-vaapi-driver nvidia-settings
    sudo akmods --force --rebuild
    sudo dracut --force
    print_success "NVIDIA drivers installed (reboot required)"
}

# Main
main() {
    print_status "Starting Fedora setup..."

    update_system
    install_essential_packages
    install_zinit
    install_starship
    install_fastfetch
    install_rust
    install_fnm
    setup_shell
    install_rust_tools
    install_dev_tools
    install_fedora_extras
    install_nvidia_drivers

    print_success "Fedora setup complete!"
    echo "  - System packages and development tools"
    echo "  - ZSH + Zinit (plugin manager)"
    echo "  - FNM + Node.js LTS"
    echo "  - Rust toolchain + modern CLI tools"
    echo "  - Neovim (custom NvChad config)"
    echo "  - Starship prompt + Fastfetch"
    echo "  - RPM Fusion + Flatpak"
    print_warning "Restart your terminal or reboot for all changes to take effect."
}

main "$@"
