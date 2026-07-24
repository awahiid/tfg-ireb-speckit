# Analyze Template — IREB Edition

> **Replaces**: Default SpecKit `analyze-template.md`
> **Governed by**: constitution Article 0 (Proportionality First)

Verifies consistency: REQ → spec → plan → tasks → code → tests.

---

## 0. Proportionality Check ← FIRST

| Tier | Max diff | Max files |
|---|---|---|
| Trivial | <200 lines | 1 file |
| Small | <500 lines | 1–2 files |
| Medium | <1000 lines | 2–5 files |
| Large | any | any |

- [ ] Diff size matches the declared tier
- [ ] No generated boilerplate (SpecKit init files, agent configs) counted as implementation
- [ ] If diff exceeds tier limits → ⚠️ OVER-SPECIFICATION

---

## 1. Traceability Matrix

| REQ-ID | Spec | Plan | Tasks | Code | Tests | Status |
|--------|------|------|-------|------|-------|--------|
| REQ-[...] | ✅/❌ | ✅/❌ | ✅/❌ | ✅/❌ | ✅/❌ | Complete/Incomplete |

---

## 2. Cross-Artifact Consistency

- [ ] Every plan decision references a REQ-ID
- [ ] All plan tasks are decomposed in tasks.md
- [ ] Every modified file has a corresponding task
- [ ] No orphan tasks (without REQ-ID)
- [ ] No modified files without REQ-ID traceability

---

## 3. Anti-Hallucination

- [ ] Code comments do NOT invent stakeholders, objectives, or context
- [ ] Commit/PR messages don't reference non-existent issues or PRs
- [ ] No fabricated source references

---

## 4. Test Coverage

| REQ-ID | Verification Criterion | Test | Covers? |
|--------|------------------------|------|---------|
| REQ-[...] | [from spec attribute 8] | [test] | ✅/❌ |

---

## Acceptance Gates

- [ ] 100% REQ-IDs traceable to code
- [ ] 0 orphan files
- [ ] Diff proportional to tier (see §0)
- [ ] 0 context hallucinations
- [ ] ≥80% verification criteria covered by tests (trivial: optional)

### Verdict
- ✅ PASS
- ⚠️ PASS with warnings (list)
- ❌ FAIL (list blockers)
