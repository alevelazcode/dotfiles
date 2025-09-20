# =============================================================================
# ZSH Configuration Entry Point
# =============================================================================
# This file is the entry point for the modular ZSH configuration
# It simply loads the modular configuration system

# Load the modular configuration
if [[ -f "$HOME/.config/zsh/init.zsh" ]]; then
    source "$HOME/.config/zsh/init.zsh"
else
    echo "❌ Modular ZSH configuration not found at ~/.config/zsh/init.zsh"
    echo "Please run the installation script or check your configuration."
    
    # Fallback to basic configuration
    export TERM=xterm-256color
    export EDITOR=nvim
    
    # Basic PATH
    export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
    
    # Basic keybindings
    bindkey -v
    
    # Basic completion
    autoload -Uz compinit && compinit
fi 
# Added by Windsurf
export PATH="/Users/alejandrovelazco/.codeium/windsurf/bin:$PATH"


# Load Angular CLI autocompletion.
source <(ng completion script)

# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/Users/alejandrovelazco/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "${HOME}/miniforge3/etc/profile.d/conda.sh" ]; then
#         . "${HOME}/miniforge3/etc/profile.d/conda.sh"
#     else
#         export PATH="/Users/alejandrovelazco/miniforge3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE='/Users/alejandrovelazco/miniforge3/bin/mamba';
export MAMBA_ROOT_PREFIX='/Users/alejandrovelazco/miniforge3';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
