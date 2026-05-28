# ╔══════════════════════════════════════════════════════════════╗
# ║                  🛠️  ENVIRONMENT: PROGRAMS                    ║
# ║     Configurations & environments for global CLI utilities   ║
# ╚══════════════════════════════════════════════════════════════╝

# ────────────────────────────────────────────────────────────────
# ℹ️  METADATA & EDITOR CONFIG
# ────────────────────────────────────────────────────────────────
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# ────────────────────────────────────────────────────────────────
# 📖  DOCUMENTATION {{
# ────────────────────────────────────────────────────────────────
# PURPOSE
#   Defines environment for language runtimes and CLI tools.
#
# RESPONSIBILITIES
#   ✔ Language environments:
#     - asdf (Go, Java, Node, etc.)
#     - SDKMAN
#     - Ruby, Python, Perl configs
#
#   ✔ Global tool behavior:
#     - LESS
#     - EDITOR
#     - GPG_TTY
#
#   ✔ PATH extensions required by tools
#
# IMPORTANT
#   Everything here should be:
#     - needed by scripts
#     - relevant outside interactive shells
#
# RULE OF THUMB
#   "Would a script need this environment?"
#     → YES → belongs here
#     → NO  → belongs in rc/
#
# LOADED FROM
#   .zprofile
# }}

# ────────────────────────────────────────────────────────────────
# 🟢  NODE / NPM
# ────────────────────────────────────────────────────────────────
if [ -d "$XDG_DATA_HOME/npm/bin" ]; then
  export PATH="$XDG_DATA_HOME/npm/bin:$PATH"
fi

# ────────────────────────────────────────────────────────────────
# 🍺  HOMEBREW BUNDLER
# ────────────────────────────────────────────────────────────────
if (( $+commands[brew] )); then
  # Disable the automatic creation of Brewfile.lock.json files
  export HOMEBREW_BUNDLE_NO_LOCK=1
fi

# ────────────────────────────────────────────────────────────────
# 🍏  MACOS SPECIFIC SETTINGS
# ────────────────────────────────────────────────────────────────
# Disable macOS shell restore feature (/etc/bashrc_Apple_Terminal) 
# which pollution-spawns ~/.zsh_session folders
shell_is_macos && export SHELL_SESSIONS_DISABLE=1

# ────────────────────────────────────────────────────────────────
# 📄  PAGER & LESS CONFIGURATION
# ────────────────────────────────────────────────────────────────
export PAGER=less

# Flags:
#   --RAW-CONTROL-CHARS  -> Keep ANSI color codes printable
#   --ignore-case        -> Smart case search (case-insensitive until CAPS are used)
#   --status-column      -> Show a clean status column at the screen edge
export LESS="--RAW-CONTROL-CHARS --ignore-case --status-column"

# ────────────────────────────────────────────────────────────────
# 🖥️  DESKTOP ENVIRONMENT DETECTION
# ────────────────────────────────────────────────────────────────
# Set target identifier string depending on the active base OS platform
if shell_is_macos; then
	export DESKTYPE=macos
fi
