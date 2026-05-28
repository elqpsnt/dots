# ╔══════════════════════════════════════════════════════════════╗
# ║                 🚀  ENVIRONMENT: INTERACTIVE TOOLS           ║
# ║   CLI integrations, fuzzy engines, hooks, and pager themes   ║
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
#   Configures interactive CLI tools managed via mise, bat, fzf, and zoxide.
# }}

# ────────────────────────────────────────────────────────────────
# ⚙️  MISE ENVIRONMENT INITIALIZATION
# ────────────────────────────────────────────────────────────────
# Mise handles starship, direnv, and fzf hooks automatically if 
# configured inside ~/.config/mise/config.toml
if (( $+commands[mise] )); then
  eval "$(mise activate zsh)"
fi

# ────────────────────────────────────────────────────────────────
# 🦇  BAT (MODERN CAT REPLACEMENT)
# ────────────────────────────────────────────────────────────────
# Interactive pager adjustments and colorized system man-page styling
if (( $+commands[bat] )); then
  export BAT_THEME="Rose-Pine-Moon"
  export PAGER="bat"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# ────────────────────────────────────────────────────────────────
# 🔍  FZF (FUZZY FINDER SETTINGS)
# ────────────────────────────────────────────────────────────────
# Custom interaction parameters, shortcuts, and fallback search overrides
if (( $+commands[fzf] )); then
  export FZF_COMPLETION_OPTS='--multi'
  
  # Leverage fast 'fd' binary over traditional system 'find' if available
  if (( $+commands[fd] )); then
    export FZF_DEFAULT_COMMAND='fd --type file --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
fi

# ────────────────────────────────────────────────────────────────
# 📂  ZOXIDE (SMARTER CD ENGINE)
# ────────────────────────────────────────────────────────────────
# Setup context-learning folder shortcut hooks for active prompts
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

# ────────────────────────────────────────────────────────────────
# 🦅  YAZI (TERMINAL FILE MANAGER)
# ────────────────────────────────────────────────────────────────
# Opens Yazi and syncs the shell's current directory upon exit
if (( $+commands[yazi] )); then
  function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	command rm -f -- "$tmp"
  }
fi
