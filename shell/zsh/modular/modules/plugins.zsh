# =============================================================================
# Plugins Configuration (deferred via zsh-defer)
# =============================================================================
# zsh-syntax-highlighting is intentionally NOT here — it must load
# synchronously in init.zsh so ZLE hooks register correctly.
# =============================================================================

: ${HOMEBREW_PREFIX:=/opt/homebrew}
local _cache="$HOME/.cache/zsh"

# -----------------------------------------------------------------------------
# Autosuggestions — inline history hints
# -----------------------------------------------------------------------------
zinit light zsh-users/zsh-autosuggestions

# -----------------------------------------------------------------------------
# FZF — fuzzy finder (Homebrew provides the shell integration scripts)
# -----------------------------------------------------------------------------
local _fzf="$HOMEBREW_PREFIX/opt/fzf/shell"
[[ -f "$_fzf/key-bindings.zsh" ]] && source "$_fzf/key-bindings.zsh"
[[ -f "$_fzf/completion.zsh"   ]] && source "$_fzf/completion.zsh"

# -----------------------------------------------------------------------------
# Zoxide — smart cd (cached init)
# -----------------------------------------------------------------------------
local _zoxide_cache="$_cache/zoxide.zsh"
if [[ -f "$_zoxide_cache" ]]; then
    source "$_zoxide_cache"
elif [[ -x "$HOMEBREW_PREFIX/bin/zoxide" ]]; then
    "$HOMEBREW_PREFIX/bin/zoxide" init zsh >"$_zoxide_cache" 2>/dev/null
    source "$_zoxide_cache"
fi

# -----------------------------------------------------------------------------
# Bun completions
# -----------------------------------------------------------------------------
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# -----------------------------------------------------------------------------
# kubectl / helm — lazy loaded (init only on first invocation)
# -----------------------------------------------------------------------------
kubectl() {
    unfunction kubectl 2>/dev/null
    local _c="$_cache/kubectl.zsh"
    [[ ! -f "$_c" && -x "$HOMEBREW_PREFIX/bin/kubectl" ]] && \
        "$HOMEBREW_PREFIX/bin/kubectl" completion zsh >"$_c" 2>/dev/null
    [[ -f "$_c" ]] && source "$_c"
    command kubectl "$@"
}

helm() {
    unfunction helm 2>/dev/null
    local _c="$_cache/helm.zsh"
    [[ ! -f "$_c" && -x "$HOMEBREW_PREFIX/bin/helm" ]] && \
        "$HOMEBREW_PREFIX/bin/helm" completion zsh >"$_c" 2>/dev/null
    [[ -f "$_c" ]] && source "$_c"
    command helm "$@"
}
