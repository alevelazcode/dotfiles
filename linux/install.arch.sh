
# Install paru in arch linux
sudo pacman -S --needed base-devel
sudo pacman -S --needed git
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

# Install packages
sudo paru -S bat exa fd fzf git-delta neovim ripgrep starship tmux zsh fish

# Install fisher
sudo paru -S fisher

# Install starship and nerd fonts with paru
sudo paru -S nerd-fonts-fira-code starship


# Install nvm and node lts
sudo paru -S nvm
nvm install --lts

# Install rust
sudo paru -S rustup
rustup install stable


# Install golang
sudo paru -S go

# Install Python with pip
sudo paru -S python python-pip

# Install docker and docker-compose
sudo paru -S docker 

# Install xorg dependencies needed for qtile
sudo paru -S xorg xorg-xinit xorg-xrandr xorg-xsetroot xorg-xset xorg-xrdb xorg-xdpyinfo xorg-xprop xorg-xwininfo xorg-xinput xorg-xbacklight

# Install  qtile and dependencies
sudo paru -S qtile picom rofi ranger conky feh







