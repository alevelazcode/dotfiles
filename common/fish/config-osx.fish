set -x PATH /opt/homebrew/bin $PATH
fish_add_path "/opt/homebrew/bin"


if type -q exa
  alias ll "exa -l -g --icons"
  alias lla "ll -a"
end

abbr bc "brew cleanup"
abbr bd "brew doctor"
abbr bi "brew install"
abbr bic "brew install --cask"
abbr bif "brew info"
abbr bifc "brew info --cask"
abbr bo "brew outdated"
abbr bs "brew services"
abbr bsr "brew services restart"

function code
  set location "$PWD/$argv"
  open -n -b "com.microsoft.VSCode" --args $location
end

set --export ANDROID_HOME $HOME/Library/Android/sdk
set --export  JAVA_HOME /Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home/


# export NVM_DIR=~/.nvm
# source $(brew --prefix nvm)/nvm.sh

rbenv init - | source
