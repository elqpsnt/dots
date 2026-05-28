# ╔══════════════════════════════════════════════════════════════╗
# ║                        🍺  HOMEBREW                          ║
# ║  Installs the core package manager & optimizes telemetry     ║
# ╚══════════════════════════════════════════════════════════════╝

log_section "Installing Homebrew Package Manager"

# Check if Homebrew executable is accessible in the current system path
if ! command -v brew &>/dev/null; then
    log_info "Homebrew not found. Executing remote installation sequence..."
    
    # Set environment flag to run installer seamlessly without interactive prompts
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Bind Homebrew path environment dynamically so the rest of the script session can use it instantly
    if [ -f "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f "/usr/local/bin/brew" ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    log_success "Homebrew engine installed."
else
    log_success "Homebrew is already present on this machine. Syncing formula indexes..."
    brew update
fi

# Opt-out of analytics tracker for enhanced execution speeds and personal data privacy
log_info "Disabling Homebrew tracking analytics telemetry..."
brew analytics off

log_success "Homebrew setup fully finalized."
