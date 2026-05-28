# ╔══════════════════════════════════════════════════════════════╗
# ║                     🔌  RC: PLUGINS                          ║
# ║   Third-party shell extensions, lifecycle hooks & syntax     ║
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
#   Manages and loads Zsh plugins.
#
# RESPONSIBILITIES
#   ✔ Downloads missing plugins via zsh_add_plugin function.
#   ✔ Sources plugin logic for interactive use.
#
# RULE OF THUMB
#   "Is this a third-party shell enhancement?"
#     → YES → belongs here
#
# LOADED FROM
#   .zshrc
# }}

# ────────────────────────────────────────────────────────────────
# 📦  THIRD-PARTY EXTENSIONS (ORDER SENSITIVE)
# ────────────────────────────────────────────────────────────────
# Inline suggestions based on command history lookup arrays
add_plugin "zsh-users/zsh-autosuggestions"

# Intelligent, contextual bracket, paren, and quote boundary pairing
add_plugin "hlissner/zsh-autopair"

# Live visual validation parsing
# CRITICAL: This must be loaded absolutely last to prevent hooks from breaking!
add_plugin "zsh-users/zsh-syntax-highlighting"

# ────────────────────────────────────────────────────────────────
# ⚙️  PLUGIN CONFIGURATIONS
# ────────────────────────────────────────────────────────────────
# Color palette assignment for text predictions (fg=8 represents muted gray)
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
