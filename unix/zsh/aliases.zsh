
# Aliases
alias cat="bat --style=plain"
alias vim="nvim"
alias vi="nvim"
alias g='git'
# alias python3="python"
alias pip='pip3'
alias python='python3'
alias htop='btm'
alias grep="batgrep --style=plain"
alias ls='eza --icons -F -H --group-directories-first --git -1 -a'
alias ll='ls -alF'
alias gc="git commit"
alias gp="git push"
alias ga="git add ."
alias gs="git status -s"
alias gpl="git pull"
alias gc="(){git commit -m $1}"
alias gco="git checkout"
alias gcb="git pull && git checkout -b"
# Alias to checkout master and pull
alias gcm="git checkout master"

# Clean Brew
alias brewski='brew update && brew upgrade && brew cleanup; brew doctor; brew missing; echo "Brewski Complete" | terminal-notifier -sound default -appIcon https://brew.sh/assets/img/homebrew-256x256.png -title "Homebrew"'

alias copilot='gh copilot'
alias gcs='gh copilot suggest'
alias gce='gh copilot explain'

# Additional aliases
alias jupyter-notebook="~/.local/bin/jupyter-notebook --no-browser"

alias pnd="pnpm dev"
alias run-kloov-be="cd ~/work/work/kloov/kloov-be;git pull; pnpm start:dev"
alias run-kloov-fe="cd ~/work/work/kloov/kloov-fe; pnpm dev"
alias run-kloov-strapi="cd ~/work/work/kloov/kloov-strapi;git pull; yarn develop"

alias downloads="cd ~/Downloads"
alias work="cd ~/work"

alias neofetch='fastfetch'


alias cargoglobalupdate='cargo install --list | awk '{print $1}' | xargs -n 1 cargo install --force ; cargo clean'


