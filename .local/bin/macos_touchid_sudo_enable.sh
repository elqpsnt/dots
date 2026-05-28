#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════╗
# ║                   ⚙️  TOUCHID FOR SUDO                        ║
# ║   Enables TouchID authentication inside macOS Terminals      ║
# ║   Note: Re-run this after major macOS operating system updates║
# ╚══════════════════════════════════════════════════════════════╝

# Core Dependencies:
# • brew install pam-reattach (Crucial for cmux/tmux background tty attachments)
# • Ref: https://github.com/fabianishere/pam_reattach

set -o errexit
set -o nounset
set -o pipefail

# Force the script to escalate privileges and run as root natively
test "$EUID" -eq 0 || exec sudo bash "$0" "$@"

PAM_FILE=/etc/pam.d/sudo
SCRIPT_NAME=$(basename "$0")

# Define the dynamic PAM injection configuration blocks
read -r -d '' ADDED_MODULES <<-EOF
	# Added by ${SCRIPT_NAME}:
	auth       optional       /opt/homebrew/lib/pam/pam_reattach.so
	auth       sufficient     pam_tid.so

	# Original:
	EOF

timestamp=$(date "+%Y-%m-%d-%H%M%S")

# Check if TouchID tracking module configuration already exists
if grep -q "pam_tid.so" "$PAM_FILE"; then
	echo "TouchID for sudo is already enabled."
else
	# Create an atomic timestamped backup before modifying critical OS system configuration
	cp $PAM_FILE ${PAM_FILE}.${timestamp}.bak
	
	# Prepend the custom reattach and TouchID hooks into the sudo matrix file safely
	echo -e "$ADDED_MODULES" | cat - $PAM_FILE > ${PAM_FILE}.new
	mv ${PAM_FILE}.new $PAM_FILE

	echo "TouchID for sudo is now enabled."
fi
