# # Set PATH
# export PATH="/opt/homebrew/bin:$PATH"

# This function adds the specified path to PATH without duplicates
# Equivalent to fish_add_path
path_append() {
  for ARG in "$@"; do
    if [[ ":$PATH:" != *":$ARG:"* ]]; then
      export PATH="${PATH:+"$PATH:"}$ARG"
    fi
  done
}

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-abbr:$FPATH

    autoload -Uz compinit
    compinit
  fi

path_append "/opt/homebrew/bin"

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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
# export JAVA_HOME="/Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home/"


export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"

# Initialize rbenv
if which rbenv > /dev/null; then eval "$(rbenv init - zsh)"; fi



# Alias 
# Mac App Store (https://github.com/argon/mas)
alias masi='mas install'
alias masl='mas list'
alias maso='mas outdated'
alias mass='mas search'
alias masu='mas upgrade'
