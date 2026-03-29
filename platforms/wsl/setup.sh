#!/bin/bash

# =============================================================================
# WSL2 Ubuntu Setup Script
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

# Check WSL
check_wsl() {
    if [[ ! -f /proc/version ]] || ! grep -qi microsoft /proc/version; then
        print_error "This script is designed for WSL2. Use the Linux setup instead."
        exit 1
    fi
    print_success "WSL2 environment detected"
}

# Update system
update_system() {
    print_status "Updating system packages..."
    sudo apt update && sudo apt upgrade -y
    print_success "System updated"
}

# Install essential packages
install_essential_packages() {
    print_status "Installing essential packages..."

    # CLI-only — no X11/GUI packages (use Windows-side apps instead)
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
        libffi-dev \
        liblzma-dev \
        unzip \
        htop \
        fzf \
        tmux \
        jq \
        python3 \
        python3-pip \
        python3-venv \
        openssh-client

    # WSL utilities (wslopen, wslview, wslpath helpers, etc.)
    sudo apt install -y wslu 2>/dev/null || print_warning "wslu not available — install manually if needed"
}

# Install Neovim
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

# Install Java 17 JDK (required by React Native / Expo / Android)
install_java() {
    print_status "Installing Java 17 JDK..."
    if ! command -v javac &> /dev/null || ! java -version 2>&1 | grep -q "17"; then
        sudo apt install -y openjdk-17-jdk
        sudo update-alternatives --set java  /usr/lib/jvm/java-17-openjdk-amd64/bin/java  2>/dev/null || true
        sudo update-alternatives --set javac /usr/lib/jvm/java-17-openjdk-amd64/bin/javac 2>/dev/null || true
        print_success "Java 17 JDK installed"
    else
        print_success "Java 17 JDK is already installed"
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

# WSL-specific config
setup_wsl_config() {
    print_status "Setting up WSL-specific configurations..."

    # Try to create .wslconfig on the Windows side
    local win_user
    win_user=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r' || echo "")
    local wslconfig="/mnt/c/Users/${win_user}/.wslconfig"

    if [[ -n "$win_user" ]] && [[ -d "/mnt/c/Users/${win_user}" ]]; then
        # Always overwrite to keep mirrored networking + DNS settings current
        cat > "$wslconfig" <<'WSLCONF'
[wsl2]
memory=8GB
processors=4
swap=2GB
networkingMode=mirrored
dnsTunneling=true
autoProxy=true

[experimental]
hostAddressLoopback=true
WSLCONF
        print_success ".wslconfig written at $wslconfig (mirrored networking enabled)"
    else
        print_warning "Could not detect Windows user. Create .wslconfig manually with networkingMode=mirrored"
    fi

    # Ensure /etc/wsl.conf has sane defaults
    if [[ ! -f /etc/wsl.conf ]]; then
        sudo tee /etc/wsl.conf > /dev/null <<'WSLSYS'
[automount]
enabled = true
options = "metadata,umask=22,fmask=11"

[interop]
enabled = true
appendWindowsPath = true

[network]
generateResolvConf = true
WSLSYS
        print_success "/etc/wsl.conf created with sane defaults"
    else
        print_status "/etc/wsl.conf already exists — skipping"
    fi
}

# Detect Docker Desktop WSL integration
setup_docker_desktop() {
    print_status "Checking Docker Desktop integration..."
    if [[ -S /var/run/docker.sock ]] || command -v docker &> /dev/null; then
        print_success "Docker is available (Docker Desktop WSL integration detected)"
    else
        print_status "Docker not found. Enable WSL integration in Docker Desktop settings if needed."
    fi
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

    if command -v pip3 &> /dev/null; then
        if ! command -v pipx &> /dev/null; then
            pip3 install --user pipx || print_warning "Failed to install pipx"
        fi
        pipx ensurepath 2>/dev/null || true
        for app in black flake8 mypy ipython; do
            pipx install "$app" 2>/dev/null || true
        done
        print_success "Python tools installed via pipx"
    fi
}

# Install Android SDK (Linux-native for fast Gradle builds)
install_android_sdk() {
    print_status "Installing Android SDK (command-line tools)..."

    local sdk_root="$HOME/Android/Sdk"
    local cmdline_dir="$sdk_root/cmdline-tools"

    if [[ -f "$cmdline_dir/latest/bin/sdkmanager" ]]; then
        print_success "Android SDK command-line tools already installed"
    else
        # Download the latest command-line tools for Linux
        local tmp_zip="/tmp/android-cmdline-tools.zip"
        local dl_url="https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"
        wget -qO "$tmp_zip" "$dl_url" || {
            print_warning "Failed to download Android command-line tools"
            return 0
        }
        mkdir -p "$cmdline_dir"
        unzip -qo "$tmp_zip" -d "$cmdline_dir"
        # Google ships them under cmdline-tools/; sdkmanager expects cmdline-tools/latest/
        if [[ -d "$cmdline_dir/cmdline-tools" ]]; then
            mv "$cmdline_dir/cmdline-tools" "$cmdline_dir/latest"
        fi
        rm -f "$tmp_zip"
        print_success "Android command-line tools installed"
    fi

    export ANDROID_HOME="$sdk_root"
    export ANDROID_SDK_ROOT="$sdk_root"
    export PATH="$cmdline_dir/latest/bin:$PATH"

    # Accept licenses non-interactively
    yes | sdkmanager --licenses > /dev/null 2>&1 || true

    # Install required SDK components for React Native / Expo
    print_status "Installing Android SDK packages (platform-tools, build-tools, platform)..."
    sdkmanager --install \
        "platform-tools" \
        "platforms;android-35" \
        "platforms;android-36" \
        "build-tools;35.0.0" \
        "build-tools;36.0.0" \
        "emulator" \
        2>/dev/null || print_warning "Some SDK packages failed — run sdkmanager manually"

    print_success "Android SDK ready at $sdk_root"
    print_status "The Android emulator runs on Windows — use adb.exe wrapper (set in zsh config)"
    print_status "Run the Windows-side setup first: platforms/wsl/windows-setup.ps1"
}

# Prompt to run Windows-side Android setup
setup_windows_android() {
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local ps1_script="$script_dir/windows-setup.ps1"

    if [[ -f "$ps1_script" ]]; then
        local win_path
        win_path=$(wslpath -w "$ps1_script" 2>/dev/null)
        print_status "Windows-side Android setup script available at:"
        echo "  $win_path"
        echo ""
        read -rp "Run Windows setup now? (requires Admin PowerShell) [y/N] " answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            powershell.exe -ExecutionPolicy Bypass -File "$win_path" || {
                print_warning "Windows setup failed or was not run as Admin."
                print_status "Run manually from an elevated PowerShell:"
                echo "  powershell -ExecutionPolicy Bypass -File \"$win_path\""
            }
        else
            print_status "Skipped. Run manually when ready:"
            echo "  powershell -ExecutionPolicy Bypass -File \"$win_path\""
        fi
    else
        print_warning "windows-setup.ps1 not found at $ps1_script"
    fi
}

# Windows integration
setup_windows_integration() {
    print_status "Setting up Windows integration..."
    if [[ ! -L ~/winhome ]] && [[ -d "/mnt/c/Users" ]]; then
        WIN_USER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r' || echo "")
        if [[ -n "$WIN_USER" ]] && [[ -d "/mnt/c/Users/$WIN_USER" ]]; then
            ln -sf "/mnt/c/Users/$WIN_USER" ~/winhome
            print_success "Windows home linked to ~/winhome"
        fi
    fi
}

# Main
main() {
    print_status "Starting WSL2 Ubuntu setup..."

    check_wsl
    update_system
    install_essential_packages
    install_java
    install_neovim
    install_zinit
    install_starship
    install_fastfetch
    install_rust
    install_fnm
    setup_shell
    setup_wsl_config
    setup_docker_desktop
    install_rust_tools
    install_dev_tools
    install_android_sdk
    setup_windows_android
    setup_windows_integration

    print_success "WSL2 setup complete!"
    echo "  - System packages and build tools"
    echo "  - WSL utilities (wslu)"
    echo "  - ZSH + Zinit (plugin manager)"
    echo "  - FNM + Node.js LTS"
    echo "  - Rust toolchain + modern CLI tools"
    echo "  - Neovim"
    echo "  - Starship prompt + Fastfetch"
    echo "  - Android SDK (Linux-native) + adb.exe alias"
    echo "  - Windows integration (winhome, .wslconfig mirrored networking)"
    echo "  - No GUI apps (use Windows-side apps instead)"
    print_warning "Restart your terminal or run 'source ~/.zshrc'"
}

main "$@"
