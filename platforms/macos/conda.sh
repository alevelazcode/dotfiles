# Install miniconda3 or update it if it's already installed in mac os with ARM architecture
if [ ! -d ~/miniconda3 ]; then
    echo "Installing Miniconda3"
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh
    bash Miniconda3-latest-MacOSX-arm64.sh
    rm Miniconda3-latest-MacOSX-arm64.sh
else
    echo "Updating Miniconda3"
    conda update --all
fi