# =============================================================================
# ZSH ULTRA-FAST Entry Point
# =============================================================================
# Target: <100ms startup time
# Technique: Load modular config with zsh-defer for async loading

# Load modular configuration (contains zsh-defer for async loading)
[[ -f "$HOME/.config/zsh/init.zsh" ]] && source "$HOME/.config/zsh/init.zsh"

# -----------------------------------------------------------------------------
# PATH additions (instant - just exports)
# -----------------------------------------------------------------------------
export PATH="/Users/alejandrovelazco/.codeium/windsurf/bin:$PATH"
export PATH="/Users/alejandrovelazco/.antigravity/antigravity/bin:$PATH"

# -----------------------------------------------------------------------------
# LAZY LOADERS (only execute when command is first used)
# -----------------------------------------------------------------------------

# Angular CLI - lazy load completions
ng() {
    unfunction ng 2>/dev/null
    source <(command ng completion script 2>/dev/null)
    command ng "$@"
}

# Mamba - lazy load (conda alternative)
export MAMBA_EXE="$HOME/miniforge3/bin/mamba"
export MAMBA_ROOT_PREFIX="$HOME/miniforge3"
mamba() {
    unfunction mamba 2>/dev/null
    eval "$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2>/dev/null)"
    mamba "$@"
}
