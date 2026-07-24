# Implementation Plan Template — IREB Edition

> **Replaces**: Default SpecKit `plan-template.md`
> **Governed by**: constitution Article 0 (Proportionality First)

---

## Implementation Plan: [FEATURE]

**Spec**: [link] | **Tier**: [ Trivial / Small / Medium / Large ]

---

## Phase 0: Proportionality Gate ← FIRST

**Determine tier BEFORE anything else.** See constitution Article 0.

| Tier | Files | Plan content |
|---|---|---|
| **Trivial** | 1 | Skip Phases 1-3. Jump to §Implementation: list the file + 1 task. |
| **Small** | 1–2 | Minimal Phase 0. Skip architecture, data model, API contracts unless needed. |
| **Medium** | 2–5 | Full gates. Skip empty sections. |
| **Large** | 5+ | Complete plan. |

---

## Phase 0b: Pre-Implementation Gates (Medium+ only)

For Trivial and Small, skip to Phase 1 (or Implementation directly for Trivial).

### Verifiability Gate
- [ ] Every requirement has attribute 8 (Verification) with observable behavior
- [ ] No circular verification ("will be tested during QA")

### Anti-Ambiguity Gate
- [ ] No subjective terms: fast, efficient, intuitive, robust, adequate
- [ ] Quantitative criteria use concrete numbers

### Traceability Gate
- [ ] Every requirement has Source (attribute 5) and Rationale (attribute 6)
- [ ] Dependencies (attribute 11) documented if applicable

### Minimality Gate
- [ ] Plan covers ONLY files needed for the requirement
- [ ] No refactors, no new deps, no "while we're here"
- [ ] Each planned file maps to one REQ-ID

| Gate Result | Action |
|---|---|
| ALL pass | Proceed |
| 1-2 fail | Document in Complexity Tracking |
| ≥3 fail | **BLOCK**: fix spec first |

---

## Phase 1: Technical Design (Small+ only)

### 1.1 Files to Touch

| File | REQ-ID | Change |
|---|---|---|
| [path] | REQ-[...] | [what changes] |

### 1.2 Architecture (Medium+ only)

[Link each design decision to the requirement it implements.]

---

## Phase 2: Implementation Strategy

### 2.1 Test-First Order (Medium+ only)

For Trivial/Small: tests after or alongside implementation is fine.

1. Contracts → 2. Contract Tests → 3. Integration Tests → 4. Unit Tests → 5. Source

### 2.2 Tasks by Requirement

| REQ-ID | Tasks |
|---|---|
| REQ-[...] | 1. [task], ... |

Each task → exactly one REQ-ID. No orphans.

---

## Phase 3: Verification (Small+)

| REQ-ID | Verification Method | Expected Result |
|---|---|---|
| REQ-[...] | [test / inspection] | [expected] |

---

## Complexity Tracking

Exceptions to constitutional articles:

| Decision | Violation | Justification |
|---|---|---|
| [what] | [which article] | [why] |

---

## Post-Implementation

- [ ] Diff is proportional (trivial <200 lines, small <500, medium <1000)
- [ ] All REQ-IDs traceable to code
- [ ] 0 context hallucinations in comments/messages

### References

[1] Glinz, M. et al. (2024). *CPRE Foundation Level Handbook*, v1.2.0. IREB.
[2] ISO/IEC/IEEE 29148:2018.
[3] INCOSE (2012). *Guide for Writing Requirements*. INCOSE.
