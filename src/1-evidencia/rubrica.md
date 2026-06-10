# IR-QM v3 — Rúbrica pragmática para selección de cambios candidatos

## Objetivo
Esta versión no evalúa si un texto ya es un requisito bien formado, sino si una entrada de changelog o release note es **suficientemente buena** como para entrar en el corpus base y poder derivar posteriormente un requisito implementable.

## Principio general
La rúbrica prioriza:
- **trazabilidad mínima suficiente**,
- **presencia de señales estructurales útiles**,
- **utilidad práctica para derivación posterior**,
- y **defendibilidad de la inclusión**.

No busca eliminar toda ambigüedad. Busca permitir una selección **rápida, consistente y razonable**.

---

# Dimensiones

## R — Traceability (0–3)

| # | Pregunta | Regla |
|---|---|---|
| R1 | ¿La entrada aparece en release notes o changelog oficial del repositorio? | Sí = 1, No = 0 |
| R2 | ¿La entrada contiene referencia explícita a PR (`#NNNN` o URL)? | Sí = 1, No = 0 |
| R3 | ¿Puede enlazarse a una PR o artefacto trazable concreto? | Sí = 1, No/indeterminado = 0 |

### Justificación
La trazabilidad sigue siendo el mínimo no negociable. Sin ella, la entrada pierde mucho valor como evidencia base.

---

## S — Structural signals (0–3)

| # | Pregunta | Regla |
|---|---|---|
| S1 | ¿El texto menciona una superficie técnica identificable? | Endpoint, API, CLI, workflow, UI, comando, componente, modelo, etc. = 1 |
| S2 | ¿El texto contiene una condición, actor o contexto explícito? | `when`, `if`, actor como `customer`, `merchant`, `admin`, etc. = 1 |
| S3 | ¿El texto contiene un elemento técnico fuerte? | Método HTTP, path, campo, comando, error, archivo, valor concreto = 1 |

### Justificación
Estas señales no convierten el texto en un requisito, pero aumentan la probabilidad de derivar uno bien definido después.

---

## U — Utility for derivation (0–3)

| # | Pregunta | Regla |
|---|---|---|
| U1 | ¿El cambio describe una capacidad, corrección o restricción funcional? | Sí = 1, No = 0 |
| U2 | ¿El cambio parece observable o razonablemente comprobable en una fase posterior? | Sí = 1, No = 0 |
| U3 | ¿La entrada parece lo bastante informativa como para justificar revisión posterior de PR/tests/docs? | Sí = 1, No = 0 |

### Justificación
Aquí no exigimos verificabilidad completa. Solo pedimos que el cambio sea prometedor como base para derivación.

---

## D — Defendibility (0–1)

| # | Pregunta | Regla |
|---|---|---|
| D1 | ¿Puede justificarse en un breve párrafo por qué la entrada entra y cuáles son sus limitaciones? | Sí = 1, No = 0 |

### Justificación
Este criterio introduce una comprobación metodológica muy útil: si no puedes defender la inclusión de forma breve y clara, probablemente la entrada no es suficientemente buena.

---

# Score total y decisión

| Score total | Decisión |
|---|---|
| 7–10 | Incluir |
| 5–6 | Incluir con reserva / opcional |
| 0–4 | Excluir |

## Regla adicional
- **R1 y R2 deberían cumplirse casi siempre**.  
- Si falta trazabilidad básica, la entrada normalmente se excluye, salvo caso excepcional muy bien justificado.