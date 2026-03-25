# =============================================================================
# macOS Configuration
# =============================================================================

: ${HOMEBREW_PREFIX:=/opt/homebrew}

# -----------------------------------------------------------------------------
# PATH
# -----------------------------------------------------------------------------
path_prepend "$HOMEBREW_PREFIX/opt/python/libexec/bin"
path_append "/Applications/Windsurf.app/Contents/MacOS"

# Xcode
[[ -d "/Applications/Xcode.app/Contents/Developer" ]] && \
    export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"

# -----------------------------------------------------------------------------
# Aliases (no checks needed - just define them)
# -----------------------------------------------------------------------------
alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder"
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias brew-clean="brew cleanup"

# -----------------------------------------------------------------------------
# Lazy loaders
# -----------------------------------------------------------------------------
conda() {
    unfunction conda 2>/dev/null
    local conda_path="$HOMEBREW_PREFIX/Caskroom/miniforge/base/bin/conda"
    [[ ! -f "$conda_path" ]] && conda_path="$HOME/miniforge3/bin/conda"
    if [[ -f "$conda_path" ]]; then
        eval "$("$conda_path" shell.zsh hook)"
        conda "$@"
    else
        echo "conda not found"; return 1
    fi
}

mamba() {
    unfunction mamba 2>/dev/null
    if [[ -f "$HOME/miniforge3/bin/mamba" ]]; then
        eval "$("$HOME/miniforge3/bin/mamba" shell hook --shell zsh --root-prefix "$HOME/miniforge3" 2>/dev/null)"
        mamba "$@"
    else
        echo "mamba not found"; return 1
    fi
}

rbenv() {
    unfunction rbenv 2>/dev/null
    if [[ -d "$HOME/.rbenv" ]]; then
        eval "$(command rbenv init - zsh)"
        rbenv "$@"
    else
        echo "rbenv not installed"; return 1
    fi
}
