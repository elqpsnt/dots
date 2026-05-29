# ╔══════════════════════════════════════════════════════════════╗
# ║                      💻  RC: ALIASES                         ║
# ║   Interactive shortcuts, command enhancements, and wrappers  ║
# ╚══════════════════════════════════════════════════════════════╝

# ────────────────────────────────────────────────────────────────
# ℹ️  METADATA & EDITOR CONFIG
# ────────────────────────────────────────────────────────────────
# Suppress alias expansion: $ \aliasname || 'aliasname'
# Print alias definition:   alias <aliasname>
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# ────────────────────────────────────────────────────────────────
# 📖  DOCUMENTATION {{
# ────────────────────────────────────────────────────────────────
# PURPOSE
#   Defines a comprehensive set of **interactive aliases and command wrappers**
#   to improve CLI ergonomics, defaults, and workflows across environments.
#
#   This file centralizes all alias logic, including OS-specific behavior,
#   tool enhancements, and productivity shortcuts.
#
# RESPONSIBILITIES
#   ✔ Desktop/OS-specific command behavior
#     - open, logout, screensaver, trash handling
#     - Conditional logic via $DESKTYPE and platform checks
#
#   ✔ CLI UX improvements
#     - Enable colors (ls, grep, gcc diagnostics)
#     - Improve defaults for common tools
#
#   ✔ Tool substitution and enhancement
#     - Prefer modern tools if available (eza, lsd, colordiff, cdu)
#     - Normalize behavior across systems (BSD vs GNU)
#
#   ✔ Program-specific aliases
#     - vim/nvim behavior
#     - libreoffice commands
#     - gpg, pdflatex, octave, etc.
#
#   ✔ Workflow and productivity shortcuts
#     - File/system utilities (ll, dusch, mkdirtoday, etc.)
#     - Git helpers, systemctl shortcuts, process helpers
#     - fzf-marks integration and bookmark helpers
#
#   ✔ XDG compatibility wrappers
#     - Force tools to respect XDG config locations
#
#   ✔ SSH and system helpers
#     - ssh-agent helpers (keyon/off/list)
#     - sudo command wrappers
#
#   ✘ DO NOT put here:
#     - Environment variables (→ env/*)
#     - PATH modifications (→ env/programs.zsh)
#     - Tool initialization or sourcing (→ rc/tools.zsh)
#     - Large or slow logic unrelated to command usage
#
# WHY
#   This file:
#     - standardizes command behavior across machines
#     - reduces friction in daily terminal usage
#     - adapts dynamically to available tools and OS differences
#
#   It acts as a **UX layer** on top of the raw shell environment.
#
# STARTUP CONTEXT
#   Loaded during:
#     → .zshrc (interactive shells only)
#
#   So it affects:
#     - terminal sessions
#     - NOT scripts or non-interactive shells
#
# RULE OF THUMB
#   "Does this change how I type or use commands interactively?"
#     → YES → put it here
#
#   "Does this configure environment or initialize a tool?"
#     → NO → belongs in env/* or rc/tools.zsh
# }}

# ────────────────────────────────────────────────────────────────
# 🍏  DESKTOP / OS SPECIFIC (MACOS)
# ────────────────────────────────────────────────────────────────
case $DESKTYPE in
  macos)
    # Lock the screen
    alias afk='/System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine'

    # Show/hide dotfiles inside Finder.app
    alias mac_showhidden='defaults write com.apple.finder AppleShowAllFiles TRUE; killall Finder'
    alias mac_hidehidden='defaults write com.apple.finder AppleShowAllFiles FALSE; killall Finder'

    # Empty the native macOS trash bin
    alias mac_emptytrash='rm -rf ~/.Trash/*'

    # List apps installed explicitly from the Mac App Store
    alias mac_app_store_apps="find /Applications \-maxdepth 4 \-path '*Contents/_MASReceipt/receipt' -print | sed 's#.app/Contents/_MASReceipt/receipt#.app#g; s#/Applications/##'"
    ;;
  *)
    ;;
esac

# ────────────────────────────────────────────────────────────────
# 📝  TEXT EDITORS
# ────────────────────────────────────────────────────────────────
alias vi='nvim'
alias e='nvim'

# ────────────────────────────────────────────────────────────────
# 🚀  MODERN CLI UTILITY REPLACEMENTS
# ────────────────────────────────────────────────────────────────
alias cat='bat'

# ────────────────────────────────────────────────────────────────
# ⚡  SHORTHANDS & PRODUCTIVITY
# ────────────────────────────────────────────────────────────────
alias cl='clear'
alias image_dim="identify -format '%w %h\n'"  # Extract dimensions of an image file
# Copy file(s) or stdin to clipboard
clip() {
  if [ -t 0 ]; then
    command cat "$@" | pbcopy
  else
    pbcopy
  fi
}
alias lg='lazygit'
