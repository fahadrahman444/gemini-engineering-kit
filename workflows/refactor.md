# Refactoring Workflow

## Steps

1. **Pre-Check:**
   - Verify working tree is clean with `git status`.
   - Ensure existing tests pass before touching code.

2. **Refactor in Small Steps:**
   - Eliminate CodeSlop (dead code, padding comments, loose types).
   - Consolidate duplicated logic into shared standard helpers.
   - Maintain public API contracts and type signatures.

3. **Verify Each Step:**
   - Run typechecker and unit tests after each contiguous block change.

4. **Diff Review:**
   - Ensure no unintended behavioral side effects were introduced.
