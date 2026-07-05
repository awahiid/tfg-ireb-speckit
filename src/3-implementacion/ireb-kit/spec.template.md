# Feature Specification Template — IREB Edition

> **Replaces**: Default SpecKit `spec-template.md`
> **Based on**: IREB CPRE Foundation Level Handbook [1], ISO/IEC/IEEE 29148:2018 [2],
> INCOSE Guide for Writing Requirements [3].

---

## Template Structure

This template replaces the default SpecKit spec-template. It enforces
IREB-compliant requirement attributes, verifiability criteria, and
traceability to sources. The SpecKit agent fills this template when
`/speckit.specify` is executed with a requirement formalized using the
IREB template.

---

## Feature: [FEATURE_NAME]

**Feature ID**: [###-feature-name]
**Branch**: `[###-feature-name]`
**Created**: [DATE]
**Source**: [Stakeholder / Document / Changelog / PR / Issue / Regulation]

---

## 1. Requirements

Each requirement MUST include all required attributes. Requirements
without verification criteria or source SHALL NOT be considered complete.

### REQ-[PROJECT]-[NNN]: [SHORT_NAME]

| Attribute | Value |
|---|---|
| **Type** | [ Functional \| Quality \| Constraint ] |
| **Priority** | [ High \| Medium \| Low ] |
| **Source** | [Document reference with version/date/URL] |
| **Rationale** | [Why this requirement exists] |
| **Module** | [Subsystem or functional area] |
| **Dependencies** | [REQ-IDs or "None"] |

**Formal Description**:
El sistema deberá [observable_verb] [object] [condition].

> **Rule**: Follow the INCOSE pattern: "The system shall [verb] [object]
> [condition]". Use observable verbs: "generate", "register", "reject",
> "return", "prevent", "notify", "calculate", "validate", "block".
> Avoid ambiguous verbs: "manage", "handle", "process", "support",
> "facilitate", "improve", "provide".
> *Reference*: INCOSE Guide [3, §Structure].

**Verification**:
[Observable criterion: how to confirm compliance. Must be testable,
measurable, or inspectable. Include expected output, error codes,
state changes, or log entries.]

> **Rule**: The verification criterion must be an observable behavior,
> not a vague intention. Valid examples: "The API shall return HTTP 401
> if the token has expired", "The system shall persist the creation
> timestamp with UTC timezone". Invalid: "It will be tested during QA".
> *Reference*: ISO 29148 §6.2.2 [2].

**Acceptance Scenarios**:
1. [Given... When... Then...]
2. [Given... When... Then...]

---

## 2. Quality Requirements

If applicable, specify measurable quality criteria:

| ID | Attribute | Target | Measurement Method |
|---|---|---|---|
| Q-[NNN] | [Response Time / Throughput / Accuracy / Availability] | [value] [unit] | [how to measure] |

> **Rule**: Quality requirements must be measurable. "The system should
> be fast" is not valid. "The system shall respond in less than 200ms
> for 95% of requests" is valid.
> *Reference*: ISO 29148 §6.2.2 [2], IREB §Quality Requirements [1].

---

## 3. Constraints

If applicable, specify constraints on the solution:

| ID | Type | Description |
|---|---|---|
| C-[NNN] | [Technology / Regulation / Business Rule / Organizational] | [Specific constraint] |

> **Rule**: Constraints are NOT functional requirements. They limit the
> solution space and must be verifiable. Example: "The implementation
> shall not introduce new external dependencies" is a constraint; "The
> system shall authenticate users" is functional.
> *Reference*: IREB §Constraints [1].

---

## 4. Domain Glossary

Terms with specific meaning in this feature's context:

| Term | Definition |
|---|---|
| [term] | [precise definition] |

> **Rule**: Define domain-specific terms to ensure shared understanding.
> *Reference*: IREB Principle 5 (Common Language) [1, pp. 16-18].

---

## 5. Completeness Checklist

Before proceeding to `/speckit.plan`, verify:

- [ ] All requirements have a Type (Functional / Quality / Constraint)
- [ ] All requirements have a Source with document reference
- [ ] All requirements have a Rationale
- [ ] All requirements have a Verification criterion
- [ ] All requirements have a measurable or observable verb
- [ ] No [NEEDS CLARIFICATION] markers remain (max 3)
- [ ] No ambiguous terms (fast, efficient, robust, user-friendly)
- [ ] Quality requirements include numeric targets
- [ ] All terms are defined in the glossary
- [ ] All dependencies between requirements are documented

> **Reference**: Criteria based on ISO 29148 §6.2.2 [2] and
> INCOSE characteristics of individual requirements [3].

---

## 6. Traceability Matrix

| REQ-ID | Source | Spec Section | Plan Section | Task IDs | Test File |
|---|---|---|---|---|---|
| REQ-[P]-[N] | [changelog/PR] | [##] | [plan ###] | [T###] | [test file] |

> **Rule**: This matrix is populated as the pipeline progresses.
> The SpecKit agent generates it, but the template must request it.
> *Reference*: IREB Traceability definition [1, Glossary].

---

## Field Validation Rules

The SpecKit agent MUST enforce these rules when filling the template:

| Field | Rule | Reference |
|---|---|---|
| Type | Must be exactly one of: Functional, Quality, Constraint | IREB §Requirements Types [1] |
| Priority | Must be exactly one of: High, Medium, Low | IREB §Stakeholder Priority [1] |
| Source | Must include at minimum: document type, version/date/identifier | ISO 29148 §6.3.1 [2] |
| Formal Description | Must start with "El sistema deberá" + observable verb | INCOSE §Structure [3] |
| Verification | Must describe observable behavior, not intention | ISO 29148 §6.2.2 [2] |
| Rationale | Must answer "why does this exist" | IREB §Rationale [1] |

---

### References

[1] Glinz, M. et al. (2024). *CPRE Foundation Level Handbook*, v1.2.0. IREB.
[2] ISO/IEC/IEEE 29148:2018.
[3] INCOSE (2012). *Guide for Writing Requirements*. INCOSE.
