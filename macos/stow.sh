stow_dotfiles() {
  local files=(
    "aerospace"
    "ghostty"
    "nvim"
    "sketchybar"
    "tmux"
    "zsh"
  )

  for file in "${files[@]}"; do
    stow -v -d ../stow "$file" --target $HOME
  done
}
