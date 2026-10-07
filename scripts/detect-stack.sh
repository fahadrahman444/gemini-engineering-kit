#!/usr/bin/env bash
# Gemini Engineering Kit - Automatic Project Stack Detector
set -e

DIR="${1:-.}"
cd "$DIR"

CYAN="\033[0;36m"
BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RESET="\033[0m"

echo -e "${BOLD}${CYAN}Gemini Kit — Project Stack Detection${RESET}"
echo -e "${CYAN}Target:${RESET} $(pwd)"
echo -e "${CYAN}──────────────────────────────────────────${RESET}"

LANGS=()
FRAMEWORKS=()
DATABASES=()
TESTERS=()
LINTERS=()
RECOMMENDED_SKILLS=()

# 1. Detect Languages & Frameworks
if [ -f "package.json" ]; then
    LANGS+=("TypeScript/JavaScript (Node.js)")
    RECOMMENDED_SKILLS+=("modern-web-guidance" "anti-slop-cleanup" "mobile-first-ui")
    
    if grep -q '"next"' package.json; then
        FRAMEWORKS+=("Next.js")
    elif grep -q '"react"' package.json; then
        FRAMEWORKS+=("React")
    elif grep -q '"vue"' package.json; then
        FRAMEWORKS+=("Vue.js")
    elif grep -q '"express"' package.json; then
        FRAMEWORKS+=("Express")
    fi
    
    # DB in Node
    if grep -q '"@prisma/client"' package.json || [ -d "prisma" ]; then
        DATABASES+=("Prisma ORM")
        RECOMMENDED_SKILLS+=("database-engineering")
    fi
    if grep -q '"drizzle-orm"' package.json; then
        DATABASES+=("Drizzle ORM")
        RECOMMENDED_SKILLS+=("database-engineering")
    fi
    if grep -q '"pg"' package.json || grep -q '"postgres"' package.json; then
        DATABASES+=("PostgreSQL (Native Driver)")
        RECOMMENDED_SKILLS+=("database-engineering")
    fi

    # Linters / Testers
    if grep -q '"vitest"' package.json; then TESTERS+=("Vitest"); fi
    if grep -q '"jest"' package.json; then TESTERS+=("Jest"); fi
    if grep -q '"eslint"' package.json || [ -f ".eslintrc*" ]; then LINTERS+=("ESLint"); fi
fi

if [ -f "go.mod" ]; then
    LANGS+=("Go (Golang)")
    RECOMMENDED_SKILLS+=("security-auditing" "universal-debian-deploy")
    if grep -q "gin-gonic" go.mod; then FRAMEWORKS+=("Gin"); fi
    if grep -q "gorm.io" go.mod; then DATABASES+=("GORM"); RECOMMENDED_SKILLS+=("database-engineering"); fi
    if grep -q "jackc/pgx" go.mod || grep -q "lib/pq" go.mod; then DATABASES+=("PostgreSQL (pgx/pq)"); RECOMMENDED_SKILLS+=("database-engineering"); fi
    TESTERS+=("go test")
fi

if [ -f "Cargo.toml" ]; then
    LANGS+=("Rust")
    RECOMMENDED_SKILLS+=("anti-slop-cleanup" "security-auditing")
    TESTERS+=("cargo test")
fi

if [ -f "pyproject.toml" ] || [ -f "requirements.txt" ]; then
    LANGS+=("Python")
    if [ -f "requirements.txt" ]; then
        if grep -qi "fastapi" requirements.txt; then FRAMEWORKS+=("FastAPI"); fi
        if grep -qi "django" requirements.txt; then FRAMEWORKS+=("Django"); fi
        if grep -qi "flask" requirements.txt; then FRAMEWORKS+=("Flask"); fi
    fi
    TESTERS+=("pytest")
fi

if [ -f "Dockerfile" ] || [ -f "docker-compose.yml" ] || [ -f "compose.yaml" ]; then
    FRAMEWORKS+=("Docker / Containerized")
    RECOMMENDED_SKILLS+=("universal-debian-deploy")
fi

# Fallback recommendations
RECOMMENDED_SKILLS+=("context-and-session-optimization" "full-project-audit")

# Unique list of skills
UNIQUE_SKILLS=($(echo "${RECOMMENDED_SKILLS[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

echo -e "${BOLD}Detected Languages:${RESET}  ${GREEN}${LANGS[*]:-Unknown}${RESET}"
echo -e "${BOLD}Detected Frameworks:${RESET}  ${GREEN}${FRAMEWORKS[*]:-None/Custom}${RESET}"
echo -e "${BOLD}Detected Databases:${RESET}   ${GREEN}${DATABASES[*]:-None detected}${RESET}"
echo -e "${BOLD}Detected Tests:${RESET}       ${GREEN}${TESTERS[*]:-None detected}${RESET}"
echo -e "${BOLD}Detected Linters:${RESET}     ${GREEN}${LINTERS[*]:-None detected}${RESET}"
echo -e "\n${BOLD}${YELLOW}Active Recommended Skills:${RESET}"
for s in "${UNIQUE_SKILLS[@]}"; do
    echo -e "  • ${s}"
done
