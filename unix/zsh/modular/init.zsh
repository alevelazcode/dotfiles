#!/bin/zsh

# =============================================================================
# ZSH Modular Configuration
# =============================================================================
# Simple and functional configuration for macOS and WSL2

# Set the base directory for zsh configuration
export ZSH_CONFIG_DIR="${ZSH_CONFIG_DIR:-$HOME/.config/zsh}"

# Create config directory if it doesn't exist
[[ ! -d "$ZSH_CONFIG_DIR" ]] && mkdir -p "$ZSH_CONFIG_DIR"

# =============================================================================
# Core Configuration Loading
# =============================================================================

# Load core configuration files
source "$ZSH_CONFIG_DIR/core/env.zsh"
source "$ZSH_CONFIG_DIR/core/path.zsh"
source "$ZSH_CONFIG_DIR/core/options.zsh"
source "$ZSH_CONFIG_DIR/core/keybindings.zsh"

# =============================================================================
# OS Detection and Specific Configuration
# =============================================================================

# Detect operating system and load appropriate configuration
case "$(uname -s)" in
    Darwin*)
        # macOS
        source "$ZSH_CONFIG_DIR/os/macos.zsh"
        ;;
    Linux*)
        # Check if running in WSL
        if grep -qi Microsoft /proc/version 2>/dev/null; then
            source "$ZSH_CONFIG_DIR/os/wsl.zsh"
        else
            source "$ZSH_CONFIG_DIR/os/linux.zsh"
        fi
        ;;
    *)
        echo "Unsupported operating system: $(uname -s)"
        ;;
esac

# =============================================================================
# Feature Modules
# =============================================================================

# Load feature modules
source "$ZSH_CONFIG_DIR/modules/aliases.zsh"
source "$ZSH_CONFIG_DIR/modules/functions.zsh"
source "$ZSH_CONFIG_DIR/modules/plugins.zsh"
source "$ZSH_CONFIG_DIR/modules/completion.zsh"
source "$ZSH_CONFIG_DIR/modules/prompt.zsh"

# =============================================================================
# Development Tools
# =============================================================================

# Load development tool configurations
source "$ZSH_CONFIG_DIR/dev/node.zsh"
source "$ZSH_CONFIG_DIR/dev/python.zsh"
source "$ZSH_CONFIG_DIR/dev/rust.zsh"
source "$ZSH_CONFIG_DIR/dev/docker.zsh"

# =============================================================================
# Local Configuration (Optional)
# =============================================================================

# Load local configuration if it exists (for machine-specific settings)
[[ -f "$ZSH_CONFIG_DIR/local.zsh" ]] && source "$ZSH_CONFIG_DIR/local.zsh"

# =============================================================================
# Final Initialization
# =============================================================================

# Initialize completion system
autoload -Uz compinit
compinit

# Load any additional completions
[[ -d "$ZSH_CONFIG_DIR/completions" ]] && fpath=("$ZSH_CONFIG_DIR/completions" $fpath)

echo "✅ ZSH configuration loaded successfully" 