### Evaluación IR-QM v3 — REQ-AUTHENTIK-10110

---

## R — Traceability (0–3)

**R1:** PR aparece en release note/changelog
Sí → 1

**R2:** Referencia explícita a PR #10110
Sí → 1

**R3:** Enlazable a artefacto concreto (PR URL)
Sí → 1

**Subtotal R = 3**

---

## S — Structural signals (0–3)

**S1:** Superficie técnica identificable
API runtime, OpenAPI schema, admin UI → 1

**S2:** Condición / actor explícito
No hay condiciones tipo if/when ni actor específico → 0

**S3:** Elemento técnico fuerte
Campo `openssl_fips_enabled`, schema OpenAPI, endpoint runtime → 1

**Subtotal S = 2**

---

## U — Utility for derivation (0–3)

**U1:** Capacidad/corrección/restricción funcional
Corrección de esquema API → 1

**U2:** Observabilidad/verificabilidad razonable
Se puede verificar vía API + schema inspection → 1

**U3:** Utilidad para revisión posterior (tests/docs/UI)
Afecta backend + schema + frontend → 1

**Subtotal U = 3**

---

## D — Defendibility (0–1)

**D1:** Justificable inclusión y límites
Sí: cambio claro, trazable, pero sin issue explícito ni especificación funcional completa → 1

**Subtotal D = 1**

---

## SCORE TOTAL

R (3) + S (2) + U (3) + D (1) = **9 / 10**

---

## DECISIÓN

**INCLUIR**

---

## Justificación corta (defendibilidad)

La entrada está altamente trazable (PR explícito), tiene señales técnicas fuertes (API + schema + UI), y es completamente derivable hacia un requisito funcional verificable. La ausencia de issue explícito no degrada la calidad porque el PR y commits proporcionan trazabilidad suficiente. La falta de condición explícita limita ligeramente el score estructural, pero no afecta la utilidad global del cambio.
