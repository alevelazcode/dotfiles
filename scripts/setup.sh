#!/bin/bash

# =============================================================================
# Dotfiles Setup Script - Cross Platform (macOS ARM M1 & WSL2/Ubuntu Linux)
# =============================================================================

echo "🔧 Setting up dotfiles..."

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Create .config directory if it doesn't exist
mkdir -p ~/.config

# =============================================================================
# ZSH Configuration Setup
# =============================================================================

echo "📁 Setting up ZSH configuration..."

# Create zsh config directory
mkdir -p ~/.config/zsh

# Symlink the modular zsh configuration
ln -sf "$DOTFILES_DIR/unix/zsh/modular"/* ~/.config/zsh/

# Symlink the main .zshrc
ln -sf "$DOTFILES_DIR/unix/.zshrc" ~/.zshrc

echo "✅ ZSH configuration linked"

# =============================================================================
# Other Configuration Files
# =============================================================================

echo "📁 Setting up other configurations..."

# Neofetch configuration
if [[ -d "$DOTFILES_DIR/common/neofetch" ]]; then
    ln -sf "$DOTFILES_DIR/common/neofetch" ~/.config/
    echo "✅ Neofetch configuration linked"
fi

# Starship configuration
if [[ -f "$DOTFILES_DIR/startship/starship.toml" ]]; then
    ln -sf "$DOTFILES_DIR/startship/starship.toml" ~/.config/
    echo "✅ Starship configuration linked"
fi

# Neovim configuration
if [[ -d "$DOTFILES_DIR/nvim" ]]; then
    ln -sf "$DOTFILES_DIR/nvim" ~/.config/
    echo "✅ Neovim configuration linked"
fi

# Ripgrep configuration
if [[ -f "$DOTFILES_DIR/unix/.ripgreprc" ]]; then
    ln -sf "$DOTFILES_DIR/unix/.ripgreprc" ~/.ripgreprc
    echo "✅ Ripgrep configuration linked"
fi

echo "🎉 Setup complete! Please restart your terminal or run 'source ~/.zshrc'"