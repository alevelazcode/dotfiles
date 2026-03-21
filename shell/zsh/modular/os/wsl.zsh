# =============================================================================
# WSL Specific Configuration
# =============================================================================

export DONT_PROMPT_WSL_INSTALL=1

# Browser via wslu
(( $+commands[wslview] )) && export BROWSER="wslview"

# -----------------------------------------------------------------------------
# PATH
# -----------------------------------------------------------------------------
path_append "/usr/local/go/bin"

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------
alias explorer="explorer.exe"
alias clip="clip.exe"
alias notepad="notepad.exe"
alias code="code.exe"

if (( $+commands[wslview] )); then
    alias open="wslview"
    alias browse="wslview"
else
    alias open='cmd.exe /c start ""'
    alias browse='cmd.exe /c start ""'
fi

[[ -L ~/winhome ]] || [[ -d ~/winhome ]] && alias winhome="cd ~/winhome"

# -----------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------

# copy() is defined in modules/functions.zsh (cross-platform)

# Paste from Windows clipboard
paste() {
    powershell.exe -NoProfile -Command Get-Clipboard 2>/dev/null | tr -d '\r'
}

# Open Windows Explorer in current directory
explore() {
    explorer.exe "$(wslpath -w "${1:-.}")"
}
