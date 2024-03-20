#Install Brew in MacOs

# Install Brew
# Verify if Brew exist
if which brew &> /dev/null; then
    echo "brew is installed"
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Create link to Brewfile in home directory force if exist
ln -sf ~/dotfiles/macos/Brewfile ~/Brewfile

# Update Brew
echo "Updating Brew"
brew update
brew upgrade

# Install all the packages from Brewfile
brew bundle --file=~/Brewfile

chmod +x ./macos/shell.sh
./shell.sh

# Linking files
chmod ~/dotfiles/unix/setup.sh
source ~/dotfiles/unix/setup.sh


# Rust packages
chmod +x ~/dotfiles/common/rust.sh
source ~/dotfiles/common/rust.sh

# Node packages
chmod +x ~/dotfiles/common/node.sh
source ~/dotfiles/common/node.sh

chmod +x ~/dotfiles/macos/conda.sh
source ~/dotfiles/macos/conda.sh

