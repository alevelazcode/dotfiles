# =============================================================================
# Linux Specific Configuration
# =============================================================================

path_append "/snap/bin"

alias vscode="code ."
alias meminfo="free -h"
alias diskusage="df -h"

# Package manager aliases (detect distro family)
if (( $+commands[paru] )); then
    alias install="paru -S"
    alias remove="paru -Rns"
    alias search="paru -Ss"
    alias show="paru -Si"
    update() { paru -Syu }
elif (( $+commands[pacman] )); then
    alias install="sudo pacman -S"
    alias remove="sudo pacman -Rns"
    alias search="pacman -Ss"
    alias show="pacman -Si"
    update() { sudo pacman -Syu }
elif (( $+commands[apt] )); then
    alias install="sudo apt install"
    alias remove="sudo apt remove"
    alias search="apt search"
    alias show="apt show"
    update() { sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean }
fi
