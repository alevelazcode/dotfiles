# =============================================================================
# WSL Specific Configuration
# =============================================================================

# =============================================================================
# WSL Environment Variables
# =============================================================================

# WSL specific environment
export OSTYPE="linux-gnu"
export WSL="true"

# =============================================================================
# WSL PATH Configuration
# =============================================================================

# WSL specific paths
path_append "/snap/bin"
path_append "/usr/local/go/bin"

# =============================================================================
# WSL Aliases
# =============================================================================

# WSL specific aliases
alias explorer="explorer.exe"
alias code="code.exe"
alias clip="clip.exe"

# Windows commands
alias notepad="notepad.exe"
alias calc="calc.exe"
alias mspaint="mspaint.exe"

# =============================================================================
# WSL Functions
# =============================================================================

# Function to copy to clipboard (WSL)
copy() {
    if [[ -n "$1" ]]; then
        echo "$1" | clip.exe
        echo "Copied to clipboard: $1"
    else
        echo "Usage: copy <text>"
    fi
}

# Function to open Windows Explorer in current directory
explore() {
    explorer.exe .
}

# Function to open file with Windows default application
open() {
    local file="$1"
    if [[ -z "$file" ]]; then
        echo "Usage: open <file>"
        return 1
    fi
    
    if [[ -f "$file" ]]; then
        cmd.exe /c start "" "$file"
    else
        echo "File not found: $file"
        return 1
    fi
}

# Function to open URL in Windows browser
browse() {
    local url="$1"
    if [[ -z "$url" ]]; then
        echo "Usage: browse <url>"
        return 1
    fi
    
    cmd.exe /c start "" "$url"
}

# =============================================================================
# WSL Development Environment
# =============================================================================

# WSL specific development tools
if command -v code &> /dev/null; then
    # VS Code in WSL
    alias vscode="code ."
fi

# =============================================================================
# WSL System Information
# =============================================================================

# Function to show WSL system info
wsl-info() {
    echo "=== WSL System Information ==="
    echo "WSL Version: $(uname -r)"
    echo "Distribution: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
    echo "Architecture: $(uname -m)"
    echo "Kernel: $(uname -r)"
    
    echo ""
    echo "=== Windows Integration ==="
    if command -v explorer.exe &> /dev/null; then
        echo "Windows Explorer: Available"
    else
        echo "Windows Explorer: Not available"
    fi
    
    if command -v clip.exe &> /dev/null; then
        echo "Windows Clipboard: Available"
    else
        echo "Windows Clipboard: Not available"
    fi
    
    echo ""
    echo "=== WSL Paths ==="
    echo "WSL Home: $HOME"
    echo "Windows User: /mnt/c/Users/$(whoami)"
}

# =============================================================================
# WSL Performance Optimizations
# =============================================================================

# Disable Windows Defender real-time monitoring for WSL (if needed)
# This can improve performance but should be used carefully
# export WSLENV=WSLENV:WSL_DISABLE_WINDOWS_DEFENDER:1

echo "✅ WSL configuration loaded" 