# IREB Kit for SpecKit

> Inject these files into a SpecKit-enabled repo to apply
> professional requirements engineering (IREB CPRE + ISO 29148 + INCOSE).

## Kit files

| # | File | Injection target | Command | Rationale |
|---|---------|-----------------|---------|---------------|
| 1 | `AGENTS.md` | `./` (root) | *All* | Global IREB instructions. References constitution for details. |
| 2 | `constitution.md` | `.specify/memory/` | `/speckit.constitution` | 9 IREB articles. Article 0 (Proportionality) is the OVERRIDING principle. |
| 3 | `spec-template.md` | `.specify/templates/` | `/speckit.specify` | 12 IREB attributes. Proportional: skip sections that don't apply. |
| 4 | `clarify-template.md` | `.specify/templates/` | `/speckit.clarify` | Ambiguity + hallucination detector. Placeholders, not fixed values. |
| 5 | `checklist-template.md` | `.specify/templates/` | `/speckit.checklist` | Tiered quality control: L1 (3 criteria), L2 (8), L3 (13). |
| 6 | `plan-template.md` | `.specify/templates/` | `/speckit.plan` | Proportionality gate first. Trivial changes skip most phases. |
| 7 | `tasks-template.md` | `.specify/templates/` | `/speckit.tasks` | Mandatory [REQ-ID] traceability. Proportional task count. |
| 8 | `analyze-template.md` | `.specify/templates/` | `/speckit.analyze` | Diff size check + traceability matrix + anti-hallucination. |

## Why this kit works — 5 key principles

| # | Principle | Problem it solves | Mechanism |
|---|-----------|-------------------|-----------|
| **P1** | Proportionality First | Scope creep: 5902-line diff for a URL change | Article 0 tier table. Trivial = minimal spec + 1 task. |
| **P2** | No Hallucination | Invents stakeholders, objectives, PRs not in input | Constitution Art. I + clarify §5 + checklist R13 = triple lock |
| **P3** | Mandatory Traceability | Orphan code without links to requirements | Every artifact links to REQ-ID. No orphans allowed. |
| **P4** | Observable Verifiability | "Will be tested during QA" | Every requirement has concrete verification criterion (attribute 8) |
| **P5** | Minimality | "While we're here" refactors, new deps | Constitution Art. III. Only what the requirement asks for. |

## Quick injection

```bash
cp AGENTS.md                    my-repo/
cp constitution.md              my-repo/.specify/memory/
cp spec-template.md             my-repo/.specify/templates/
cp clarify-template.md          my-repo/.specify/templates/
cp checklist-template.md        my-repo/.specify/templates/
cp plan-template.md             my-repo/.specify/templates/
cp tasks-template.md            my-repo/.specify/templates/
cp analyze-template.md          my-repo/.specify/templates/
```

## How to use

Inject the kit, then use `/speckit.*` commands normally. The constitution and
AGENTS.md enforce IREB rules automatically. No extra scripts needed — the
templates themselves guide the agent toward proportional, traceable output.

## Normative basis

| Source | Reference |
|--------|-----------|
| IREB CPRE Foundation Level | Glinz et al. (2024), v1.2.0 |
| ISO/IEC/IEEE 29148:2018 | §6.2.2 Quality Characteristics |
| INCOSE Guide for Writing Requirements | (2012) |
