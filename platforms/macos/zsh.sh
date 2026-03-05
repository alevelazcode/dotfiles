#!/bin/bash

# =============================================================================
# ZSH Setup — Zinit-based (replaces Oh My Zsh)
# =============================================================================

# Set ZSH as default shell
echo "Setting ZSH as default shell"
if [[ "$SHELL" != "$(which zsh)" ]]; then
    echo "$(which zsh)" | sudo tee -a /etc/shells
    chsh -s "$(which zsh)"
fi

# Zinit is installed via Homebrew (brew install zinit)
# Plugins are loaded automatically by shell/zsh/modular/init.zsh
echo "ZSH setup complete. Zinit plugins will be loaded on first shell start."
