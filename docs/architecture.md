# Gemini Engineering Kit — Architecture Guide

## System Overview

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

## Conceptual Hierarchy
1. **Rules (`rules/`):** Universal laws defining *how the agent behaves* (minimalism, security, AI safety).
2. **Skills (`skills/`):** Detailed runbooks on *how specific technical procedures are executed*.
3. **Agents (`agents/`):** Specialized persona definitions defining *who does the work*.
4. **Workflows (`workflows/`):** Orchestrated steps routing *simple, standard, and complex tasks*.
5. **Tools (`bin/`, `scripts/`):** Deterministic machine verification tools running tests, secret scans, stack detection, and audits.
