#!/bin/bash

source config.sh

echo "Updating github repo for Dotfiles"

read -r -p "Do you want to copy dotfiles to repo? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  echo "Copying..."
  cd $repo
  sudo cp ~/.zshrc $repo_home
  sudo cp ~/.config/starship.toml $repo_config
  sudo cp -r ~/.config/swaync/ $repo_config
  sudo cp -r ~/.config/hypr/ $repo_config
  sudo cp -r ~/.config/nvim/ $repo_config
  sudo cp -r ~/.config/waybar/ $repo_config
  sudo cp -r ~/.config/wofi/ $repo_config
  sudo cp -r ~/.config/kitty/ $repo_config
else
  echo "Not Updating dotfiles"
fi

read -r -p "Do you want to push to github? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  echo "Pushing to github"
  cd $repo
  git add .
  date=$(date +%b/%d/%H:%M)
  read -r -p "Commit Message: " comMessage
  git commit -m "$comMessage $date"
  git push --quiet origin main
  echo "Done pushing, changes saved"
else
  echo "Not pushing changes to github"
fi
