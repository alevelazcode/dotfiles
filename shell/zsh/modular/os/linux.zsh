# =============================================================================
# Linux Specific Configuration
# =============================================================================


# -----------------------------------------------------------------------------
# PATH
# -----------------------------------------------------------------------------
path_prepend "$HOME/.local/bin"
path_append "/snap/bin"
path_append "/usr/local/go/bin"

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------
alias update="sudo apt update && sudo apt upgrade -y"
alias install="sudo apt install"
alias remove="sudo apt remove"
alias search="apt search"
alias show="apt show"
alias vscode="code ."

alias meminfo="free -h"
alias diskusage="df -h"

# -----------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------

# copy() is defined in modules/functions.zsh (cross-platform)

update-system() {
    sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean
}
