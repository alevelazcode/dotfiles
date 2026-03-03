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
# (Bun and pnpm are managed in dev/node.zsh alongside their env vars)
# (Cargo is managed in dev/rust.zsh alongside CARGO_HOME)
# -----------------------------------------------------------------------------

# Go
path_append "$HOME/go/bin"
