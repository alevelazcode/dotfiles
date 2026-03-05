# =============================================================================
# Prompt ULTRA-OPTIMIZED Configuration
# =============================================================================
# Uses cached starship init to avoid eval overhead (~40ms saved)

local _starship_cache="$HOME/.cache/zsh/starship.zsh"

# Priority: cached file > generate cache > fallback prompt
if [[ -f "$_starship_cache" ]]; then
    source "$_starship_cache"
elif (( $+commands[starship] )); then
    # Generate cache for next time
    command starship init zsh > "$_starship_cache" 2>/dev/null
    source "$_starship_cache"
else
    # Minimal fallback prompt (instant)
    PS1='%F{cyan}%~%f %F{green}❯%f '
fi