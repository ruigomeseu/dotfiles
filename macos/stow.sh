stow_dotfiles() {
  local files=(
    "aerospace"
    "ghostty"
    "sketchybar"
    "tmux"
    "zsh"
  )

  for file in "${files[@]}"; do
    stow -v -d ../stow "$file" --target $HOME
  done
}