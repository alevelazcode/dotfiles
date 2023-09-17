# If it's a macOS
if [[ `uname` =~ "Darwin" ]]; then
  CODE_PATH=~/Library/Application\ Support/Code/User
# Else, it's a Linux (WSL or not)
else
  CODE_PATH=~/.config/Code/User
  # If this folder doesn't exist, it's a WSL
  if [ ! -e $CODE_PATH ]; then
    CODE_PATH=~/.vscode-server/data/Machine
  fi
fi

for name in settings.json keybindings.json; do
  target="$CODE_PATH/$name"
  backup $target
  symlink $PWD/$name $target
done
