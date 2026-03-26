#!/bin/zsh
# =============================================================================
# ZSH Configuration - Init
# =============================================================================

# zsh-defer for async loading
[[ -f "$HOME/.zsh/zsh-defer/zsh-defer.plugin.zsh" ]] && \
    source "$HOME/.zsh/zsh-defer/zsh-defer.plugin.zsh"

# Internal variables (no export needed — only used by zsh config files)
: ${ZSH_CONFIG_DIR:=$HOME/.config/zsh}
: ${ZSH_CACHE_DIR:=${XDG_CACHE_HOME:-$HOME/.cache}/zsh}
[[ ! -d "$ZSH_CACHE_DIR" ]] && mkdir -p "$ZSH_CACHE_DIR"

# Homebrew (hardcoded to avoid subprocess)
if [[ -d "/opt/homebrew" ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
    export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
elif [[ -d "/usr/local/Homebrew" ]]; then
    export HOMEBREW_PREFIX="/usr/local"
    export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
fi

# Zinit plugin manager (before compinit so it can register its completions dir)
local _zinit_path=""
if [[ -n "$HOMEBREW_PREFIX" && -f "$HOMEBREW_PREFIX/opt/zinit/zinit.zsh" ]]; then
    _zinit_path="$HOMEBREW_PREFIX/opt/zinit/zinit.zsh"
elif [[ -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]]; then
    _zinit_path="$HOME/.local/share/zinit/zinit.git/zinit.zsh"
elif [[ -f /usr/share/zinit/zinit.zsh ]]; then
    _zinit_path="/usr/share/zinit/zinit.zsh"
fi
if [[ -n "$_zinit_path" ]]; then
    source "$_zinit_path"
    autoload -Uz _zinit
    (( ${+_comps} )) && _comps[zinit]=_zinit
fi

# Core (sync - needed immediately)
source "$ZSH_CONFIG_DIR/core/env.zsh"
source "$ZSH_CONFIG_DIR/core/path.zsh"

# Options
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY
setopt NO_BEEP INTERACTIVE_COMMENTS PROMPT_SUBST

# Vi mode (keybindings.zsh handles the rest)
bindkey -v
source "$ZSH_CONFIG_DIR/core/keybindings.zsh"

# Compinit (cached, rebuild once per day, skip compaudit for speed)
# Strip non-existent directories from fpath (e.g. vendor-completions on Arch)
fpath=( ${^fpath}(N/) )
autoload -Uz compinit
local zcompdump="$HOME/.zcompdump"
if [[ -n $zcompdump(#qN.mh+24) ]] || [[ ! -f "$zcompdump" ]]; then
    compinit -u -d "$zcompdump"
else
    compinit -C -d "$zcompdump"
fi

# OS-specific (sync - contains PATH setup)
if [[ "$OSTYPE" == darwin* ]]; then
    source "$ZSH_CONFIG_DIR/os/macos.zsh"
elif [[ -f /proc/version ]] && [[ "$(</proc/version)" == *[Mm]icrosoft* ]]; then
    source "$ZSH_CONFIG_DIR/os/wsl.zsh"
else
    source "$ZSH_CONFIG_DIR/os/linux.zsh"
fi

# Deferred loading (everything else loads AFTER prompt appears)
# Add new modules here — single list, no duplication
local -a _modules=(
    modules/aliases
    modules/functions
    modules/completion
    modules/plugins
    dev/node
    dev/python
    dev/rust
    dev/docker
    dev/android
)

if (( $+functions[zsh-defer] )); then
    for _m in $_modules; do zsh-defer source "$ZSH_CONFIG_DIR/$_m.zsh"; done
    [[ -f "$ZSH_CONFIG_DIR/local.zsh" ]] && zsh-defer source "$ZSH_CONFIG_DIR/local.zsh"
else
    for _m in $_modules; do source "$ZSH_CONFIG_DIR/$_m.zsh"; done
    [[ -f "$ZSH_CONFIG_DIR/local.zsh" ]] && source "$ZSH_CONFIG_DIR/local.zsh"
fi

# Syntax highlighting — loaded sync, LAST (ZLE hooks need registration before user input)
zinit light zsh-users/zsh-syntax-highlighting

# Prompt (sync - must appear instantly)
source "$ZSH_CONFIG_DIR/modules/prompt.zsh"
