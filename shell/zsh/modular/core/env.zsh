# =============================================================================
# Environment Variables
# =============================================================================

export TERM="xterm-256color"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"

# History
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE="$HOME/.zsh_history"

# FZF
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --style=numbers --color=always --line-range :500 {}'"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude .cache"

# Zoxide
export _ZO_DATA_DIR="$HOME/.local/share/zoxide"

# Starship
export STARSHIP_CONFIG="$HOME/.config/starship.toml"

# Console Ninja
[[ -d "$HOME/.console-ninja/.bin" ]] && export PATH="$HOME/.console-ninja/.bin:$PATH"
