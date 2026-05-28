# ╔══════════════════════════════════════════════════════════════╗
# ║                     📜  RC: HISTORY                          ║
# ║   Shell command persistence, optimization, and hooks         ║
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
#   Configures shell history behavior.
#
# RESPONSIBILITIES
#   ✔ HISTFILE location (XDG-compliant)
#   ✔ history size limits
#   ✔ history options (deduplication, timestamps, etc.)
#
# RULE OF THUMB
#   "Does this affect command history storage or behavior?"
#     → YES → belongs here
#
# LOADED FROM
#   .zshrc
# }}

# ────────────────────────────────────────────────────────────────
# 🗄️  STORAGE & SIZING (INTERNAL STORAGE)
# ────────────────────────────────────────────────────────────────
# Note: Variables are not exported as child processes track their own sessions.
HISTFILE=${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history
HISTSIZE=1000000  # Number of operational lines to retain in memory cache
SAVEHIST=1000000  # Max count of raw events committed directly to disk

# Target pattern boundaries to bypass history indexing entirely
HISTORY_IGNORE="poweroff|reboot|halt|shutdown|xlogout"

# ────────────────────────────────────────────────────────────────
# ⚙️  HISTORY ENGINE OPTIONS (SETOPT)
# ────────────────────────────────────────────────────────────────
setopt appendhistory    # Incrementally append log tracks upon closing; don't overwrite
setopt histignoredups   # Drop immediate sequential identical commands
setopt histignorespace  # Ignore typing tracking for statements starting with blank space
setopt extendedhistory  # Record starting epoch timestamps and execution run intervals
setopt histreduceblanks # Compress multi-space text streams down into neat singles

# ────────────────────────────────────────────────────────────────
# 🛠️  DYNAMIC FILTERS (ZSH HOOKS)
# ────────────────────────────────────────────────────────────────
# Prevents invalid/failed commands (typos) from saving to persistent files
# Reference: https://superuser.com/a/902508/42070
zshaddhistory() {
  local j=1
  while ([[ ${${(z)1}[$j]} == *=* ]]) {
    ((j++))
  }
  whence ${${(z)1}[$j]} >| /dev/null || return 1
}
