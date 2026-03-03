#!/bin/zsh
# =============================================================================
# ZSH Configuration - Init
# =============================================================================

# zsh-defer for async loading
[[ -f "$HOME/.zsh/zsh-defer/zsh-defer.plugin.zsh" ]] && \
    source "$HOME/.zsh/zsh-defer/zsh-defer.plugin.zsh"

# Essential variables
export ZSH_CONFIG_DIR="${ZSH_CONFIG_DIR:-$HOME/.config/zsh}"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ ! -d "$ZSH_CACHE_DIR" ]] && mkdir -p "$ZSH_CACHE_DIR"

# Homebrew (hardcoded to avoid subprocess)
if [[ -d "/opt/homebrew" ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
    export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
elif [[ -d "/usr/local/Homebrew" ]]; then
    export HOMEBREW_PREFIX="/usr/local"
    export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
fi

# Core (sync - needed immediately)
source "$ZSH_CONFIG_DIR/core/env.zsh"
source "$ZSH_CONFIG_DIR/core/path.zsh"

# Options
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY
setopt NO_BEEP INTERACTIVE_COMMENTS PROMPT_SUBST

# Vi mode + essential bindings
bindkey -v
bindkey '^R' history-incremental-search-backward
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# Compinit (cached, rebuild once per day)
autoload -Uz compinit
local zcompdump="$HOME/.zcompdump"
if [[ -n $zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# OS-specific (sync - contains PATH setup)
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

# Deferred loading (everything else loads AFTER prompt appears)
if (( $+functions[zsh-defer] )); then
    zsh-defer source "$ZSH_CONFIG_DIR/modules/aliases.zsh"
    zsh-defer source "$ZSH_CONFIG_DIR/modules/functions.zsh"
    zsh-defer source "$ZSH_CONFIG_DIR/modules/plugins.zsh"
    zsh-defer source "$ZSH_CONFIG_DIR/dev/node.zsh"
    zsh-defer source "$ZSH_CONFIG_DIR/dev/python.zsh"
    zsh-defer source "$ZSH_CONFIG_DIR/dev/rust.zsh"
    zsh-defer source "$ZSH_CONFIG_DIR/dev/docker.zsh"
    [[ -f "$ZSH_CONFIG_DIR/local.zsh" ]] && zsh-defer source "$ZSH_CONFIG_DIR/local.zsh"
else
    source "$ZSH_CONFIG_DIR/modules/aliases.zsh"
    source "$ZSH_CONFIG_DIR/modules/functions.zsh"
    source "$ZSH_CONFIG_DIR/modules/plugins.zsh"
    source "$ZSH_CONFIG_DIR/dev/node.zsh"
    source "$ZSH_CONFIG_DIR/dev/python.zsh"
    source "$ZSH_CONFIG_DIR/dev/rust.zsh"
    source "$ZSH_CONFIG_DIR/dev/docker.zsh"
    [[ -f "$ZSH_CONFIG_DIR/local.zsh" ]] && source "$ZSH_CONFIG_DIR/local.zsh"
fi

# Prompt (sync - must appear instantly)
source "$ZSH_CONFIG_DIR/modules/prompt.zsh"
