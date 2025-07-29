# =============================================================================
# Linux Specific Configuration
# =============================================================================

# =============================================================================
# Linux Environment Variables
# =============================================================================

# Linux specific environment
export OSTYPE="linux-gnu"
export LINUX="true"

# =============================================================================
# Linux PATH Configuration
# =============================================================================

# Linux specific paths
path_append "/snap/bin"
path_append "/usr/local/go/bin"

# =============================================================================
# Linux Aliases
# =============================================================================

# Linux specific aliases
alias update="sudo apt update && sudo apt upgrade -y"
alias install="sudo apt install"
alias remove="sudo apt remove"
alias search="apt search"
alias show="apt show"

# System information
alias sysinfo="neofetch"
alias meminfo="free -h"
alias diskusage="df -h"
alias process="ps aux"

# =============================================================================
# Linux Functions
# =============================================================================

# Function to copy to clipboard (Linux)
copy() {
    if [[ -n "$1" ]]; then
        if command -v xclip &> /dev/null; then
            echo "$1" | xclip -selection clipboard
            echo "Copied to clipboard: $1"
        elif command -v wl-copy &> /dev/null; then
            echo "$1" | wl-copy
            echo "Copied to clipboard: $1"
        else
            echo "No clipboard tool available (install xclip or wl-copy)"
            return 1
        fi
    else
        echo "Usage: copy <text>"
    fi
}

# Function to update system packages
update-system() {
    echo "Updating system packages..."
    sudo apt update
    sudo apt upgrade -y
    sudo apt autoremove -y
    sudo apt autoclean
    echo "System update complete!"
}

# Function to install packages
install-packages() {
    for package in "$@"; do
        echo "Installing $package..."
        sudo apt install -y "$package"
    done
}

# Function to remove packages
remove-packages() {
    for package in "$@"; do
        echo "Removing $package..."
        sudo apt remove -y "$package"
    done
}

# Function to search packages
search-packages() {
    apt search "$1"
}

# Function to show package info
show-package() {
    apt show "$1"
}

# =============================================================================
# Linux Development Environment
# =============================================================================

# Linux specific development tools
if command -v code &> /dev/null; then
    # VS Code in Linux
    alias vscode="code ."
fi

# =============================================================================
# Linux System Information
# =============================================================================

# Function to show Linux system info
linux-info() {
    echo "=== Linux System Information ==="
    echo "Distribution: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
    echo "Architecture: $(uname -m)"
    echo "Kernel: $(uname -r)"
    
    echo ""
    echo "=== Package Manager ==="
    if command -v apt &> /dev/null; then
        echo "Package Manager: apt (Debian/Ubuntu)"
    elif command -v dnf &> /dev/null; then
        echo "Package Manager: dnf (Fedora/RHEL)"
    elif command -v pacman &> /dev/null; then
        echo "Package Manager: pacman (Arch)"
    else
        echo "Package Manager: Unknown"
    fi
    
    echo ""
    echo "=== Display Server ==="
    if [[ -n "$WAYLAND_DISPLAY" ]]; then
        echo "Display Server: Wayland"
    elif [[ -n "$DISPLAY" ]]; then
        echo "Display Server: X11"
    else
        echo "Display Server: None (headless)"
    fi
}

echo "✅ Linux configuration loaded" 