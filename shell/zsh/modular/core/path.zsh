# =============================================================================
# PATH Configuration
# =============================================================================

# Add path to end of PATH (no duplicates)
path_append() {
    local p="$1"
    [[ -n "$p" && -d "$p" && ":$PATH:" != *":$p:"* ]] && export PATH="$PATH:$p"
}

# Add path to beginning of PATH (no duplicates)
path_prepend() {
    local p="$1"
    [[ -n "$p" && -d "$p" && ":$PATH:" != *":$p:"* ]] && export PATH="$p:$PATH"
}

# -----------------------------------------------------------------------------
# Base — standard user directories
# -----------------------------------------------------------------------------
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/bin"

# -----------------------------------------------------------------------------
# Development tools
# -----------------------------------------------------------------------------

# Cargo (early — needed before prompt for starship on Linux)
path_prepend "$HOME/.cargo/bin"

# FNM (sync — must run before deferred modules so node/npm are in PATH)
# Cached to avoid subprocess on every shell start
if (( $+commands[fnm] )); then
    local _fnm_cache="$ZSH_CACHE_DIR/fnm.zsh"
    if [[ ! -f "$_fnm_cache" ]]; then
        command fnm env --use-on-cd > "$_fnm_cache" 2>/dev/null
    fi
    source "$_fnm_cache"
fi

# Go (system install + user workspace)
path_append "/usr/local/go/bin"
path_append "$HOME/go/bin"

# Console Ninja
path_prepend "$HOME/.console-ninja/.bin"

# Codeium / Windsurf CLI
path_prepend "$HOME/.codeium/windsurf/bin"

# Antigravity
path_append "$HOME/.antigravity/antigravity/bin"
