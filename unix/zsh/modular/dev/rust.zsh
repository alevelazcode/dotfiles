# =============================================================================
# Rust Development Configuration
# =============================================================================

# =============================================================================
# Rust Environment Variables
# =============================================================================

# Rust configuration
export RUST_BACKTRACE=1
export RUST_LOG="info"

# Cargo configuration
export CARGO_HOME="$HOME/.cargo"
export CARGO_TARGET_DIR="$HOME/.cargo/target"

# Add Cargo binaries to PATH
path_append "$HOME/.cargo/bin"

# =============================================================================
# Rust Tool Aliases (if tools are installed)
# =============================================================================

# Enhanced file viewing and searching (only if tools are available)
if command -v bat &> /dev/null; then
    alias cat="bat --style=plain"
fi

if command -v eza &> /dev/null; then
    alias ls='eza --icons -F -H --group-directories-first --git -1 -a'
    alias ll='eza --icons -F -H --group-directories-first --git -la'
    alias la='eza --icons -F -H --group-directories-first --git -a'
    alias tree='eza --tree'
fi

if command -v bottom &> /dev/null; then
    alias htop='bottom'
fi

if command -v ripgrep &> /dev/null; then
    alias rg='ripgrep'
fi

if command -v fd &> /dev/null; then
    alias find='fd'
fi

# =============================================================================
# Rust Aliases
# =============================================================================

# Cargo aliases
alias cg="cargo"
alias cgb="cargo build"
alias cgr="cargo run"
alias cgt="cargo test"
alias cgc="cargo check"
alias cgf="cargo fmt"
alias cgcl="cargo clean"

# Rust toolchain aliases
alias rustup-update="rustup update"

# =============================================================================
# Rust Functions
# =============================================================================

# Function to create new Rust project
create-rust-project() {
    local project_name="$1"
    local project_type="${2:-bin}"
    
    if [[ -z "$project_name" ]]; then
        echo "Usage: create-rust-project <project_name> [project_type]"
        echo "Project types: bin, lib"
        return 1
    fi
    
    case "$project_type" in
        bin)
            cargo new "$project_name"
            ;;
        lib)
            cargo new --lib "$project_name"
            ;;
        *)
            echo "Unknown project type: $project_type"
            return 1
            ;;
    esac
    
    echo "Rust $project_type project '$project_name' created!"
}

# Function to update all global cargo packages
update-cargo-globals() {
    echo "Updating global cargo packages..."
    cargo install --list | awk '{print $1}' | xargs -n 1 cargo install --force
    cargo clean
    echo "Global cargo packages updated!"
}

# Function to install essential Rust tools
install-rust-tools() {
    echo "Installing essential Rust tools..."
    cargo install bat eza bottom ripgrep fd-find zoxide starship
    echo "Essential Rust tools installed!"
}

# Function to check Rust environment
check-rust-env() {
    echo "=== Rust Environment Check ==="
    
    if command -v rustc &> /dev/null; then
        echo "✅ rustc: $(rustc --version)"
    else
        echo "❌ rustc is not installed"
    fi
    
    if command -v cargo &> /dev/null; then
        echo "✅ cargo: $(cargo --version)"
    else
        echo "❌ cargo is not installed"
    fi
    
    if command -v rustup &> /dev/null; then
        echo "✅ rustup: $(rustup --version)"
    else
        echo "❌ rustup is not installed"
    fi
    
    if [[ -f "Cargo.toml" ]]; then
        echo "✅ In a Rust project"
    else
        echo "ℹ️  Not in a Rust project"
    fi
    
    echo ""
    echo "=== Rust Tools Check ==="
    local tools=("bat" "eza" "bottom" "ripgrep" "fd" "zoxide" "starship")
    for tool in "${tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            echo "✅ $tool is installed"
        else
            echo "❌ $tool is not installed"
        fi
    done
} 