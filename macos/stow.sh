stow_dotfiles() {
  for dir in ../stow/*/; do
    stow -v -d ../stow "$(basename "$dir")" --target $HOME
  done
}
