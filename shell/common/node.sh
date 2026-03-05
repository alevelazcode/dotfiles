# Install Node.js global packages (Node.js managed via FNM)
echo "Installing Node.js global packages..."

if ! command -v fnm &> /dev/null; then
    echo "FNM not found. Install it first via your platform setup script."
    exit 0
fi

# Ensure FNM environment is loaded
eval "$(fnm env --use-on-cd)"

# Install Yarn and PNPM
npm install -g yarn pnpm

echo "Node.js packages installation complete"
