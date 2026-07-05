# REQ-OPTIN-SCOPE: Configuración de ámbito opcional en OptInFeatureConfig

> **Feature ID**: optin-scope-config
> **Branch**: `optin-scope-config`
> **Created**: 2026-07-05
> **Source**: PR #26801

---

## 1. Requirements

### REQ-OPTIN-SCOPE: Configuración de ámbito opcional en OptInFeatureConfig

| Attribute | Value |
|---|---|
| **Type** | Functional |
| **Priority** | Medium |
| **Source** | PR #26801 — sin fuente adicional documentada |
| **Rationale** | Algunas funcionalidades "opt-in" solo son relevantes para ciertos niveles de la jerarquía del sistema (por ejemplo, solo para administradores de organización o solo para usuarios individuales). |
| **Module** | OptInFeatureConfig |
| **Dependencies** | None |

**Formal Description**:
El sistema deberá aceptar un campo `scope` opcional en `OptInFeatureConfig` que restringa la funcionalidad a los valores `org`, `team` y/o `user`.

**Verification**:
1. Crear una `OptInFeatureConfig` sin `scope`. Verificar que la configuración se crea correctamente y la funcionalidad está disponible sin restricciones de ámbito.
2. Crear una `OptInFeatureConfig` con `scope: ["org"]`. Verificar que la funcionalidad solo se activa para operaciones a nivel de organización.
3. Crear una `OptInFeatureConfig` con `scope: ["org", "user"]`. Verificar que la funcionalidad se activa tanto a nivel de organización como de usuario.
4. Crear una `OptInFeatureConfig` con un valor inválido. Verificar que el sistema rechaza la configuración con un error de validación.

**Acceptance Scenarios**:
1. Given una `OptInFeatureConfig` sin `scope`, when se consulta la configuración, then la funcionalidad está disponible globalmente.
2. Given una `OptInFeatureConfig` con `scope: ["org"]`, when un usuario intenta activar la funcionalidad a nivel de equipo, then el sistema rechaza la operación.
3. Given una `OptInFeatureConfig` con `scope: ["team"]`, when un usuario intenta activar la funcionalidad a nivel de organización, then el sistema rechaza la operación.
4. Given una `OptInFeatureConfig` con `scope: ["user"]`, when un administrador configura la funcionalidad globalmente, then el sistema rechaza la operación.

---

## 2. Quality Requirements

None.

---

## 3. Constraints

| ID | Type | Description |
|---|---|---|
| C-OPTIN-01 | Technology | El campo `scope` debe definirse como un array de strings con valores permitidos `org`, `team`, `user`. El valor por defecto debe ser `["org", "team", "user"]` (o `null`/`undefined` indicando sin restricción). |

---

## 4. Domain Glossary

| Term | Definition |
|---|---|
| `OptInFeatureConfig` | Configuración de una funcionalidad opcional ("opt-in") que los usuarios pueden activar explícitamente. |
| `scope` | Ámbito jerárquico al que aplica una funcionalidad: `org` (organización), `team` (equipo), `user` (usuario individual). |

---

## 5. Completeness Checklist

- [x] All requirements have a Type (Functional / Quality / Constraint)
- [x] All requirements have a Source with document reference
- [x] All requirements have a Rationale
- [x] All requirements have a Verification criterion
- [x] All requirements have a measurable or observable verb
- [x] No [NEEDS CLARIFICATION] markers remain (max 3)
- [x] No ambiguous terms (fast, efficient, robust, user-friendly)
- [x] Quality requirements include numeric targets
- [x] All terms are defined in the glossary
- [x] All dependencies between requirements are documented

---

## 6. Traceability Matrix

| REQ-ID | Source | Spec Section | Plan Section | Task IDs | Test File |
|---|---|---|---|---|---|
| REQ-OPTIN-SCOPE | PR #26801 | §1 | — | — | — |

---

## Field Validation Rules

| Field | Rule | Reference |
|---|---|---|
| Type | Functional | IREB §Requirements Types [1] |
| Priority | Medium | IREB §Stakeholder Priority [1] |
| Source | PR #26801 — sin fuente adicional documentada | ISO 29148 §6.3.1 [2] |
| Formal Description | "El sistema deberá" + aceptar, restringir | INCOSE §Structure [3] |
| Verification | Crear, verificar, consultar, rechazar | ISO 29148 §6.2.2 [2] |
| Rationale | Algunas funcionalidades opt-in solo son relevantes para ciertos niveles de la jerarquía | IREB §Rationale [1] |
