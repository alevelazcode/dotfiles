#!/bin/bash

# =============================================================================
# Linux Ubuntu/Debian Setup Script
# =============================================================================

set -e

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
    sudo locale-gen en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
    sudo apt update && sudo apt upgrade -y
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
        python3 \
        python3-pip \
        python3-venv

    print_success "Essential packages installed"
}

# Install Neovim (latest from source or PPA)
install_neovim() {
    print_status "Installing Neovim..."

    if ! command -v nvim &> /dev/null; then
        sudo apt install -y software-properties-common
        sudo add-apt-repository -y ppa:neovim-ppa/unstable
        sudo apt update
        sudo apt install -y neovim
        print_success "Neovim installed"
    else
        print_success "Neovim is already installed"
    fi
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
        sudo apt install -y fastfetch 2>/dev/null || {
            wget -qO /tmp/fastfetch.deb "https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.deb"
            sudo dpkg -i /tmp/fastfetch.deb
            rm /tmp/fastfetch.deb
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

# Install FNM (Fast Node Manager)
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

    # Install Node.js LTS
    if command -v fnm &> /dev/null; then
        fnm install --lts
        fnm default lts-latest
        print_success "Node.js LTS installed via FNM"
    fi
}

# Install modern CLI tools via Cargo
install_rust_tools() {
    print_status "Installing Rust CLI tools..."
    if command -v cargo &> /dev/null; then
        cargo install \
            ripgrep \
            fd-find \
            bat \
            eza \
            tokei \
            du-dust \
            procs \
            sd \
            tealdeer \
            zoxide \
            cargo-watch \
            cargo-edit \
            cargo-update
        print_success "Rust CLI tools installed"
    fi
}

# Setup shell
setup_shell() {
    print_status "Setting up shell configuration..."
    if [[ "$SHELL" != "$(which zsh)" ]]; then
        chsh -s "$(which zsh)"
    fi
    print_success "ZSH is the default shell"
}

# Install dev tools (global npm packages, Python tools)
install_dev_tools() {
    print_status "Installing development tools..."

    if command -v npm &> /dev/null; then
        npm install -g \
            typescript \
            ts-node \
            prettier \
            yarn \
            pnpm
        print_success "Node.js global packages installed"
    fi

    if command -v pip3 &> /dev/null; then
        if ! command -v pipx &> /dev/null; then
            pip3 install --user pipx
        fi
        pipx ensurepath
        for app in black flake8 mypy ipython; do
            pipx install "$app" 2>/dev/null || true
        done
        print_success "Python tools installed via pipx"
    fi
}

# Main
main() {
    print_status "Starting Linux Ubuntu/Debian setup..."

    update_system
    install_essential_packages
    install_neovim
    install_zinit
    install_starship
    install_fastfetch
    install_rust
    install_fnm
    setup_shell
    install_rust_tools
    install_dev_tools

    print_success "Linux setup complete!"
    echo "  - System packages and build tools"
    echo "  - ZSH + Zinit (plugin manager)"
    echo "  - FNM + Node.js LTS"
    echo "  - Rust toolchain + modern CLI tools"
    echo "  - Neovim (custom NvChad config)"
    echo "  - Starship prompt + Fastfetch"
    print_warning "Restart your terminal or run 'source ~/.zshrc'"
}

main "$@"
