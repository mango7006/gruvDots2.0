#!/bin/bash

set -e

if [ "$EUID" -eq 0 ]; then
  echo "Do not run this script as root. Use a normal user."
  exit 1
fi

source config.sh

conf=~/.config/

echo "Install script for dotfiles"

read -r -p "Do you want to make a backup of your current dotfiles? (if this is a clean install answer no) [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  echo "Creating backup of current dotfiles"
  mkdir -p ~/.config/bkup
  sudo tar -czvf ~/.config/bkup/backup.tar.gz \
    $conf/{kitty,swaync,hypr,nvim,waybar,wofi} \
    $conf/starship.toml ~/.zshrc 2>/dev/null || echo "Some files were missing, skipped in backup"

else
  echo "Not making a backup of current dotfiles"
fi

read -r -p "Are you SURE that you want to replace your dotfiles? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  echo "Alrighty, overwriting."
  cp -r $gitDir/swaync/ $conf
  cp -r $gitDir/hypr/ $conf
  cp -r $gitDir/nvim/ $conf
  cp -r $gitDir/waybar/ $conf
  cp -r $gitDir/wofi/ $conf
  cp $gitDir/starship.toml $conf
  cp -r $gitDir/kitty/ $conf
  cp $gitDirHome/.zshrc ~
else
  echo "Not overwriting."
fi

read -r -p "Do you want to install dependencies and packages? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  echo "Downloading packages"
  sudo pacman -S --needed --noconfirm neovim
  sudo pacman -S --needed --noconfirm starship zoxide bat eza ripgrep trash-cli yazi
  sudo pacman -S --needed --noconfirm lazygit luarocks npm typescript unzip minizip fzf
  sudo pacman -S --needed --noconfirm ttf-droid ttf-font-awesome ttf-ibm-plex ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols ttf-mononoki-nerd
  sudo pacman -S --needed --noconfirm firefox libnotify feh nwg-look
  sudo pacman -S --needed --noconfirm brightnessctl gammastep
  sudo pacman -S --needed --noconfirm pavucontrol nm-connection-editor blueman
  sudo pacman -S --needed --noconfirm swaync hyprland hyprlock hyprpicker qt5-wayland qt6-5compat qt6-shadertools qt6-wayland swww waybar
  sudo pacman -S --needed --noconfirm wofi xdg-desktop-portal-gtk xdg-desktop-portal-hyprland xdg-desktop-portal-wlr kitty wl-clipboard
else
  echo -e "Not installing packages. \n WARNING: this might make my dotfiles unuseable."
fi

read -r -p "Do you want the full install? (optional programs like discord and spotify) [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  echo "Installing extra's"
  sudo pacman -S --needed --noconfirm vlc mpv evince obs-studio spotify-launcher signal-desktop obsidian bitwarden
else
  echo -e "Keeping it minimal"
fi

# Function to install paru if not present
install_paru() {
  echo "Installing paru..."
  sudo pacman -Sy --needed --noconfirm base-devel git

  temp_dir=$(mktemp -d)
  git clone https://aur.archlinux.org/paru.git "$temp_dir/paru"
  cd "$temp_dir/paru"
  makepkg -si --noconfirm
  rm -rf "$temp_dir"

  echo "paru installation complete."
}

if ! command -v paru &>/dev/null; then
  install_paru || {
    echo "paru installation failed. Exiting."
    exit 1
  }
else
  echo "paru is already installed."
fi

# read -r -p "do you want to install AUR packages? [y/n] " response
# if [[ "$response" =~ ^([yY][ee][ss]|[yY])$ ]]; then
#   echo "installing AUR pkgs"
#   paru -S --needed --noconfirm arcolinux-logout bibata-cursor-theme-bin clipse-bin gruvbox-dark-gtk hyprshot spicetify-cli stremio topgrade-bin vesktop-bin waypaper || echo "Some AUR packages failed to install."
# else
#   echo -e "not installing packages. \n WARNING: this might make my dotfiles unuseable."
# fi
#
echo "End of install script"
