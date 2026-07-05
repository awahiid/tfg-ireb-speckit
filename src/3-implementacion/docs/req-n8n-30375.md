# REQ-N8N-30375: Corrección del procesamiento de correos en el disparador IMAP

> **Feature ID**: n8n-30375-imap-email-trigger-fix
> **Branch**: `n8n-30375-imap-email-trigger-fix`
> **Created**: 2026-07-03
> **Source**: Pull Request #30375, Issue #28392, Community report

---

## 1. Requirements

### REQ-N8N-30375: Corrección del procesamiento de correos en el disparador IMAP

| Attribute | Value |
|---|---|
| **Type** | Functional |
| **Priority** | High |
| **Source** | Pull Request #30375 (https://github.com/n8n-io/n8n/pull/30375), Issue #28392 (https://github.com/n8n-io/n8n/issues/28392), Community report (https://community.n8n.io/t/imap-not-triggering/120280) |
| **Rationale** | La implementación anterior marcaba correos como leídos aunque no activaran el flujo de trabajo, un fallo en un correo malformado detenía el flujo silenciosamente, y el manejo incorrecto del identificador de último mensaje causaba ejecuciones duplicadas en lotes grandes. |
| **Module** | Email Trigger (IMAP) |
| **Dependencies** | None |

**Formal Description**:

El sistema deberá marcar como leídos únicamente los correos procesados exitosamente cuando la opción de post-procesamiento sea `read`.

El sistema deberá omitir los mensajes sin parte `HEADER` o con `HEADER` vacío en modo "simple", registrar una advertencia y continuar el procesamiento sin desactivar el flujo.

El sistema deberá actualizar `lastMessageUid` después de cada lote de 20 o más correos.

**Verification**:

1. Configurar un disparador IMAP con post-procesamiento `read`. Enviar correos nuevos. Activar el flujo. Verificar en el servidor IMAP que solo los correos que activaron el flujo estén marcados como leídos.

2. Simular un correo sin parte `HEADER` en modo "simple". Ejecutar el flujo. Verificar en los logs una advertencia y que el flujo no se desactiva.

3. Enviar más de 20 correos nuevos. Ejecutar el flujo. Verificar que cada correo produce exactamente una ejecución y que `lastMessageUid` se actualiza tras cada lote.

**Acceptance Scenarios**:

1. Given un disparador IMAP con post-procesamiento `read`, when se procesan 5 correos nuevos y 3 activan el flujo, then solo esos 3 deben aparecer marcados como `\\SEEN` en el servidor.

2. Given un disparador IMAP en modo "simple", when se recibe un mensaje sin `HEADER`, then el sistema debe registrar un `warn` y continuar procesando el siguiente correo sin desactivar el flujo.

3. Given 25 correos nuevos en la bandeja IMAP, when se ejecuta el flujo, then cada correo debe disparar exactamente una ejecución y `lastMessageUid` debe reflejar el último UID tras cada lote de 20.

---

## 2. Quality Requirements

None.

---

## 3. Constraints

| ID | Type | Description |
|---|---|---|
| C-30375-01 | Technology | La implementación debe operar dentro del nodo "Email Trigger (IMAP)" de n8n sin modificar otros nodos ni la infraestructura del servidor IMAP. |

---

## 4. Domain Glossary

| Term | Definition |
|---|---|
| `lastMessageUid` | Identificador único del último mensaje procesado, usado para evitar reprocesar correos ya vistos en iteraciones previas del disparador IMAP. |
| `\\SEEN` | Indicador IMAP estándar que el servidor asigna a los mensajes marcados como leídos. |
| Post-procesamiento | Acción configurable que el nodo IMAP ejecuta sobre los correos después de recuperarlos (marcar como leído, eliminar, etc.). |

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
| REQ-N8N-30375 | PR #30375, Issue #28392, Community report | §1 | — | — | — |

---

## Field Validation Rules

| Field | Rule | Reference |
|---|---|---|
| Type | Functional | IREB §Requirements Types [1] |
| Priority | High | IREB §Stakeholder Priority [1] |
| Source | PR #30375, Issue #28392, Community report (URLs incluidos) | ISO 29148 §6.3.1 [2] |
| Formal Description | "El sistema deberá" + marcar, omitir, actualizar | INCOSE §Structure [3] |
| Verification | Configurar, enviar, activar, verificar, simular, ejecutar, comprobar | ISO 29148 §6.2.2 [2] |
| Rationale | Errores críticos documentados: pérdida de activaciones, detención silenciosa, duplicados | IREB §Rationale [1] |
