# =============================================================================
# Functions Configuration
# =============================================================================

# =============================================================================
# Navigation Functions
# =============================================================================

# Function to exit (equivalent to Fish's abbreviation)
function bd() { exit }

# Function to quit tmux
function q() { tmux kill-server }

# Function for awsume (AWS profile switcher)
function ast() { 
    aw set -t $(aw list | fzf-tmux -p --reverse --preview 'aw set -t {}') 
}

# =============================================================================
# Package Manager Functions
# =============================================================================

# pnpm functions
function pn() { pnpm "$@" }
function pni() { pnpm i "$@" }
function pnd() { pnpm dev "$@" }
function pbs() { pnpm serve "$@" }
function pnb() { pnpm build "$@" }

# npm functions
function ns() { npm run serve "$@" }

# =============================================================================
# Utility Functions
# =============================================================================

# Clear screen
function c() { clear }

# Make file executable
function cx() { chmod +x "$@" }

# =============================================================================
# Docker Functions
# =============================================================================

# Docker compose functions
function dc() { docker compose "$@" }
function dcd() { docker compose down "$@" }
function dcdv() { docker compose down -v "$@" }
function dcr() { docker compose restart "$@" }
function dcu() { docker compose up -d "$@" }

# =============================================================================
# Clipboard Functions
# =============================================================================

# Cross-platform copy function
copy() {
    local text="$*"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        printf "%s" "$text" | tr -d "\n" | pbcopy
    elif command -v clip.exe &> /dev/null; then
        # WSL2
        printf "%s" "$text" | tr -d "\n" | clip.exe
    elif command -v xclip &> /dev/null; then
        # Linux with xclip
        printf "%s" "$text" | tr -d "\n" | xclip -selection clipboard
    else
        echo "No clipboard tool found"
        return 1
    fi
}

# =============================================================================
# File and Directory Functions
# =============================================================================

# Create directory and navigate to it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# =============================================================================
# Git Functions
# =============================================================================

# Git commit with message
gc() {
    git commit -m "$1"
}

# Git checkout and pull
gcp() {
    git checkout "$1" && git pull
}

# Git status with more details
gst() {
    git status --porcelain
}

# =============================================================================
# Development Functions
# =============================================================================

# Create a new project directory with git
newproject() {
    local project_name="$1"
    if [[ -z "$project_name" ]]; then
        echo "Usage: newproject <project_name>"
        return 1
    fi
    
    mkdir "$project_name"
    cd "$project_name"
    git init
    echo "# $project_name" > README.md
    git add README.md
    git commit -m "Initial commit"
    echo "Project '$project_name' created and initialized with git"
}

# Quick server functions
serve-http() {
    local port="${1:-8000}"
    python3 -m http.server "$port"
}

serve-https() {
    local port="${1:-8443}"
    python3 -m http.server "$port" --bind 127.0.0.1
}

# =============================================================================
# System Functions
# =============================================================================

# Get public IP address
myip() {
    curl -s https://ipinfo.io/ip
}

# Get local IP address
localip() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'
    else
        ip addr show | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | cut -d/ -f1
    fi
}

# Kill process by port
killport() {
    local port="$1"
    if [[ -z "$port" ]]; then
        echo "Usage: killport <port_number>"
        return 1
    fi
    
    local pid=$(lsof -ti:"$port")
    if [[ -n "$pid" ]]; then
        echo "Killing process on port $port (PID: $pid)"
        kill -9 "$pid"
    else
        echo "No process found on port $port"
    fi
}

# =============================================================================
# Search Functions
# =============================================================================

# Search for files containing text
search-files() {
    local search_term="$1"
    local directory="${2:-.}"
    
    if [[ -z "$search_term" ]]; then
        echo "Usage: search-files <search_term> [directory]"
        return 1
    fi
    
    find "$directory" -type f -exec grep -l "$search_term" {} \;
}

# Search for files by name
find-file() {
    local filename="$1"
    local directory="${2:-.}"
    
    if [[ -z "$filename" ]]; then
        echo "Usage: find-file <filename> [directory]"
        return 1
    fi
    
    find "$directory" -name "*$filename*" -type f
}

# =============================================================================
# Network Functions
# =============================================================================

# Test internet connection
ping-test() {
    ping -c 3 8.8.8.8
}

# Test DNS resolution
dns-test() {
    nslookup google.com
}

# =============================================================================
# Backup Functions
# =============================================================================

# Backup a file with timestamp
backup() {
    local file="$1"
    if [[ -f "$file" ]]; then
        cp "$file" "$file.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Backup created: $file.backup.$(date +%Y%m%d_%H%M%S)"
    else
        echo "File '$file' not found"
    fi
}

# =============================================================================
# Weather Functions
# =============================================================================

# Get weather information
weather() {
    local city="${1:-$(curl -s https://ipinfo.io/city)}"
    curl -s "wttr.in/$city?format=3"
}

# =============================================================================
# Utility Functions
# =============================================================================

# Create a temporary directory and navigate to it
tempdir() {
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"
    echo "Created temporary directory: $temp_dir"
}

# Count lines of code in a directory
loc() {
    local directory="${1:-.}"
    find "$directory" -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" -o -name "*.java" -o -name "*.cpp" -o -name "*.c" -o -name "*.h" -o -name "*.go" -o -name "*.rs" | xargs wc -l | tail -1
} 