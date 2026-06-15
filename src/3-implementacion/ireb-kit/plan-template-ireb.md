# Implementation Plan Template — IREB Edition

> **Replaces**: Default SpecKit `plan-template.md`
> **Based on**: IREB CPRE Foundation Level [1], ISO/IEC/IEEE 29148 [2],
> INCOSE Guide for Writing Requirements [3], Fagan Inspections [4].

---

## Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]

**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`
(IREB-formatted with 12 attributes).

---

## Phase 0: Pre-Implementation Gates (IREB)

These gates replace the default SpecKit gates (Simplicity Gate,
Anti-Abstraction Gate, Integration-First Gate). They verify that
the specification meets IREB quality standards BEFORE any technical
planning begins.

> *Reference*: Fagan (1976) established that structured gate inspections
> before implementation catch defects early when they are cheapest to
> fix [4]. IREB Principle 9 (Systematic Work) requires quality assurance
> throughout the lifecycle, not only at the end [1, pp. 16-18].

### Verifiability Gate (Article I)

- [ ] Every requirement has a verification criterion with observable behavior
- [ ] Verification criteria include expected outputs, error codes, or state changes
- [ ] No verification criterion is circular ("will be tested during QA")

### Anti-Ambiguity Gate (Article V)

- [ ] No subjective terms detected: fast, efficient, intuitive, robust, adequate
- [ ] All quantitative criteria use concrete numbers and units
- [ ] Remaining ambiguities are explicitly marked in the spec

### Traceability Gate (Articles III, VII)

- [ ] Every requirement has a Source field with document reference
- [ ] Every requirement has a Rationale field (explicit or inferred)
- [ ] Dependencies between requirements are documented (if applicable)

### Classification Gate (Article IV)

- [ ] Every requirement has a Type: Functional, Quality, or Constraint
- [ ] Quality requirements include numeric targets
- [ ] Constraints are distinguished from functional requirements

### Gate Decision

| Result | Action |
|---|---|
| ALL gates pass | Proceed to Phase 1 |
| 1-2 gates fail | Document exceptions in Complexity Tracking |
| ≥ 3 gates fail | **BLOCK**: Fix specification before planning |

---

## Phase 1: Technical Design

### 1.1 Technology Stack

| Component | Technology | Justification |
|---|---|---|
| [component] | [choice] | [linked to which requirement(s)] |

> **Rule**: Every technology choice must be traceable to a requirement
> or constraint. No "preference" without justification.
> *Reference*: Article III (Traceability).

### 1.2 Architecture Overview

[Describe the architectural approach. Link each design decision to
the specific requirement(s) it implements.]

> **Rule**: Architecture decisions without requirement traceability
> violate Article III and shall be documented as exceptions in the
> Complexity Tracking section.

### 1.3 Data Model

Key entities and their relationships, derived from the specification:

| Entity | Attributes | Related Requirements |
|---|---|---|
| [Entity] | [fields] | REQ-[...] |

### 1.4 API Contracts

| Endpoint / Event | Method | Request/Response | Implements |
|---|---|---|---|
| [path] | [GET, POST, event type] | [schema] | REQ-[...] |

---

## Phase 2: Implementation Strategy

### 2.1 File Creation Order (Test-First)

This order is mandated by the IREB constitution (Article I: Verifiability
and Article III: Traceability):

1. **Contracts** (`contracts/`): API specifications with expected behavior
2. **Contract Tests**: Verify contracts against the specification
3. **Integration Tests**: Verify component interactions
4. **Unit Tests**: Verify individual functions
5. **Source Files**: Implement to make tests pass

> *Reference*: INCOSE [3] and ISO 29148 [2] require verification before
> acceptance. Test-first ordering ensures verification is designed before
> implementation, not retrofitted.

### 2.2 Implementation Tasks by Requirement

Organize tasks by the requirement they implement, not by technical module:

| REQ-ID | Tasks |
|---|---|
| REQ-[P]-[N] | 1. [task], 2. [task], ... |

> *Rule*: Each task must be traceable to exactly one requirement.
> Tasks that serve multiple requirements must be split.
> *Reference*: Article VI (Single Obligation) [1].

---

## Phase 3: Verification Strategy

### 3.1 Verification by Requirement

| REQ-ID | Verification Method | Expected Result | Test File |
|---|---|---|---|
| REQ-[P]-[N] | [test / analysis / inspection / demonstration] | [expected] | [file] |

> *Rule*: The verification method must match the Verification field
> in the requirement specification. If the requirement says "API shall
> return HTTP 401", the verification must test that exact behavior.
> *Reference*: ISO 29148 §6.2.2 [2].

### 3.2 Regression Gate

Before accepting the implementation:

- [ ] All existing tests still pass (no regressions)
- [ ] All new tests pass
- [ ] Contract tests cover all API endpoints
- [ ] Traceability matrix is complete (REQ → test → implementation)

---

## Complexity Tracking

Any architectural decision that cannot be traced to a requirement,
or that violates a constitutional article, must be documented here:

| Decision | Violation | Justification | Approved |
|---|---|---|---|
| [what] | [which article] | [why still needed] | [yes/no] |

> *Reference*: Constitutional enforcement is not rigid prohibition
> but explicit accountability. Article IX (Continuous Quality
> Assurance) requires that exceptions be documented and justified [1].

---

## Post-Implementation Verification

After `/speckit.implement`:

- [ ] `/speckit.analyze` confirms spec ↔ plan ↔ tasks ↔ code consistency
- [ ] All verification tests pass
- [ ] Traceability chain is complete: REQ → spec → plan → task → test → code
- [ ] Updates to Constitution Sync Impact Report if implementation
  revealed principle violations

> *Reference*: IREB Principle 6 (Validation) requires confirming
> that the implementation matches the specified requirements [1,
> pp. 16-18].

---

### References

[1] Glinz, M. et al. (2024). *CPRE Foundation Level Handbook*, v1.2.0. IREB.
[2] ISO/IEC/IEEE 29148:2018.
[3] INCOSE (2012). *Guide for Writing Requirements*. INCOSE.
[4] Fagan, M.E. (1976). "Design and Code Inspections". *IBM Systems Journal*.
