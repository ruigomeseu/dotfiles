install_macos_apps() {
  local apps=(
    aerospace
    aws-vault
    brave-browser
    cursor
    datagrip
    fantastical
    font-hack-nerd-font
    ghostty
    insomnia
    insomnia
    lunar
    ngrok
    orbstack
    raycast
    readdle-spark
    sf-symbols
    signal
    slack
    spotify
    telegram
    zoom
  )

  info "Installing macOS apps..."
  install_brew_casks "${apps[@]}"
}

install_masApps() {
  local apps=(
    # Apple Store ID: https://medium.com/@protiumx/bash-gnu-stow-take-a-walk-while-your-new-macbook-is-being-set-up-351a6f2f9225
  )

  info "Installing App Store apps..."
  for app in "${apps[@]}"; do
    mas install "$app"
  done
}
