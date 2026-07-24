# IREB Requirements Engineering Constitution
**For GitHub SpecKit (SDD)**

> **Version**: 2.0 | **Ratified**: 2026-06-13 | **Last Amended**: 2026-07-22
> **Based on**: IREB CPRE Foundation Level [1], ISO/IEC/IEEE 29148:2018 [2], INCOSE [3].

---

## Article 0 — Proportionality First ← OVERRIDING

**Adapt the process to the problem, not the problem to the process.**

| Change size | Spec | Tasks | Tests | Checklist |
|---|---|---|---|---|
| **Trivial** (1 file, <20 LOC) | 1 FR with verification | 1 task | 1 test optional | R7+R9+R13 only |
| **Small** (1–2 files) | 1–2 FRs | 2–3 tasks | required | core criteria |
| **Medium** (2–5 files) | full spec, skip empty sections | normal | required | full |
| **Large** (5+ files) | complete spec | full | required | full |

Do NOT generate user stories, acceptance scenarios, glossaries, or quality requirements
unless the change genuinely needs them. A one-line URL fix does not need a user story.

> *Ref*: INCOSE warns against gold-plating [3, §3.4]. IREB Principle 1: requirements are a means, not an end [1].

---

## Article I — No Hallucination ← BLOCKING

Source, Rationale, and stakeholder information MUST come exclusively from the input.
If the input lacks information for a field, write "no additional documented source".
NEVER invent stakeholders, business objectives, issues, PRs, or organizational context.

> *Ref*: IREB Source attribute [1, Glossary]; ISO 29148 traceability [2, §6.3.1].

---

## Article II — Verifiability

Every requirement MUST have at least one observable verification criterion
(API response, state change, log entry, error code, event). Use concrete verbs:
validate, reject, return, notify, calculate, block, redirect, transform.

Avoid: manage, handle, support, process, optimize, ensure.

> *Ref*: ISO 29148 §6.2.2 [2]; INCOSE observable verbs [3].

---

## Article III — Minimality

Implement EXACTLY what is specified. No refactors, no new dependencies,
no "while we're here" changes, no future-proofing. If the requirement
doesn't ask for it, don't do it.

> *Ref*: ISO 29148 §5.2.2 — each requirement must be "necessary" [2].

---

## Article IV — Traceability

Every artifact (spec, plan, task, code, test) SHALL link to a REQ-ID.
No orphan tasks. No untraceable code.

> *Ref*: IREB bidirectional traceability [1, Glossary]; ISO 29148 §6.2.2 [2].

---

## Article V — No Ambiguity

No subjective terms: fast, efficient, intuitive, robust, user-friendly, adequate.
Use numbers: "<X ms", "<N% error rate". If ambiguity cannot be resolved from
the source, mark it explicitly.

> *Ref*: ISO 29148 §6.2.2 unambiguous [2]; INCOSE [3, §Unambiguous].

---

## Article VI — Single Obligation

One behavior per requirement. Conditions ("if X", "when Y") are allowed.
Two independent actions → two separate requirements.

> *Ref*: INCOSE singularity [3, §Singular].

---

## Article VII — Classification

Every requirement MUST have exactly one Type: Functional / Quality / Constraint.

> *Ref*: IREB requirement types [1, §Requirements Types].

---

## Article VIII — Source + Rationale

Every requirement MUST document:
- **Source**: where it comes from (document, changelog, PR) — enough detail to locate it.
- **Rationale**: why it exists — what problem it solves.

> *Ref*: IREB Source and Rationale attributes [1, Glossary].

---

## Article IX — Continuous QA

Quality checks SHALL be applied throughout the pipeline, not just at the end:
clarify → checklist → analyze (pre) → implement → analyze (post).

> *Ref*: IREB Principle 9 [1, pp. 16-18]; ISO 29148 §5.3 [2].

---

## Governance

This constitution supersedes default SpecKit practices. Amendments require
documented rationale. All artifacts shall comply with these Articles.

**Version**: 2.0 | **Ratified**: 2026-06-13 | **Last Amended**: 2026-07-22

---

### References

[1] Glinz, M. et al. (2024). *CPRE Foundation Level Handbook*, v1.2.0. IREB.
[2] ISO/IEC/IEEE 29148:2018.
[3] INCOSE (2012). *Guide for Writing Requirements*. INCOSE.
