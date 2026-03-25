# =============================================================================
# Linux Specific Configuration
# =============================================================================

path_append "/snap/bin"

# Aliases
alias install="sudo apt install"
alias remove="sudo apt remove"
alias search="apt search"
alias show="apt show"
alias vscode="code ."
alias meminfo="free -h"
alias diskusage="df -h"

# Full system update
update() {
    sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean
}
