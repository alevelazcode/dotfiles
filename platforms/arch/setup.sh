#!/bin/bash

# =============================================================================
# Arch Linux / EndeavourOS Setup Script
# =============================================================================
# Supports: Arch Linux, EndeavourOS, Manjaro, and other Arch-based distros
# Primary package manager: paru (AUR helper)
# Fallback: pacman (official repos)
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

# =============================================================================
# Core System Functions (SRP: Single Responsibility Principle)
# =============================================================================

# Update system packages
update_system() {
    print_status "Updating system packages..."
    sudo pacman -Syu --noconfirm
    print_success "System updated"
}

# Install base-devel, zsh, and prerequisites for AUR
# zsh MUST be installed early so chsh and symlinks work even if later steps fail
install_build_prerequisites() {
    print_status "Installing build prerequisites + zsh..."

    local prerequisites=(
        base-devel
        git
        curl
        wget
        zsh
    )

    sudo pacman -S --needed --noconfirm "${prerequisites[@]}"
    print_success "Build prerequisites + zsh installed"
}

# =============================================================================
# Package Manager Functions (DIP: Dependency Inversion Principle)
# =============================================================================

# Install paru AUR helper if not present or broken (e.g. libalpm mismatch)
install_paru() {
    if command -v paru &> /dev/null && paru --version &> /dev/null; then
        print_success "paru is already installed"
        return 0
    fi

    if command -v paru &> /dev/null; then
        print_warning "paru exists but is broken (likely libalpm version mismatch), rebuilding..."
    fi

    print_status "Installing paru AUR helper..."

    local temp_dir
    temp_dir=$(mktemp -d)
    trap "rm -rf '$temp_dir'" EXIT

    cd "$temp_dir"
    git clone https://aur.archlinux.org/paru-bin.git
    cd paru-bin
    makepkg -si --noconfirm

    cd - > /dev/null

    if command -v paru &> /dev/null; then
        print_success "paru installed successfully"
    else
        print_error "Failed to install paru"
        return 1
    fi
}

# Configure paru for better performance
configure_paru() {
    local paru_conf="$HOME/.config/paru/paru.conf"

    if [[ ! -f "$paru_conf" ]]; then
        print_status "Configuring paru for optimal performance..."
        mkdir -p "$(dirname "$paru_conf")"

        cat > "$paru_conf" << 'EOF'
[options]
BottomUp
SudoLoop
CleanAfter
BatchInstall
CombinedUpgrade
NewsOnUpgrade

[bin]
PreBuildCommand = true
FileManager = ranger
Pager = less
EOF
        print_success "paru configured"
    fi
}

# Generic package installer
# Tests that paru actually works (not just exists) before using it — avoids
# silent failures when paru is broken (e.g. libalpm.so version mismatch).
install_packages() {
    local -a packages=("$@")

    if [[ ${#packages[@]} -eq 0 ]]; then
        print_warning "No packages specified"
        return 0
    fi

    if command -v paru &> /dev/null && paru --version &> /dev/null; then
        paru -S --needed --noconfirm "${packages[@]}" 2>&1 | grep -v "warning: database file" || true
    else
        sudo pacman -S --needed --noconfirm "${packages[@]}" 2>&1 | grep -v "warning: database file" || true
    fi
}

# =============================================================================
# Essential Packages Installation (SRP)
# =============================================================================

install_essential_packages() {
    print_status "Installing essential packages..."

    local essential_packages=(
        # Core utilities (zsh/git/curl already in build prerequisites)
        htop
        tree
        unzip
        fzf
        tmux
        jq

        # Build tools (equivalent to build-essential in Debian)
        base-devel
        cmake
        pkgconf

        # Development libraries (no -dev suffix in Arch)
        openssl
        readline
        zlib
        bzip2
        sqlite
        ncurses
        xz
        tk
        libxml2
        xmlsec
        libffi

        # Python (python3 is just "python" in Arch)
        python
        python-pip
        python-pipx

        # Modern CLI tools (all available in official repos)
        ripgrep
        fd
        bat
        eza
        zoxide
        dust
        procs
        sd
        tealdeer
        tokei
        bottom
        git-delta

        # Package managers (flatpak from official repos)
        flatpak
    )

    install_packages "${essential_packages[@]}"
    print_success "Essential packages installed"
}

# Enable flatpak + snapd services after installation
setup_package_managers() {
    # Flatpak: add Flathub remote + install flatpak apps
    if command -v flatpak &> /dev/null; then
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo 2>/dev/null || true
        print_success "Flatpak + Flathub configured"

        # WezTerm — AUR package is abandoned, flatpak is the maintained source
        if ! flatpak list --app 2>/dev/null | grep -q org.wezfurlong.wezterm; then
            print_status "Installing WezTerm via Flatpak..."
            flatpak install -y flathub org.wezfurlong.wezterm && print_success "WezTerm installed" \
                || print_warning "Failed to install WezTerm via Flatpak"
        else
            print_success "WezTerm is already installed"
        fi
    fi

    # Snapd: install from AUR + enable service + create symlink
    if ! command -v snap &> /dev/null; then
        print_status "Installing snapd from AUR..."
        install_packages snapd
    fi
    if command -v snap &> /dev/null; then
        sudo systemctl enable --now snapd.socket
        sudo systemctl enable --now snapd.apparmor 2>/dev/null || true
        # Classic snap support requires this symlink
        [[ -L /snap ]] || sudo ln -sf /var/lib/snapd/snap /snap
        print_success "Snapd enabled"
    fi
}

# =============================================================================
# Development Tools Installation (SRP)
# =============================================================================

# Install Neovim (latest stable)
install_neovim() {
    print_status "Installing Neovim..."

    if command -v nvim &> /dev/null; then
        print_success "Neovim is already installed"
        return 0
    fi

    install_packages neovim
    print_success "Neovim installed"
}

# Install ZSH plugin manager (Zinit)
install_zinit() {
    print_status "Installing Zinit..."

    local zinit_dir="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

    if [[ -d "$zinit_dir" ]]; then
        print_success "Zinit is already installed"
        return 0
    fi

    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
    print_success "Zinit installed"
}

# Install Starship prompt
install_starship() {
    print_status "Installing Starship prompt..."

    if command -v starship &> /dev/null; then
        print_success "Starship is already installed"
        return 0
    fi

    install_packages starship
    print_success "Starship installed"
}

# Install Fastfetch system info tool
install_fastfetch() {
    print_status "Installing Fastfetch..."

    if command -v fastfetch &> /dev/null; then
        print_success "Fastfetch is already installed"
        return 0
    fi

    install_packages fastfetch
    print_success "Fastfetch installed"
}

# Install Rust toolchain
install_rust() {
    print_status "Installing Rust..."

    if command -v rustc &> /dev/null; then
        print_success "Rust is already installed"
        return 0
    fi

    # Install rustup from official repos (Arch way)
    install_packages rustup

    # Initialize default toolchain
    rustup default stable

    print_success "Rust installed"
}

# Install FNM (Fast Node Manager)
install_fnm() {
    print_status "Installing FNM..."

    if command -v fnm &> /dev/null; then
        print_success "FNM is already installed"
    else
        install_packages fnm
        print_success "FNM installed"
    fi

    # Setup FNM environment
    export PATH="$HOME/.local/share/fnm:$PATH"
    if command -v fnm &> /dev/null; then
        eval "$(fnm env --use-on-cd)"

        # Install Node.js LTS
        print_status "Installing Node.js LTS via FNM..."
        fnm install --lts
        fnm default lts-latest
        print_success "Node.js LTS installed"
    fi
}

# =============================================================================
# Cargo Development Tools (SRP + Performance Optimization)
# =============================================================================

# Install cargo-specific development tools
# NOTE: Modern CLI tools (ripgrep, fd, bat, etc.) are installed in install_essential_packages()
# as they are ALL available in official Arch repos (unlike Ubuntu where cargo is needed)
install_cargo_tools() {
    print_status "Installing Cargo development tools..."

    if ! command -v cargo &> /dev/null; then
        print_warning "Cargo not found, skipping cargo tools"
        return 0
    fi

    # All cargo tools are now in official Arch repos! (moved from AUR)
    # Much faster than cargo install and better integrated with pacman
    local cargo_tools=(
        cargo-watch      # Auto-recompile on file changes
        cargo-edit       # Add/remove dependencies from CLI
        cargo-update     # Update installed binaries
        cargo-binstall   # Install pre-compiled binaries (faster than cargo install)
    )

    install_packages "${cargo_tools[@]}"
    print_success "Cargo development tools installed"
}

# =============================================================================
# Additional Development Tools (SRP)
# =============================================================================

install_java() {
    print_status "Installing Java Development Kit..."

    if command -v javac &> /dev/null; then
        local java_version
        java_version=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
        print_success "Java JDK $java_version is already installed"
        return 0
    fi

    # Install Java 17 LTS (matching Ubuntu setup for compatibility)
    # Available: jdk-openjdk (latest), jdk17-openjdk, jdk11-openjdk
    install_packages jdk17-openjdk
    print_success "Java 17 JDK installed"
}

install_docker() {
    print_status "Installing Docker..."

    if command -v docker &> /dev/null; then
        print_success "Docker is already installed"
        return 0
    fi

    install_packages docker docker-compose

    # Enable and start Docker service
    sudo systemctl enable docker.service
    sudo systemctl start docker.service

    # Add user to docker group
    if ! groups "$USER" | grep -q docker; then
        sudo usermod -aG docker "$USER"
        print_warning "User added to docker group. Log out and back in for changes to take effect."
    fi

    print_success "Docker installed"
}

# =============================================================================
# Node.js and Python Global Tools (SRP)
# =============================================================================

install_node_global_packages() {
    print_status "Installing Node.js global packages..."

    if ! command -v npm &> /dev/null; then
        print_warning "npm not found, skipping Node.js global packages"
        return 0
    fi

    local npm_packages=(
        typescript
        ts-node
        prettier
        eslint
        yarn
        pnpm
    )

    npm install -g "${npm_packages[@]}" || print_warning "Some npm packages failed to install"
    print_success "Node.js global packages installed"
}

install_python_tools() {
    print_status "Installing Python development tools..."

    if ! command -v pipx &> /dev/null; then
        print_warning "pipx not found, skipping Python tools"
        return 0
    fi

    # Ensure pipx path is configured
    pipx ensurepath 2>/dev/null || true

    local python_tools=(
        black       # Code formatter
        flake8      # Linter
        mypy        # Type checker
        ipython     # Enhanced REPL
        poetry      # Dependency manager
    )

    for tool in "${python_tools[@]}"; do
        pipx install "$tool" 2>/dev/null || print_warning "Failed to install $tool"
    done

    print_success "Python tools installed"
}

# =============================================================================
# GUI Applications (OCP: Open/Closed Principle)
# =============================================================================

install_gui_applications() {
    print_status "Installing GUI applications..."

    # Check if running on a graphical environment
    if [[ -z "${DISPLAY:-}" ]] && [[ -z "${WAYLAND_DISPLAY:-}" ]]; then
        print_warning "No graphical environment detected, skipping GUI apps"
        return 0
    fi

    # Official repos (pacman) - best option
    print_status "Installing GUI apps from official repos..."
    local official_gui_apps=(
        firefox
        telegram-desktop    # Official package (matching Ubuntu snap)
    )
    install_packages "${official_gui_apps[@]}" 2>/dev/null || print_warning "Some official GUI apps failed"

    # AUR packages (paru) - for proprietary apps
    if command -v paru &> /dev/null; then
        print_status "Installing GUI apps from AUR..."
        local aur_gui_apps=(
            visual-studio-code-bin      # VSCode binary
            android-studio              # Android development (matching Ubuntu snap)
            teams-for-linux-bin         # Microsoft Teams wrapper (matching Ubuntu snap)
            postman-bin                 # API testing tool (matching Ubuntu snap)
            mongodb-compass-bin         # MongoDB GUI (matching Ubuntu snap)
        )

        for app in "${aur_gui_apps[@]}"; do
            if paru -Qi "$app" &>/dev/null; then
                print_success "$app is already installed"
            else
                print_status "Installing $app from AUR..."
                paru -S --needed --noconfirm "$app" 2>/dev/null && print_success "$app installed" \
                    || print_warning "Failed to install $app (non-critical, can install manually)"
            fi
        done
    else
        print_warning "paru not available, skipping AUR GUI apps (android-studio, teams-for-linux, postman, mongodb-compass)"
        print_status "You can install them later with: paru -S android-studio teams-for-linux-bin postman-bin mongodb-compass-bin"
    fi

    print_success "GUI applications installation complete"
}

# =============================================================================
# Shell Configuration (SRP)
# =============================================================================

setup_shell() {
    print_status "Setting up ZSH as default shell..."

    local zsh_path
    zsh_path="$(command -v zsh)"

    if [[ "$SHELL" != "$zsh_path" ]]; then
        chsh -s "$zsh_path"
        print_success "ZSH set as default shell"
    else
        print_success "ZSH is already the default shell"
    fi
}

# =============================================================================
# Arch-Specific Optimizations (SRP)
# =============================================================================

optimize_pacman() {
    print_status "Optimizing pacman configuration..."

    local pacman_conf="/etc/pacman.conf"

    # Enable parallel downloads
    if ! grep -q "^ParallelDownloads" "$pacman_conf"; then
        print_status "Enabling parallel downloads..."
        sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' "$pacman_conf"
        print_success "Parallel downloads enabled"
    fi

    # Enable Color output
    if ! grep -q "^Color" "$pacman_conf"; then
        sudo sed -i 's/^#Color/Color/' "$pacman_conf"
    fi

    # Enable ILoveCandy (Pac-Man progress bar)
    if ! grep -q "ILoveCandy" "$pacman_conf"; then
        sudo sed -i '/^Color/a ILoveCandy' "$pacman_conf"
    fi

    print_success "pacman optimized"
}

enable_multilib() {
    print_status "Enabling multilib repository (32-bit support)..."

    local pacman_conf="/etc/pacman.conf"

    if ! grep -q "^\[multilib\]" "$pacman_conf"; then
        echo "" | sudo tee -a "$pacman_conf" > /dev/null
        echo "[multilib]" | sudo tee -a "$pacman_conf" > /dev/null
        echo "Include = /etc/pacman.d/mirrorlist" | sudo tee -a "$pacman_conf" > /dev/null
        sudo pacman -Sy
        print_success "multilib repository enabled"
    else
        print_success "multilib repository is already enabled"
    fi
}

# =============================================================================
# Main Installation Flow (LSP: Liskov Substitution Principle)
# =============================================================================

main() {
    print_status "Starting Arch Linux setup..."

    # System optimization and prerequisites (zsh installed here)
    optimize_pacman
    enable_multilib
    update_system
    install_build_prerequisites
    setup_shell

    # Package manager setup
    install_paru
    configure_paru

    # Core packages
    install_essential_packages
    setup_package_managers

    # Development environments
    install_neovim
    install_rust
    install_fnm
    install_java
    install_docker

    # Shell and prompt
    install_zinit
    install_starship
    install_fastfetch

    # Cargo development tools
    install_cargo_tools

    # Development tools
    install_node_global_packages
    install_python_tools

    # GUI applications (optional)
    install_gui_applications

    print_success "Arch Linux setup complete!"
    echo ""
    echo "Installed components:"
    echo "  ✓ Optimized pacman configuration (parallel downloads)"
    echo "  ✓ paru AUR helper (optimized for performance)"
    echo "  ✓ base-devel + essential build tools"
    echo "  ✓ All modern CLI tools (ripgrep, fd, bat, eza, zoxide, etc.) via pacman"
    echo "  ✓ Flatpak + Snapd package managers"
    echo "  ✓ ZSH + Zinit plugin manager"
    echo "  ✓ FNM + Node.js LTS"
    echo "  ✓ Rust toolchain + cargo development tools"
    echo "  ✓ Neovim (custom config)"
    echo "  ✓ Starship prompt + Fastfetch"
    echo "  ✓ Java 17 JDK + Docker"
    echo "  ✓ Python tools + Node.js packages"
    echo "  ✓ GUI applications (Telegram, VSCode, Android Studio, etc.)"
    echo ""
    print_warning "Restart your terminal or run 'source ~/.zshrc' to apply changes"

    if groups "$USER" | grep -q docker; then
        : # docker group already active
    else
        print_warning "Log out and back in for Docker group membership to take effect"
    fi
}

main "$@"
