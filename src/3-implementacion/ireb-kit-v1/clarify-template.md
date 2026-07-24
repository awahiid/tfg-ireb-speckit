# Clarify Template — IREB Edition

> **Replaces**: Default SpecKit `clarify-template.md`
> **Based on**: IREB CPRE §Validation, ISO 29148 §6.2.2

Detecta defectos en la especificación. Solo señala problemas, NO los resuelvas.
Si no hay problemas, indícalo explícitamente.

---

## 1. Ambigüedades léxicas

Términos no observables que deben reemplazarse:

| Término | Problema | Alternativa IREB |
|---------|----------|-----------------|
| rápido, eficiente | No verificable | "responde en < 200ms" |
| robusto, fiable | No verificable | "tolera fallos de red con retry 3x" |
| intuitivo, fácil | Subjetivo | "completa la tarea en ≤ 3 clics" |
| gestionar, manejar | Weak verb | "crear, modificar, eliminar" |
| soportar | Weak verb | "aceptar, procesar, validar" |

- [ ] Are any terms from the list above present in the specification?
- [ ] Are there other ambiguous terms not listed?

---

## 2. Missing Verification Criteria

Each requirement must have at least one observable verification criterion.
Valid formats: HTTP response, state change, emitted event,
confirmed persistence, applied validation.

- [ ] Is any requirement missing a verification criterion?
- [ ] Does any criterion use non-observable verbs?

---

## 3. Missing Classification

Every requirement must have a Type (Functional | Quality | Constraint).

- [ ] Is any requirement missing a Type?
- [ ] Is any Type not one of the three valid values?

---

## 4. Incomplete Attributes

Review the 12 IREB attributes: ID, Name, Type, Description, Source,
Rationale, Priority, Verification, Status, Version, Dependencies, Module.

- [ ] Are any required fields empty?
- [ ] Does Source only say "changelog" without version/PR/commit?
- [ ] Is Rationale empty or generic?

---

## 5. Context Hallucination ← CRITICAL

The model MUST NEVER invent information not present in the original input.

- [ ] Does Source mention stakeholders not in the input?
- [ ] Does Rationale invent undeclared business objectives?
- [ ] Is a "team", "department", or "client" assumed without being mentioned?
- [ ] Are issues, PRs, or documents referenced that are not in the input?

If any of these is detected → ❌ CONTEXT HALLUCINATION.
The requirement must be rewritten without fabricated information.

---

## Output Format

```markdown
## Clarify Report

### Detected Ambiguities
- [REQ-ID] "term" → suggestion (non-binding)

### Missing Verification Criteria
- [REQ-ID] without verification criterion

### Missing Classification
- [REQ-ID] without Type

### Incomplete Attributes
- [REQ-ID] field X empty

### Context Hallucinations
- [REQ-ID] inventa stakeholder Y no presente en el input original

### Resumen
- Total problemas: N
- Bloqueantes (alucinaciones): M
```
