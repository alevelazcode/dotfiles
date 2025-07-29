#!/bin/bash

# =============================================================================
# Quick ZSH Configuration Setup
# =============================================================================
# Simple script to create symlink for the modular ZSH configuration

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🔧 ZSH Configuration Setup${NC}"
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/zsh"

echo -e "${YELLOW}📁 Script location: $SCRIPT_DIR${NC}"
echo -e "${YELLOW}📁 Config target: $CONFIG_DIR${NC}"
echo ""

# Create config directory
echo "Creating configuration directory..."
mkdir -p "$CONFIG_DIR"

# Copy files
echo "Copying configuration files..."
cp -r "$SCRIPT_DIR"/* "$CONFIG_DIR/"

# Remove setup scripts from config directory
rm -f "$CONFIG_DIR"/setup.sh
rm -f "$CONFIG_DIR"/install*.sh
rm -f "$CONFIG_DIR"/*.md

# Create symlink for .zshrc
echo "Creating .zshrc symlink..."
if [[ -f "$HOME/.zshrc" ]]; then
    echo -e "${YELLOW}⚠️  Existing .zshrc found. Moving to .zshrc.backup${NC}"
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

ln -sf "$CONFIG_DIR/.zshrc" "$HOME/.zshrc"

# Make init.zsh executable
chmod +x "$CONFIG_DIR/init.zsh"

echo ""
echo -e "${GREEN}✅ Setup complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Restart your terminal"
echo "2. Or run: source ~/.zshrc"
echo ""
echo "Configuration files are in: $CONFIG_DIR"
echo "Local config: $CONFIG_DIR/local.zsh" 