# =============================================================================
# ZSH Configuration with Starship Prompt
# =============================================================================

# Basic environment
export TERM="xterm-256color"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Basic PATH
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# =============================================================================
# Starship Prompt Configuration
# =============================================================================

# Initialize Starship (this replaces PROMPT and RPROMPT)
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
    echo "🚀 Starship prompt loaded"
else
    # Fallback simple prompt if Starship fails
    PROMPT='%n@%m %~ $ '
    echo "⚠️  Starship not found, using fallback prompt"
fi

# =============================================================================
# Basic Configuration
# =============================================================================

# Basic aliases
alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -A'
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'

# Git aliases
alias g='git'
alias ga='git add .'
alias gs='git status -s'
alias gp='git push'
alias gpl='git pull'

# Basic functions
function reload-config() {
    source ~/.zshrc
}

function restore-simple-prompt() {
    echo "To restore simple prompt:"
    echo "bash ~/dotfiles/unix/simple-fix.sh && source ~/.zshrc"
}

# =============================================================================
# ZSH Options
# =============================================================================

# Enable completion
autoload -Uz compinit
compinit

# History configuration
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS

echo "✅ ZSH with Starship configuration loaded"
