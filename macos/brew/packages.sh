taps=(
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
  p7zip
  postgresql
  pulumi/tap/pulumi
  rclone
  redis
  ripgrep
  stripe/stripe-cli/stripe
  stow
  telnet
  tmux
  wget
  withgraphite/tap/graphite
  yt-dlp
  sesh
  starship
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

start_brew_services() {
  local services=(
    atuin
    felixkratz/formulae/sketchybar
  )

  info "Starting brew services..."
  for service in "${services[@]}"; do
    info "Starting service < $service >"
    brew services start "$service"
  done
}
