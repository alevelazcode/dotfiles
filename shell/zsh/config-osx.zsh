# # Set PATH
# export PATH="/opt/homebrew/bin:$PATH"


# Path helper functions (add without duplicates)
path_append() {
  for ARG in "$@"; do
    [[ ":$PATH:" != *":$ARG:"* ]] && export PATH="${PATH:+"$PATH:"}$ARG"
  done
}

path_prepend() {
  for ARG in "$@"; do
    [[ ":$PATH:" != *":$ARG:"* ]] && export PATH="$ARG${PATH:+":$PATH"}"
  done
}

# Use cached HOMEBREW_PREFIX instead of calling brew --prefix
if [[ -d "/opt/homebrew" ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
elif [[ -d "/usr/local/Homebrew" ]]; then
    export HOMEBREW_PREFIX="/usr/local"
fi

if [[ -n "$HOMEBREW_PREFIX" && -d "$HOMEBREW_PREFIX/share/zsh-abbr" ]]; then
    FPATH="$HOMEBREW_PREFIX/share/zsh-abbr:$FPATH"
fi

path_append "$HOMEBREW_PREFIX/bin"

# NVM - LAZY LOADING (only load when needed)
export NVM_DIR="$HOME/.nvm"

# Add default node to PATH immediately
if [[ -d "$NVM_DIR/versions/node" ]]; then
    local default_node=$(ls -1 "$NVM_DIR/versions/node" 2>/dev/null | sort -V | tail -n1)
    [[ -n "$default_node" ]] && path_prepend "$NVM_DIR/versions/node/$default_node/bin"
fi

_load_nvm() {
    unfunction nvm node npm npx 2>/dev/null
    [[ -f "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" --no-use
}
nvm() { _load_nvm; nvm "$@" }

# Syntax highlighting - use direct path
[[ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
    source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Abbreviations as functions for brew
bc() { brew cleanup "$@" }
bd() { brew doctor "$@" }
bi() { brew install "$@" }
bic() { brew install --cask "$@" }
bif() { brew info "$@" }
bifc() { brew info --cask "$@" }
bo() { brew outdated "$@" }
bs() { brew services "$@" }
bsr() { brew services restart "$@" }

# Function to open files in Visual Studio Code
code() {
  local location="$PWD/${1}"
  open -n -b "com.microsoft.VSCode" --args "$location"
}

# Environment variables for Android and Java development
export ANDROID_HOME="$HOME/Library/Android/sdk"




# Option A: hard-coded path
export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-21.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"


# rbenv - LAZY LOADING
if [[ -d "$HOME/.rbenv" ]]; then
    rbenv() {
        unfunction rbenv 2>/dev/null
        eval "$(command rbenv init - zsh)"
        rbenv "$@"
    }
fi



# Alias 
# Mac App Store (https://github.com/argon/mas)
alias masi='mas install'
alias masl='mas list'
alias maso='mas outdated'
alias mass='mas search'
alias masu='mas upgrade'
