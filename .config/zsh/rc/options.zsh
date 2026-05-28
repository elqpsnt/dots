# ╔══════════════════════════════════════════════════════════════╗
# ║                      ⚙️  RC: OPTIONS                         ║
# ║   Zsh core engine configurations (setopt, unsetopt & bounds) ║
# ╚══════════════════════════════════════════════════════════════╝

# ────────────────────────────────────────────────────────────────
# ℹ️  METADATA & EDITOR CONFIG
# ────────────────────────────────────────────────────────────────
# Documentation Manual: http://zsh.sourceforge.net/Doc/Release/Options.html
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# ────────────────────────────────────────────────────────────────
# 📖  DOCUMENTATION {{
# ────────────────────────────────────────────────────────────────
# PURPOSE
#   Configures Zsh shell options (setopt / unsetopt).
#
# RESPONSIBILITIES
#   ✔ Shell behavior:
#     - directory navigation
#     - job control
#     - input/output behavior
#     - word characters (affects Ctrl-W, vi text objects)
#
# RULE OF THUMB
#   "Is this a `setopt` or core shell behavior?"
#     → YES → belongs here
#
# LOADED FROM
#   .zshrc
# }}

# ────────────────────────────────────────────────────────────────
# 🧠  CORE SHELL BEHAVIOR
# ────────────────────────────────────────────────────────────────
# Required for (N) glob qualifiers, (#q...) syntax, ^ negation, etc.
setopt extendedglob 

# Keep terminal audio completely silent
setopt nobeep

# ────────────────────────────────────────────────────────────────
# 📁  DIRECTORY NAVIGATION (PUSHD)
# ────────────────────────────────────────────────────────────────
setopt autopushd        # Automatically save visited directories onto the stack
setopt pushdignoredups  # Prevent identical directory tracking duplication on the stack
setopt pushdtohome      # Typing 'pushd' with zero parameters defaults straight to $HOME

# ────────────────────────────────────────────────────────────────
# 📥  INPUT / OUTPUT HANDLING
# ────────────────────────────────────────────────────────────────
# Allow comments starting with '#' directly inside the active prompt (Bash parity)
setopt interactivecomments

# Explicitly disable intrusive spell-checking (avoids encouraging loose typing)
unsetopt correct correctall

# Performance / debugging fallbacks (disabled by default)
# setopt nohashdirs     # Suppress rehash maps to track down new system binaries
# setopt printexitvalue # Explicitly echo abnormal non-zero execution exit signals

# ────────────────────────────────────────────────────────────────
# 💼  JOB CONTROL
# ────────────────────────────────────────────────────────────────
setopt longlistjobs     # Display complete PID strings when backgrounding or suspending tasks

# ────────────────────────────────────────────────────────────────
# 👥  SHELL EMULATION (BASH PARITY)
# ────────────────────────────────────────────────────────────────
setopt shnullcmd        # Enable simple redirection truncation logic: $> file

# ────────────────────────────────────────────────────────────────
# 🔤  WORD BOUNDARIES (ZLE TEXT OBJECT ERASING)
# ────────────────────────────────────────────────────────────────
# Modifies delimiter behavior for Ctrl-W deletion bursts and custom vi text objects.
# Leaving this completely empty forces Ctrl-W to stop at any non-alphanumeric item
# (e.g., path slashes, dashes, dots), preventing it from wiping out whole file paths.
WORDCHARS=''
