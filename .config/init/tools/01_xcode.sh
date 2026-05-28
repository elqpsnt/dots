# ╔══════════════════════════════════════════════════════════════╗
# ║                  🛠️  XCODE COMMAND LINE TOOLS               ║
# ║  Installs Apple's underlying development & compilation CLI   ║
# ╚══════════════════════════════════════════════════════════════╝

log_section "Installing Xcode Command Line Tools"

# Check if Xcode CLI tools are already active
if ! xcode-select -p &>/dev/null; then
    log_info "Xcode Command Line Tools not detected. Initializing setup..."
    
    # Create a temporary file to force the software update engine to find CLI tools
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    
    # Find the matching software update string from Apple's update servers
    PROD=$(softwareupdate -l | grep "\*.*Command Line" | head -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n')
    
    if [ -n "$PROD" ]; then
        log_info "Downloading and installing: $PROD"
        sudo softwareupdate -i "$PROD" --verbose
        log_success "Xcode Command Line Tools deployed."
    else
        log_warning "Could not fetch automated installer packet from update stream."
        log_info "Triggering native macOS visual prompt. Please follow instructions on screen..."
        xcode-select --install
    fi
    
    # Clean up the temporary update check block file
    rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
else
    log_success "Xcode Command Line Tools are already installed."
fi
