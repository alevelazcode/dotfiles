# =============================================================================
# Prompt Configuration - Clean Version
# =============================================================================

# =============================================================================
# Simple Clean Prompt
# =============================================================================

# Disable prompt substitution to avoid %{%} issues
unsetopt PROMPT_SUBST

# Set a simple, clean prompt
PROMPT='%F{green}%n@%m%f %F{blue}%~%f %F{yellow}%#%f '
RPROMPT='%F{cyan}%T%f'

echo "✅ Clean prompt loaded"

# =============================================================================
# Prompt Functions
# =============================================================================

# Function to reload prompt
reload-prompt() {
    echo "Reloading clean prompt..."
    source "$ZSH_CONFIG_DIR/modules/prompt.zsh"
    echo "Clean prompt reloaded!"
}

# Function to show prompt info
show-prompt-info() {
    echo "Current prompt configuration:"
    echo "✅ Using clean prompt"
    echo "🔧 PROMPT: $PROMPT"
    echo "🔧 RPROMPT: $RPROMPT"
}

# =============================================================================
# Prompt Aliases
# =============================================================================

# Alias for reloading prompt
alias rp="reload-prompt"

# Alias for showing prompt info
alias pi="show-prompt-info"

# =============================================================================
# Prompt Status
# =============================================================================

# Function to check prompt status
check-prompt() {
    echo "Prompt system status:"
    echo "✅ Using clean prompt (no %{%} characters)"
    echo ""
    echo "Current prompt variables:"
    echo "PROMPT: $PROMPT"
    echo "RPROMPT: $RPROMPT"
} 