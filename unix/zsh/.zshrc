# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


export JAVA_HOME="/opt/homebrew/opt/openjdk@11"
export TERM=xterm-256color

export ZSH=$HOME/.oh-my-zsh

export CONFIG_ZSH=$HOME/config_zsh

export BUN_INSTALL="$HOME/.bun"

export PATH="$BUN_INSTALL/bin:$PATH"

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

export PATH=$JAVA_HOME/bin:$PATH

export PATH="$HOME/.jenv/bin:$PATH"

# Determine OS and source the appropriate config file
case "$(uname)" in
  Darwin)
    . "$CONFIG_ZSH/config-osx.zsh"
    ;;
  Linux)
    . "$CONFIG_ZSH/config-linux.zsh"
    ;;
  *)
    . "$CONFIG_ZSH/config-windows.zsh"
    ;;
esac




# Check if local configuration file exists and source it
LOCAL_CONFIG="$CONFIG_ZSH/config-local.zsh"
[[ -f $LOCAL_CONFIG ]] && source $LOCAL_CONFIG

# Import module function from fish, need to convert to zsh equivalent
# source ~/.config/fish/custom_functions/copy_to_clipboard.fish
# This will need to be converted or rewritten for zsh.

# Set neovim as default editor
export EDITOR=nvim

# NodeJS
export TERM=xterm-256color

# Update PATH
# export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.rbenv/bin:$ANDROID_HOME/cmdline-tools/tools:$ANDROID_HOME/cmdline-tools/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$HOME/miniconda3/bin:$HOME/go/bin:$HOME/.cargo/bin:node_modules/.bin:$HOME/personal_scripts:$PATH"

# For conda, initialize in zsh like so:
if [[ -f $HOME/miniconda3/bin/conda ]]; then
  eval "$($HOME/miniconda3/bin/conda 'shell.zsh' 'hook')"
fi

# Keybindings, for vi-mode you can set in zsh directly
bindkey -v

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="$HOME/personal-scripts/bash:$PATH"

export PATH=$HOME/bin:$PATH

export PATH="$HOME/.local/bin:$PATH"

export PATH="$(brew --prefix python)/libexec/bin:$PATH"

export PATH="$HOME/.cargo/bin:$PATH"


# Plugins 
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -f $CONFIG_ZSH/aliases.zsh ]] && source $CONFIG_ZSH/aliases.zsh
[[ -f "$CONFIG_ZSH/functions.zsh" ]] && source "$CONFIG_ZSH/functions.zsh"
[[ -f $CONFIG_ZSH/plugins.zsh ]] && source $CONFIG_ZSH/plugins.zsh

# # # Load and initialise completion system
# autoload -Uz compinit && compinit

# # source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# pokemon-colorscripts -r

PATH=~/.console-ninja/.bin:$PATH


# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Added by Windsurf
export PATH="/Users/alejandrovelazco/.codeium/windsurf/bin:$PATH"

export PATH="$HOME/Library/Android/sdk/cmdline-tools/latest/bin:$PATH"
export ANDROID_HOME=$HOME/Library/Android/sdk

export PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools
