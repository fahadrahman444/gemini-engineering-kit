# Bugfix Workflow

## Steps

1. **Reproduce & Isolate:**
   - Locate failing test or error log.
   - Inspect call stack and relevant symbol definitions.

2. **Understand the Contract:**
   - Identify the exact mismatch between expected and actual behavior.
   - Avoid guessing in trial-and-error loops.

3. **Surgical Fix:**
   - Apply the minimal code edit needed to resolve the root cause.
   - Preserve existing documentation and surrounding code structure.

4. **Regression Verification:**
   - Run tests or add a regression test confirming the bug cannot reappear.
   - Run `gemini-kit verify`.
