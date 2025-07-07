setup_osx() {
  info "Configuring MacOS default settings"

  # Disable prompting to use new external drives as Time Machine volume
  defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

  # Hide external hard drives on desktop
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false

  # Hide hard drives on desktop
  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false

  # Hide removable media hard drives on desktop
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

  # Hide mounted servers on desktop
  defaults write com.apple.finder ShowMountedServersOnDesktop -bool false

  # Hide icons on desktop
  defaults write com.apple.finder CreateDesktop -bool false

  # Avoid creating .DS_Store files on network volumes
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

  # Show path bar
  defaults write com.apple.finder ShowPathbar -bool true

  # Show hidden files inside the finder
  defaults write com.apple.finder "AppleShowAllFiles" -bool true

  # Show Status Bar
  defaults write com.apple.finder "ShowStatusBar" -bool true

  # Do not show warning when changing the file extension
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

  # Set search scope to current folder
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

  # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
  defaults write com.apple.screencapture type -string "png"

  # Set weekly software update checks
  defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 7

  # Hide menu bar
  defaults write NSGlobalDomain _HIHideMenuBar -bool true

  # Set Dock autohide
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock largesize -float 256
  defaults write com.apple.dock "minimize-to-application" -bool true
  defaults write com.apple.dock tilesize -float 64

  # Disable startup sound
  sudo nvram SystemAudioVolume=%01
}
