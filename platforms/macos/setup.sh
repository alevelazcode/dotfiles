#!/bin/bash

# =============================================================================
# macOS Setup Script
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

# Install Homebrew
install_homebrew() {
    print_status "Checking Homebrew installation..."

    if ! command -v brew &> /dev/null; then
        print_status "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        print_success "Homebrew is already installed"
    fi

    print_status "Updating Homebrew package database..."
    brew update
}

# Install packages from Brewfile
install_packages() {
    print_status "Installing packages from Brewfile..."

    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    if [[ -f "$SCRIPT_DIR/Brewfile" ]]; then
        # --no-upgrade: install missing packages only, don't upgrade existing ones
        # Run 'brew upgrade' manually when you want to update everything
        brew bundle --file="$SCRIPT_DIR/Brewfile" --no-upgrade \
            || print_warning "Some Brewfile packages failed (non-critical)"
        print_success "Brewfile packages processed"
    else
        print_error "Brewfile not found at $SCRIPT_DIR/Brewfile"
        exit 1
    fi
}

# Setup shell
setup_shell() {
    print_status "Setting up shell configuration..."

    local zsh_path
    zsh_path="$(command -v zsh)"

    # Add Homebrew zsh to /etc/shells if missing (required by chsh)
    if ! grep -qxF "$zsh_path" /etc/shells; then
        print_status "Adding $zsh_path to /etc/shells..."
        echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
    fi

    if [[ "$SHELL" != "$zsh_path" ]]; then
        print_status "Setting zsh as default shell..."
        chsh -s "$zsh_path"
    fi
    print_success "ZSH is the default shell"
}

# Setup FNM and install latest Node.js LTS
setup_fnm() {
    print_status "Setting up FNM (Fast Node Manager)..."

    if command -v fnm &> /dev/null; then
        eval "$(fnm env --use-on-cd)"

        if ! fnm list | grep -q "lts-latest"; then
            print_status "Installing latest Node.js LTS..."
            fnm install --lts
            fnm default lts-latest
        fi
        print_success "FNM configured with Node.js LTS"
    else
        print_warning "FNM not found — will be available after brew bundle"
    fi
}

# Setup Rust via rustup
setup_rust() {
    print_status "Setting up Rust..."

    if command -v rustc &> /dev/null; then
        print_success "Rust toolchain already installed"
        return 0
    fi

    if command -v rustup-init &> /dev/null; then
        rustup-init -y --no-modify-path
        source "$HOME/.cargo/env"
        print_success "Rust toolchain installed via rustup-init"
    elif command -v rustup &> /dev/null; then
        rustup install stable
        source "$HOME/.cargo/env"
        print_success "Rust toolchain installed via rustup"
    else
        print_warning "Neither rustup-init nor rustup found — install via 'brew install rustup-init'"
    fi
}

# Start skhd and yabai services
setup_wm_services() {
    print_status "Setting up window management services..."

    if command -v skhd &> /dev/null; then
        skhd --start-service 2>/dev/null || true
        print_success "skhd service started"
    fi

    if command -v yabai &> /dev/null; then
        yabai --start-service 2>/dev/null || true
        print_success "yabai service started"
    fi
}

# Install development tools
install_dev_tools() {
    print_status "Installing development tools..."

    # Node.js global packages (via fnm-managed npm)
    if command -v npm &> /dev/null; then
        npm install -g \
            typescript \
            ts-node \
            prettier \
            yarn \
            pnpm \
            || print_warning "Some npm packages failed to install"
        print_success "Node.js global packages installed"
    fi

    # Cargo dev extensions only (CLI tools already installed via Brewfile)
    if command -v cargo &> /dev/null; then
        for pkg in cargo-watch cargo-edit cargo-update; do
            cargo install "$pkg" 2>/dev/null || print_warning "Failed to install $pkg (may already be installed)"
        done
        print_success "Cargo extensions installed"
    fi
}

# Main
main() {
    print_status "Starting macOS setup..."

    install_homebrew
    install_packages
    setup_shell
    setup_fnm
    setup_rust
    setup_wm_services
    install_dev_tools

    print_success "macOS setup complete!"
    echo "  - Homebrew packages from Brewfile"
    echo "  - ZSH + Zinit (plugin manager)"
    echo "  - FNM + Node.js LTS"
    echo "  - Rust toolchain"
    echo "  - skhd + yabai (window management)"
    echo "  - Neovim (custom NvChad config)"
    echo "  - Zed, Zen browser, Wezterm"
    print_warning "Restart your terminal or run 'source ~/.zshrc'"
}

main "$@"
