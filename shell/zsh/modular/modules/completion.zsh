# =============================================================================
# Completion Styles ONLY (compinit already done in init.zsh)
# =============================================================================
# This file is loaded via zsh-defer, so it doesn't block startup

# Completion options
setopt AUTO_LIST AUTO_MENU COMPLETE_IN_WORD

# -----------------------------------------------------------------------------
# Completion Styles (zstyle is fast, no subprocess)
# -----------------------------------------------------------------------------
zstyle ':completion:*' menu select
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path "$HOME/.cache/zsh"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Kill/SSH specific
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd' 