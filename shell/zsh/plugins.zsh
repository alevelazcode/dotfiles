

plugins=(
git
zsh-autosuggestions
zsh-syntax-highlighting
fzf
z
)
# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Zoxide - use cache for faster startup
local _zoxide_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zoxide.zsh"
if [[ ! -f "$_zoxide_cache" || ! -s "$_zoxide_cache" ]]; then
    mkdir -p "${_zoxide_cache:h}"
    zoxide init zsh > "$_zoxide_cache" 2>/dev/null
fi
[[ -f "$_zoxide_cache" ]] && source "$_zoxide_cache"

# Starship - use cache for faster startup
local _starship_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/starship.zsh"
if [[ ! -f "$_starship_cache" || ! -s "$_starship_cache" ]]; then
    mkdir -p "${_starship_cache:h}"
    starship init zsh > "$_starship_cache" 2>/dev/null
fi
[[ -f "$_starship_cache" ]] && source "$_starship_cache"
