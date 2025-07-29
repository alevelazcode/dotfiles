

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

eval "$(zoxide init zsh)"
# source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
eval "$(starship init zsh)"
