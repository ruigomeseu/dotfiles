#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

. ./utils.sh
. ./brew/brew.sh
. ./brew/packages.sh
. ./brew/casks.sh
. ./osx-defaults.sh
. ./stow.sh

cleanup() {
  info "Finishing..."
}

wait_input() {
  read -r -p "Press enter to continue.."
}

main() {
  info "Setting up MacOS..."

  info "################################################################################"
  info "Homebrew Packages"
  info "################################################################################"
  wait_input
  install_packages

  success "Finished installing Homebrew packages"

  info "################################################################################"
  info "Starting Services"
  info "################################################################################"
  start_brew_services

  success "Finished starting brew services"

  info "################################################################################"
  info "MacOS Apps"
  info "################################################################################"
  wait_input
  install_macos_apps

  install_masApps
  success "Finished installing macOS apps"

  info "################################################################################"
  info "Configuration"
  info "################################################################################"
  wait_input

  setup_osx
  success "Finished configuring MacOS defaults. NOTE: A restart is needed"

  stow_dotfiles
  success "Finished stowing dotfiles"

  success "Done - restart your system to complete the setup"
}

trap cleanup SIGINT SIGTERM ERR EXIT

main