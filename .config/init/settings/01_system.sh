# ╔══════════════════════════════════════════════════════════════╗
# ║               ⚙️  SYSTEM & LOCALIZATION                      ║
# ║  Host identity, localization, power management & updates     ║
# ╚══════════════════════════════════════════════════════════════╝

COMPUTER_NAME="Elqpsnt"
LANGUAGES=(en ar)
LOCALE="en_US@currency=USD"
MEASUREMENT_UNITS="Centimeters"

log_section "Configuring System, Identity & Localization"

log_info "Setting identity to '$COMPUTER_NAME'..."
sudo scutil --set ComputerName "$COMPUTER_NAME"
sudo scutil --set HostName "$COMPUTER_NAME"
sudo scutil --set LocalHostName "$COMPUTER_NAME"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMPUTER_NAME"

log_info "Set language and text formats ($LOCALE)..."
defaults write NSGlobalDomain AppleLanguages -array "${LANGUAGES[@]}"
defaults write NSGlobalDomain AppleLocale -string "$LOCALE"
defaults write NSGlobalDomain AppleMeasurementUnits -string "$MEASUREMENT_UNITS"
defaults write NSGlobalDomain AppleMetricUnits -bool true
sudo defaults write /Library/Preferences/com.apple.timezone.auto Active -bool YES
sudo systemsetup -setusingnetworktime on

log_info "Tweaking core system parameters & speeds..."
sudo systemsetup -setrestartfreeze on 2> /dev/null
sudo pmset -a standbydelay 86400
sudo pmset -a sms 0
defaults write com.apple.sound.beep.feedback -bool false
sudo nvram SystemAudioVolume=" "
sudo nvram StartupMute=%01
defaults write com.apple.menuextra.battery ShowPercent YES
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
defaults write com.apple.LaunchServices LSQuarantine -bool false
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false
defaults write com.apple.CrashReporter DialogType -string "none"
launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

log_success "System base configurations applied."
