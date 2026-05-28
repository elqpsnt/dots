# ╔══════════════════════════════════════════════════════════════╗
# ║                 📦  APP-SPECIFIC PREFERENCES                 ║
# ║  Mail, Calendar, Terminal, Activity Monitor & Updates        ║
# ╚══════════════════════════════════════════════════════════════╝

log_section "Configuring Core macOS Native Applications"

log_info "Optimizing Apple Mail client interface layouts..."
defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
defaults write com.apple.mail DisableReplyAnimations -bool true
defaults write com.apple.mail DisableSendAnimations -bool true
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true
defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"
defaults write com.apple.mail MailSound -string ""
defaults write com.apple.mail PlayMailSounds -bool false
defaults write com.apple.mail ConversationViewMarkAllAsRead -bool true
defaults write com.apple.mail IndexTrash -bool false
defaults write com.apple.mail AutoFetch -bool true
defaults write com.apple.mail PollTime -string "-1"
defaults write com.apple.mail ConversationViewSortDescending -bool true

log_info "Enforcing clean Pro themes and UTF-8 rules on Terminal..."
defaults write com.apple.terminal StringEncodings -array 4
defaults write com.apple.terminal "Default Window Settings" -string "Pro"
defaults write com.apple.terminal "Startup Window Settings" -string "Pro"
defaults write com.apple.Terminal ShowLineMarks -int 0

log_info "Configuring real-time CPU metric reporting for Activity Monitor..."
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
defaults write com.apple.ActivityMonitor IconType -int 5
defaults write com.apple.ActivityMonitor ShowCategory -int 0
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

log_info "Automating quiet System & App Store critical updates..."
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
defaults write com.apple.SoftwareUpdate ScheduleFrequency -string 7
defaults write com.apple.SoftwareUpdate AutomaticDownload -bool true
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -bool true
defaults write com.apple.commerce AutoUpdate -bool true
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

log_success "Native configurations complete."
