#!/bin/bash

# =============================================================================
# Rust Toolchain Setup (cross-platform)
# =============================================================================

# Ensure rustup is available
if ! command -v rustup &> /dev/null; then
    echo "Installing Rust via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    source "$HOME/.cargo/env"
fi

# Update Rust toolchain
echo "Updating Rust toolchain..."
rustup update stable

# Update all installed cargo packages
if command -v cargo-install-update &> /dev/null; then
    echo "Updating installed cargo packages..."
    cargo install-update -a
fi
