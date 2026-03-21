# =============================================================================
# macOS ULTRA-OPTIMIZED Configuration
# =============================================================================
# NO command -v checks, NO eval, NO brew --prefix calls
# Everything hardcoded or lazy-loaded for MAXIMUM speed

# Environment

# HOMEBREW_PREFIX already set in init.zsh, but ensure it exists
: ${HOMEBREW_PREFIX:=/opt/homebrew}

# -----------------------------------------------------------------------------
# PATH - Direct paths only, no function calls
# -----------------------------------------------------------------------------
[[ -d "$HOMEBREW_PREFIX/opt/python/libexec/bin" ]] && \
    export PATH="$HOMEBREW_PREFIX/opt/python/libexec/bin:$PATH"

# Java & Android — managed in dev/android.zsh (cross-platform)

# Windsurf
[[ -d "/Applications/Windsurf.app/Contents/MacOS" ]] && \
    export PATH="$PATH:/Applications/Windsurf.app/Contents/MacOS"

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
alias brew-update="brew update && brew upgrade"
alias brew-clean="brew cleanup"

# -----------------------------------------------------------------------------
# LAZY LOADERS - Only execute when command is first used
# -----------------------------------------------------------------------------

# Conda lazy loader
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

# Mamba lazy loader
mamba() {
    unfunction mamba 2>/dev/null
    if [[ -f "$HOME/miniforge3/bin/mamba" ]]; then
        eval "$("$HOME/miniforge3/bin/mamba" shell hook --shell zsh --root-prefix "$HOME/miniforge3" 2>/dev/null)"
        mamba "$@"
    else
        echo "mamba not found"; return 1
    fi
}

# rbenv lazy loader
rbenv() {
    unfunction rbenv 2>/dev/null
    if [[ -d "$HOME/.rbenv" ]]; then
        eval "$(command rbenv init - zsh)"
        rbenv "$@"
    else
        echo "rbenv not installed"; return 1
    fi
}
