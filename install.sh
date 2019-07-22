#!/bin/bash

dotfiles_dir=~/dotfiles

# Install Oh My ZSH
$dotfiles_dir/oh-my-zsh/install.sh

ln -sf $dotfiles_dir/Xresources ~/.Xresources
ln -sf $dotfiles_dir/scripts ~/.scripts
ln -sf $dotfiles_dir/zshrc ~/.zshrc
ln -sf $dotfiles_dir/config/compton ~/.config
ln -sf $dotfiles_dir/config/dunst ~/.config
ln -sf $dotfiles_dir/config/i3 ~/.config
ln -sf $dotfiles_dir/config/alacritty ~/.config
ln -sf $dotfiles_dir/config/nvim ~/.config
ln -sf $dotfiles_dir/config/polybar ~/.config
