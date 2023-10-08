
# Update dependencies and install git and curl with apt
echo "Updating dependencies and installing git and curl"
apt update
apt install -y git curl
apt install -y build-essential
apt install -y libssl-dev

# Install fish and fisher in debian distro
echo "Installing fish and fisher"
apt install -y fish
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

# set fish as default shell
csh -s $(which fish)

#Install starship and nerd fonts
curl -fsSL https://starship.rs/install.sh | bash
#Install nerd font cascadia code
apt install -y fonts-cascadia-code

# Install rust
echo "Installing rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Verity rust installation
echo "Verifying rust installation"
rustc --version


# Install nvm and node js lts
echo "Installing nvm and node js lts"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
nvm install --lts

# Install golang with apt
apt install -y golang

# Install python and pip
apt install -y python3 python3-pip



# Install Ubuntu .NET packages 
declare repo_version=$(if command -v lsb_release &> /dev/null; then lsb_release -r -s; else grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"'; fi)
#
# Download Microsoft signing key and repository
wget https://packages.microsoft.com/config/ubuntu/$repo_version/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
#
# Install Microsoft signing key and repository
sudo dpkg -i packages-microsoft-prod.deb
#
# Clean up
rm packages-microsoft-prod.deb
#
# Update packages
sudo apt update
