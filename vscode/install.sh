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

echo "Creating symlinks for settings.json and keybindings.json in $CODE_PATH"

for name in settings.json keybindings.json; do
  target="$CODE_PATH/$name"
  if [ -e "$target" ]; then
    rm "$target"
  fi
  # Crear el enlace simbólico
  ln -s "$PWD/$name" "$target"
done
