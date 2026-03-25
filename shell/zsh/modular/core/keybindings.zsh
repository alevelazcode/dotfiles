# =============================================================================
# Key Bindings Configuration
# =============================================================================

# Emacs-style line editing (on top of vi mode set in init.zsh)
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^K' kill-line
bindkey '^U' backward-kill-line
bindkey '^W' backward-kill-word
bindkey '^Y' yank
bindkey '^L' clear-screen

# History navigation
bindkey '^[[A' history-beginning-search-backward
bindkey '^[OA' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey '^[OB' history-beginning-search-forward
bindkey '^R' history-incremental-search-backward

# Word navigation (Alt+arrows and Ctrl+arrows)
bindkey '^[b' backward-word
bindkey '^[[1;3D' backward-word
bindkey '^[f' forward-word
bindkey '^[[1;3C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# Completion
bindkey '^I' menu-complete
bindkey '^[[Z' reverse-menu-complete

# Edit command in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Copy current command to clipboard (copy() from deferred functions.zsh)
function copy-command() {
    copy "$BUFFER" 2>/dev/null
    zle -M "Command copied to clipboard"
}
zle -N copy-command
bindkey '^X^C' copy-command

# Clear screen + list directory
function clear-and-ls() {
    clear
    ll 2>/dev/null || ls -la
    zle reset-prompt
}
zle -N clear-and-ls
bindkey '^X^L' clear-and-ls

# Terminal-specific sequences (Home/End/Delete vary by terminal)
case "$TERM" in
    xterm*|rxvt*|alacritty*|kitty*)
        bindkey '^[[H' beginning-of-line
        bindkey '^[[F' end-of-line
        bindkey '^[[3~' delete-char
        ;;
    screen*|tmux*)
        bindkey '^[[1~' beginning-of-line
        bindkey '^[[4~' end-of-line
        bindkey '^[[3~' delete-char
        ;;
esac
