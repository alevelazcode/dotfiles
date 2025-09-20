# Install Miniforge or update it if it's already installed in macOS with ARM architecture
if [ ! -d ~/miniforge3 ]; then
  echo "Installing Miniforge"
  wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-arm64.sh
  bash Miniforge3-MacOSX-arm64.sh
  rm Miniforge3-MacOSX-arm64.sh
else
  echo "Updating Miniforge"
  conda update --all
fi
