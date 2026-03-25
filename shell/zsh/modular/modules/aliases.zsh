# =============================================================================
# Aliases
# =============================================================================

# Modern CLI tools (Rust replacements)
local _eza='eza --icons -F -H --group-directories-first --git'
alias ls="$_eza -1 -a"
alias ll="$_eza -la"
alias la="$_eza -a"
alias l="$_eza -1"
alias tree='eza --tree'
alias cat="bat --style=plain"

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Editors
alias vim="nvim"
alias vi="nvim"
alias v="nvim"

# Git
alias g='git'
alias ga="git add"
alias gs="git status -s"
alias gp="git push"
alias gpl="git pull"
alias gco="git checkout"
alias gcb="git pull && git checkout -b"
alias gb="git branch"
alias gd="git diff"
alias gl="git log --oneline --graph --decorate"

# Docker
alias d="docker"
alias dc="docker compose"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcdv="docker compose down -v"
alias dcr="docker compose restart"
alias dcl="docker compose logs"
alias dps="docker ps"

# Package managers
alias pn="pnpm"
alias pni="pnpm i"
alias pnd="pnpm dev"
alias pnb="pnpm build"
alias nrd="npm run dev"
alias nrb="npm run build"

# GitHub Copilot
alias copilot='gh copilot'
alias gcs='gh copilot suggest'
alias gce='gh copilot explain'

# Misc
alias c="clear"
alias bd="exit"
