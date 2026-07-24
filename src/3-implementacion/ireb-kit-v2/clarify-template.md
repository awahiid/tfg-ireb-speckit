# Clarify Template — IREB Edition

> **Replaces**: Default SpecKit `clarify-template.md`
> **Based on**: IREB CPRE §Validation, ISO 29148 §6.2.2

Detects defects in the specification. Only flag problems, do NOT resolve them.
If there are no problems, state it explicitly.

---

## 1. Lexical Ambiguities

Non-observable terms that must be replaced:

| Term | Problem | IREB Alternative (use placeholders, not fixed values) |
|---------|----------|-----------------|
| fast, efficient | Not verifiable | "responds in <X ms" |
| robust, reliable | Not verifiable | "tolerates failures with N retries" |
| intuitive, easy | Subjective | "completes the task in ≤N steps" |
| manage, handle | Weak verb | "create, modify, delete" |
| support | Weak verb | "accept, process, validate" |

- [ ] Are any terms from the list above present in the specification?
- [ ] Are there other ambiguous terms not listed?

---

## 2. Missing Verification Criteria

- [ ] Is any requirement missing attribute 8 (Verification)?
- [ ] Does any criterion use non-observable verbs?

---

## 3. Missing Classification

- [ ] Is any requirement missing attribute 3 (Type)?
- [ ] Is any Type not one of: Functional, Quality, Constraint?

---

## 4. Incomplete Attributes

Review all 12 attributes per requirement: ID, Name, Type, Description, Source,
Rationale, Priority, Verification, Status, Version, Dependencies, Module.

- [ ] Are any attributes empty without explicit "None" or "Not documented" marker?
- [ ] Does Source lack version/PR/commit reference?
- [ ] Is Rationale empty or generic?

---

## 5. Context Hallucination ← CRITICAL

- [ ] Does Source mention stakeholders, teams, or departments not in the input?
- [ ] Does Rationale invent undeclared business objectives?
- [ ] Are issues, PRs, or documents referenced that are not in the input?
- [ ] Is any organizational context fabricated (why, who, from where)?

If any → ❌ CONTEXT HALLUCINATION. Requirement must be rewritten.

---

## Output Format

```markdown
## Clarify Report

### Detected Ambiguities
- [REQ-ID] "term" → suggestion (non-binding)

### Missing Verification Criteria
- [REQ-ID] missing verification

### Missing Classification
- [REQ-ID] missing Type

### Incomplete Attributes
- [REQ-ID] attribute X empty

### Context Hallucinations
- [REQ-ID] invents Y not present in input

### Summary
- Total problems: N
- Blocking (hallucinations): M
```
