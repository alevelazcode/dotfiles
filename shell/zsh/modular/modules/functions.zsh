# =============================================================================
# Shell Functions
# =============================================================================

q() { tmux kill-server }
cx() { chmod +x "$@" }

# Cross-platform copy
copy() {
    if [[ "$OSTYPE" == darwin* ]]; then
        printf "%s" "$*" | tr -d "\n" | pbcopy
    elif (( $+commands[clip.exe] )); then
        printf "%s" "$*" | tr -d "\n" | clip.exe
    elif (( $+commands[xclip] )); then
        printf "%s" "$*" | tr -d "\n" | xclip -selection clipboard
    fi
}

mkcd() { mkdir -p "$1" && cd "$1" }

extract() {
    [[ ! -f "$1" ]] && { echo "'$1' is not a valid file"; return 1; }
    case "$1" in
        *.tar.bz2|*.tbz2) tar xjf "$1" ;;
        *.tar.gz|*.tgz)   tar xzf "$1" ;;
        *.tar)             tar xf "$1"  ;;
        *.bz2)     bunzip2 "$1"    ;;
        *.gz)      gunzip "$1"     ;;
        *.zip)     unzip "$1"      ;;
        *.7z)      7z x "$1"       ;;
        *.rar)     unrar e "$1"    ;;
        *)         echo "'$1' cannot be extracted" ;;
    esac
}

gc() { git commit -m "$1" }
gcp() { git checkout "$1" && git pull }

myip() { curl -s https://ipinfo.io/ip }
killport() {
    [[ -z "$1" ]] && { echo "Usage: killport <port>"; return 1; }
    local pid=$(lsof -ti:"$1")
    [[ -n "$pid" ]] && kill -9 "$pid" && echo "Killed PID $pid on port $1" || echo "No process on port $1"
}

timezsh() {
    echo "ZSH startup benchmark (5 runs):"
    for i in 1 2 3 4 5; do time (zsh -i -c exit); done
}

zsh-clear-cache() {
    local d="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
    rm -f "$d"/*.zsh "$d"/evalcache_*.zsh "${ZDOTDIR:-$HOME}"/.zcompdump* 2>/dev/null
    echo "ZSH caches cleared. Will regenerate on next startup."
}

# -----------------------------------------------------------------------------
# Zinit maintenance
# -----------------------------------------------------------------------------
zsh-update() {
    echo "🔄 Updating Zinit and plugins..."
    zinit self-update && zinit update --all
    echo "✅ All Zinit plugins updated!"
}

dev-update() {
    echo "🛠️ Updating system tools..."
    brewski
    rustup update
    starship upgrade
    zsh-update
    echo "🎉 Everything's fresh and clean!"
}
