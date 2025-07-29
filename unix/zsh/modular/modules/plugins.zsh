# =============================================================================
# Plugins Configuration
# =============================================================================

# =============================================================================
# ZSH Autosuggestions
# =============================================================================

# Load zsh-autosuggestions if available
if [[ -f "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [[ -f "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [[ -f "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# =============================================================================
# ZSH Syntax Highlighting
# =============================================================================

# Load zsh-syntax-highlighting if available
if [[ -f "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ -f "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# =============================================================================
# FZF Configuration
# =============================================================================

# Load FZF if available
if command -v fzf &> /dev/null; then
    # FZF key bindings
    if [[ -f "/opt/homebrew/opt/fzf/shell/key-bindings.zsh" ]]; then
        source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
    elif [[ -f "/usr/share/doc/fzf/examples/key-bindings.zsh" ]]; then
        source "/usr/share/doc/fzf/examples/key-bindings.zsh"
    elif [[ -f "$HOME/.fzf/shell/key-bindings.zsh" ]]; then
        source "$HOME/.fzf/shell/key-bindings.zsh"
    fi
    
    # FZF completion
    if [[ -f "/opt/homebrew/opt/fzf/shell/completion.zsh" ]]; then
        source "/opt/homebrew/opt/fzf/shell/completion.zsh"
    elif [[ -f "/usr/share/doc/fzf/examples/completion.zsh" ]]; then
        source "/usr/share/doc/fzf/examples/completion.zsh"
    elif [[ -f "$HOME/.fzf/shell/completion.zsh" ]]; then
        source "$HOME/.fzf/shell/completion.zsh"
    fi
fi

# =============================================================================
# Zoxide (Smart cd)
# =============================================================================

# Initialize zoxide if available
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# =============================================================================
# Starship Prompt (DISABLED - Causing %{%} characters conflict)
# =============================================================================

# COMMENTED OUT TO FIX %{%} CHARACTERS ISSUE
# Initialize Starship if available
# if command -v starship &> /dev/null; then
#     eval "$(starship init zsh)"
# fi

# =============================================================================
# Bun Completions
# =============================================================================

# Load bun completions if available
if [[ -s "$HOME/.bun/_bun" ]]; then
    source "$HOME/.bun/_bun"
fi

# =============================================================================
# Additional Tool Completions
# =============================================================================

# Load additional completions if available
if command -v kubectl &> /dev/null; then
    source <(kubectl completion zsh)
fi

if command -v helm &> /dev/null; then
    source <(helm completion zsh)
fi

if command -v docker &> /dev/null; then
    # Docker completions are usually handled by Oh My Zsh
    # But we can add custom ones here if needed
fi

if command -v aws &> /dev/null; then
    # AWS CLI completions
    if [[ -f "/opt/homebrew/bin/aws_zsh_completer.sh" ]]; then
        source "/opt/homebrew/bin/aws_zsh_completer.sh"
    elif [[ -f "/usr/local/bin/aws_zsh_completer.sh" ]]; then
        source "/usr/local/bin/aws_zsh_completer.sh"
    fi
fi

# =============================================================================
# Custom Plugin Functions
# =============================================================================

# Function to reload plugins
reload-plugins() {
    echo "Reloading zsh plugins..."
    autoload -Uz compinit
    compinit
    echo "Plugins reloaded!"
}

# Function to list loaded plugins
list-plugins() {
    echo "Loaded plugins:"
    
    if [[ -f "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] || \
       [[ -f "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] || \
       [[ -f "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
        echo "- zsh-autosuggestions"
    fi
    
    if [[ -f "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] || \
       [[ -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] || \
       [[ -f "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
        echo "- zsh-syntax-highlighting"
    fi
    
    if command -v fzf &> /dev/null; then
        echo "- fzf"
    fi
    
    if command -v zoxide &> /dev/null; then
        echo "- zoxide"
    fi
    
    echo "- starship (disabled to prevent %{%} characters)"
    
    if [[ -s "$HOME/.bun/_bun" ]]; then
        echo "- bun completions"
    fi
    
    if command -v kubectl &> /dev/null; then
        echo "- kubectl completions"
    fi
    
    if command -v helm &> /dev/null; then
        echo "- helm completions"
    fi
    
    if command -v aws &> /dev/null; then
        echo "- aws completions"
    fi
}

# =============================================================================
# Plugin Status Check
# =============================================================================

# Check if essential plugins are loaded
check-plugins() {
    local missing_plugins=()
    
    # Check zsh-autosuggestions
    if ! [[ -f "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
       ! [[ -f "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
       ! [[ -f "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
        missing_plugins+=("zsh-autosuggestions")
    fi
    
    # Check zsh-syntax-highlighting
    if ! [[ -f "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
       ! [[ -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
       ! [[ -f "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
        missing_plugins+=("zsh-syntax-highlighting")
    fi
    
    # Check fzf
    if ! command -v fzf &> /dev/null; then
        missing_plugins+=("fzf")
    fi
    
    # Check zoxide
    if ! command -v zoxide &> /dev/null; then
        missing_plugins+=("zoxide")
    fi
    
    # Note: Starship is intentionally disabled
    
    if [[ ${#missing_plugins[@]} -eq 0 ]]; then
        echo "✅ All plugins are loaded successfully (Starship disabled to prevent %{%} characters)"
    else
        echo "⚠️  Missing plugins: ${missing_plugins[*]}"
        echo "💡 Consider installing missing plugins for better experience"
        echo "🚨 Starship is disabled to prevent %{%} characters conflict"
    fi
} 