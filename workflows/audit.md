# Audit Workflow (Hybrid Machine + AI)

## Steps

1. **Deterministic Machine Scans:**
   - Execute secret scan, package audit, git cleanliness, and typecheck:
     `gemini-kit audit .agents/audits/audit_$(date +%F).md`

2. **AI Architectural Analysis:**
   - Review multi-tenant isolation, RLS policies, and authorization boundaries.
   - Review UI performance (backdrop blur lag, touch target footprints).
   - Review race condition locks and transaction boundaries.

3. **Consolidated Report:**
   - Produce standard audit document with severity rankings (`Critical`, `High`, `Medium`, `Low`).
   - Provide concrete, minimal remediation steps.
