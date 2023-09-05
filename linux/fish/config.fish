if status is-interactive
    # Commands to run in interactive sessions can go here
end
set -gx EDITOR nvim


# NodeJS
set -gx TERM xterm-256color

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH
# Ruby rbenv
set -x PATH $HOME/.rbenv/bin $PATH

set --export JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
set --export ANDROID_HOME $HOME/Android
set --export ANDROID_SDK_ROOT $HOME/Android

set -gx EDITOR nvim


# Rust
set -gx PATH ~/.cargo/bin $PATH
# NodeJS
set -gx PATH node_modules/.bin $PATH
set -gx PATH $ANDROID_HOME/cmdline-tools/tools $PATH;
set -gx PATH $ANDROID_HOME/cmdline-tools/tools/bin $PATH;
set -gx PATH $ANDROID_HOME/cmdline-tools/tools/lib $PATH;
set -gx PATH $ANDROID_HOME/platform-tools $PATH
set -gx PATH $ANDROID_HOME/emulator $PATH
set -gx PATH $ANDROID_HOME/tools $PATH
set -gx PATH $ANDROID_HOME/tools/bin $PATH
set -gx PATH ~/miniconda3/bin $PATH

# Rust
set -gx PATH ~/.cargo/bin $PATH
# NodeJS
set -gx PATH node_modules/.bin $PATH

set -x WSL_HOST (tail -1 /etc/resolv.conf | cut -d' ' -f2)
set -x ADB_SERVER_SOCKET tcp:$WSL_HOST:5037


# NVM
function __check_rvm --on-variable PWD --description 'Do nvm stuff'
  status --is-command-substitution; and return
  if test -f .nvmrc; and test -r .nvmrc;
    nvm use
  else
  end
end

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
alias bat="batcat"
alias cat="bat --style=plain"
alias vim="nvim"
alias vi="nvim"
alias g='git'
alias python="python3" 
alias pip="pip3"
alias ll='ls -alF'
alias la='lsd -a --group-dirs=first'
alias l='lsd --group-dirs=first'
alias lla='lsd -lha --group-dirs=first'
alias htop='btm'
alias ls='exa --icons -F -H --group-directories-first --git -1'
alias runner="ssh root@206.189.115.220"
alias algo-node="ssh root@159.89.181.135"
alias testnet-node="ssh root@137.184.44.109"
alias wallet-dev-="ssh root@159.65.221.171"
alias wallet-prod="ssh vendible@137.184.202.212"

#Add the following line after the case statement
alias jupyter-notebook="~/.local/bin/jupyter-notebook --no-browser"
# export PATH="$PATH:$HOME/.spicetify"


abbr :bd "exit"
abbr :q "tmux kill-server"
abbr ast "aw set -t (aw list | fzf-tmux -p --reverse --preview 'aw set -t {}')"
abbr bc "brew cleanup"
abbr bd "brew doctor"
abbr bi "brew install"
abbr bic "brew install --cask"
abbr bif "brew info"
abbr bifc "brew info --cask"
abbr bo "brew outdated"
abbr bs "brew services"
abbr bsr "brew services restart"

abbr y "yarn"
abbr ya "yarn add"
abbr yad "yarn add -D"
abbr yb "yarn build"
abbr yd "yarn dev"
abbr ye "yarn e2e"
abbr yg "yarn generate"
abbr yl "yarn lint"
abbr yt "yarn test"
abbr yu "yarn ui"

abbr c "clear"
abbr cl "clear"
abbr claer "clear"
abbr clera "clear"
abbr cx "chmod +x"
abbr dc "docker compose"
abbr dcd "docker compose down"
abbr dcdv "docker compose down -v"
abbr dcr "docker compose restart"
abbr dcu "docker compose up -d" 
#
#
# . $(brew --prefix)/etc/profile.d/z.sh

# Emulates vim's cursor shape behavior
# Set the normal and visual mode cursors to a block

set fish_greeting
set fish_cursor_default block
# Set the insert mode cursor to a line
set fish_cursor_insert line
# Set the replace mode cursor to an underscore
set fish_cursor_replace_one underscore
# The following variable can be used to configure cursor shape in
# visual mode, but due to fish_cursor_default, is redundant here
set fish_cursor_visual block

function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    fish_default_key_bindings -M insert

    # Then execute the vi-bindings so they take precedence when there's a conflict.
    # Without --no-erase fish_vi_key_bindings will default to
    # resetting all bindings.
    # The argument specifies the initial mode (insert, "default" or visual).
    fish_vi_key_bindings --no-erase insert
end

# fish colors
set -U fish_color_autosuggestion grey 
set -U fish_color_command green 
set -U fish_color_error red
set -U fish_color_param cyan
set -U fish_color_redirections yellow
set -U fish_color_terminators white
set -U fish_color_valid_path green


# oh-my-posh init fish | source
zoxide init fish | source
# ~/.config/fish/config.fish

starship init fish | source

conda init fish | source 
# rbenv init - | source
