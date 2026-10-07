# Feature Implementation Workflow

## Steps

1. **Scout & Context:**
   - Scout existing architecture, similar components, and database models.
   - Detect project stack and reusable helpers.

2. **Planning:**
   - For non-trivial features, draft a plan in `.agents/plans/<feature-name>.md`.
   - Specify file paths, type contracts, and DB schema requirements.

3. **Implementation:**
   - Implement backend schemas/routes first, followed by frontend UI components.
   - Adhere to the Ponytail Minimalist Ladder (YAGNI, reuse existing utilities).
   - Implement mobile-first touch standards (≥44px touch targets).

4. **Testing & Verification:**
   - Run `gemini-kit verify` to validate types, lint, and test suites.
   - Add unit/integration tests covering new feature pathways.

5. **Review & Audit:**
   - Review diff (`git diff`) for loose types or unhandled edge cases.
   - Ensure mutation locks are present on UI trigger buttons.
