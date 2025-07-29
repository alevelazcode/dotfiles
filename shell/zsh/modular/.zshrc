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