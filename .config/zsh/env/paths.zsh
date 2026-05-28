# ╔══════════════════════════════════════════════════════════════╗
# ║                     🛤️  ENVIRONMENT: PATHS                   ║
# ║      System binary PATH construction & completion setup      ║
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
#   Defines and constructs the system PATH.
#
# RESPONSIBILITIES
#   ✔ Add system and user binary directories
#   ✔ Initialize Homebrew environment
#   ✔ Ensure PATH ordering and deduplication
#   ✔ Ensure needed directories exist
#
# IMPORTANT
#   PATH must be constructed carefully:
#     - order matters
#     - avoid duplicates (typeset -U path)
#
# RULE OF THUMB
#   "Does this change where executables are found?"
#     → YES → belongs here
#
# LOADED FROM
#   .zprofile
# }}

# ────────────────────────────────────────────────────────────────
# 🛡️  PATH DEDUPLICATION & EXPORT
# ────────────────────────────────────────────────────────────────
typeset -U path   # Prevent duplicate entries in PATH
typeset -U fpath  # Prevent duplicate entries in FPATH
export PATH       # Make the path available in subshells

# ────────────────────────────────────────────────────────────────
# 📦  HOMEBREW INITIALIZATION
# ────────────────────────────────────────────────────────────────
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# ────────────────────────────────────────────────────────────────
# 🏗️  PATH CONSTRUCTION
# ────────────────────────────────────────────────────────────────
path=(
  $HOME/bin
  $HOME/.local/bin
  /usr/local/bin
  /usr/local/sbin
  /usr/sbin
  /sbin
  $path
)

# ────────────────────────────────────────────────────────────────
# 🛠️  RUNTIME MANAGERS (MISE)
# ────────────────────────────────────────────────────────────────
# Replaces asdf shims. Must be prepended last to take precedence.
if (( $+commands[mise] )); then
  eval "$(mise activate zsh --shims)"
fi

# ────────────────────────────────────────────────────────────────
# 🧩  SHELL FUNCTIONS & COMPLETIONS (FPATH)
# ────────────────────────────────────────────────────────────────
# Homebrew zsh completions
if [[ -d "$HOMEBREW_PREFIX/share/zsh-completions" ]]; then
  fpath=("$HOMEBREW_PREFIX/share/zsh-completions" $fpath)
fi

# Custom functions (lazy loaded)
fpath=($ZDOTDIR/functions $fpath)

# Load only functions needed at startup shell level
autoload -Uz has_command sourceifexists $ZDOTDIR/functions/shell_is_*(:t)

# ────────────────────────────────────────────────────────────────
# 📁  DIRECTORY SANITIZATION
# ────────────────────────────────────────────────────────────────
# Ensure completion cache directory exists
[[ -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh" ]] || mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

# Ensure XDG path for zsh history exists
[[ -d "${XDG_STATE_HOME:-$HOME/.local/state}/zsh" ]] || mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh"
