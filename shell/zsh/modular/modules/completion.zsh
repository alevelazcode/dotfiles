# =============================================================================
# Completion Configuration
# =============================================================================

# =============================================================================
# Basic Completion Setup
# =============================================================================

# Enable completion system
autoload -Uz compinit

# Load completion system
compinit

# =============================================================================
# Completion Options
# =============================================================================

# Completion system options
setopt AUTO_LIST
setopt AUTO_MENU
setopt AUTO_PARAM_SLASH
setopt COMPLETE_IN_WORD
setopt MENU_COMPLETE

# =============================================================================
# Completion Styles
# =============================================================================

# Use menu selection
zstyle ':completion:*' menu select

# Menu selection key bindings (must be after compinit)
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Use cache for completion
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Fuzzy matching
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# =============================================================================
# Completion Colors
# =============================================================================

# Colors for completion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# =============================================================================
# Specific Completion Styles
# =============================================================================

# Git completion
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash

# Kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# SSH completion
zstyle ':completion:*:scp:*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:scp:*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr

# =============================================================================
# Custom Completion Functions
# =============================================================================

# Function to reload completions
reload-completions() {
    echo "Reloading completions..."
    compinit
    echo "Completions reloaded!"
}

# Function to list available completions
list-completions() {
    echo "Available completions:"
    compgen -A function | grep "^_" | sort
}

# =============================================================================
# Development Tool Completions
# =============================================================================

# Node.js completions
if command -v npm &> /dev/null; then
    # npm completion is usually handled by Oh My Zsh
    # But we can add custom npm completions here if needed
fi

# Python completions
if command -v pip &> /dev/null; then
    # pip completion
    if [[ -f "$HOME/.local/bin/pip" ]]; then
        eval "$(pip completion --zsh)"
    fi
fi

# Docker completions
if command -v docker &> /dev/null; then
    # Docker completion is usually handled by Oh My Zsh
    # But we can add custom docker completions here if needed
fi

# Kubernetes completions
if command -v kubectl &> /dev/null; then
    # kubectl completion is handled in plugins.zsh
fi

# AWS CLI completions
if command -v aws &> /dev/null; then
    # AWS completion is handled in plugins.zsh
fi

# =============================================================================
# Custom Completion Functions
# =============================================================================

# Custom completion for project directories
_project_dirs() {
    local dirs
    dirs=($(find ~/work -maxdepth 2 -type d -name ".*" -prune -o -type d -print 2>/dev/null))
    _describe 'project directories' dirs
}

# Custom completion for git branches
_git_branches() {
    local branches
    branches=($(git branch --format='%(refname:short)'))
    _describe 'git branches' branches
}

# Custom completion for docker containers
_docker_containers() {
    local containers
    containers=($(docker ps --format='{{.Names}}'))
    _describe 'docker containers' containers
}

# =============================================================================
# Completion Aliases
# =============================================================================

# Alias for reloading completions
alias rc="reload-completions"

# Alias for listing completions
alias lc="list-completions"

# =============================================================================
# Completion Status
# =============================================================================

# Function to check completion status
check-completions() {
    echo "Completion system status:"
    
    if autoload -Uz compinit; then
        echo "✅ compinit autoloaded successfully"
    else
        echo "❌ compinit autoload failed"
    fi
    
    if compinit; then
        echo "✅ Completion system initialized"
    else
        echo "❌ Completion system initialization failed"
    fi
    
    echo ""
    echo "Available completion functions:"
    compgen -A function | grep "^_" | head -10
    echo "... and more"
} 