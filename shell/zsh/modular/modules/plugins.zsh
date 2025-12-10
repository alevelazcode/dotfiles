# =============================================================================
# Plugins ULTRA-OPTIMIZED Configuration
# =============================================================================
# NO command -v, direct file checks using $HOMEBREW_PREFIX
# This file is loaded via zsh-defer (async) so it doesn't block startup

# Use variable for cleaner code
: ${HOMEBREW_PREFIX:=/opt/homebrew}
local _zsh_cache="$HOME/.cache/zsh"

# -----------------------------------------------------------------------------
# ZSH Autosuggestions - Direct load (fast plugin)
# -----------------------------------------------------------------------------
local _as="$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$_as" ]] && source "$_as"

# -----------------------------------------------------------------------------
# ZSH Syntax Highlighting - Direct load (must be last ideally)
# -----------------------------------------------------------------------------
local _sh="$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -f "$_sh" ]] && source "$_sh"

# -----------------------------------------------------------------------------
# FZF - Direct load (keybindings + completion)
# -----------------------------------------------------------------------------
local _fzf_keys="$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
local _fzf_comp="$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
[[ -f "$_fzf_keys" ]] && source "$_fzf_keys"
[[ -f "$_fzf_comp" ]] && source "$_fzf_comp"

# -----------------------------------------------------------------------------
# Zoxide - Use CACHED init (saves ~30ms eval)
# -----------------------------------------------------------------------------
local _zoxide_cache="$_zsh_cache/zoxide.zsh"
if [[ -f "$_zoxide_cache" ]]; then
    source "$_zoxide_cache"
elif [[ -x "$HOMEBREW_PREFIX/bin/zoxide" ]]; then
    "$HOMEBREW_PREFIX/bin/zoxide" init zsh > "$_zoxide_cache" 2>/dev/null
    source "$_zoxide_cache"
fi

# -----------------------------------------------------------------------------
# Bun completions - Direct load (small file)
# -----------------------------------------------------------------------------
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# -----------------------------------------------------------------------------
# LAZY LOADERS for heavy tools (kubectl, helm, aws)
# These are defined as functions and only load completions when first used
# -----------------------------------------------------------------------------

# kubectl lazy loader
kubectl() {
    unfunction kubectl 2>/dev/null
    local _kube_cache="$_zsh_cache/kubectl.zsh"
    if [[ ! -f "$_kube_cache" ]] && [[ -x "$HOMEBREW_PREFIX/bin/kubectl" ]]; then
        "$HOMEBREW_PREFIX/bin/kubectl" completion zsh > "$_kube_cache" 2>/dev/null
    fi
    [[ -f "$_kube_cache" ]] && source "$_kube_cache"
    command kubectl "$@"
}

# helm lazy loader
helm() {
    unfunction helm 2>/dev/null
    local _helm_cache="$_zsh_cache/helm.zsh"
    if [[ ! -f "$_helm_cache" ]] && [[ -x "$HOMEBREW_PREFIX/bin/helm" ]]; then
        "$HOMEBREW_PREFIX/bin/helm" completion zsh > "$_helm_cache" 2>/dev/null
    fi
    [[ -f "$_helm_cache" ]] && source "$_helm_cache"
    command helm "$@"
}

# AWS completer (static file, no lazy needed)
[[ -f "$HOMEBREW_PREFIX/bin/aws_zsh_completer.sh" ]] && \
    source "$HOMEBREW_PREFIX/bin/aws_zsh_completer.sh" 