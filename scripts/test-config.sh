#!/bin/bash

# =============================================================================
# ZSH Configuration Test Script
# =============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

print_status "Testing ZSH configuration..."

# Test if .zshrc exists
if [[ -f "$HOME/.zshrc" ]]; then
    print_success ".zshrc exists"
else
    print_error ".zshrc not found"
    exit 1
fi

# Test if zsh config directory exists
if [[ -d "$HOME/.config/zsh" ]]; then
    print_success "ZSH config directory exists"
else
    print_error "ZSH config directory not found"
    exit 1
fi

# Test core files
core_files=("env.zsh" "path.zsh" "options.zsh" "keybindings.zsh")
for file in "${core_files[@]}"; do
    if [[ -f "$HOME/.config/zsh/core/$file" ]]; then
        print_success "Core file $file exists"
    else
        print_error "Core file $file not found"
    fi
done

# Test OS detection
if [[ -f "$HOME/.config/zsh/os/macos.zsh" ]] || \
   [[ -f "$HOME/.config/zsh/os/linux.zsh" ]] || \
   [[ -f "$HOME/.config/zsh/os/wsl.zsh" ]]; then
    print_success "OS-specific configuration exists"
else
    print_error "No OS-specific configuration found"
fi

# Test modules
module_files=("aliases.zsh" "functions.zsh" "plugins.zsh" "completion.zsh" "prompt.zsh")
for file in "${module_files[@]}"; do
    if [[ -f "$HOME/.config/zsh/modules/$file" ]]; then
        print_success "Module file $file exists"
    else
        print_error "Module file $file not found"
    fi
done

# Test dev tools
dev_files=("node.zsh" "python.zsh" "rust.zsh" "docker.zsh")
for file in "${dev_files[@]}"; do
    if [[ -f "$HOME/.config/zsh/dev/$file" ]]; then
        print_success "Dev file $file exists"
    else
        print_error "Dev file $file not found"
    fi
done

# Test if zsh can load the configuration
print_status "Testing ZSH configuration loading..."

# Create a temporary test script
cat > /tmp/test_zsh_config.zsh << 'EOF'
# Test zsh configuration loading
set -e

# Source the main .zshrc
source ~/.zshrc

# Test if basic functionality works
echo "Testing basic functionality..."

# Test if PATH is set
if [[ -n "$PATH" ]]; then
    echo "✅ PATH is set"
else
    echo "❌ PATH is not set"
    exit 1
fi

# Test if EDITOR is set
if [[ -n "$EDITOR" ]]; then
    echo "✅ EDITOR is set to: $EDITOR"
else
    echo "❌ EDITOR is not set"
fi

# Test if basic commands work
if command -v ls &> /dev/null; then
    echo "✅ ls command available"
else
    echo "❌ ls command not available"
fi

echo "✅ ZSH configuration test completed successfully"
EOF

# Run the test
if zsh /tmp/test_zsh_config.zsh; then
    print_success "ZSH configuration loads successfully"
else
    print_error "ZSH configuration has errors"
    exit 1
fi

# Clean up
rm -f /tmp/test_zsh_config.zsh

print_success "All tests completed successfully!"
print_status "Your ZSH configuration is working correctly." 