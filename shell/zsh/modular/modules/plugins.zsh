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
# FZF — shell integration managed by zinit (binary still from Homebrew)
# atinit sources key-bindings and completion from the cloned repo directory
# -----------------------------------------------------------------------------
zinit ice wait lucid atinit"source shell/key-bindings.zsh; source shell/completion.zsh"
zinit light junegunn/fzf

# -----------------------------------------------------------------------------
# Zoxide — smart cd (cached init)
# -----------------------------------------------------------------------------
local _zoxide_cache="$_cache/zoxide.zsh"
if [[ -f "$_zoxide_cache" ]]; then
    source "$_zoxide_cache"
elif (( $+commands[zoxide] )); then
    command zoxide init zsh >"$_zoxide_cache" 2>/dev/null
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
    [[ ! -f "$_c" ]] && (( $+commands[kubectl] )) && \
        command kubectl completion zsh >"$_c" 2>/dev/null
    [[ -f "$_c" ]] && source "$_c"
    command kubectl "$@"
}

helm() {
    unfunction helm 2>/dev/null
    local _c="$_cache/helm.zsh"
    [[ ! -f "$_c" ]] && (( $+commands[helm] )) && \
        command helm completion zsh >"$_c" 2>/dev/null
    [[ -f "$_c" ]] && source "$_c"
    command helm "$@"
}
