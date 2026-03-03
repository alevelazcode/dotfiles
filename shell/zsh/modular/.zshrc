# =============================================================================
# ZSH Entry Point
# =============================================================================

[[ -f "$HOME/.config/zsh/init.zsh" ]] && source "$HOME/.config/zsh/init.zsh"

# Extra PATH (tools that add themselves here)
[[ -d "$HOME/.codeium/windsurf/bin" ]] && export PATH="$HOME/.codeium/windsurf/bin:$PATH"
[[ -d "$HOME/.antigravity/antigravity/bin" ]] && export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# Lazy loaders for rarely-used tools
ng() {
    unfunction ng 2>/dev/null
    source <(command ng completion script 2>/dev/null)
    command ng "$@"
}

mamba() {
    unfunction mamba 2>/dev/null
    eval "$("$HOME/miniforge3/bin/mamba" shell hook --shell zsh --root-prefix "$HOME/miniforge3" 2>/dev/null)"
    mamba "$@"
}
