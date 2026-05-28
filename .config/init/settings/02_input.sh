# ╔══════════════════════════════════════════════════════════════╗
# ║              ⌨️  KEYBOARD, TRACKPAD & INPUT                   ║
# ║   Gestures, key repeat rates, and peripheral behaviors       ║
# ╚══════════════════════════════════════════════════════════════╝

log_section "Configuring Keyboard, Trackpad & Input Devices"

log_info "Calibrating key repeats and keyboard light timeouts..."
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write com.apple.BezelServices kDim -bool true
defaults write com.apple.BezelServices kDimTime -int 300
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

log_info "Configuring Trackpad multi-gestures and tap-to-click..."
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true
defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerHorizSwipeGesture -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 1

log_info "Boosting Bluetooth audio quality bandwidth..."
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

log_success "Input devices tailored smoothly."
