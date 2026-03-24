# Install Node.js global packages (Node.js managed via FNM)
echo "Installing Node.js global packages..."

if ! command -v fnm &> /dev/null; then
    echo "FNM not found. Install it first via your platform setup script."
    return 0
fi

# Ensure FNM environment is loaded (--shell bash avoids zsh-only hooks
# like autoload/add-zsh-hook that fail when sourced from install.sh)
eval "$(fnm env --shell bash)"

# Install Yarn and PNPM
npm install -g yarn pnpm

echo "Node.js packages installation complete"
