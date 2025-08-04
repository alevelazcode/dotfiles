# ZSH Setup with Oh My Zsh and Essential Plugins

This document describes the comprehensive ZSH setup included in the dotfiles project.

## Overview

The ZSH setup provides a modern, feature-rich shell experience with:
- **Oh My Zsh** framework for plugin management
- **Essential plugins** for productivity and usability
- **Modern CLI tools** integration
- **Cross-platform compatibility** (macOS, Linux, WSL, Fedora)

## Features

### 🛠 **Oh My Zsh Framework**
- Plugin management system
- Theme support (using `robbyrussell` for speed)
- Auto-updates and community plugins

### 🔌 **Essential Plugins Included**

#### Built-in Oh My Zsh Plugins:
- **git** - Git aliases and git status in prompt
- **docker** & **docker-compose** - Docker command completions
- **npm**, **node**, **python**, **pip** - Language-specific completions
- **rust**, **cargo**, **golang** - Modern language support
- **kubectl**, **helm**, **terraform** - DevOps tools
- **aws**, **gcp**, **azure** - Cloud provider completions
- **systemd** - System service management
- **colored-man-pages** - Syntax highlighting for man pages
- **command-not-found** - Suggests packages for missing commands
- **extract** - Universal archive extraction
- **sudo** - ESC ESC to add sudo to previous command
- **web-search** - Search from terminal
- **z** - Smart directory jumping
- **jsontools**, **urltools** - Data manipulation utilities

#### Custom Community Plugins:
- **zsh-autosuggestions** - Fish-like autosuggestions
- **zsh-syntax-highlighting** - Real-time syntax highlighting
- **zsh-completions** - Additional completion definitions
- **zsh-history-substring-search** - History search improvements
- **fast-syntax-highlighting** - Faster syntax highlighting alternative
- **you-should-use** - Reminds you to use aliases

### 🔧 **Modern CLI Tools Integration**

The configuration automatically detects and integrates modern CLI tools:

```bash
# Enhanced ls with eza
alias ls='eza --color=auto --group-directories-first'
alias ll='eza -l --color=auto --group-directories-first'
alias la='eza -la --color=auto --group-directories-first'
alias lt='eza --tree --color=auto'

# Enhanced cat with bat
alias cat='bat'
alias catp='bat --style=plain'

# Enhanced find with fd
alias find='fd'

# Enhanced grep with ripgrep
alias grep='rg'

# Enhanced du with dust
alias du='dust'

# Enhanced ps with procs
alias ps='procs'
```

### ⚡ **Performance Optimizations**

- **Lazy loading** for heavy tools (nvm, rbenv, pyenv)
- **Completion caching** for faster startup
- **Minimal theme** for responsiveness
- **Smart plugin loading** based on availability

## Installation

### Automatic Installation

The ZSH setup is automatically installed when you run any platform setup:

```bash
# Automatic installation (detects your platform)
./install.sh

# Or platform-specific
./install.sh macos     # macOS
./install.sh fedora    # Fedora/RHEL
./install.sh linux     # Ubuntu/Debian
./install.sh wsl       # WSL2
```

### Manual Installation

You can also run the ZSH setup independently:

```bash
# Run ZSH setup script directly
./shell/common/zsh-setup.sh
```

## Configuration

### Main Configuration File

The setup creates an optimized `.zshrc` with:

```bash
# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Essential plugins
plugins=(
    git docker npm python rust kubectl
    zsh-autosuggestions zsh-syntax-highlighting
    zsh-completions you-should-use
    # ... and many more
)
```

### Customization

#### Adding Custom Aliases

Add to `~/.zshrc.local` (automatically loaded):

```bash
# Custom aliases
alias myproject='cd ~/projects/myproject'
alias serve='python -m http.server 8000'
```

#### Adding Custom Plugins

1. Clone plugin to Oh My Zsh custom directory:
```bash
git clone https://github.com/plugin-author/plugin-name ~/.oh-my-zsh/custom/plugins/plugin-name
```

2. Add to plugins list in `~/.zshrc`:
```bash
plugins=(
    # existing plugins...
    plugin-name
)
```

3. Reload ZSH:
```bash
source ~/.zshrc
# or
reload
```

## Usage

### Essential Commands

```bash
# Reload ZSH configuration
reload

# Edit ZSH configuration
zshconfig

# Edit Oh My Zsh
ohmyzsh

# Navigate directories
..          # cd ..
...         # cd ../..
mkcd mydir  # mkdir mydir && cd mydir

# Git shortcuts (via git plugin)
gst         # git status
gco         # git checkout
gaa         # git add .
gcm         # git commit -m
gps         # git push
gpl         # git pull

# System information
myip        # External IP address
localip     # Local IP address
```

### Plugin Features

#### Autosuggestions
- Type command and see gray suggestion
- Press `→` to accept suggestion
- Based on command history

#### Syntax Highlighting
- Commands turn green when valid
- Red when invalid or not found
- Highlights strings, variables, etc.

#### History Substring Search
- Use `↑` and `↓` to search history
- Type part of command and navigate matches

#### You Should Use
- Reminds you when you type a command that has an alias
- Helps learn and use shortcuts

## Troubleshooting

### Common Issues

1. **Slow startup**
   ```bash
   # Check what's taking time
   time zsh -i -c exit
   
   # Disable heavy plugins temporarily
   # Edit ~/.zshrc and comment out slow plugins
   ```

2. **Plugin not working**
   ```bash
   # Check if plugin is installed
   ls ~/.oh-my-zsh/custom/plugins/
   
   # Verify plugin is in ~/.zshrc plugins list
   grep "plugins=" ~/.zshrc
   
   # Reload configuration
   reload
   ```

3. **Autosuggestions not showing**
   ```bash
   # Check if plugin is loaded
   echo $plugins | grep autosuggestions
   
   # Reinstall plugin
   rm -rf ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
   git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
   ```

4. **Theme issues**
   ```bash
   # Reset to default theme
   sed -i 's/ZSH_THEME=.*/ZSH_THEME="robbyrussell"/' ~/.zshrc
   reload
   ```

### Reset ZSH Configuration

To completely reset ZSH configuration:

```bash
# Backup existing configuration
cp ~/.zshrc ~/.zshrc.backup

# Remove Oh My Zsh
rm -rf ~/.oh-my-zsh

# Run setup again
./shell/common/zsh-setup.sh
```

## Platform-Specific Notes

### macOS
- ZSH is default since macOS Catalina
- Uses Homebrew for additional packages
- Integrates with macOS-specific tools

### Linux/Ubuntu
- Installs ZSH via APT if not present
- Sets as default shell automatically
- Includes Linux-specific aliases

### Fedora/RHEL
- Installs ZSH via DNF if not present
- Includes RPM-based package management
- Fedora-specific optimizations

### WSL2
- Optimized for Windows integration
- Includes Windows PATH integration
- WSL-specific configurations

## Advanced Configuration

### Environment Variables

```bash
# Add to ~/.zshrc.local
export EDITOR='nvim'
export BROWSER='firefox'
export PAGER='less'
```

### Custom Functions

```bash
# Add to ~/.zshrc.local
function weather() {
    curl "wttr.in/$1"
}

function cheat() {
    curl "cheat.sh/$1"
}
```

### Performance Tuning

```bash
# Disable features for faster startup
DISABLE_AUTO_UPDATE=true
DISABLE_UPDATE_PROMPT=true
DISABLE_UNTRACKED_FILES_DIRTY=true
```

## Resources

- [Oh My Zsh Documentation](https://ohmyz.sh/)
- [ZSH Manual](http://zsh.sourceforge.net/Doc/)
- [Awesome ZSH Plugins](https://github.com/unixorn/awesome-zsh-plugins)
- [ZSH Autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [ZSH Syntax Highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

## Contributing

To add new plugins or improve the setup:

1. Test the plugin thoroughly
2. Update the `shell/common/zsh-setup.sh` script
3. Update this documentation
4. Test across all supported platforms