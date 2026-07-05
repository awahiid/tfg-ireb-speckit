# IRB RE Constitution for SpecKit

**Version**: 1.0 | **Ratified**: 2026-06-13  
**Based on**: IREB CPRE Foundation Level, ISO/IEC/IEEE 29148, INCOSE Guide for Writing Requirements

## Core Principles

### I. Verifiability Mandate

All requirements must include an observable verification criterion. No requirement shall be considered complete without a method to confirm its fulfillment through testing, analysis, inspection, or demonstration.

Rationale: ISO 29148 requires every requirement to be verifiable. A requirement without a verification criterion cannot be evaluated and therefore has no value.

### II. Functional Minimality

Implement exactly what is specified. No speculative features, no "might need later" additions. If a requirement does not ask for a behavior, it shall not be implemented.

Rationale: IREB Principle of Value Orientation. Implementing unrequested features is waste and introduces unverified behavior.

### III. Complete Traceability

Every implementation decision must be traceable back to a specific requirement. The chain requirement → intent → implementation → evidence shall be reconstructible.

Rationale: ISO 29148 requires bidirectional traceability. Without it, impact analysis, verification, and maintenance become impossible.

### IV. Requirement Type Classification

Distinguish between functional requirements, quality requirements, and constraints. Functional requirements describe what the system does. Quality requirements describe how well it does it (performance, security, usability). Constraints limit the solution space (technology, regulation, business rules).

Rationale: IREB distinguishes these three categories to enable differentiated analysis, prioritization, and validation.

### V. No Ambiguity

Avoid subjective terms: "fast", "efficient", "intuitive", "adequate". Use concrete, measurable criteria. When ambiguity is unavoidable, mark it explicitly.

Rationale: ISO 29148 and INCOSE require requirements to be unambiguous. Ambiguity propagates through the entire pipeline and produces incorrect implementations.

### VI. Single Obligation

Each requirement shall express exactly one behavior. A condition is not an additional obligation. Two independent actions belong in two separate requirements.

Rationale: INCOSE sets singularity as an essential characteristic. Multiple obligations in one requirement prevent independent verification.

## Development Workflow

### Quality Gates

- Before plan: verify all requirements pass the IREB quality checklist (verifiability, no ambiguity, single obligation, type classified, source documented, rationale present).
- Before implement: run cross-artifact consistency analysis (spec → plan → tasks).
- After implement: verify traceability chain is complete.

### Input Standards

- Requirements must follow the IREB formalization template with 12 attributes prior to `/speckit.specify`.
- The constitution shall be customized for each project before the first `/speckit.specify`.

## Governance

This constitution supersedes default SpecKit development practices. Amendments require documented rationale and review. All tasks and implementations must comply with these principles.

**Version**: 1.0 | **Ratified**: 2026-06-13 | **Last Amended**: 2026-06-13
