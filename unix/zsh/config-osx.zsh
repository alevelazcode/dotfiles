# Set PATH
export PATH="/opt/homebrew/bin:$PATH"

# This function adds the specified path to PATH without duplicates
# Equivalent to fish_add_path
path_append() {
  for ARG in "$@"; do
    if [[ ":$PATH:" != *":$ARG:"* ]]; then
      export PATH="${PATH:+"$PATH:"}$ARG"
    fi
  done
}

path_append "/opt/homebrew/bin"

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

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
export JAVA_HOME="/Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home/"

# Initialize rbenv
if which rbenv > /dev/null; then eval "$(rbenv init - zsh)"; fi
