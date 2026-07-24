# Analyze Template — IREB Edition

> **Replaces**: Default SpecKit `analyze-template.md`
> **Based on**: IREB CPRE §Traceability, ISO 29148 §6.3.1, INCOSE §Traceability

Verifies consistency and traceability of the full chain:
**REQ → spec → plan → tasks → code → tests**.

---

## 1. Traceability Matrix

Each REQ-ID must have at least one artifact at each level:

| REQ-ID | Spec | Plan | Tasks | Code | Tests | Status |
|--------|------|------|-------|------|-------|--------|
| REQ-APP-001 | ✅ | ✅ | ✅ | ✅ | ✅ | Complete |
| REQ-APP-002 | ✅ | ✅ | ❌ | — | — | No tasks |

---

## 2. Spec ↔ Plan Consistency

- [ ] Does every plan decision reference a REQ-ID?
- [ ] Are there untraceable architecture decisions?
- [ ] Does the plan contradict any spec verification criterion?

---

## 3. Plan ↔ Tasks Consistency

- [ ] Are all plan tasks decomposed?
- [ ] Are there orphan tasks without a corresponding plan item?
- [ ] Does task ordering respect plan dependencies?

---

## 4. Tasks ↔ Code Consistency

- [ ] Does every modified file have a REQ-ID in its header?
- [ ] Are there modified files without a corresponding task?
- [ ] Are there tasks with no generated code?

---

## 5. External Traceability (IREB medium)

- [ ] Does every requirement link to its original source?
- [ ] Are there broken links in the source → spec chain?

---

## 6. Anti-Hallucination Verification

- [ ] Does the code contain comments that invent stakeholders or objectives?
- [ ] Do commit/PR messages reference non-existent sources?
- [ ] Does the generated changelog mention unverifiable issues/PRs?

---

## 7. Test Coverage

| REQ-ID | Verification Criterion | Associated Test | Covers? |
|--------|------------------------|---------------|---------|
| REQ-APP-001 | 415 response on disallowed MIME | `test_upload_mime_rejected` | ✅ |
| REQ-APP-001 | 200 response on allowed MIME | `test_upload_mime_accepted` | ✅ |

---

## Output Format

```markdown
## Analyze Report

### Traceability
- Total REQ: N
- Complete traceability: M (X%)
- Broken links: K

### Gaps
- [REQ-ID] missing task / missing code / missing test

### Orphans
- File X modified without REQ-ID
- Task Y without REQ-ID

### Hallucinations detected
- (empty if none)

### Verdict
- ✅ PASS — ready to implement
- ⚠️ PASS with warnings (list)
- ❌ FAIL (list blockers)
```

---

## Acceptance Gates

For the analysis to be considered passed:
- [ ] 100% of REQ-IDs traceable to code
- [ ] 0 orphan files (without REQ-ID)
- [ ] 0 context hallucinations
- [ ] ≥ 80% of verification criteria covered by tests
