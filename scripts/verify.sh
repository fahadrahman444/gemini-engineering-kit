#!/usr/bin/env bash
# Gemini Engineering Kit - Deterministic Code Verification Script
set -e

DIR="${1:-.}"
cd "$DIR"

GREEN="\033[0;32m"
RED="\033[0;31m"
CYAN="\033[0;36m"
BOLD="\033[1m"
RESET="\033[0m"

echo -e "${BOLD}${CYAN}Gemini Kit — Deterministic Verification Pipeline${RESET}"
echo -e "${CYAN}──────────────────────────────────────────────────${RESET}"

FAILURES=0

run_check() {
    local label="$1"
    local cmd="$2"

    echo -ne "  Running ${BOLD}${label}${RESET}... "
    if eval "$cmd" >/tmp/verify_out.log 2>&1; then
        echo -e "${GREEN}PASS${RESET}"
    else
        echo -e "${RED}FAIL${RESET}"
        cat /tmp/verify_out.log | tail -n 15
        FAILURES=$((FAILURES + 1))
    fi
}

# 1. TypeScript / JavaScript
if [ -f "tsconfig.json" ] || [ -f "package.json" ]; then
    if npx --no-install tsc --version >/dev/null 2>&1; then
        run_check "TypeScript Typecheck" "npx tsc --noEmit"
    fi
    if [ -f ".eslintrc*" ] || grep -q '"eslint"' package.json 2>/dev/null; then
        run_check "ESLint" "npx eslint . --max-warnings=0"
    fi
    if npm run test --if-present --dry-run >/dev/null 2>&1; then
        run_check "Unit Tests" "npm test"
    fi
fi

# 2. Go (Golang)
if [ -f "go.mod" ]; then
    run_check "Go Vet" "go vet ./..."
    run_check "Go Test" "go test -v ./..."
fi

# 3. Rust
if [ -f "Cargo.toml" ]; then
    run_check "Cargo Check" "cargo check"
    run_check "Cargo Test" "cargo test"
fi

# 4. Git Diff Check (Trailing whitespace / conflict markers)
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    run_check "Git Diff Check" "git diff --check"
fi

echo -e "${CYAN}──────────────────────────────────────────────────${RESET}"
if [ $FAILURES -eq 0 ]; then
    echo -e "Result: ${GREEN}${BOLD}ALL CHECKS PASSED${RESET}"
    exit 0
else
    echo -e "Result: ${RED}${BOLD}${FAILURES} CHECKS FAILED${RESET}"
    exit 1
fi
