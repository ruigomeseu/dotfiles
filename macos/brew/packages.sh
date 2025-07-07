taps=(
  homebrew/cask
  homebrew/cask-fonts
  stripe/stripe-cli
  withgraphite/tap
  felixkratz/formulae
  jesseduffield/lazygit
)

packages=(
  atuin
  awscli
  bat
  btop
  cmake
  diff-so-fancy
  eza
  fastfetch
  fd
  fzf
  sketchybar
  jq
  just
  libpq
  neovim
  nvm
  p7zip
  pulumi/tap/pulumi
  rclone
  redis
  ripgrep
  stripe/stripe-cli/stripe
  telnet
  wget
  withgraphite/tap/graphite
  yt-dlp
  zoxide
  zsh
  zsh-autosuggestions
  zsh-syntax-highlighting
)

install_packages() {
  info "Configuring taps"
  apply_brew_taps "${taps[@]}"

  info "Installing packages..."
  install_brew_formulas "${packages[@]}"

  info "Cleaning up brew packages..."
  brew cleanup
}
