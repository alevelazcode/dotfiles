# =============================================================================
# Aliases Configuration
# =============================================================================

# =============================================================================
# File and Directory Aliases
# =============================================================================

# Enhanced file listing (using Rust tools)
if command -v eza &> /dev/null; then
    alias ls='eza --icons -F -H --group-directories-first --git -1 -a'
    alias ll='eza --icons -F -H --group-directories-first --git -la'
    alias la='eza --icons -F -H --group-directories-first --git -a'
    alias l='eza --icons -F -H --group-directories-first --git -1'
    alias tree='eza --tree'
fi

# Enhanced file viewing (using Rust tools)
if command -v bat &> /dev/null; then
    alias cat="bat --style=plain"
fi
if command -v batgrep &> /dev/null; then
    alias grep="batgrep"
fi
if command -v fd &> /dev/null; then
    alias find='fd'
fi
if command -v ripgrep &> /dev/null; then
    alias rg='ripgrep'
fi

# Directory navigation
alias downloads="cd ~/Downloads"
alias work="cd ~/work"
alias home="cd ~"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# =============================================================================
# Editor Aliases
# =============================================================================

# Neovim as default editor
alias vim="nvim"
alias vi="nvim"
alias v="nvim"

# =============================================================================
# Git Aliases
# =============================================================================

alias g='git'
alias ga="git add ."
alias gs="git status -s"
# gc is defined as a function in functions.zsh
alias gp="git push"
alias gpl="git pull"
alias gco="git checkout"
alias gcb="git pull && git checkout -b"
# gcm is defined as a function in functions.zsh
alias gb="git branch"
alias gd="git diff"
alias gl="git log --oneline --graph --decorate"
alias gr="git remote -v"

# Git commit with message (function moved to functions.zsh)

# =============================================================================
# Python Aliases
# =============================================================================

alias python='python3'
alias pip='pip3'
alias jupyter-notebook="~/.local/bin/jupyter-notebook --no-browser"

# =============================================================================
# Node.js and Package Manager Aliases
# =============================================================================

# pnpm aliases
alias pn="pnpm"
alias pni="pnpm i"
alias pnd="pnpm dev"
alias pbs="pnpm serve"
alias pnb="pnpm build"

# npm aliases
alias ns="npm run serve"

# =============================================================================
# System Utility Aliases
# =============================================================================

# Enhanced system monitoring (using Rust tools)
if command -v btm &> /dev/null; then
    alias htop='btm'
fi
if command -v fastfetch &> /dev/null; then
    alias neofetch='fastfetch'
fi

# Process management
alias psaux="ps aux"
# killport is defined as a function in functions.zsh

# =============================================================================
# Development Workflow Aliases
# =============================================================================

# Project-specific aliases
alias run-kloov-be="cd ~/work/work/kloov/kloov-be;git pull; pnpm start:dev"
alias run-kloov-fe="cd ~/work/work/kloov/kloov-fe; pnpm dev"
alias run-kloov-strapi="cd ~/work/work/kloov/kloov-strapi;git pull; yarn develop"

# =============================================================================
# GitHub Copilot Aliases
# =============================================================================

alias copilot='gh copilot'
alias gcs='gh copilot suggest'
alias gce='gh copilot explain'

# =============================================================================
# Rust/Cargo Aliases
# =============================================================================

# Update all global cargo packages
alias cargoglobalupdate='cargo install --list | awk '\''{print $1}'\'' | xargs -n 1 cargo install --force ; cargo clean'

# =============================================================================
# Docker Aliases
# =============================================================================

alias dc="docker compose"
alias dcd="docker compose down"
alias dcdv="docker compose down -v"
alias dcr="docker compose restart"
alias dcu="docker compose up -d"
alias dps="docker ps"
alias di="docker images"

# =============================================================================
# Utility Aliases
# =============================================================================

# Clear screen
alias c="clear"

# Exit
alias bd="exit"

# Quick navigation
if command -v aw &> /dev/null && command -v fzf-tmux &> /dev/null; then
    alias ast() { aw set -t $(aw list | fzf-tmux -p --reverse --preview 'aw set -t {}') }
fi

# =============================================================================
# Conditional Aliases (OS-specific)
# =============================================================================

# macOS specific aliases (if not already defined in os/macos.zsh)
if [[ "$OSTYPE" == "darwin"* ]]; then
    # These might be overridden by os/macos.zsh
    [[ -z "$(alias | grep '^alias brewski=')" ]] && alias brewski='brew update && brew upgrade && brew cleanup; brew doctor; brew missing; echo "Brewski Complete" | terminal-notifier -sound default -appIcon https://brew.sh/assets/img/homebrew-256x256.png -title "Homebrew"'
fi

# Linux/WSL specific aliases (if not already defined in os/linux.zsh or os/wsl.zsh)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # These might be overridden by os/linux.zsh or os/wsl.zsh
    [[ -z "$(alias | grep '^alias update=')" ]] && alias update="sudo apt update && sudo apt upgrade -y"
fi 