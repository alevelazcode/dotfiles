# =============================================================================
# Plugins Configuration (deferred via zsh-defer)
# =============================================================================

local _cache="$ZSH_CACHE_DIR"

# -----------------------------------------------------------------------------
# Autosuggestions — inline history hints
# -----------------------------------------------------------------------------
zinit light zsh-users/zsh-autosuggestions

# FZF
if (( $+commands[bat] )); then
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --style=numbers --color=always --line-range :500 {}'"
else
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
fi
if (( $+commands[fd] )); then
    export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude .cache"
fi

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
