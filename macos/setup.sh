#Install Brew in MacOs

# Install Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Update Brew
echo "Updating Brew"
brew update
brew upgrade

brew tap Homebrew/bundle

#
# Install from Brewfile
echo "Installing from Brewfile"
brew bundle --file=~/dotfiles/macos/Brewfile

# Set fish as default shell
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)

#
# Install fish plugins with fisher 
echo "Installing fish plugins with fisher"
fish -c "fisher update"
# NVM plugin to fish
fish -c "fisher add jorgebucaran/nvm.fish"
# FZF plugin to fish
fish -c "fisher add jethrokuan/fzf"




# Linked files config
echo "Linking files"
ln -s ~/dotfiles/fish/* ~/.config/fish/

ln -s  ../common/neofetch ~/.config
ln -s ../common/startship/starship.toml ~/.config

ln -s ../unix/zsh/.zshrc ~/.zshrc



# Install last version Node JS with NVM
echo "Installing Node JS LTS with NVM"
nvm install --lts

# Install Yarn
echo "Installing Yarn"
npm install --global yarn

echo "Installing PNPM" 
npm install -g pnpm


# If rust is not installed, install it

# Install rustup
echo "<--- Installing rustup ---> "	
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# Check rust version
rustup --version




# Install miniconda3
mkdir -p ~/miniconda3
curl https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh -o ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh

