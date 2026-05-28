#!/usr/bin/env zsh

# ╔══════════════════════════════════════════════════════════════╗
# ║                   🚀  MAC OS DOTFILES SETUP                  ║
# ║  The orchestrator file that loads all modular configurations ║
# ╚══════════════════════════════════════════════════════════════╝

# Get the absolute path of the directory containing this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source colors and log utilities from the utils directory
if [ -f "${SCRIPT_DIR}/utils/colors.sh" ]; then
    source "${SCRIPT_DIR}/utils/colors.sh"
else
    echo "❌ Error: utils/colors.sh not found! Check your directory structure."
    exit 1
fi

# Close System Preferences to avoid overwriting settings we are about to change
osascript -e 'tell application "System Preferences" to quit'

log_warning "Administrative privileges required. Please authenticate:"
sudo -v

# Keep-alive: update existing `sudo` time stamp until setup script finishes
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# --- 1. Run Core Tool Installations -------------------------------------------
if [ -f "${SCRIPT_DIR}/tools/01_xcode.sh" ]; then
    source "${SCRIPT_DIR}/tools/01_xcode.sh"
fi

if [ -f "${SCRIPT_DIR}/tools/02_homebrew.sh" ]; then
    source "${SCRIPT_DIR}/tools/02_homebrew.sh"
fi

# --- 2. Install Packages via Homebrew Bundle ---------------------------------
log_section "Installing Package Ecosystem"

if [ -f "${SCRIPT_DIR}/packages/Brewfile" ]; then
    log_info "Installing CLI tools from Brewfile..."
    brew bundle --file="${SCRIPT_DIR}/packages/Brewfile"
    log_success "CLI tools processing complete."
fi

if [ -f "${SCRIPT_DIR}/packages/Caskfile" ]; then
    log_info "Installing GUI applications from Caskfile..."
    brew bundle --file="${SCRIPT_DIR}/packages/Caskfile"
    log_success "GUI applications processing complete."
fi

# --- 3. Source all modular files inside the settings directory dynamically -----
for config_file in "${SCRIPT_DIR}/settings/"*.sh; do
    if [ -f "$config_file" ]; then
        source "$config_file"
    fi
done

# --- Clean up & Restart affected apps -----------------------------------------
log_section "Applying Configuration Changes"
log_info "Restarting modified system applications to apply updates..."

apps=(
    "Address Book" 
    "Calendar" 
    "Contacts" 
    "Dock" 
    "Finder" 
    "Mail" 
    "Safari" 
    "SystemUIServer" 
    "iCal"
)

for app in "${apps[@]}"; do
    killall "${app}" &> /dev/null
done

echo -e "\n${BOLD}${GREEN}🎉 macOS environment configured flawlessly!${RESET}\n"
