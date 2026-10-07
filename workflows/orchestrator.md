# Task Orchestrator & Execution Pipeline

The orchestrator dynamically routes incoming user requests through the appropriate execution pipeline based on task complexity.

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

## 1. Complexity Classification

### 🟢 Simple (System 1: Fast Execution)
- Minor UI styling adjustments, typo fixes, simple helper updates, answering questions.
- **Pipeline:** Direct Implementer $\rightarrow$ Quick Verify $\rightarrow$ Report.

### 🟡 Standard (System 2: Targeted Inspection)
- Standard bug fixes, adding a simple API endpoint, single-component refactors.
- **Pipeline:** Scout $\rightarrow$ Implementer $\rightarrow$ Tester $\rightarrow$ Reviewer $\rightarrow$ Report.

### 🔴 Complex (System 2: Full Architecture & Deliberation)
- Multi-service features, database migrations, security redesign, major refactors.
- **Pipeline:** Scout $\rightarrow$ Planner (Create `PLAN.md`) $\rightarrow$ Implementer $\rightarrow$ Tester $\rightarrow$ Reviewer $\rightarrow$ Report.
