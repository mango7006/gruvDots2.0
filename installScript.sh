#!/bin/bash

source config.sh

conf=~/.config/

echo "Install script for dotfiles"

read -r -p "Do you want to make a backup of your current dotfiles? (if this is a clean install answer no) [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  echo "Creating backup of current dotfiles"
  mkdir -p ~/.config/bkup
  sudo tar -czvf ~/.config/bkup/backup.tar.gz $conf/kitty $conf/swaync $conf/hypr $conf/nvim $conf/waybar $conf/wofi $conf/starship.toml ~/.zshrc
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
  sudo pacman -S --needed --noconfirm starship zoxide bat eza ripgrep yazi arp-scan trash-cli yazi
  sudo pacman -S --needed --noconfirm lazygit luarocks npm typescript unzip minizip fzf
  sudo pacman -S --needed --noconfirm ttf-droid ttf-font-awesome ttf-ibm-plex ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols
  sudo pacman -S --needed --noconfirm bitwarden firefox obsidian signal-desktop libnotify spotify-launcher obs-studio feh evince thunar mpv vlc nwg-look
  sudo pacman -S --needed --noconfirm brightnessctl gammastep
  sudo pacman -S --needed --noconfirm pavucontrol nm-connection-editor blueman
  sudo pacman -S --needed --noconfirm swaync hyprland hyprlock hyprpicker qt5-wayland qt6-5compat qt6-shadertools qt6-wayland swww waybar wofi xdg-desktop-portal-gtk xdg-desktop-portal-hyprland xdg-desktop-portal-wlr kitty ly wl-clipboard
  systemctl enable NetworkManager sshd ufw bluetooth ly systemd-timesyncd
else
  echo -e "Not installing packages. \n WARNING: this might make my dotfiles unuseable."
fi

# pacman -Qs paru &>/dev/null || sudo pacman -S --needed --noconfirm base-devel && git clone --quiet https://aur.archlinux.org/paru.git && cd paru && makepkg -si && echo "paru is now installed."

read -r -p "do you want to install AUR packages? [y/n] " response
if [[ "$response" =~ ^([yy][ee][ss]|[yy])$ ]]; then
  echo "installing AUR pkgs"
  paru -S --needed --noconfirm arcolinux-logout bibata-cursor-theme-bin clipse-bin hyprshot spicetify-cli stremio topgrade-bin vesktop-bin waypaper
else
  echo -e "not installing packages. \n warning: this might make my dotfiles unuseable."
fi

echo "End of install script"
