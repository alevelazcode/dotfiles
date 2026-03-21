# =============================================================================
# Node.js Configuration
# =============================================================================
# Loaded via zsh-defer — eval cost is negligible (runs after prompt appears)

export NODE_OPTIONS="--max-old-space-size=4096"

# FNM — fast Node.js version manager (Rust, replaces NVM)
# --use-on-cd: auto-switches version on .node-version / .nvmrc detection
# NOTE: fnm env is evaluated in core/path.zsh (sync) so its PATH is available
# before any deferred modules run. Only the hook setup happens here via defer.

# pnpm + bun
export PNPM_HOME="$HOME/.local/share/pnpm"
export BUN_INSTALL="$HOME/.bun"
[[ -d "$PNPM_HOME"       ]] && export PATH="$PNPM_HOME:$PATH"
[[ -d "$BUN_INSTALL/bin" ]] && export PATH="$BUN_INSTALL/bin:$PATH"

# Angular CLI — lazy loaded (completion only on first use)
ng() {
    unfunction ng 2>/dev/null
    source <(command ng completion script 2>/dev/null)
    command ng "$@"
}
