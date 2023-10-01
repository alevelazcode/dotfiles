switch (uname)
  case Darwin
    source (dirname (status --current-filename))/config-osx.fish
  case Linux
    source (dirname (status --current-filename))/config-linux.fish
  case '*'
    source (dirname (status --current-filename))/config-windows.fish
end

set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
  source $LOCAL_CONFIG
end
#import module function from fish
source ~/.config/fish/custom_functions/copy_to_clipboard.fish

# Set neovim as default editor
set -gx EDITOR nvim



# NodeJS
set -gx TERM xterm-256color

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH
# Ruby rbenv
set -x PATH $HOME/.rbenv/bin $PATH


set -gx EDITOR nvim


# Android SDK
set -gx PATH $ANDROID_HOME/cmdline-tools/tools $PATH;
set -gx PATH $ANDROID_HOME/cmdline-tools/tools/bin $PATH;
set -gx PATH $ANDROID_HOME/cmdline-tools/tools/lib $PATH;
set -gx PATH $ANDROID_HOME/platform-tools $PATH
set -gx PATH $ANDROID_HOME/emulator $PATH
set -gx PATH $ANDROID_HOME/tools $PATH
set -gx PATH $ANDROID_HOME/tools/bin $PATH


# Miniconda 3 (Python) 
set -gx PATH ~/miniconda3/bin $PATH

# Go
set -g GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH

# Rust
set -gx PATH ~/.cargo/bin $PATH

# NodeJS
set -gx PATH node_modules/.bin $PATH



# NVM
function __check_rvm --on-variable PWD --description 'Do nvm stuff'
  status --is-command-substitution; and return
  if test -f .nvmrc; and test -r .nvmrc;
    nvm use
  else
  end
end

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# alias bat="batcat"
alias cat="bat --style=plain"
alias vim="nvim"
alias vi="nvim"
alias g='git'
alias python="python3" 
alias pip="pip3"
alias htop='btm'
alias ls='exa --icons -F -H --group-directories-first --git -1'
alias ll='ls -alF'
alias gc="git commit"
alias gp="git push"
alias gpl="git pull"
alias gc="git commit -m"


#Add the following line after the case statement
alias jupyter-notebook="~/.local/bin/jupyter-notebook --no-browser"
# export PATH="$PATH:$HOME/.spicetify"

abbr :bd "exit"
abbr :q "tmux kill-server"
abbr ast "aw set -t (aw list | fzf-tmux -p --reverse --preview 'aw set -t {}')"

abbr pn "pnpm"
abbr pni "pnpm i"
abbr pnd "pnpm dev"
abbr pbs "pnpm serve"
abbr pnb = "pnpm build"


abbr ns "npm run serve"

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

if test -f $HOME/miniconda3/bin/conda
    eval $HOME/miniconda3/bin/conda "shell.fish" "hook" $argv | source
end

function fish_user_key_bindings
  fish_vi_key_bindings
end
