# =============================================================================
# Node.js ULTRA-OPTIMIZED Configuration  
# =============================================================================
# NO command -v, NO ls/sort pipes during startup. Maximum lazy loading.

export NVM_DIR="$HOME/.nvm"
export NODE_OPTIONS="--max-old-space-size=4096"

# -----------------------------------------------------------------------------
# INSTANT NODE ACCESS: Use default alias or cached path
# -----------------------------------------------------------------------------
# Read default version from .nvm/alias/default (no subprocess!)
if [[ -f "$NVM_DIR/alias/default" ]]; then
    local _default_ver=$(<"$NVM_DIR/alias/default")
    # Handle version prefixes like "lts/*" or direct versions
    if [[ "$_default_ver" == lts/* ]]; then
        # Find the actual LTS version directory
        local _lts_name="${_default_ver#lts/}"
        [[ -d "$NVM_DIR/versions/node" ]] && \
            _default_ver=$(command ls -1d "$NVM_DIR/versions/node"/*"$_lts_name"* 2>/dev/null | tail -1)
        _default_ver="${_default_ver##*/}"
    fi
    [[ -d "$NVM_DIR/versions/node/$_default_ver/bin" ]] && \
        export PATH="$NVM_DIR/versions/node/$_default_ver/bin:$PATH"
fi

# -----------------------------------------------------------------------------
# NVM LAZY LOADER - Only load full NVM when switching versions
# -----------------------------------------------------------------------------
_nvm_lazy_load() {
    unfunction nvm 2>/dev/null
    [[ -f "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
}
nvm() { _nvm_lazy_load; nvm "$@" }

# -----------------------------------------------------------------------------
# pnpm/bun paths (direct, no checks)
# -----------------------------------------------------------------------------
export PNPM_HOME="$HOME/.local/share/pnpm"
export BUN_INSTALL="$HOME/.bun"
[[ -d "$PNPM_HOME" ]] && export PATH="$PNPM_HOME:$PATH"
[[ -d "$BUN_INSTALL/bin" ]] && export PATH="$BUN_INSTALL/bin:$PATH"

# -----------------------------------------------------------------------------
# Aliases (lightweight)
# -----------------------------------------------------------------------------
alias pn="pnpm"
alias pni="pnpm install"
alias pnd="pnpm dev"
alias pnb="pnpm build"
alias nrd="npm run dev"
alias nrb="npm run build" 
