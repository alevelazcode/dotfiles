
# Set ZSH as default shell
echo "Setting ZSH as default shell"
echo $(which zsh) | sudo tee -a /etc/shells
chsh -s $(which zsh)

# Setup ZSH
chmod +x ~/dotfiles/macos/zsh.sh
source ~/dotfiles/macos/zsh.sh