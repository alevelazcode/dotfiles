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

# Syntax highlighting theme — Tokyo Night Darker
# Defined here (sync, global scope) so the plugin reads it correctly at load time
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
typeset -gA ZSH_HIGHLIGHT_STYLES
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
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#9aa5ce' # 'string'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#9aa5ce' # "string"
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'         # typos
