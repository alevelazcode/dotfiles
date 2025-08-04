#!/bin/bash

# =============================================================================
# ZSH Setup Script with Oh My Zsh and Essential Plugins
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to install ZSH if not already installed
install_zsh() {
    if command -v zsh &> /dev/null; then
        print_success "ZSH is already installed"
        return 0
    fi
    
    print_status "Installing ZSH..."
    
    if command -v brew &> /dev/null; then
        # macOS with Homebrew
        brew install zsh
    elif command -v dnf &> /dev/null; then
        # Fedora/RHEL
        sudo dnf install -y zsh
    elif command -v apt &> /dev/null; then
        # Ubuntu/Debian
        sudo apt update
        sudo apt install -y zsh
    elif command -v pacman &> /dev/null; then
        # Arch Linux
        sudo pacman -S --noconfirm zsh
    elif command -v zypper &> /dev/null; then
        # openSUSE
        sudo zypper install -y zsh
    else
        print_error "Package manager not supported. Please install ZSH manually."
        return 1
    fi
    
    print_success "ZSH installed successfully"
}

# Function to set ZSH as default shell
set_default_shell() {
    local current_shell=$(echo $SHELL)
    local zsh_path=$(which zsh)
    
    if [[ "$current_shell" == "$zsh_path" ]]; then
        print_success "ZSH is already the default shell"
        return 0
    fi
    
    print_status "Setting ZSH as default shell..."
    
    # Add zsh to /etc/shells if not present
    if ! grep -q "$zsh_path" /etc/shells; then
        print_status "Adding ZSH to /etc/shells..."
        echo "$zsh_path" | sudo tee -a /etc/shells > /dev/null
    fi
    
    # Change default shell
    if command -v chsh &> /dev/null; then
        chsh -s "$zsh_path"
        print_success "Default shell changed to ZSH"
        print_warning "Please restart your terminal or log out and back in for changes to take effect"
    else
        print_warning "chsh command not found. Please set ZSH as default shell manually"
        print_status "Run: chsh -s $zsh_path"
    fi
}

# Function to install Oh My Zsh
install_oh_my_zsh() {
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        print_success "Oh My Zsh is already installed"
        return 0
    fi
    
    print_status "Installing Oh My Zsh..."
    
    # Download and install Oh My Zsh
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || {
        print_error "Failed to install Oh My Zsh"
        return 1
    }
    
    print_success "Oh My Zsh installed successfully"
}

# Function to install essential ZSH plugins
install_essential_plugins() {
    local oh_my_zsh_dir="$HOME/.oh-my-zsh"
    local custom_plugins_dir="$oh_my_zsh_dir/custom/plugins"
    
    if [[ ! -d "$oh_my_zsh_dir" ]]; then
        print_error "Oh My Zsh not found. Please install it first."
        return 1
    fi
    
    print_status "Installing essential ZSH plugins..."
    
    # Create custom plugins directory
    mkdir -p "$custom_plugins_dir"
    
    # Install zsh-autosuggestions
    if [[ ! -d "$custom_plugins_dir/zsh-autosuggestions" ]]; then
        print_status "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$custom_plugins_dir/zsh-autosuggestions"
        print_success "zsh-autosuggestions installed"
    else
        print_success "zsh-autosuggestions already installed"
    fi
    
    # Install zsh-syntax-highlighting
    if [[ ! -d "$custom_plugins_dir/zsh-syntax-highlighting" ]]; then
        print_status "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$custom_plugins_dir/zsh-syntax-highlighting"
        print_success "zsh-syntax-highlighting installed"
    else
        print_success "zsh-syntax-highlighting already installed"
    fi
    
    # Install zsh-completions
    if [[ ! -d "$custom_plugins_dir/zsh-completions" ]]; then
        print_status "Installing zsh-completions..."
        git clone https://github.com/zsh-users/zsh-completions "$custom_plugins_dir/zsh-completions"
        print_success "zsh-completions installed"
    else
        print_success "zsh-completions already installed"
    fi
    
    # Install zsh-history-substring-search
    if [[ ! -d "$custom_plugins_dir/zsh-history-substring-search" ]]; then
        print_status "Installing zsh-history-substring-search..."
        git clone https://github.com/zsh-users/zsh-history-substring-search "$custom_plugins_dir/zsh-history-substring-search"
        print_success "zsh-history-substring-search installed"
    else
        print_success "zsh-history-substring-search already installed"
    fi
    
    # Install fast-syntax-highlighting (alternative to zsh-syntax-highlighting)
    if [[ ! -d "$custom_plugins_dir/fast-syntax-highlighting" ]]; then
        print_status "Installing fast-syntax-highlighting..."
        git clone https://github.com/zdharma-continuum/fast-syntax-highlighting "$custom_plugins_dir/fast-syntax-highlighting"
        print_success "fast-syntax-highlighting installed"
    else
        print_success "fast-syntax-highlighting already installed"
    fi
    
    # Install you-should-use
    if [[ ! -d "$custom_plugins_dir/you-should-use" ]]; then
        print_status "Installing you-should-use..."
        git clone https://github.com/MichaelAquilina/zsh-you-should-use "$custom_plugins_dir/you-should-use"
        print_success "you-should-use installed"
    else
        print_success "you-should-use already installed"
    fi
    
    print_success "Essential ZSH plugins installed"
}

# Function to create optimized .zshrc
create_zshrc() {
    local zshrc_path="$HOME/.zshrc"
    local backup_path="$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Backup existing .zshrc
    if [[ -f "$zshrc_path" ]]; then
        print_status "Backing up existing .zshrc to $backup_path"
        cp "$zshrc_path" "$backup_path"
    fi
    
    print_status "Creating optimized .zshrc..."
    
    cat > "$zshrc_path" << 'EOF'
# =============================================================================
# Oh My Zsh Configuration with Essential Plugins
# =============================================================================

# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme configuration
ZSH_THEME="robbyrussell"  # Simple and fast theme

# Update behavior
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# History settings
HIST_STAMPS="yyyy-mm-dd"

# Standard plugins (these come with Oh My Zsh)
plugins=(
    git
    docker
    docker-compose
    npm
    node
    python
    pip
    rust
    cargo
    golang
    kubectl
    helm
    terraform
    aws
    gcp
    azure
    systemd
    ssh-agent
    gpg-agent
    colored-man-pages
    command-not-found
    extract
    sudo
    web-search
    z
    history
    copypath
    copyfile
    copybuffer
    dirhistory
    jsontools
    urltools
    # Custom plugins (installed separately)
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    zsh-history-substring-search
    fast-syntax-highlighting
    you-should-use
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# =============================================================================
# User Configuration
# =============================================================================

# Environment variables
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export BROWSER='open'

# Language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Compilation flags
export ARCHFLAGS="-arch $(uname -m)"

# =============================================================================
# Custom Aliases
# =============================================================================

# Enhanced ls with modern tools
if command -v eza &> /dev/null; then
    alias ls='eza --color=auto --group-directories-first'
    alias ll='eza -l --color=auto --group-directories-first'
    alias la='eza -la --color=auto --group-directories-first'
    alias lt='eza --tree --color=auto'
else
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
fi

# Enhanced cat with bat
if command -v bat &> /dev/null; then
    alias cat='bat'
    alias catp='bat --style=plain'
fi

# Enhanced find with fd
if command -v fd &> /dev/null; then
    alias find='fd'
fi

# Enhanced grep with ripgrep
if command -v rg &> /dev/null; then
    alias grep='rg'
fi

# Enhanced du with dust
if command -v dust &> /dev/null; then
    alias du='dust'
fi

# Enhanced ps with procs
if command -v procs &> /dev/null; then
    alias ps='procs'
fi

# Git aliases (enhanced)
alias gst='git status'
alias gco='git checkout'
alias gaa='git add .'
alias gcm='git commit -m'
alias gps='git push'
alias gpl='git pull'
alias glg='git log --graph --oneline --decorate'

# System aliases
alias reload='source ~/.zshrc'
alias zshconfig='$EDITOR ~/.zshrc'
alias ohmyzsh='$EDITOR ~/.oh-my-zsh'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Network
alias myip='curl -s ifconfig.me'
alias localip='ipconfig getifaddr en0'

# =============================================================================
# Custom Functions
# =============================================================================

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# =============================================================================
# Tool Initialization
# =============================================================================

# Initialize Starship prompt (if available and preferred over Oh My Zsh theme)
# if command -v starship &> /dev/null; then
#     eval "$(starship init zsh)"
# fi

# Initialize zoxide (smart cd)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# Initialize fzf
if command -v fzf &> /dev/null; then
    # Key bindings
    source <(fzf --zsh) 2>/dev/null || true
fi

# Initialize direnv (if available)
if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# =============================================================================
# Performance Optimizations
# =============================================================================

# Lazy load nvm (if installed)
if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
    # Lazy load nvm
    export NVM_DIR="$HOME/.nvm"
    nvm() {
        unset -f nvm
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        nvm "$@"
    }
fi

# Lazy load rbenv (if installed)
if command -v rbenv &> /dev/null; then
    eval "$(rbenv init - zsh)"
fi

# Lazy load pyenv (if installed)
if command -v pyenv &> /dev/null; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

# =============================================================================
# Local Configuration
# =============================================================================

# Load local configuration if it exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Welcome message
echo "🚀 ZSH with Oh My Zsh loaded successfully!"
EOF

    print_success "Optimized .zshrc created"
}

# Function to update plugins in .zshrc
update_zshrc_plugins() {
    local zshrc_path="$HOME/.zshrc"
    
    if [[ ! -f "$zshrc_path" ]]; then
        print_warning ".zshrc not found. Creating new one..."
        create_zshrc
        return 0
    fi
    
    print_status "Updating plugin list in .zshrc..."
    
    # This function would update an existing .zshrc with the correct plugin list
    # For now, we'll just recommend recreating the .zshrc
    print_warning "Please run create_zshrc to get the latest plugin configuration"
}

# Main function
setup_zsh() {
    print_status "Starting comprehensive ZSH setup..."
    
    # Install ZSH
    install_zsh
    
    # Set as default shell
    set_default_shell
    
    # Install Oh My Zsh
    install_oh_my_zsh
    
    # Install essential plugins
    install_essential_plugins
    
    # Create optimized .zshrc
    create_zshrc
    
    print_success "ZSH setup complete!"
    print_status "Please restart your terminal for all changes to take effect"
    print_status "Available commands:"
    echo "  - reload: Reload ZSH configuration"
    echo "  - zshconfig: Edit ZSH configuration"
    echo "  - ohmyzsh: Edit Oh My Zsh"
}

# Run setup if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_zsh "$@"
fi