# =============================================================================
# macOS Specific Configuration
# =============================================================================

# =============================================================================
# macOS Environment Variables
# =============================================================================

# macOS specific environment
export OSTYPE="darwin"
export MACOS="true"

# =============================================================================
# macOS PATH Configuration
# =============================================================================

# Homebrew paths (check both Intel and Apple Silicon)
if [[ -d "/opt/homebrew/bin" ]]; then
    # Apple Silicon
    path_prepend "/opt/homebrew/bin"
    path_prepend "/opt/homebrew/sbin"
elif [[ -d "/usr/local/bin" ]]; then
    # Intel
    path_prepend "/usr/local/bin"
    path_prepend "/usr/local/sbin"
fi

# Python from Homebrew
if command -v brew &> /dev/null; then
    if [[ -d "$(brew --prefix python)/libexec/bin" ]]; then
        path_append "$(brew --prefix python)/libexec/bin"
    fi
fi

# =============================================================================
# macOS Aliases
# =============================================================================

# macOS specific aliases
alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder"
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

# Clipboard
alias pbcopy="pbcopy"
alias pbpaste="pbpaste"

# =============================================================================
# macOS Functions
# =============================================================================

# Function to copy to clipboard (macOS)
copy() {
    if [[ -n "$1" ]]; then
        echo "$1" | pbcopy
        echo "Copied to clipboard: $1"
    else
        echo "Usage: copy <text>"
    fi
}

# Function to open applications
open-app() {
    local app_name="$1"
    if [[ -z "$app_name" ]]; then
        echo "Usage: open-app <application_name>"
        return 1
    fi
    
    open -a "$app_name"
}

# Function to show/hide hidden files
toggle-hidden-files() {
    local current_state=$(defaults read com.apple.finder AppleShowAllFiles 2>/dev/null || echo "NO")
    
    if [[ "$current_state" == "YES" ]]; then
        defaults write com.apple.finder AppleShowAllFiles NO
        echo "Hidden files are now hidden"
    else
        defaults write com.apple.finder AppleShowAllFiles YES
        echo "Hidden files are now visible"
    fi
    
    killall Finder
}

# =============================================================================
# Development Tools (macOS specific)
# =============================================================================

# Homebrew
if command -v brew &> /dev/null; then
    # Homebrew aliases
    alias brew-update="brew update && brew upgrade"
    alias brew-clean="brew cleanup"
    alias brew-deps="brew deps --installed"
    
    # Homebrew functions
    brew-info() {
        if [[ -n "$1" ]]; then
            brew info "$1"
        else
            echo "Usage: brew-info <package>"
        fi
    }
fi

# =============================================================================
# macOS Development Environment
# =============================================================================

# Xcode Command Line Tools
if [[ -d "/Applications/Xcode.app/Contents/Developer" ]]; then
    export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
fi

# =============================================================================
# macOS System Information
# =============================================================================

# Function to show macOS system info
macos-info() {
    echo "=== macOS System Information ==="
    echo "macOS Version: $(sw_vers -productVersion)"
    echo "Build Version: $(sw_vers -buildVersion)"
    echo "Architecture: $(uname -m)"
    echo "Kernel: $(uname -r)"
    
    if command -v brew &> /dev/null; then
        echo "Homebrew: $(brew --version | head -n1)"
    else
        echo "Homebrew: Not installed"
    fi
    
    echo ""
    echo "=== Hardware Information ==="
    system_profiler SPHardwareDataType | grep -E "(Model Name|Model Identifier|Processor|Memory|Serial Number)" | sed 's/^[[:space:]]*//'
}

echo "✅ macOS configuration loaded" 