# =============================================================================
# Plugins Configuration
# =============================================================================

: ${HOMEBREW_PREFIX:=/opt/homebrew}
local _zsh_cache="$HOME/.cache/zsh"

# Autosuggestions
local _as="$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$_as" ]] && source "$_as"

# Syntax highlighting (prefer fast variant)
local _fsh="$HOMEBREW_PREFIX/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
local _sh="$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
if [[ -f "$_fsh" ]]; then
    source "$_fsh"
elif [[ -f "$_sh" ]]; then
    source "$_sh"
fi

# FZF keybindings + completion
local _fzf_keys="$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
local _fzf_comp="$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
[[ -f "$_fzf_keys" ]] && source "$_fzf_keys"
[[ -f "$_fzf_comp" ]] && source "$_fzf_comp"

# Zoxide (cached init)
local _zoxide_cache="$_zsh_cache/zoxide.zsh"
if [[ -f "$_zoxide_cache" ]]; then
    source "$_zoxide_cache"
elif [[ -x "$HOMEBREW_PREFIX/bin/zoxide" ]]; then
    "$HOMEBREW_PREFIX/bin/zoxide" init zsh > "$_zoxide_cache" 2>/dev/null
    source "$_zoxide_cache"
fi

# Bun completions
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# kubectl/helm - lazy loaded (only init on first use)
kubectl() {
    unfunction kubectl 2>/dev/null
    local cache="$_zsh_cache/kubectl.zsh"
    [[ ! -f "$cache" ]] && [[ -x "$HOMEBREW_PREFIX/bin/kubectl" ]] && \
        "$HOMEBREW_PREFIX/bin/kubectl" completion zsh > "$cache" 2>/dev/null
    [[ -f "$cache" ]] && source "$cache"
    command kubectl "$@"
}

helm() {
    unfunction helm 2>/dev/null
    local cache="$_zsh_cache/helm.zsh"
    [[ ! -f "$cache" ]] && [[ -x "$HOMEBREW_PREFIX/bin/helm" ]] && \
        "$HOMEBREW_PREFIX/bin/helm" completion zsh > "$cache" 2>/dev/null
    [[ -f "$cache" ]] && source "$cache"
    command helm "$@"
}
