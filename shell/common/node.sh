# Install Node.js packages (Node.js is already installed via Homebrew/APT)
echo "Installing Node.js packages..."

# Install Yarn
echo "Installing Yarn"
npm install --global yarn

echo "Installing PNPM" 
npm install -g pnpm

echo "Node.js packages installation complete"