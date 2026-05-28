# ╔══════════════════════════════════════════════════════════════╗
# ║                    📂  ENVIRONMENT: XDG                      ║
# ║   Enforcing XDG Base Directory standards across CLI tools    ║
# ╚══════════════════════════════════════════════════════════════╝

# ────────────────────────────────────────────────────────────────
# ℹ️  METADATA & EDITOR CONFIG
# ────────────────────────────────────────────────────────────────
# Most $XDG_* variables are set in ~/.zshenv
# Modeline {{
#	vi: foldmarker={{,}} filetype=zsh foldmethod=marker foldlevel=0 tabstop=4 shiftwidth=4:
# }}

# ────────────────────────────────────────────────────────────────
# 📖  DOCUMENTATION {{
# ────────────────────────────────────────────────────────────────
# PURPOSE
#   Centralizes XDG Base Directory configuration.
#
# RESPONSIBILITIES
#   ✔ Define XDG-related environment variables for programs
#   ✔ Redirect tool configs away from $HOME into XDG paths
#
# EXAMPLES
#   - INPUTRC
#   - GNUPGHOME
#   - DOCKER_CONFIG
#
# RULE OF THUMB
#   "Does this tell a program WHERE to store its files?"
#     → YES → belongs here
#
# LOADED FROM
#   .zprofile (login shell, environment setup phase)
# }}

# ────────────────────────────────────────────────────────────────
# 🧰  GENERAL CLI TOOLS
# ────────────────────────────────────────────────────────────────
export ACKRC=$XDG_CONFIG_HOME/ack/ackrc
export CGDB_DIR=$XDG_CONFIG_HOME/cgdb
export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export GDBHISTFILE=$XDG_DATA_HOME/gdb/history
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export GRIPHOME=$XDG_CONFIG_HOME/grip
export RIPGREP_CONFIG_PATH=$XDG_CONFIG_HOME/ripgrep/config
export SQLITE_HISTORY=$XDG_DATA_HOME/sqlite_history
export WGETRC=$XDG_CONFIG_HOME/wget/wgetrc

# ────────────────────────────────────────────────────────────────
# 🟢  RUNTIMES & PACKAGE MANAGERS
# ────────────────────────────────────────────────────────────────
# Node & Bun (Mise managed toolchains)
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc

# Language specific caches & configs
export GRADLE_USER_HOME=$XDG_DATA_HOME/gradle
export SOLARGRAPH_CACHE=$XDG_CACHE_HOME/solargraph

# Go environment path overrides (keeps home directory clean)
export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"

# ────────────────────────────────────────────────────────────────
# 📝  TEXT EDITORS (VIM / NVIM)
# ────────────────────────────────────────────────────────────────
# Conditionally route fallback paths to classic Vim or modern Neovim configs
export VIMINIT='let $MYVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/vimrc" : "$XDG_CONFIG_HOME/nvim/init.lua" | so $MYVIMRC'
export GVIMINIT='let $MYGVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/gvimrc" : "$XDG_CONFIG_HOME/nvim/init.gvim" | so $MYGVIMRC'
