# Quick Setup Instructions

## 🚀 One-Command Installation

```bash
# 1. Navigate to the modular directory
cd unix/zsh/modular

# 2. Run the setup script
./setup.sh

# 3. Restart your terminal or run:
source ~/.zshrc
```

That's it! Your ZSH configuration is now ready to use on both macOS and WSL2.

## 📁 What Gets Installed

The setup script will:

1. **Copy** all configuration files to `~/.config/zsh/`
2. **Create** a symlink: `~/.zshrc` → `~/.config/zsh/.zshrc`
3. **Backup** your existing `.zshrc` to `.zshrc.backup`
4. **Make** the configuration executable

## 🔧 Configuration Structure

```
~/.config/zsh/
├── init.zsh                 # Main loader
├── .zshrc                   # Entry point (symlink)
├── core/                    # Basic settings
├── os/                      # macOS/WSL specific
├── modules/                 # Features (aliases, functions, etc.)
├── dev/                     # Development tools
└── local.zsh               # Your personal config
```

## 🎯 What You Get

- **Cross-platform**: Works on macOS and WSL2
- **Modular**: Easy to customize and maintain
- **Modern tools**: Rust-based CLI tools (optional)
- **Development ready**: Node.js, Python, Rust, Docker support
- **Smart detection**: Automatically detects your OS

## 🛠️ Customization

Edit `~/.config/zsh/local.zsh` for your personal settings:

```bash
# Add your aliases, functions, and environment variables here
alias myproject="cd ~/my-special-project"
export MY_API_KEY="your-key-here"
```

## 📦 Optional: Install Recommended Tools

### macOS
```bash
brew install fzf starship zoxide
cargo install bat eza ripgrep fd-find bottom
```

### WSL2/Linux
```bash
sudo apt update && sudo apt install -y curl git build-essential
curl -sS https://starship.rs/install.sh | sh
cargo install bat eza ripgrep fd-find bottom starship zoxide
```

## 🔄 Updates

To update your configuration:

1. Copy new files to `~/.config/zsh/`
2. Run `source ~/.zshrc`

## 🐛 Troubleshooting

If something doesn't work:

1. Check the symlink: `ls -la ~/.zshrc`
2. Check the config: `ls -la ~/.config/zsh/`
3. Restart your terminal

---

**That's it! Enjoy your new ZSH configuration! 🎉** 