# =============================================================================
# PATH Configuration
# =============================================================================
# Cross-platform PATH management for macOS and WSL

# =============================================================================
# PATH Management Functions
# =============================================================================

# Function to add path to PATH without duplicates
path_append() {
    local path_to_add="$1"
    if [[ -n "$path_to_add" && -d "$path_to_add" ]]; then
        if [[ ":$PATH:" != *":$path_to_add:"* ]]; then
            export PATH="$PATH:$path_to_add"
        fi
    fi
}

# Function to add path to beginning of PATH without duplicates
path_prepend() {
    local path_to_add="$1"
    if [[ -n "$path_to_add" && -d "$path_to_add" ]]; then
        if [[ ":$PATH:" != *":$path_to_add:"* ]]; then
            export PATH="$path_to_add:$PATH"
        fi
    fi
}

# =============================================================================
# Base PATH Configuration
# =============================================================================

# Standard user directories
path_prepend "$HOME/bin"
path_prepend "$HOME/.local/bin"

# =============================================================================
# Development Tools PATH
# =============================================================================

# Rust/Cargo
if [[ -d "$HOME/.cargo/bin" ]]; then
    path_append "$HOME/.cargo/bin"
fi

# Node.js (NVM)
if [[ -d "$HOME/.nvm" ]]; then
    path_append "$HOME/.nvm"
fi

# Python (pip user installs)
if [[ -d "$HOME/.local/bin" ]]; then
    path_append "$HOME/.local/bin"
fi

# Go
if [[ -d "$HOME/go/bin" ]]; then
    path_append "$HOME/go/bin"
fi

# Bun
if [[ -d "$HOME/.bun/bin" ]]; then
    path_append "$HOME/.bun/bin"
fi

# pnpm
if [[ -d "$HOME/.local/share/pnpm" ]]; then
    path_append "$HOME/.local/share/pnpm"
fi

# =============================================================================
# OS-Specific PATH (handled in OS modules)
# =============================================================================
# macOS and WSL specific paths are handled in their respective OS modules
# to avoid conflicts and ensure proper detection 