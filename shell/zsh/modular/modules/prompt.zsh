# =============================================================================
# Prompt ULTRA-OPTIMIZED Configuration
# =============================================================================
# Uses cached starship init to avoid eval overhead (~40ms saved)

: ${HOMEBREW_PREFIX:=/opt/homebrew}
local _starship_cache="$HOME/.cache/zsh/starship.zsh"
local _starship_bin="$HOMEBREW_PREFIX/bin/starship"

# Priority: cached file > generate cache > fallback prompt
if [[ -f "$_starship_cache" ]]; then
    source "$_starship_cache"
elif [[ -x "$_starship_bin" ]]; then
    # Generate cache for next time
    "$_starship_bin" init zsh > "$_starship_cache" 2>/dev/null
    source "$_starship_cache"
else
    # Minimal fallback prompt (instant)
    PS1='%F{cyan}%~%f %F{green}❯%f '
fi