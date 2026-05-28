# ╔══════════════════════════════════════════════════════════════╗
# ║                   🌐  NETWORK & SECURITY                     ║
# ║  Firewall activation, stealth mode, and connection rules     ║
# ╚══════════════════════════════════════════════════════════════╝

log_section "Configuring Network Security & Firewall"

log_info "Activating macOS Application Firewall (ALF)..."
# 0 = disabled, 1 = specific apps allowed, 2 = block all incoming
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1

log_info "Enabling Stealth Mode (ignore ping and probing requests)..."
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -int 1

log_info "Enabling logging for firewall events..."
sudo defaults write /Library/Preferences/com.apple.alf loggingenabled -int 1

log_info "Enforcing download signed applications rule..."
sudo defaults write /Library/Preferences/com.apple.alf downloadsignedenabled -int 1

# Restart the application firewall service daemon to commit the updates immediately
log_info "Reloading firewall service state..."
sudo launchctl kickstart -k system/com.apple.alf.agent 2>/dev/null || true

log_success "Network security and stealth protocols hardened."
