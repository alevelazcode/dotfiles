# ZSH Modular Configuration

A simple and functional modular ZSH configuration that works on macOS and WSL2. This configuration is designed to be easy to install, maintain, and customize.

## 🚀 Features

- **🔧 Modular**: Configuration split into organized files by function
- **🌍 Cross-platform**: Optimized support for macOS and WSL2
- **⚡ Simple installation**: Just run one script
- **🛠️ Maintainable**: Clear and documented structure
- **🎨 Customizable**: Separate local configuration
- **💻 Development ready**: Modern tools and configurations
- **🦀 Rust tools**: Modern CLI tools for better performance

## 📁 File Structure

```
~/.config/zsh/
├── init.zsh                 # Main initialization file
├── .zshrc                   # Main file (symlink)
├── setup.sh                 # Quick setup script
├── core/                    # Core configuration
│   ├── env.zsh             # Environment variables
│   ├── path.zsh            # PATH configuration
│   ├── options.zsh         # ZSH options
│   └── keybindings.zsh     # Key bindings
├── os/                      # OS-specific configuration
│   ├── macos.zsh           # macOS configuration
│   ├── linux.zsh           # Linux configuration
│   └── wsl.zsh             # WSL2 configuration
├── modules/                 # Feature modules
│   ├── aliases.zsh         # Aliases
│   ├── functions.zsh       # Functions
│   ├── plugins.zsh         # Plugins
│   ├── completion.zsh      # Completions
│   └── prompt.zsh          # Prompt configuration
├── dev/                     # Development configurations
│   ├── node.zsh            # Node.js
│   ├── python.zsh          # Python
│   ├── rust.zsh            # Rust
│   └── docker.zsh          # Docker
└── local.zsh               # Local configuration (not versioned)
```

## 🛠️ Installation

### Quick Setup (Recommended)

1. Clone this repository or download the files
2. Navigate to the `unix/zsh/modular` directory
3. Run the setup script:

```bash
chmod +x setup.sh
./setup.sh
```

That's it! The script will:
- Copy all configuration files to `~/.config/zsh/`
- Create a symlink for `.zshrc`
- Make the configuration executable
- Backup your existing `.zshrc` if it exists

### Manual Installation

If you prefer to install manually:

1. Copy all files to `~/.config/zsh/`
2. Create a symlink for .zshrc:
   ```bash
   ln -sf ~/.config/zsh/.zshrc ~/.zshrc
   ```
3. Make the init.zsh file executable:
   ```bash
   chmod +x ~/.config/zsh/init.zsh
   ```

## 🔧 Configuration

### Local Configuration

For machine-specific configurations, edit `~/.config/zsh/local.zsh`:

```bash
# Example local configuration
alias myproject="cd ~/my-special-project"
export MY_API_KEY="your-api-key-here"

myfunction() {
    echo "This is a local function"
}
```

### Customization

Each module can be customized by editing the corresponding files:

- **Aliases**: `~/.config/zsh/modules/aliases.zsh`
- **Functions**: `~/.config/zsh/modules/functions.zsh`
- **Plugins**: `~/.config/zsh/modules/plugins.zsh`
- **Prompt**: `~/.config/zsh/modules/prompt.zsh`

## 🎯 Features

### Useful Aliases

```bash
# Navigation
..          # cd ..
...         # cd ../..
....        # cd ../../..

# Git
g           # git
ga          # git add .
gs          # git status -s
gc          # git commit
gp          # git push
gpl         # git pull

# Docker
dc          # docker compose
dcd         # docker compose down
dcu         # docker compose up -d

# Node.js
pn          # pnpm
pni         # pnpm install
pnd         # pnpm dev

# Rust tools (if installed)
cat         # bat (with syntax highlighting)
ls          # eza (with icons)
htop        # bottom (modern system monitor)
```

### Useful Functions

```bash
# Create and navigate to directory
mkcd mydir

# Create Node.js project
create-node-project myapp pnpm

# Create Rust project
create-rust-project myapp

# Check environments
check-node-env
check-rust-env

# OS-specific functions
macos-info    # Show macOS system info
wsl-info      # Show WSL system info
linux-info    # Show Linux system info
```

## 🔌 Included Plugins

- **zsh-autosuggestions**: Intelligent autocompletion
- **zsh-syntax-highlighting**: Syntax highlighting
- **fzf**: Fuzzy search
- **zoxide**: Smart directory navigation
- **starship**: Modern and fast prompt

## 🦀 Rust Tools

The configuration is optimized to use modern Rust tools that offer better performance:

- **bat**: Better `cat` with syntax highlighting
- **eza**: Better `ls` with icons and git info
- **bottom**: Better `htop` for system monitoring
- **ripgrep**: Ultra-fast text search
- **fd**: Better `find` for file discovery
- **zoxide**: Smart directory navigation
- **starship**: Modern and fast prompt

## 🛠️ Development Tools

### Node.js
- NVM for version management
- Support for npm, pnpm, yarn
- Aliases and functions for development

### Python
- Virtual environment support
- Modern Python tools
- Development aliases

### Rust
- Cargo configuration
- Modern Rust CLI tools
- Development aliases

### Docker
- Docker and docker-compose aliases
- Management functions
- Optimized configuration

## 📦 Recommended Dependencies

### macOS
```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install tools
brew install fzf starship zoxide
brew install --cask font-jetbrains-mono-nerd-font

# Install Rust tools with cargo
cargo install bat eza ripgrep fd-find bottom
```

### WSL2/Linux
```bash
# Install essentials
sudo apt update && sudo apt install -y curl git build-essential

# Install Starship
curl -sS https://starship.rs/install.sh | sh

# Install Rust tools with cargo
cargo install bat eza ripgrep fd-find bottom starship zoxide
```

## 🎨 Prompt

The configuration uses **Starship** as the primary prompt, with a fallback to a custom prompt if Starship is not available.

### Install Starship

```bash
# macOS
brew install starship

# Linux/WSL
curl -sS https://starship.rs/install.sh | sh
```

## 🔄 Updates

To update the configuration:

1. Backup your current configuration
2. Copy the new files
3. Reload the configuration:
   ```bash
   source ~/.zshrc
   ```

## 🐛 Troubleshooting

### Configuration doesn't load

1. Check that the symlink exists:
   ```bash
   ls -la ~/.zshrc
   ```

2. Check that the config directory exists:
   ```bash
   ls -la ~/.config/zsh/
   ```

3. Check that `init.zsh` is executable:
   ```bash
   ls -la ~/.config/zsh/init.zsh
   ```

### Plugins don't work

1. Install the missing plugins according to your OS
2. Restart your terminal

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add documentation if necessary
5. Submit a pull request

## 📄 License

This project is under the MIT License. See the `LICENSE` file for more details.

---

**Enjoy your new ZSH configuration! 🎉** 