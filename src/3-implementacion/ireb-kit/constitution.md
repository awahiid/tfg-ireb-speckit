# IREB Requirements Engineering Constitution
**For GitHub SpecKit (SDD)**

> **Version**: 1.0 | **Ratified**: 2026-06-13 | **Last Amended**: 2026-06-13
> **Based on**: IREB CPRE Foundation Level Handbook (Glinz et al., 2024) [1],
> ISO/IEC/IEEE 29148:2018 [2], INCOSE Guide for Writing Requirements (2012) [3].

---

## Article I — Verifiability Mandate

All requirements MUST include an observable verification criterion.
No requirement shall progress past specification without a defined method
to confirm its fulfillment through testing, analysis, inspection, or
demonstration.

**Justification**: ISO/IEC/IEEE 29148 §6.2.2 establishes verifiability as
an essential quality characteristic: "Each requirement shall be verifiable"
[2]. INCOSE reinforces this: "A requirement is verifiable if there exists
a finite, cost-effective process to check that the system meets the
requirement" [3, §Characteristics of Individual Requirements]. IREB
defines verifiability as "the degree to which the fulfillment of a
requirement by an implemented system can be verified" [1, Glossary].
A requirement without a verification criterion cannot be evaluated and
therefore has zero value in an engineering process.

---

## Article II — Functional Minimality

Implement EXACTLY what is specified. No speculative features, no
"might need later" additions, no future-proofing without an explicit
requirement. If a requirement does not ask for a behavior, it SHALL NOT
be implemented.

**Justification**: IREB Principle 1 (Value Orientation) states that
requirements are a means to achieve results, not a documentary end in
themselves [1, pp. 16-18]. Implementing unrequested features contradicts
this principle: it adds complexity without traceable value. ISO 29148
§5.2.2 requires that each requirement be "necessary" — a requirement is
necessary if it is essential to meet stakeholder needs [2].
Speculative code, by definition, has no stakeholder need behind it.

---

## Article III — Complete Traceability

Every implementation decision MUST be traceable back to a specific
requirement. The chain requirement → intent → implementation → evidence
SHALL be reconstructible for every case in the corpus.

**Justification**: ISO/IEC/IEEE 29148 §6.2.2 requires traceability as
an essential quality characteristic [2]. IREB defines traceability as
"the ability to trace a requirement back to its origins, forward to its
implementation in design and code and its associated tests, and to
requirements it depends on" [1, Glossary]. Without bidirectional
traceability, impact analysis, verification, and maintenance
become impossible. Fagan (1976) establishes that structured inspection
requires explicit traceability between specification and implementation [4].

---

## Article IV — Requirement Type Classification

Distinguish between three requirement types:
- **Functional**: describes what the system does (behavior, result).
- **Quality**: describes how well the system does it (performance,
  security, usability, reliability).
- **Constraint**: limits the solution space (technology, regulation,
  business rules, organizational policies).

Every requirement MUST be classified into exactly one of these
categories before proceeding to implementation.

**Justification**: IREB distinguishes explicitly between functional
requirements, quality requirements, and constraints [1, §Requirements
Types]. IEEE 29148 §5.2.1 establishes different categories of
requirements within a specification [2]. Differentiated classification
enables differentiated analysis, prioritization, and validation
strategies. Quality requirements, for instance, require measurement
criteria that functional requirements do not.

---

## Article V — No Ambiguity

Avoid subjective terms: "fast", "efficient", "intuitive", "adequate",
"appropriate", "sufficient", "user-friendly", "robust". Use concrete,
measurable criteria (time, throughput, accuracy, error rate). When
ambiguity cannot be resolved from the source text, the remaining
uncertainty SHALL be marked explicitly.

**Justification**: ISO 29148 §6.2.2 requires that requirements be
"unambiguous" — each requirement shall have only one interpretation [2].
INCOSE states: "Ambiguity is a primary source of requirements defects.
A requirement is unambiguous if it can be interpreted in only one way"
[3, §Unambiguous]. IREB defines unambiguity as "the degree to which a
requirement is expressed such that it cannot be understood differently
by different people" [1, Glossary]. Ambiguity propagates through the
entire pipeline and produces incorrect or unverifiable implementations.

---

## Article VI — Single Obligation

Each requirement SHALL express exactly one behavior, one capability,
or one constraint. A condition clause ("if X", "when Y", "unless Z")
is not an additional obligation. Two independent actions belong in two
separate requirements.

**Justification**: INCOSE establishes singularity as an essential
characteristic: "A requirement should state a single capability,
characteristic, constraint, or quality factor" [3, §Singular].
IEEE 830 §4.3.2 reinforces this: requirements should be "singular"
to enable independent verification and traceability. Multiple
obligations in one requirement prevent independent verification
and complicate change management — changing one obligation forces
re-verification of the other.

---

## Article VII — Source Documentation

Every requirement MUST document its origin. The source may be a
stakeholder, a document, a regulation, a legacy system, a changelog
entry, a pull request, or an issue. The source must include sufficient
information (version, date, URL, identifier) to allow anyone to
locate the original evidence.

**Justification**: IREB defines Source as a fundamental attribute:
"The source from which a requirement has been derived. Typical sources
are stakeholders, documents, existing systems and observations" [1,
Glossary]. ISO 29148 §6.3.1 contemplates documentary sources as valid
origins of requirements as long as they are identifiable and traceable
[2]. The source attribute supports backward traceability, one of the
two directions of the IREB traceability requirement.

---

## Article VIII — Rationale Requirement

Every requirement MUST include a rationale explaining WHY it exists.
The rationale answers: what problem does this requirement solve, or
what benefit does it provide? The rationale may be explicit (stated in
the source) or inferred from context, but it must be documented.

**Justification**: IREB defines Rationale as the justification of the
requirement and recommends documenting it to facilitate validation
and maintenance [1, §Requirements Documentation, attribute Rationale].
INCOSE considers the justification a key element for understanding the
underlying need [3, §Characteristics of Individual Requirements].
Without rationale, requirements become arbitrary — they cannot be
prioritized, negotiated, or validated against stakeholder goals.

---

## Article IX — Continuous Quality Assurance

Quality validation SHALL NOT be a one-time gate at the end of the
process. It shall be applied continuously: before planning (clarify,
checklist), after task definition (analyze), and after implementation
(analyze, conformance inspection).

**Justification**: IREB Principle 9 (Systematic and Disciplined Work)
states that quality and control require systematic processes, not
ad-hoc verification [1, pp. 16-18]. ISO 29148 §5.3 requires that
requirements be validated and verified throughout the lifecycle,
not only at the end [2]. The SDD pipeline mirrors this by offering
continuous quality commands (clarify, checklist, analyze) that can
be applied at multiple stages.

---

## Governance

This constitution supersedes default SpecKit development practices
(Library-First, CLI Mandate, TDD, Simplicity, Anti-Abstraction).
Amendments require documented rationale and review. All feature
specifications and implementations shall comply with these Articles.

**Version**: 1.0 | **Ratified**: 2026-06-13 | **Last Amended**: 2026-06-13

---

### References

[1] Glinz, M., van Loenhoud, H., Staal, S., Bühne, S. (2024).
    *CPRE Foundation Level Handbook*, v1.2.0. IREB.

[2] ISO/IEC/IEEE 29148:2018. *Systems and Software Engineering —
    Life Cycle Processes — Requirements Engineering*. ISO/IEC/IEEE.

[3] INCOSE (2012). *Guide for Writing Requirements*.
    International Council on Systems Engineering.

[4] Fagan, M.E. (1976). "Design and Code Inspections to Reduce
    Errors in Program Development". *IBM Systems Journal*, 15(3).
