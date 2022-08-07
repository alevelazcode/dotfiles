
# export PATH=/opt/homebrew/bin:$PATH
# export NVM_DIR=~/.nvm
# source $(brew --prefix nvm)/nvm.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
alias cat="bat --style=plain"
alias vim="nvim"
alias vi="nvim"
alias y='yarn'
alias g='git'
alias dc='docker compose'
alias d='docker'
alias python="python3" 
alias pip="pip3"
alias ll='lsd -lh --group-dirs=first'
alias la='lsd -a --group-dirs=first'
alias l='lsd --group-dirs=first'
alias lla='lsd -lha --group-dirs=first'
alias htop='btm'
alias ls='lsd --group-dirs=first'
alias runner="ssh root@206.189.115.220"
alias algo-node="ssh root@159.89.181.135"
alias testnet-node="ssh root@137.184.44.109"
alias wallet-dev-="ssh root@159.65.221.171"
alias wallet-prod="ssh root@137.184.202.212"
# export PATH="$PATH:$HOME/.spicetify"
 
#
# . $(brew --prefix)/etc/profile.d/z.sh

# Emulates vim's cursor shape behavior
# Set the normal and visual mode cursors to a block
set fish_cursor_default block
# Set the insert mode cursor to a line
set fish_cursor_insert line
# Set the replace mode cursor to an underscore
set fish_cursor_replace_one underscore
# The following variable can be used to configure cursor shape in
# visual mode, but due to fish_cursor_default, is redundant here
set fish_cursor_visual block

starship init fish | source
