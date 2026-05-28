# ╔══════════════════════════════════════════════════════════════╗
# ║                     ⌨️  RC: BINDINGS                         ║
# ║   Keybindings, Zsh Line Editor (ZLE), and Vi-mode tweaks     ║
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
#   Defines keybindings and ZLE (Zsh Line Editor) behavior.
#
# RESPONSIBILITIES
#   ✔ bindkey mappings
#   ✔ vi-mode configuration
#   ✔ custom ZLE widgets
#
# RULE OF THUMB
#   "Does this change keyboard behavior?"
#     → YES → belongs here
#
# LOADED FROM
#   .zshrc
# }}

# ────────────────────────────────────────────────────────────────
# 🎛️  VI-MODE INITIALIZATION
# ────────────────────────────────────────────────────────────────
# CRITICAL: Must execute before setting up fzf.
# Reference: https://github.com/junegunn/fzf/issues/1596#issuecomment-2128091715
bindkey -v  # Enable native vi command editing mode

# Adjust escape key latency for switching to normal mode (10 ms)
export KEYTIMEOUT=1

# Useful discovery commands:
#   $ bindkey -l     -> View all binding namespaces
#   $ bindkey -m <ns> -> View active shortcuts within a namespace

# ────────────────────────────────────────────────────────────────
# ⚡  CORE INTERACTIVE KEYBINDINGS
# ────────────────────────────────────────────────────────────────
bindkey '^[[Z' reverse-menu-complete  # Shift-Tab: Step backward through completion list
bindkey "\ep"   insert-last-word       # Alt-P: Insert the last argument of previous command (!$)
bindkey ' '     magic-space            # Space: Dynamically expand history expansions (like !!)

# Fallback history search (only active if fzf isn't overriding ^R)
if (( ! $+commands[fzf] )); then
  bindkey "^R" history-beginning-search-backward
  bindkey "^E" history-beginning-search-forward
fi

# ────────────────────────────────────────────────────────────────
# 🧹  TEXT MANIPULATION & ERASING
# ────────────────────────────────────────────────────────────────
bindkey "^?" backward-delete-char  # Backspace
bindkey "^H" backward-delete-char  # Ctrl-H (Alternative Backspace)
bindkey "^W" backward-kill-word    # Ctrl-W: Delete word backward
bindkey "^U" backward-kill-line    # Ctrl-U: Clear line backward

# Fix native forward-delete logic on macOS terminals
# Must explicitly follow "bindkey -v" to register over the mode shift
# References: 
#   - https://stackoverflow.com/questions/33270381/delete-forward-character-iterm2-osx
#   - https://superuser.com/questions/288684/terminal-on-mac-delete-key-behavior
if shell_is_macos; then
  bindkey "^[[3~"  delete-char
  bindkey "^[3;5~" delete-char
fi

# ────────────────────────────────────────────────────────────────
# 🧮  VI TEXT OBJECTS EXTENSIONS (ZLE)
# ────────────────────────────────────────────────────────────────
# Adds inner/around quotes capabilities in normal/visual mode (e.g., ci", da')
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
  for c in {a,i}{\',\",\`}; do
    bindkey -M $m $c select-quoted
  done
done

# ────────────────────────────────────────────────────────────────
# 📝  FULL BUFFER TEXT EDITING (ZLE)
# ────────────────────────────────────────────────────────────────
# Pressing 'v' in visual command mode drops current prompt buffer into NVIM
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line
