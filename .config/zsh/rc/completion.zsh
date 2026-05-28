# ╔══════════════════════════════════════════════════════════════╗
# ║                    🎯  RC: COMPLETION                        ║
# ║   Zsh completion system engine (zstyle, compinit & optimization)║
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
#   Configures Zsh completion system.
#
# RESPONSIBILITIES
#   ✔ zstyle completion settings
#   ✔ completion behavior and caching
#   ✔ completion-related tweaks
#   ✔ compinit
#
# RULE OF THUMB
#   "Does this affect tab-completion behavior?"
#     → YES → belongs here
#
# LOADED FROM
#   .zshrc
# }}

# ────────────────────────────────────────────────────────────────
# 🎛️  GENERAL COMPLETION ENGINE STYLES (ZSTYLE)
# ────────────────────────────────────────────────────────────────
# Enable arrows/visual selection grid in completion menu
zstyle ':completion:*' menu select

# Evaluation stack order for tab completions
zstyle ':completion:*' completer _expand _expand_alias _extensions _complete _ignored _correct _approximate

# Typo correction leniency boundaries
zstyle ':completion:*:correct:::' max-errors 2 not-numeric
zstyle ':completion:*:approximate:::' max-errors 3 numeric

# Path string formatting optimizations
zstyle ':completion:*' squeeze-slashes true

# Cache engine initialization and XDG diversion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

# Aesthetic mapping & match handling
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # Inherit terminal colors
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*' # Case-insensitive smart matching
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

# Target specific process behavior on dynamic kills
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# Automatically sync completions asynchronously when PATH changes
zstyle ':completion:*' rehash true

# Filter constraints on general command tools
zstyle ':completion:*:*:open:*' tag-order '!urls'  # Stop matching web URLs on system open

# Expand the visual limit boundary before zsh queries to display more options
LISTMAX=500

# Prevent alias lookup from hiding flag context completion arrays
setopt completealiases

# ────────────────────────────────────────────────────────────────
# 🛠️  SPECIFIC COMMAND TWEAKS
# ────────────────────────────────────────────────────────────────
if (( $+commands[daemonize] )); then
  compctl -cf daemonize
fi

# ────────────────────────────────────────────────────────────────
# ⚡  COMPINIT (INITIALIZATION & BACKEND OPTIMIZATION)
# ────────────────────────────────────────────────────────────────
# Performance tweak: only run full directory scans if cache dump file is older than 24 hours.
# -d: XDG-compliant dump target
# -i: Bypass insecure permission validation checks for raw speed
autoload -Uz compinit
local _zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"

# Leverage null-glob and dynamic file modification age flags
local -a _zcompdump_stale=($_zcompdump(#qN.mh+24))

if [[ -f "$_zcompdump" && ${#_zcompdump_stale} -eq 0 ]]; then
  compinit -C -d "$_zcompdump" -i
else
  compinit -d "$_zcompdump" -i
fi
unset _zcompdump_stale

# Compile raw dump text directly into bytecode asynchronously for near-instant boot on next shell call
[[ "$_zcompdump.zwc" -nt "$_zcompdump" ]] || zcompile "$_zcompdump" &!
unset _zcompdump

# ────────────────────────────────────────────────────────────────
# 🧩  CUSTOM FUNCTION COMPLETIONS
# ────────────────────────────────────────────────────────────────
# Map flags and path routing completions for internal binaries in $ZDOTDIR/functions/
compdef _command_names viw
compdef _command_names cdw
