# =============================================================================
# Plugins Configuration
# =============================================================================
# Load order is critical:
#   1. zsh-autosuggestions  (history hints)
#   2. fzf, zoxide, tool completions
#   3. ZSH_HIGHLIGHT_STYLES defined
#   4. zsh-syntax-highlighting  ← MUST be last
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

# -----------------------------------------------------------------------------
# Syntax highlighting theme — Tokyo Night Darker
# Must be defined BEFORE loading the plugin
# -----------------------------------------------------------------------------
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=#7aa2f7'                # commands (electric blue)
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#bb9af7'             # sudo, env, etc. (purple)
ZSH_HIGHLIGHT_STYLES[alias]='fg=#9ece6a'                  # aliases (acid green)
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#7dcfff'                # builtins (icy cyan)
ZSH_HIGHLIGHT_STYLES[function]='fg=#2ac3de'               # functions (steel cyan)
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#565f89'       # ; | && (soft grey)
ZSH_HIGHLIGHT_STYLES[argument]='fg=#c0caf5'               # plain args
ZSH_HIGHLIGHT_STYLES[default]='fg=#c0caf5'                # unmatched text
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#f7768e'               # * ? [] (red-pink)
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#ff9e64'      # !! !$ (orange)
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#e0af68'   # -f (yellow)
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#e0af68'   # --flag (yellow)
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#7aa2f7'   # `cmd` (blue)
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#9aa5ce' # 'string' (muted)
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#9aa5ce' # "string" (muted)
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'         # typos (red/bold)

# -----------------------------------------------------------------------------
# Syntax highlighting — MUST be the last plugin sourced
# -----------------------------------------------------------------------------
zinit light zsh-users/zsh-syntax-highlighting
