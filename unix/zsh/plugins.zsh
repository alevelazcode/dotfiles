

plugins=(
git
zsh-autosuggestions
zsh-syntax-highlighting
)
# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

