export TERM=xterm-256color
# Determine OS and source the appropriate config file
case "$(uname)" in
  Darwin)
    source "$(dirname "${(%):-%N}")/config-osx.zsh"
    ;;
  Linux)
    source "$(dirname "${(%):-%N}")/config-linux.zsh"
    ;;
  *)
    source "$(dirname "${(%):-%N}")/config-windows.zsh"
    ;;
esac

# Check if local configuration file exists and source it
LOCAL_CONFIG="$(dirname "${(%):-%N}")/config-local.zsh"
[[ -f $LOCAL_CONFIG ]] && source $LOCAL_CONFIG

# Import module function from fish, need to convert to zsh equivalent
# source ~/.config/fish/custom_functions/copy_to_clipboard.fish
# This will need to be converted or rewritten for zsh.

# Set neovim as default editor
export EDITOR=nvim

# NodeJS
export TERM=xterm-256color

# Update PATH
export PATH=~/bin:~/.local/bin:$HOME/.rbenv/bin:$ANDROID_HOME/cmdline-tools/tools:$ANDROID_HOME/cmdline-tools/tools/bin:$ANDROID_HOME/cmdline-tools/tools/lib:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:~/miniconda3/bin:$HOME/go/bin:~/.cargo/bin:node_modules/.bin:~/personal_scripts:$PATH

# NVM
autoload -U add-zsh-hook
load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    nvm use
  fi
}
add-zsh-hook chpwd load-nvmrc

# Prompt customization
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.

# Aliases
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

# Additional aliases
alias jupyter-notebook="~/.local/bin/jupyter-notebook --no-browser"

# Functions equivalent to Fish's abbreviation
function bd() { exit }
function q() { tmux kill-server }
function ast() { aw set -t $(aw list | fzf-tmux -p --reverse --preview 'aw set -t {}') }

function pn() { pnpm }
function pni() { pnpm i }
function pnd() { pnpm dev }
function pbs() { pnpm serve }
function pnb() { pnpm build }

function ns() { npm run serve }

function c() { clear }
function cx() { chmod +x }
function dc() { docker compose }
function dcd() { docker compose down }
function dcdv() { docker compose down -v }
function dcr() { docker compose restart }
function dcu() { docker compose up -d }



function run_roger_api {
  export TWILIO_AUTH_TOKEN=6fe113093f0e40265f93d8b96f3bee16                                                                             
  export TWILIO_ACCT_SID=AC34af568071949f09acdeefacf038ad65
  export TWILIO_NUM=+15005550006
  export MAILCHIMP_API_KEY=f8e893bedcf96d4929c984bf6a6a6db8-us21
  yarn api
}

function run_roger_dashboard {
  export NODE_ENV=development                                                                                                   
  export NX_TWILIO_NUM=+15005550006
  yarn dashboard
}

# Cursor shapes, can be achieved in zsh with a plugin like zsh-vi-mode
# zsh-vi-mode provides cursor shape functionality
# Colors (use oh-my-zsh's 'colors' plugin or zsh-syntax-highlighting plugin)

# Plugins (zoxide, starship, etc.)
# Example: assuming you have these tools installed, you would initialize them in zsh like this:
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# For conda, initialize in zsh like so:
if [[ -f $HOME/miniconda3/bin/conda ]]; then
  eval "$($HOME/miniconda3/bin/conda 'shell.zsh' 'hook')"
fi

# Keybindings, for vi-mode you can set in zsh directly
bindkey -v

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="$HOME/personal_scripts/:$PATH"
