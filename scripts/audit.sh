#!/usr/bin/env bash
# Gemini Engineering Kit - Deterministic Security & Code Quality Audit Script
set -e

DIR="${1:-.}"
OUTPUT_FILE="${2:-}"
cd "$DIR"

DATE_STR=$(date +%F)
TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M:%SZ")

AUDIT_MD="# Project Engineering Audit Report

**Date:** ${DATE_STR}  
**Timestamp:** ${TIMESTAMP}  
**Target:** $(pwd)  

---

## 1. Executive Summary

| Check Area | Status | Notes |
| :--- | :--- | :--- |"

CRITICAL_ISSUES=()
HIGH_ISSUES=()
MEDIUM_ISSUES=()
LOW_ISSUES=()

# 1. Secret Scanning
echo "==> Scanning for exposed secrets..."
SECRETS_FOUND=0
if grep -rniE "(BEGIN (RSA|EC|OPENSSH|PGP) PRIVATE KEY|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z\\-_]{35}|ghp_[0-9a-zA-Z]{36})" . \
    --exclude-dir={.git,node_modules,dist,build,vendor,.gemini} 2>/dev/null; then
    CRITICAL_ISSUES+=("High-entropy private key or API token found in repository files.")
    SECRETS_FOUND=1
fi

if [ $SECRETS_FOUND -eq 0 ]; then
    AUDIT_MD+="\n| **Secret Scan** | ✅ PASS | No hardcoded API keys or private keys found |"
else
    AUDIT_MD+="\n| **Secret Scan** | ❌ CRITICAL | Hardcoded credentials detected |"
fi

# 2. Git Status & Uncommitted Changes
echo "==> Checking git cleanliness..."
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    MODIFIED_FILES=$(git status --porcelain | wc -l)
    if [ "$MODIFIED_FILES" -gt 0 ]; then
        MEDIUM_ISSUES+=("${MODIFIED_FILES} uncommitted or untracked changes currently present.")
        AUDIT_MD+="\n| **Git Working Tree** | ⚠️ UNCOMMITTED | ${MODIFIED_FILES} modified/untracked files |"
    else
        AUDIT_MD+="\n| **Git Working Tree** | ✅ CLEAN | Working directory clean |"
    fi
fi

# 3. Slop & Loose Typing Check
echo "==> Scanning for CodeSlop & loose typing..."
SLOP_COUNT=0
if [ -d "src" ] || [ -d "app" ] || [ -d "frontend" ] || [ -d "backend" ]; then
    ANY_TYPES=$(grep -rnE ":\s*any\b" src/ app/ frontend/ backend/ 2>/dev/null | grep -v "node_modules" | wc -l || echo 0)
    if [ "$ANY_TYPES" -gt 0 ]; then
        LOW_ISSUES+=("${ANY_TYPES} instances of loose ': any' type annotations found.")
        SLOP_COUNT=$((SLOP_COUNT + ANY_TYPES))
    fi
fi

if [ $SLOP_COUNT -eq 0 ]; then
    AUDIT_MD+="\n| **Strict Typing & Anti-Slop** | ✅ PASS | No loose 'any' types detected |"
else
    AUDIT_MD+="\n| **Strict Typing & Anti-Slop** | ⚠️ NOTICE | ${SLOP_COUNT} potential slop/loose types found |"
fi

# 4. Dependency Vulnerabilities
if [ -f "package.json" ]; then
    echo "==> Auditing npm dependencies..."
    if npm audit --audit-level=high >/tmp/npm_audit.log 2>&1; then
        AUDIT_MD+="\n| **Dependencies (npm)** | ✅ PASS | Zero high/critical vulnerabilities |"
    else
        HIGH_ISSUES+=("npm audit reported high or critical severity package vulnerabilities.")
        AUDIT_MD+="\n| **Dependencies (npm)** | ⚠️ HIGH | Vulnerabilities reported in npm audit |"
    fi
fi

# Finalizing Report
AUDIT_MD+="

---

## 2. Findings by Severity

### 🚨 Critical
"
if [ ${#CRITICAL_ISSUES[@]} -eq 0 ]; then
    AUDIT_MD+="*None detected.*\n"
else
    for i in "${CRITICAL_ISSUES[@]}"; do AUDIT_MD+="- ${i}\n"; done
fi

AUDIT_MD+="
### ⚠️ High
"
if [ ${#HIGH_ISSUES[@]} -eq 0 ]; then
    AUDIT_MD+="*None detected.*\n"
else
    for i in "${HIGH_ISSUES[@]}"; do AUDIT_MD+="- ${i}\n"; done
fi

AUDIT_MD+="
### ℹ️ Medium & Low
"
if [ ${#MEDIUM_ISSUES[@]} -eq 0 ] && [ ${#LOW_ISSUES[@]} -eq 0 ]; then
    AUDIT_MD+="*None detected.*\n"
else
    for i in "${MEDIUM_ISSUES[@]}"; do AUDIT_MD+="- [MEDIUM] ${i}\n"; done
    for i in "${LOW_ISSUES[@]}"; do AUDIT_MD+="- [LOW] ${i}\n"; done
fi

AUDIT_MD+="
---

## 3. Recommended Actions
1. Address any critical secret or authentication findings before committing.
2. Run \`gemini-kit verify\` to validate compilers and unit test suites.
3. Clean dead code and enforce strict types using the \`anti-slop-cleanup\` skill.
"

if [ -n "$OUTPUT_FILE" ]; then
    mkdir -p "$(dirname "$OUTPUT_FILE")"
    echo -e "$AUDIT_MD" > "$OUTPUT_FILE"
    echo "==> Audit saved to: $OUTPUT_FILE"
else
    echo -e "$AUDIT_MD"
fi
