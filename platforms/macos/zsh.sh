
# Set ZSH as default shell
echo "Setting ZSH as default shell"
echo $(which zsh) | sudo tee -a /etc/shells
chsh -s $(which zsh)

# Install Oh My Zsh if it's not installed
if [ ! -d ~/.oh-my-zsh ]; then
    echo "Installing Oh My Zsh"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install Plugins

# ZSH Autosuggestions
if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
    echo "Installing ZSH Autosuggestions"
    git clone
    mv zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

# ZSH Syntax Highlighting
if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
    echo "Installing ZSH Syntax Highlighting"
    git clone
    mv zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

# Link zsh files to home directory
ln -sf  ~/dotfiles/unix/zsh/.zshrc ~/.zshrc

source ~/.zshrc


