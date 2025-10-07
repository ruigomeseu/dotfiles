install_macos_apps() {
  local apps=(
    nikitabobko/tap/aerospace
    arq
    aws-vault
    bartender
    bambu-studio
    brave-browser
    caffeine
    cursor
    datagrip
    elmedia-player
    fantastical
    font-hack-nerd-font
    font-maple-mono
    ghostty
    insomnia
    lunar
    nextcloud
    ngrok
    obsidian
    orbstack
    raycast
    readdle-spark
    sf-symbols
    signal
    slack
    spotify
    telegram
    todoist-app
    zoom
  )

  info "Installing macOS apps..."
  install_brew_casks "${apps[@]}"
}

install_masApps() {
  # Reference: https://medium.com/@protiumx/bash-gnu-stow-take-a-walk-while-your-new-macbook-is-being-set-up-351a6f2f9225
  local apps=(
    1475387142 # Tailscale
  )

  info "Installing App Store apps..."
  if [[ ${#apps[@]} -gt 0 ]]; then
    for app in "${apps[@]}"; do
      mas install "$app"
    done
  else
    info "No App Store apps to install"
  fi
}
