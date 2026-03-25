# =============================================================================
# Shell Functions
# =============================================================================

q() { tmux kill-server }
cx() { chmod +x "$@" }

# Cross-platform copy (supports args and piped input)
copy() {
    local _clip
    if [[ "$OSTYPE" == darwin* ]]; then
        _clip="pbcopy"
    elif (( $+commands[clip.exe] )); then
        _clip="clip.exe"
    elif (( $+commands[wl-copy] )); then
        _clip="wl-copy"
    elif (( $+commands[xclip] )); then
        _clip="xclip -selection clipboard"
    else
        echo "No clipboard tool available"; return 1
    fi

    if [[ -n "${1:-}" ]]; then
        printf '%s' "$*" | ${=_clip}
    elif [[ ! -t 0 ]]; then
        ${=_clip}
    else
        echo "Usage: copy <text>  or  <command> | copy"; return 1
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
    rm -f "$ZSH_CACHE_DIR"/*.zsh "${ZDOTDIR:-$HOME}"/.zcompdump* 2>/dev/null
    echo "ZSH caches cleared (fnm, starship, zoxide, completions). Will regenerate on next startup."
}

zsh-update() {
    echo "🔄 Updating Zinit and plugins..."
    zinit self-update && zinit update --all
    echo "✅ All Zinit plugins updated!"
}

dev-update() {
    if [[ "$OSTYPE" == darwin* ]]; then
        brew update && brew upgrade && brew cleanup
    elif (( $+commands[paru] )); then
        paru -Syu
    elif (( $+commands[pacman] )); then
        sudo pacman -Syu
    elif (( $+commands[apt] )); then
        sudo apt update && sudo apt upgrade -y
    fi
    (( $+commands[rustup] )) && rustup update
    zsh-update
}
