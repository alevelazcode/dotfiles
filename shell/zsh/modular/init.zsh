#!/bin/zsh
# =============================================================================
# ZSH ULTRA-OPTIMIZED Configuration
# =============================================================================
# Uses zsh-defer for PARALLEL/ASYNC loading - Target: <100ms startup
#
# OPTIMIZATION TECHNIQUES USED:
# 1. zsh-defer: Deferred execution until shell is idle
# 2. No eval $(cmd): All outputs pre-cached or hardcoded
# 3. Lazy loading: NVM, conda, rbenv, kubectl only load when used
# 4. compinit -C: Skip security check, use cache
# 5. Glob qualifier: Only regenerate completions once per day
# =============================================================================

# -----------------------------------------------------------------------------
# CRITICAL: Load zsh-defer FIRST for async capabilities
# -----------------------------------------------------------------------------
[[ -f "$HOME/.zsh/zsh-defer/zsh-defer.plugin.zsh" ]] && \
    source "$HOME/.zsh/zsh-defer/zsh-defer.plugin.zsh"

# -----------------------------------------------------------------------------
# Essential variables (MUST be sync - needed immediately)
# -----------------------------------------------------------------------------
export ZSH_CONFIG_DIR="${ZSH_CONFIG_DIR:-$HOME/.config/zsh}"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

# Create directories (only if missing)
[[ ! -d "$ZSH_CACHE_DIR" ]] && mkdir -p "$ZSH_CACHE_DIR"

# -----------------------------------------------------------------------------
# HOMEBREW_PREFIX - Hardcoded to avoid calling brew (saves ~50ms)
# -----------------------------------------------------------------------------
if [[ -d "/opt/homebrew" ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
    export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
elif [[ -d "/usr/local/Homebrew" ]]; then
    export HOMEBREW_PREFIX="/usr/local"
    export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
fi

# -----------------------------------------------------------------------------
# SYNC LOADING: Only absolute essentials (keybindings, basic options)
# -----------------------------------------------------------------------------
source "$ZSH_CONFIG_DIR/core/env.zsh"
source "$ZSH_CONFIG_DIR/core/path.zsh"

# Minimal options (inline for speed)
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY
setopt NO_BEEP INTERACTIVE_COMMENTS
setopt PROMPT_SUBST

# Vi mode keybindings
bindkey -v
bindkey '^R' history-incremental-search-backward
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# -----------------------------------------------------------------------------
# ULTRA-FAST COMPINIT with glob qualifier (only rebuild once/day)
# -----------------------------------------------------------------------------
autoload -Uz compinit
local zcompdump="$HOME/.zcompdump"
if [[ -n $zcompdump(#qN.mh+24) ]]; then
    # Cache older than 24 hours - rebuild
    compinit
else
    # Use cached completions (skip security check = FAST)
    compinit -C
fi

# -----------------------------------------------------------------------------
# OS-SPECIFIC: Load synchronously (contains PATH setup)
# -----------------------------------------------------------------------------
case "$(uname -s)" in
    Darwin*) source "$ZSH_CONFIG_DIR/os/macos.zsh" ;;
    Linux*)
        if [[ -f /proc/version ]] && grep -qi microsoft /proc/version 2>/dev/null; then
            source "$ZSH_CONFIG_DIR/os/wsl.zsh"
        else
            source "$ZSH_CONFIG_DIR/os/linux.zsh"
        fi
        ;;
esac

# -----------------------------------------------------------------------------
# DEFERRED LOADING: Everything else loads AFTER prompt appears
# -----------------------------------------------------------------------------
if (( $+functions[zsh-defer] )); then
    # Aliases & functions (lightweight, but deferred)
    zsh-defer source "$ZSH_CONFIG_DIR/modules/aliases.zsh"
    zsh-defer source "$ZSH_CONFIG_DIR/modules/functions.zsh"
    
    # Plugins (heavier)
    zsh-defer source "$ZSH_CONFIG_DIR/modules/plugins.zsh"
    
    # Development tools (heaviest - NVM, etc are lazy-loaded inside)
    zsh-defer source "$ZSH_CONFIG_DIR/dev/node.zsh"
    zsh-defer source "$ZSH_CONFIG_DIR/dev/python.zsh"
    zsh-defer source "$ZSH_CONFIG_DIR/dev/rust.zsh"
    zsh-defer source "$ZSH_CONFIG_DIR/dev/docker.zsh"
    
    # Local config
    [[ -f "$ZSH_CONFIG_DIR/local.zsh" ]] && zsh-defer source "$ZSH_CONFIG_DIR/local.zsh"
else
    # Fallback: sync loading if zsh-defer not available
    source "$ZSH_CONFIG_DIR/modules/aliases.zsh"
    source "$ZSH_CONFIG_DIR/modules/functions.zsh"
    source "$ZSH_CONFIG_DIR/modules/plugins.zsh"
    source "$ZSH_CONFIG_DIR/dev/node.zsh"
    source "$ZSH_CONFIG_DIR/dev/python.zsh"
    source "$ZSH_CONFIG_DIR/dev/rust.zsh"
    source "$ZSH_CONFIG_DIR/dev/docker.zsh"
    [[ -f "$ZSH_CONFIG_DIR/local.zsh" ]] && source "$ZSH_CONFIG_DIR/local.zsh"
fi

# -----------------------------------------------------------------------------
# PROMPT: Load synchronously for instant display, OR use cached starship
# -----------------------------------------------------------------------------
source "$ZSH_CONFIG_DIR/modules/prompt.zsh" 
