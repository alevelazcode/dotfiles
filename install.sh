#!/bin/bash

# =============================================================================
# Dotfiles Installation Script
# =============================================================================

set -euo pipefail

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

# Function to detect platform
detect_platform() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ -f /proc/version ]] && grep -qi microsoft /proc/version; then
        echo "wsl"
    elif [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case "$ID" in
            "ubuntu")
                echo "linux"
                ;;
            "fedora")
                echo "fedora"
                ;;
            "centos"|"rhel"|"rocky"|"almalinux")
                echo "fedora"  # Use Fedora setup for RHEL-based distros
                ;;
            "debian")
                echo "linux"  # Use Ubuntu/Debian setup for Debian-based distros
                ;;
            "arch"|"endeavouros"|"manjaro"|"garuda"|"artix")
                echo "arch"  # Use Arch setup for Arch-based distros
                ;;
            *)
                # Fallback: check ID_LIKE for family compatibility
                if [[ "${ID_LIKE:-}" == *"rhel"* ]] || [[ "${ID_LIKE:-}" == *"fedora"* ]]; then
                    echo "fedora"
                elif [[ "${ID_LIKE:-}" == *"debian"* ]] || [[ "${ID_LIKE:-}" == *"ubuntu"* ]]; then
                    echo "linux"
                elif [[ "${ID_LIKE:-}" == *"arch"* ]]; then
                    echo "arch"
                else
                    echo "linux"  # Default to linux for unknown distributions
                fi
                ;;
        esac
    else
        echo "unknown"
    fi
}

# Create a symlink only if it doesn't already point to the correct target.
# For directories: removes existing dir/symlink and creates fresh symlink.
# For files: uses ln -sf which overwrites atomically.
ensure_link() {
    local target="$1" link="$2"

    # Already correct — skip
    if [[ -L "$link" ]] && [[ "$(readlink "$link")" == "$target" ]]; then
        return 0
    fi

    # Remove stale symlink or existing dir at link path
    if [[ -L "$link" ]] || [[ -e "$link" ]]; then
        rm -rf "$link"
    fi

    mkdir -p "$(dirname "$link")"
    ln -sf "$target" "$link"
}

# Copy files/dirs to Windows-side for native Windows apps.
# Windows apps can't follow WSL2 Linux symlinks, so we copy instead.
# Re-run install.sh after editing configs to sync changes.
ensure_win_copy() {
    local source="$1" dest="$2"

    if [[ -d "$source" ]]; then
        # Directory: remove old and copy fresh
        rm -rf "$dest"
        mkdir -p "$(dirname "$dest")"
        cp -r "$source" "$dest"
    else
        # File: remove stale symlink/file first, then copy
        rm -f "$dest"
        mkdir -p "$(dirname "$dest")"
        cp "$source" "$dest"
    fi
}

# Resolve Windows user home from WSL (/mnt/c/Users/<user>)
get_win_home() {
    local win_user
    win_user=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r' || echo "")
    if [[ -n "$win_user" ]] && [[ -d "/mnt/c/Users/$win_user" ]]; then
        echo "/mnt/c/Users/$win_user"
    else
        return 1
    fi
}

# Function to create symlinks
create_symlinks() {
    local platform=$1

    print_status "Creating symlinks..."
    mkdir -p ~/.config

    # Resolve Windows home early for WSL symlinks
    local win_home=""
    if [[ "$platform" == "wsl" ]]; then
        win_home=$(get_win_home) || print_warning "Could not detect Windows user home — GUI app configs will be skipped"
    fi

    # Shell configuration
    if [[ -d "shell/zsh/modular" ]]; then
        ensure_link "$(pwd)/shell/zsh/modular" ~/.config/zsh
        ensure_link "$(pwd)/shell/zsh/modular/.zshrc" ~/.zshrc
        print_success "ZSH configuration linked"
    fi

    # Starship
    if [[ -f "apps/starship/starship.toml" ]]; then
        ensure_link "$(pwd)/apps/starship/starship.toml" ~/.config/starship.toml
        print_success "Starship configuration linked"
    fi

    # Fastfetch
    if [[ -f "apps/fastfetch/config.jsonc" ]]; then
        ensure_link "$(pwd)/apps/fastfetch/config.jsonc" ~/.config/fastfetch/config.jsonc
        print_success "Fastfetch configuration linked"
    fi

    # Neovim
    if [[ -d "apps/nvim" ]]; then
        ensure_link "$(pwd)/apps/nvim" ~/.config/nvim
        print_success "Neovim configuration linked"
    fi

    # Wezterm
    if [[ -d "apps/wezterm" ]]; then
        if [[ "$platform" == "wsl" ]] && [[ -n "$win_home" ]]; then
            ensure_win_copy "$(pwd)/apps/wezterm" "$win_home/.config/wezterm"
            print_success "Wezterm configuration linked (Windows-side)"
        elif [[ "$platform" != "wsl" ]]; then
            ensure_link "$(pwd)/apps/wezterm" ~/.config/wezterm
            # Flatpak WezTerm config path (Arch uses flatpak install)
            local flatpak_wezterm="$HOME/.var/app/org.wezfurlong.wezterm/config/wezterm"
            if [[ -d "$HOME/.var/app/org.wezfurlong.wezterm" ]]; then
                ensure_link "$(pwd)/apps/wezterm" "$flatpak_wezterm"
            fi
            print_success "Wezterm configuration linked"
        fi
    fi

    # VSCode
    if [[ -d "apps/vscode" ]]; then
        if [[ "$platform" == "macos" ]]; then
            local vscode_dir="$HOME/Library/Application Support/Code/User"
        else
            local vscode_dir="$HOME/.config/Code/User"
        fi
        ensure_link "$(pwd)/apps/vscode/settings.json" "$vscode_dir/settings.json"
        ensure_link "$(pwd)/apps/vscode/keybindings.json" "$vscode_dir/keybindings.json"
        print_success "VSCode configuration linked"

        # WSL: also link to Windows-side VS Code config
        if [[ "$platform" == "wsl" ]] && [[ -n "$win_home" ]]; then
            local win_vscode_dir="$win_home/AppData/Roaming/Code/User"
            ensure_win_copy "$(pwd)/apps/vscode/settings.json" "$win_vscode_dir/settings.json"
            ensure_win_copy "$(pwd)/apps/vscode/keybindings.json" "$win_vscode_dir/keybindings.json"
            print_success "VSCode configuration linked (Windows-side)"
        fi
    fi

    # Zed
    if [[ -d "apps/zed" ]]; then
        if [[ "$platform" == "wsl" ]] && [[ -n "$win_home" ]]; then
            # Zed on Windows reads from %APPDATA%\Zed\
            local win_zed_dir="$win_home/AppData/Roaming/Zed"
            ensure_win_copy "$(pwd)/apps/zed/settings.json" "$win_zed_dir/settings.json"
            ensure_win_copy "$(pwd)/apps/zed/keymap.json" "$win_zed_dir/keymap.json"
            print_success "Zed configuration linked (Windows-side)"
        elif [[ "$platform" != "wsl" ]]; then
            ensure_link "$(pwd)/apps/zed/settings.json" ~/.config/zed/settings.json
            ensure_link "$(pwd)/apps/zed/keymap.json" ~/.config/zed/keymap.json
            print_success "Zed configuration linked"
        fi
    fi

    # Git
    if [[ -f "shell/common/.gitconfig" ]]; then
        ensure_link "$(pwd)/shell/common/.gitconfig" ~/.gitconfig
        print_success "Git configuration linked"
    fi

    # Arch-only: Hyprland and Pictures (wallpaper)
    if [[ "$platform" == "arch" ]]; then
        if [[ -d "apps/hyprland" ]]; then
            mkdir -p ~/.config/hypr
            ensure_link "$(pwd)/apps/hyprland/hyprland.conf" ~/.config/hypr/hyprland.conf
            ensure_link "$(pwd)/apps/hyprland/hyprpaper.conf" ~/.config/hypr/hyprpaper.conf
            print_success "Hyprland configuration linked"
        fi
        if [[ -d "apps/pictures" ]]; then
            mkdir -p ~/Pictures
            for img in "$(pwd)/apps/pictures"/*; do
                ensure_link "$img" ~/Pictures/"$(basename "$img")"
            done
            print_success "Pictures linked"
        fi
    fi

    # macOS-only: skhd and yabai
    if [[ "$platform" == "macos" ]]; then
        if [[ -f "apps/skhd/skhdrc" ]]; then
            ensure_link "$(pwd)/apps/skhd/skhdrc" ~/.config/skhd/skhdrc
            print_success "skhd configuration linked"
        fi
        if [[ -f "apps/yabai/yabairc" ]]; then
            ensure_link "$(pwd)/apps/yabai/yabairc" ~/.config/yabai/yabairc
            print_success "yabai configuration linked"
        fi
    fi
}

# Function to install platform-specific packages
install_platform_packages() {
    local script="platforms/$1/setup.sh"
    print_status "Installing platform-specific packages for $1..."
    if [[ -f "$script" ]]; then
        bash "$script"
    else
        print_warning "No setup script found at $script"
    fi
}

# Function to install fonts from the fonts/ directory
install_fonts() {
    local platform=$1
    local fonts_dir="$(pwd)/fonts"

    if [[ ! -d "$fonts_dir" ]]; then
        print_warning "fonts/ directory not found, skipping font installation"
        return 0
    fi

    print_status "Installing fonts..."

    local dest
    case "$platform" in
        macos)
            dest="$HOME/Library/Fonts"
            ;;
        wsl)
            # WSL2: terminal runs on Windows — fonts must be on the Windows side
            local win_home
            win_home=$(get_win_home) || {
                print_warning "Could not detect Windows home — skipping font installation"
                print_status "Install fonts manually on Windows: copy .otf/.ttf to C:\\Windows\\Fonts"
                return 0
            }
            dest="$win_home/AppData/Local/Microsoft/Windows/Fonts"
            mkdir -p "$dest"
            ;;
        *)
            dest="$HOME/.local/share/fonts"
            mkdir -p "$dest"
            ;;
    esac

    local installed=0
    local skipped=0

    while IFS= read -r -d '' font_file; do
        local font_name
        font_name="$(basename "$font_file")"

        if [[ -f "$dest/$font_name" ]]; then
            (( skipped++ )) || true
        else
            cp "$font_file" "$dest/$font_name"
            (( installed++ )) || true
        fi
    done < <(find "$fonts_dir" -type f \( -name "*.otf" -o -name "*.ttf" \) -print0)

    if [[ "$platform" == "wsl" ]] && (( installed > 0 )); then
        # Register fonts in Windows using Shell.Application (same as double-click install)
        print_status "Registering fonts in Windows..."
        local win_dest
        win_dest=$(wslpath -w "$dest" 2>/dev/null || echo "")
        if [[ -n "$win_dest" ]]; then
            powershell.exe -NoProfile -Command "
                \$fontsDir = '$win_dest'
                \$shell = New-Object -ComObject Shell.Application
                \$systemFonts = \$shell.Namespace(0x14)
                Get-ChildItem \$fontsDir -Include *.otf,*.ttf -Recurse | ForEach-Object {
                    \$systemFonts.CopyHere(\$_.FullName, 0x14)
                }
            " 2>/dev/null || {
                # Fallback: register via HKCU registry
                for font_file in "$dest"/*.{otf,ttf}; do
                    [[ -f "$font_file" ]] || continue
                    local fname
                    fname="$(basename "$font_file")"
                    local display_name="${fname%.*}"
                    # Convert CamelCase filename to spaced display name
                    display_name=$(echo "$display_name" | sed 's/\([a-z]\)\([A-Z]\)/\1 \2/g; s/\([A-Z]\)\([A-Z][a-z]\)/\1 \2/g')
                    local ext="${fname##*.}"
                    local type_label="OpenType"
                    [[ "$ext" == "ttf" ]] && type_label="TrueType"
                    powershell.exe -NoProfile -Command \
                        "New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' -Name '$display_name ($type_label)' -Value '$fname' -PropertyType String -Force" \
                        2>/dev/null || true
                done
            }
        fi
        print_success "Fonts registered (restart WezTerm or log out/in for changes to take effect)"
    elif [[ "$platform" != "macos" ]] && [[ "$platform" != "wsl" ]] && (( installed > 0 )); then
        fc-cache -fv "$dest" > /dev/null 2>&1
        print_success "Font cache refreshed"
    fi

    print_success "Fonts: $installed installed, $skipped already present"
}

# Install zsh-defer (required by init.zsh for deferred module loading)
install_zsh_defer() {
    local dest="$HOME/.zsh/zsh-defer"
    if [[ -d "$dest" ]]; then
        print_success "zsh-defer already installed"
        return 0
    fi
    print_status "Installing zsh-defer..."
    mkdir -p "$HOME/.zsh"
    git clone https://github.com/romkatv/zsh-defer.git "$dest" 2>/dev/null \
        && print_success "zsh-defer installed" \
        || print_warning "Failed to install zsh-defer (deferred loading will be disabled)"
}

# Function to install common development tools
install_dev_tools() {
    print_status "Installing common development tools..."
    
    # Source common development scripts
    if [[ -f "shell/common/node.sh" ]]; then
        print_status "Installing Node.js packages..."
        source "shell/common/node.sh" || print_warning "Node.js script had issues, but Node.js is already installed"
    fi
    
    if [[ -f "shell/common/rust.sh" ]]; then
        print_status "Installing additional Rust packages..."
        source "shell/common/rust.sh" || print_warning "Rust script had issues, but Rust tools are already installed"
    fi
}

# Main installation function
main() {
    # Get the directory where this script is located
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cd "$SCRIPT_DIR"

    local platform="${1:-}"

    if [[ -z "$platform" ]]; then
        platform=$(detect_platform)
        print_status "Detected platform: $platform"
    else
        print_status "Using specified platform: $platform"
    fi

    case "$platform" in
        macos|linux|fedora|wsl|arch) ;;
        *)
            print_error "Invalid or unknown platform: $platform"
            print_status "Usage: $0 [macos|linux|fedora|wsl|arch]"
            exit 1
            ;;
    esac

    create_symlinks "$platform"
    install_platform_packages "$platform"
    install_zsh_defer
    install_fonts "$platform"
    install_dev_tools

    print_success "Installation complete!"
    print_status "Please restart your terminal or run 'source ~/.zshrc'"
}

main "$@" 