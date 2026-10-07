#!/usr/bin/env bash
# Gemini Engineering Kit - Doctor Diagnostic Script
set -e

CONFIG_DIR="${HOME}/.gemini/config"
VERSION_FILE="${CONFIG_DIR}/VERSION"
CURRENT_VER=$(cat "$VERSION_FILE" 2>/dev/null || echo "1.0.0")

GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
BOLD="\033[1m"
RESET="\033[0m"

echo -e "${BOLD}${CYAN}Gemini Engineering Kit — Doctor${RESET}"
echo -e "${CYAN}──────────────────────────────────────────${RESET}"

ERRORS=0
WARNINGS=0

check_item() {
    local name="$1"
    local status="$2"
    local detail="$3"

    if [ "$status" -eq 0 ]; then
        echo -e "  ${GREEN}✓${RESET} ${name} ${detail}"
    else
        echo -e "  ${RED}✗${RESET} ${name} ${RED}${detail}${RESET}"
        ERRORS=$((ERRORS + 1))
    fi
}

check_optional() {
    local name="$1"
    local status="$2"
    local detail="$3"

    if [ "$status" -eq 0 ]; then
        echo -e "  ${GREEN}✓${RESET} ${name} ${detail}"
    else
        echo -e "  ${YELLOW}⚠${RESET} ${name} ${YELLOW}(not installed/optional)${RESET}"
        WARNINGS=$((WARNINGS + 1))
    fi
}

# 1. Directory Structure
echo -e "\n${BOLD}Directory & Config Integrity:${RESET}"
[ -d "${CONFIG_DIR}" ] && check_item "Global Config Dir" 0 "${CONFIG_DIR}" || check_item "Global Config Dir" 1 "Missing"
[ -f "${CONFIG_DIR}/rules/AGENTS.md" ] && check_item "Master Rules (rules/AGENTS.md)" 0 "" || check_item "Master Rules" 1 "Missing"
[ -d "${CONFIG_DIR}/skills" ] && check_item "Skills Directory" 0 "($(find "${CONFIG_DIR}/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l) skills mounted)" || check_item "Skills Directory" 1 "Missing"
[ -d "${CONFIG_DIR}/agents" ] && check_item "Agent Personas" 0 "($(find "${CONFIG_DIR}/agents" -name "*.md" 2>/dev/null | wc -l) personas)" || check_item "Agent Personas" 1 "Missing"
[ -d "${CONFIG_DIR}/workflows" ] && check_item "Workflows" 0 "($(find "${CONFIG_DIR}/workflows" -name "*.md" 2>/dev/null | wc -l) workflows)" || check_item "Workflows" 1 "Missing"

# 2. System Runtimes
echo -e "\n${BOLD}Development Tools & Runtimes:${RESET}"
command -v git >/dev/null 2>&1 && check_item "Git" 0 "($(git --version | head -n 1))" || check_item "Git" 1 "Git is required"
command -v bash >/dev/null 2>&1 && check_item "Bash" 0 "(${BASH_VERSION})" || check_item "Bash" 1 "Bash is required"
command -v node >/dev/null 2>&1 && check_optional "Node.js" 0 "($(node --version))" || check_optional "Node.js" 1 ""
command -v go >/dev/null 2>&1 && check_optional "Go" 0 "($(go version | awk '{print $3}'))" || check_optional "Go" 1 ""
command -v python3 >/dev/null 2>&1 && check_optional "Python 3" 0 "($(python3 --version | awk '{print $2}'))" || check_optional "Python 3" 1 ""
command -v docker >/dev/null 2>&1 && check_optional "Docker" 0 "($(docker --version | awk '{print $3}' | tr -d ','))" || check_optional "Docker" 1 ""

echo -e "\n${CYAN}──────────────────────────────────────────${RESET}"
echo -e "Version: ${BOLD}v${CURRENT_VER}${RESET}"
if [ $ERRORS -eq 0 ]; then
    echo -e "Status:  ${GREEN}${BOLD}HEALTHY${RESET} (All critical components active)"
    exit 0
else
    echo -e "Status:  ${RED}${BOLD}UNHEALTHY${RESET} (${ERRORS} errors found)"
    exit 1
fi
