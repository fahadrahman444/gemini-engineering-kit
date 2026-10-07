# Gemini Engineering Kit 🛠️

[![CI](https://github.com/fahadrahman444/gemini-engineering-kit/actions/workflows/ci.yml/badge.svg)](https://github.com/fahadrahman444/gemini-engineering-kit/actions/workflows/ci.yml)
[![Version](https://img.shields.io/badge/version-v1.0.0-blue.svg)](VERSION)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**Gemini Engineering Kit** is an enterprise-grade agent engineering framework and CLI tool for Google Antigravity and AI coding assistants. It combines **System 1 / System 2 execution pipelines**, **hybrid deterministic machine verification**, **mobile-first standards**, and **strict anti-slop rules** into a single cohesive toolkit.

---

## 🏗️ Architecture Overview

```text
                 GEMINI ENGINEERING KIT
                           │
             ┌─────────────┴─────────────┐
             │                           │
           RULES                       TOOLS
             │                           │
       ┌─────┼─────┐              ┌──────┼──────┐
       │     │     │              │      │      │
     Core Security Git          Audit  Verify  Doctor
       │
       ▼
     AGENTS (Personas)
       │
 ┌─────┼───────────────┐
 │     │       │       │
Scout Planner Coder Reviewer
 │     │       │       │
 └─────┴───────┴───────┘
             │
             ▼
         WORKFLOWS
             │
 ┌───────────┼────────────┐
 │           │            │
Feature     Bugfix       Deploy
 │           │            │
 └───────────┼────────────┘
             ▼
     PROJECT STATE (.agents/state/)
```

- **Rules (`rules/`):** How the agent behaves (minimalism, security, AI prompt-injection defense).
- **Skills (`skills/`):** How specific technical procedures are executed (deployment, responsive UI, database).
- **Agents (`agents/`):** Specialized persona definitions (Scout, Planner, Implementer, Tester, Reviewer).
- **Workflows (`workflows/`):** Dynamic orchestrator routing tasks by complexity (**Simple**, **Standard**, **Complex**).
- **Tools (`bin/gemini-kit`, `scripts/`):** Deterministic machine verification (stack detection, doctor, secret scans, audits).

---

## 🚀 Installation

### 1-Command Installation
```bash
git clone https://github.com/fahadrahman444/gemini-engineering-kit.git ~/.gemini/config
bash ~/.gemini/config/install.sh
```

### Verification
```bash
gemini-kit doctor
```

---

## ⚡ CLI Commands

```bash
# Bootstrap agent state & rules in any project
gemini-kit init

# Check environment health & mounted skills
gemini-kit doctor

# Automatically detect languages, frameworks, DBs, and active skills
gemini-kit stack

# Run deterministic typechecking, linting, and tests
gemini-kit verify

# Run full security, secret, and code-slop audit
gemini-kit audit [output_path.md]

# Update engineering kit to latest version
gemini-kit update

# Safely uninstall with automated backup
gemini-kit uninstall
```

---

## 📦 What's Inside

### 1. Modular Rules (`rules/`)
- **`core.md`:** Ponytail Minimalist Ladder (YAGNI, platform standard library, minimal diffs).
- **`coding.md`:** Strict typing (no loose `any`), zero dead code, UI animation performance.
- **`security.md`:** Multi-tenant RLS isolation, JWT claim validation, IP rate limits.
- **`git.md`:** Pre-flight inspections, atomic conventional commits, no unapproved force-pushes.
- **`ai-safety.md`:** Prompt injection defense, untrusted repository input isolation.
- **`destructive-actions.md`:** Tiered escalation protocol for safe vs. critical shell operations.

### 2. Universal Skills (`skills/`)
- **`universal-debian-deploy`:** Linux VPS deployment for compiled binaries, Node/Python/JVM, Docker, and SPAs.
- **`mobile-first-ui`:** Dynamic viewports (`100dvh`), $\ge$44px touch targets, collision-safe typography.
- **`database-engineering`:** Zero-downtime migrations, concurrent index creation, transaction locking.
- **`dependency-management`:** 7-step anti-bloat evaluation protocol before adding new packages.
- **`security-auditing`:** Multi-tenant RLS sandboxing, JWT validation, input sanitization.
- **`full-project-audit`:** Deterministic per-file audit workflow.
- **`anti-slop-cleanup`:** CodeSlop and dead code elimination protocol.
- **`context-and-session-optimization`:** Token saving and persistent structured memory.

---

## 🔄 Task Orchestration Lifecycle

```
                    USER TASK
                       │
                       ▼
                ┌─────────────┐
                │ CLASSIFIER  │
                └──────┬──────┘
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
       SIMPLE       STANDARD      COMPLEX
          │            │            │
          │            ▼            ▼
          │          SCOUT       SCOUT
          │                         │
          │                         ▼
          │                       PLAN
          │                         │
          ▼                         ▼
                    IMPLEMENT
                        │
                        ▼
                      TEST
                        │
                        ▼
                     REVIEW
                        │
                        ▼
                     REPORT
```

---

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for details.
