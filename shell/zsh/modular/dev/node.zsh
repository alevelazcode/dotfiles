# =============================================================================
# Node.js Development Configuration
# =============================================================================

# =============================================================================
# Node Version Manager (NVM)
# =============================================================================

# Set up NVM if available
if [[ -d "$HOME/.nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"
    
    # Load NVM
    if [[ -f "$NVM_DIR/nvm.sh" ]]; then
        source "$NVM_DIR/nvm.sh"
    elif [[ -f "$(brew --prefix nvm)/nvm.sh" ]] 2>/dev/null; then
        source "$(brew --prefix nvm)/nvm.sh"
    fi
    
    # Load NVM bash completion
    if [[ -f "$NVM_DIR/bash_completion" ]]; then
        source "$NVM_DIR/bash_completion"
    fi
fi

# =============================================================================
# Node.js Environment Variables
# =============================================================================

# Node.js configuration
# export NODE_ENV="development"
export NODE_OPTIONS="--max-old-space-size=4096"

# npm configuration
# export npm_config_prefix="$HOME/.npm-global"
# export npm_config_cache="$HOME/.npm-cache"

# pnpm configuration
export PNPM_HOME="$HOME/.local/share/pnpm"
path_append "$PNPM_HOME"

# =============================================================================
# Node.js Aliases
# =============================================================================

# Node.js version management
alias node-ls="nvm list"
alias node-use="nvm use"
alias node-install="nvm install"

# Package manager aliases
alias pn="pnpm"
alias pni="pnpm install"
alias pnd="pnpm dev"
alias pnb="pnpm build"

# npm shortcuts
alias nid="npm install --save-dev"
alias nig="npm install --global"
alias nrs="npm run start"
alias nrd="npm run dev"
alias nrb="npm run build"

# =============================================================================
# Node.js Functions
# =============================================================================

# Function to switch Node.js version
node-switch() {
    local version="$1"
    if [[ -z "$version" ]]; then
        echo "Usage: node-switch <version>"
        echo "Available versions:"
        nvm list
        return 1
    fi
    
    nvm use "$version"
}

# Function to create a new Node.js project
create-node-project() {
    local project_name="$1"
    local package_manager="${2:-npm}"
    
    if [[ -z "$project_name" ]]; then
        echo "Usage: create-node-project <project_name> [package_manager]"
        echo "Package managers: npm, pnpm, yarn"
        return 1
    fi
    
    mkdir "$project_name"
    cd "$project_name"
    
    case "$package_manager" in
        npm)
            npm init -y
            ;;
        pnpm)
            pnpm init
            ;;
        yarn)
            yarn init -y
            ;;
        *)
            echo "Unknown package manager: $package_manager"
            return 1
            ;;
    esac
    
    echo "Node.js project '$project_name' created with $package_manager!"
}

# Function to check Node.js environment
check-node-env() {
    echo "=== Node.js Environment Check ==="
    
    if command -v node &> /dev/null; then
        echo "✅ Node.js: $(node --version)"
    else
        echo "❌ Node.js is not installed"
    fi
    
    if command -v npm &> /dev/null; then
        echo "✅ npm: $(npm --version)"
    else
        echo "❌ npm is not installed"
    fi
    
    if command -v pnpm &> /dev/null; then
        echo "✅ pnpm: $(pnpm --version)"
    else
        echo "ℹ️  pnpm is not installed"
    fi
    
    if [[ -d "$NVM_DIR" ]]; then
        echo "✅ NVM: $(nvm current)"
    else
        echo "❌ NVM is not installed"
    fi
    
    if [[ -f "package.json" ]]; then
        echo "✅ In a Node.js project"
    else
        echo "ℹ️  Not in a Node.js project"
    fi
}

# =============================================================================
# Bun Support (if available)
# =============================================================================

if command -v bun &> /dev/null; then
    export BUN_INSTALL="$HOME/.bun"
    path_append "$BUN_INSTALL/bin"
    
    # Load bun completions
    if [[ -s "$HOME/.bun/_bun" ]]; then
        source "$HOME/.bun/_bun"
    fi
fi 
