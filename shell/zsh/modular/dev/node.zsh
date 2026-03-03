# =============================================================================
# Node.js Configuration
# =============================================================================
# fnm (Rust, fast) > nvm (lazy loaded fallback)

export NODE_OPTIONS="--max-old-space-size=4096"
: ${HOMEBREW_PREFIX:=/opt/homebrew}
local _zsh_cache="$HOME/.cache/zsh"

# FNM - cached env
if [[ -x "$HOMEBREW_PREFIX/bin/fnm" ]] || [[ -x "$HOME/.local/share/fnm/fnm" ]]; then
    local _fnm_cache="$_zsh_cache/fnm_env.zsh"
    if [[ ! -f "$_fnm_cache" ]]; then
        fnm env --use-on-cd > "$_fnm_cache" 2>/dev/null
    fi
    [[ -f "$_fnm_cache" ]] && source "$_fnm_cache"
else
    # NVM fallback - lazy loaded
    export NVM_DIR="$HOME/.nvm"
    if [[ -f "$NVM_DIR/alias/default" ]]; then
        local _default_ver=$(<"$NVM_DIR/alias/default")
        if [[ "$_default_ver" == lts/* ]]; then
            local _lts_name="${_default_ver#lts/}"
            [[ -d "$NVM_DIR/versions/node" ]] && \
                _default_ver=$(command ls -1d "$NVM_DIR/versions/node"/*"$_lts_name"* 2>/dev/null | tail -1)
            _default_ver="${_default_ver##*/}"
        fi
        [[ -d "$NVM_DIR/versions/node/$_default_ver/bin" ]] && \
            export PATH="$NVM_DIR/versions/node/$_default_ver/bin:$PATH"
    fi
    nvm() {
        unfunction nvm 2>/dev/null
        [[ -f "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
        nvm "$@"
    }
fi

# pnpm/bun paths
export PNPM_HOME="$HOME/.local/share/pnpm"
export BUN_INSTALL="$HOME/.bun"
[[ -d "$PNPM_HOME" ]] && export PATH="$PNPM_HOME:$PATH"
[[ -d "$BUN_INSTALL/bin" ]] && export PATH="$BUN_INSTALL/bin:$PATH" 
