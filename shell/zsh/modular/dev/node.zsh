# =============================================================================
# Node.js Configuration
# =============================================================================

export NODE_OPTIONS="--max-old-space-size=4096"

# pnpm + bun
export PNPM_HOME="$HOME/.local/share/pnpm"
export BUN_INSTALL="$HOME/.bun"
path_prepend "$PNPM_HOME"
path_prepend "$BUN_INSTALL/bin"

# Angular CLI — lazy loaded (completion only on first use)
ng() {
    unfunction ng 2>/dev/null
    source <(command ng completion script 2>/dev/null)
    command ng "$@"
}
