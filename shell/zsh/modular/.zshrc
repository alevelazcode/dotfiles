# =============================================================================
# ZSH Entry Point
# =============================================================================
# Single responsibility: delegate to init.zsh (all config lives there)
# Zinit bootstrap + annexes removed — init.zsh handles Zinit loading.

[[ -f "$HOME/.config/zsh/init.zsh" ]] && source "$HOME/.config/zsh/init.zsh"
