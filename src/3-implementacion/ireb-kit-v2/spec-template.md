# Feature Specification Template — IREB Edition

> **Replaces**: Default SpecKit `spec-template.md`
> **Governed by**: constitution Article 0 (Proportionality First)

This template mirrors `src/2-requisitos/plantilla.md`. Only 12 attributes per
requirement. No extra sections unless the requirement genuinely needs them.

**CRITICAL**: Do NOT add Quality Requirements, Constraints, Glossary, Traceability
Matrix, or User Stories sections unless the specific requirement demands them.
A changelog entry about a URL fix does not need a glossary.

| Change size | What to generate |
|---|---|
| **Trivial** (1 file, <20 LOC) | 1 requirement with 12 attributes. Nothing else. |
| **Small** (1–2 files) | 1–2 requirements. |
| **Medium** (2–5 files) | 2–5 requirements. Add Quality/Constraints only if the input mentions them. |
| **Large** (5+ files) | Full treatment, but still skip empty sections. |

---

## Feature: [FEATURE_NAME]

**Feature ID**: [###-feature-name]
**Source**: [from input only — changelog, PR, issue reference]

---

## Requirements

For each requirement, fill these 12 attributes. If the input lacks data
for an attribute, write "Not documented in the original source" (Source/Rationale)
or "None" (Dependencies).

### REQ-[PROJECT]-[NNN]: [SHORT_NAME]

| # | Attribute | Value |
|---|---|---|
| 1 | **ID** | `REQ-[PROJECT]-[NNN]` |
| 2 | **Name** | [2-8 word summary of the capability] |
| 3 | **Type** | [ Functional \| Quality \| Constraint ] |
| 4 | **Description** | The system shall [observable_verb] [object] [condition]. |
| 5 | **Source** | [document reference from input only — version, date, URL, identifier] |
| 6 | **Rationale** | [why this exists — from input, or "Not documented in the original source"] |
| 7 | **Priority** | [ High \| Medium \| Low ] |
| 8 | **Verification** | [observable criterion: API response, state change, log entry, event] |
| 9 | **Status** | Draft |
| 10 | **Version** | 1.0 |
| 11 | **Dependencies** | [REQ-IDs or "None"] |
| 12 | **Module** | [subsystem or functional area] |

---

## Rules for Description (attribute 4)

1. Single obligation per requirement.
2. MUST start with "The system shall".
3. Observable verb: validate, reject, return, notify, calculate, block, redirect,
   transform, store, send, delete, create, update, log, encrypt, hash, render.
4. NO subjective terms: fast, efficient, robust, intuitive, user-friendly.
5. Quantitative criteria where possible: "< 200ms", "≤ 3 attempts".
6. Verifiable by test, analysis, inspection, or demonstration.
7. Understandable without cross-referencing other requirements.
8. No implementation details unless it's an explicit constraint.

---

## Completeness Check

Before `/speckit.plan`, verify:

- [ ] All 12 attributes filled (or explicitly marked as absent)
- [ ] Description uses observable verb and "The system shall"
- [ ] No ambiguous terms
- [ ] Source and Rationale from input only — no invented context
- [ ] Verification is concrete and testable
- [ ] No extra sections added unless the input demands them

### References

[1] Glinz, M. et al. (2024). *CPRE Foundation Level Handbook*, v1.2.0. IREB.
[2] ISO/IEC/IEEE 29148:2018.
[3] INCOSE (2012). *Guide for Writing Requirements*. INCOSE.
