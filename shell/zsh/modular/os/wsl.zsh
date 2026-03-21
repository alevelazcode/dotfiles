# =============================================================================
# WSL Specific Configuration
# =============================================================================

# =============================================================================
# WSL Environment Variables
# =============================================================================

export OSTYPE="linux-gnu"
export WSL="true"

# Avoid slow Windows PATH lookups for tools we don't need
export DONT_PROMPT_WSL_INSTALL=1

# Use Linux browser opener via wslu if available
if command -v wslview &> /dev/null; then
    export BROWSER="wslview"
fi

# =============================================================================
# WSL PATH Configuration
# =============================================================================

# WSL specific paths (no snapd in WSL2 — it doesn't work)
path_append "/usr/local/go/bin"

# =============================================================================
# WSL Aliases
# =============================================================================

# Windows interop aliases
alias explorer="explorer.exe"
alias clip="clip.exe"
alias notepad="notepad.exe"

# Use wslview (from wslu) for opening files/URLs if available,
# otherwise fall back to cmd.exe start
if command -v wslview &> /dev/null; then
    alias open="wslview"
    alias browse="wslview"
else
    alias open='cmd.exe /c start ""'
    alias browse='cmd.exe /c start ""'
fi

# VS Code Remote — use the Windows binary which auto-connects to WSL
alias code="code.exe"

# =============================================================================
# WSL Clipboard Functions
# =============================================================================

# Copy text or stdin to Windows clipboard
copy() {
    if [[ -n "${1:-}" ]]; then
        printf '%s' "$1" | clip.exe
    elif [[ ! -t 0 ]]; then
        clip.exe  # pipe stdin directly
    else
        echo "Usage: copy <text>  or  <command> | copy"
        return 1
    fi
}

# Paste from Windows clipboard
paste() {
    powershell.exe -NoProfile -Command Get-Clipboard 2>/dev/null | tr -d '\r'
}

# =============================================================================
# WSL Navigation
# =============================================================================

# Open Windows Explorer in current directory
explore() {
    explorer.exe "$(wslpath -w "${1:-.}")"
}

# Quick access to Windows home
if [[ -L ~/winhome ]] || [[ -d ~/winhome ]]; then
    alias winhome="cd ~/winhome"
fi

# =============================================================================
# WSL Development Environment
# =============================================================================

# Docker Desktop WSL integration check
if command -v docker &> /dev/null; then
    alias docker-status="docker info --format '{{.OperatingSystem}}' 2>/dev/null || echo 'Docker not running — start Docker Desktop on Windows'"
fi

# =============================================================================
# WSL System Information
# =============================================================================

wsl-info() {
    echo "=== WSL System Information ==="
    echo "WSL Version: $(uname -r)"
    echo "Distribution: $(. /etc/os-release && echo "$PRETTY_NAME")"
    echo "Architecture: $(uname -m)"

    echo ""
    echo "=== Windows Integration ==="
    for cmd in explorer.exe clip.exe powershell.exe docker wslview; do
        if command -v "$cmd" &> /dev/null; then
            echo "  $cmd: available"
        else
            echo "  $cmd: not found"
        fi
    done

    echo ""
    echo "=== WSL Paths ==="
    echo "WSL Home: $HOME"
    [[ -L ~/winhome ]] && echo "Win Home: $(readlink ~/winhome)"
    echo "Interop: /mnt/c"
}

echo "WSL configuration loaded"
