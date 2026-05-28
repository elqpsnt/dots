# ╔══════════════════════════════════════════════════════════════╗
# ║                        🎨  RC: UI                            ║
# ║   Native prompt, themes, terminal profiles, and system colors ║
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
#   Native visual configuration (No Starship/Zinit dependencies).
# }}

# ────────────────────────────────────────────────────────────────
# 📺  TERMINAL & PROFILE COLORS
# ────────────────────────────────────────────────────────────────
[[ "$TERM" == "xterm" ]] && export TERM=xterm-256color

# ────────────────────────────────────────────────────────────────
# 📁  LS_COLORS ENGINE (CACHING & XDG GENERATION)
# ────────────────────────────────────────────────────────────────
# Dynamically compiles custom color palettes for path files and outputs
_dircolors_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/dircolors.zsh"
_dircolors_source="$ZDOTDIR/dircolors"

# Regenerate system cache if source settings are updated or missing entirely
if [[ ! -s "$_dircolors_cache" ]] || [[ "$_dircolors_source" -nt "$_dircolors_cache" ]]; then
  mkdir -p "$(dirname "$_dircolors_cache")"
  if (( $+commands[dircolors] )); then
    # Leverage standard GNU tools
    [[ -f "$_dircolors_source" ]] && dircolors -b "$_dircolors_source" >| "$_dircolors_cache" || dircolors -b >| "$_dircolors_cache"
  elif (( $+commands[gdircolors] )); then
    # Fallback onto core utilities (Homebrew gnu-sed/coreutils mapping)
    [[ -f "$_dircolors_source" ]] && gdircolors -b "$_dircolors_source" >| "$_dircolors_cache" || gdircolors -b >| "$_dircolors_cache"
  fi
fi

[[ -s "$_dircolors_cache" ]] && source "$_dircolors_cache"
unset _dircolors_cache _dircolors_source

# ────────────────────────────────────────────────────────────────
# 🚀  NATIVE STARSHIP-STYLE PROMPT (VCS_INFO ENGINE)
# ────────────────────────────────────────────────────────────────
setopt prompt_subst
autoload -Uz vcs_info

# Git status presentation mapping: "on  branch" (Magenta text colors)
zstyle ':vcs_info:git:*' formats 'on %F{magenta} %b%f '
zstyle ':vcs_info:git:*' actionformats 'on %F{magenta} %b%f %F{red}(%a)%f '

# Active injection hook running right before prompt generation cycles
precmd() { vcs_info }

# Prompt Layout Syntax Structure
PROMPT='
%F{cyan}%~%f ${vcs_info_msg_0_}
%(?.%F{green}.%F{red})❯%f '

# ────────────────────────────────────────────────────────────────
# 🍏  BSD / MACOS CORE GRAPHICS SPECIFICS
# ────────────────────────────────────────────────────────────────
if [[ "$OSTYPE" == darwin* ]]; then
  export CLICOLOR=1
  export LSCOLORS="Gxfxcxdxbxegedabagacad"
fi
