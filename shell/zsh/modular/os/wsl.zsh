# =============================================================================
# WSL Specific Configuration
# =============================================================================

export DONT_PROMPT_WSL_INSTALL=1

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------
alias explorer="explorer.exe"
alias clip="clip.exe"
alias notepad="notepad.exe"
alias code="code.exe"

if (( $+commands[wslview] )); then
    export BROWSER="wslview"
    alias open="wslview"
else
    alias open='cmd.exe /c start ""'
fi

[[ -L ~/winhome || -d ~/winhome ]] && alias winhome="cd ~/winhome"

# -----------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------

# Paste from Windows clipboard
paste() {
    powershell.exe -NoProfile -Command Get-Clipboard 2>/dev/null | tr -d '\r'
}

# Open Windows Explorer in current directory
explore() {
    explorer.exe "$(wslpath -w "${1:-.}")"
}
