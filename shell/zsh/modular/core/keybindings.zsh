# =============================================================================
# Key Bindings Configuration
# =============================================================================

# =============================================================================
# Emacs-like Key Bindings
# =============================================================================

# Ctrl+A - Beginning of line
bindkey '^A' beginning-of-line

# Ctrl+E - End of line
bindkey '^E' end-of-line

# Ctrl+K - Kill from cursor to end of line
bindkey '^K' kill-line

# Ctrl+U - Kill from cursor to beginning of line
bindkey '^U' backward-kill-line

# Ctrl+W - Kill word backward
bindkey '^W' backward-kill-word

# Ctrl+Y - Yank (paste)
bindkey '^Y' yank

# Ctrl+L - Clear screen
bindkey '^L' clear-screen

# =============================================================================
# History Navigation
# =============================================================================

# Up arrow - Search history backward
bindkey '^[[A' history-beginning-search-backward
bindkey '^[OA' history-beginning-search-backward

# Down arrow - Search history forward
bindkey '^[[B' history-beginning-search-forward
bindkey '^[OB' history-beginning-search-forward

# Ctrl+R - Search history
bindkey '^R' history-incremental-search-backward

# =============================================================================
# Word Navigation
# =============================================================================

# Alt+Left - Previous word
bindkey '^[b' backward-word
bindkey '^[[1;3D' backward-word

# Alt+Right - Next word
bindkey '^[f' forward-word
bindkey '^[[1;3C' forward-word

# Ctrl+Left - Beginning of word
bindkey '^[[1;5D' beginning-of-line

# Ctrl+Right - End of word
bindkey '^[[1;5C' end-of-line

# =============================================================================
# Completion
# =============================================================================

# Tab - Menu completion
bindkey '^I' menu-complete

# Shift+Tab - Reverse menu completion
bindkey '^[[Z' reverse-menu-complete

# =============================================================================
# Custom Functions
# =============================================================================

# Function to edit command line in editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Function to expand aliases
function expand-alias() {
    zle _expand_alias
    zle self-insert
}
zle -N expand-alias
bindkey '^X^A' expand-alias

# =============================================================================
# FZF Integration
# =============================================================================

# Ctrl+T - FZF file finder (only if fzf is available)
if command -v fzf &> /dev/null; then
    bindkey '^T' fzf-file-widget
fi

# =============================================================================
# Custom Key Bindings
# =============================================================================

# Function to copy current command to clipboard
function copy-command() {
    echo -n "$BUFFER" | pbcopy 2>/dev/null || echo -n "$BUFFER" | xclip -selection clipboard 2>/dev/null || echo -n "$BUFFER" | clip.exe 2>/dev/null
    zle -M "Command copied to clipboard"
}
zle -N copy-command
bindkey '^X^C' copy-command

# Function to clear screen and show current directory
function clear-and-ls() {
    clear
    ls -la
    zle reset-prompt
}
zle -N clear-and-ls
bindkey '^X^L' clear-and-ls

# =============================================================================
# Terminal-specific Key Bindings
# =============================================================================

# Handle different terminal types
case "$TERM" in
    xterm*|rxvt*|alacritty*|kitty*)
        # Standard xterm sequences
        bindkey '^[[H' beginning-of-line
        bindkey '^[[F' end-of-line
        bindkey '^[[3~' delete-char
        bindkey '^[[1;5C' forward-word
        bindkey '^[[1;5D' backward-word
        ;;
    screen*|tmux*)
        # Screen/tmux sequences
        bindkey '^[[1~' beginning-of-line
        bindkey '^[[4~' end-of-line
        bindkey '^[[3~' delete-char
        ;;
esac 