# ╔══════════════════════════════════════════════════════════════╗
# ║                 🎨  COLOR & LOG UTILITIES                    ║
# ║  Centralized styles for consistent terminal printing         ║
# ╚══════════════════════════════════════════════════════════════╝

RESET="\033[0m"
BOLD="\033[1m"
CYAN="\033[36m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"

log_section() {
    echo -e "\n${BOLD}${CYAN}➔ %-60s${RESET}" "$1"
    echo -e "${CYAN}────────────────────────────────────────────────────────────${RESET}"
}

log_info() {    echo -e "  ${BLUE}➜ $1${RESET}"; }
log_success() { echo -e "  ${GREEN}✔ $1${RESET}"; }
log_warning() { echo -e "  ${YELLOW}⚠ $1${RESET}"; }
