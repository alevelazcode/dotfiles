#!/bin/bash

# =============================================================================
# ZSH Setup — Zinit-based (replaces Oh My Zsh)
# =============================================================================

# Set ZSH as default shell
echo "Setting ZSH as default shell"
local_zsh="$(which zsh)"
if [[ "$SHELL" != "$local_zsh" ]]; then
    # Add to /etc/shells only if not already present
    if ! grep -qxF "$local_zsh" /etc/shells; then
        echo "$local_zsh" | sudo tee -a /etc/shells
    fi
    chsh -s "$local_zsh"
fi

# Zinit is installed via Homebrew (brew install zinit)
# Plugins are loaded automatically by shell/zsh/modular/init.zsh
echo "ZSH setup complete. Zinit plugins will be loaded on first shell start."
