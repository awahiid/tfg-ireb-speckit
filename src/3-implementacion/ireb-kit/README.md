# IREB Kit for SpecKit

> Complete set of IREB-compliant resources to integrate professional
> requirements engineering into the SpecKit SDD pipeline.

## Contents

| File | Type | Purpose |
|---|---|---|
| `constitution.md` | Constitution | 9 articles based on IREB + ISO 29148 + INCOSE |
| `spec-template-ireb.md` | Template | Spec template with 12 IREB attributes |
| `plan-template-ireb.md` | Template | Plan template with IREB gates |
| `checklist-ireb.md` | Template | 12-criteria quality checklist |
| `workflow-ireb.yml` | Workflow | Full pipeline with review gates |
| `preset-ireb.yml` | Preset | Bundles all of the above |
| `prompt-template.md` | Prompt | LLM prompt to generate IREB requirements |
| `tutorial.md` | Guide | End-to-end user tutorial |

## How to use

### Quick: just the constitution

```
/speckit.constitution [paste constitution.md content here]
```

### Full: all templates

1. Copy this directory to `.specify/presets/ireb/`
2. Run: `specify preset add ireb`

## Normative basis

Every decision is grounded in:

| Source | Reference |
|---|---|
| IREB CPRE Foundation Level Handbook | Glinz et al. (2024), v1.2.0 |
| ISO/IEC/IEEE 29148:2018 | §6.2.2 Quality Characteristics |
| INCOSE Guide for Writing Requirements | (2012) |
| Fagan Inspections | Fagan, M.E. (1976) |

## Version

**1.0.0** — June 2026
