# Analyze Template — IREB Edition

> **Replaces**: Default SpecKit `analyze-template.md`
> **Based on**: IREB CPRE §Traceability, ISO 29148 §6.3.1, INCOSE §Traceability

Verifica la consistencia y trazabilidad de la cadena completa:
**REQ → spec → plan → tasks → code → tests**.

---

## 1. Matriz de trazabilidad

Cada REQ-ID debe tener al menos un artefacto en cada nivel:

| REQ-ID | Spec | Plan | Tasks | Code | Tests | Estado |
|--------|------|------|-------|------|-------|--------|
| REQ-APP-001 | ✅ | ✅ | ✅ | ✅ | ✅ | Completo |
| REQ-APP-002 | ✅ | ✅ | ❌ | — | — | Sin tasks |

---

## 2. Consistencia spec ↔ plan

- [ ] ¿Cada decisión del plan referencia un REQ-ID?
- [ ] ¿Hay decisiones de arquitectura sin trazabilidad?
- [ ] ¿El plan contradice algún criterio de verificación del spec?

---

## 3. Consistencia plan ↔ tasks

- [ ] ¿Todas las tareas del plan están descompuestas?
- [ ] ¿Hay tareas sin plan correspondiente (huérfanas)?
- [ ] ¿El orden de tareas respeta las dependencias del plan?

---

## 4. Consistencia tasks ↔ code

- [ ] ¿Cada archivo modificado tiene un REQ-ID en su cabecera?
- [ ] ¿Hay archivos modificados sin tarea correspondiente?
- [ ] ¿Hay tareas sin código generado?

---

## 5. Trazabilidad externa (medio IREB)

- [ ] ¿Cada requisito enlaza a su fuente original?
- [ ] ¿Hay eslabones rotos en la cadena fuente → spec?

---

## 6. Verificación de no-alucinación

- [ ] ¿El código contiene comentarios que inventan stakeholders u objetivos?
- [ ] ¿Los mensajes de commit/PR referencian fuentes no existentes?
- [ ] ¿El changelog generado menciona issues/PRs no verificables?

---

## 7. Cobertura de tests

| REQ-ID | Criterio de verificación | Test asociado | ¿Cubre? |
|--------|-------------------------|---------------|---------|
| REQ-APP-001 | Respuesta 415 en MIME no permitido | `test_upload_mime_rejected` | ✅ |
| REQ-APP-001 | Respuesta 200 en MIME permitido | `test_upload_mime_accepted` | ✅ |

---

## Formato de salida

```markdown
## Informe de Analyze

### Trazabilidad
- Total REQ: N
- Trazabilidad completa: M (X%)
- Eslabones rotos: K

### Brechas
- [REQ-ID] sin tarea / sin código / sin test

### Huérfanos
- Archivo X modificado sin REQ-ID
- Tarea Y sin REQ-ID

### Alucinaciones detectadas
- (vacío si no hay)

### Veredicto
- ✅ APTO para implementar
- ⚠️ APTO con advertencias (listar)
- ❌ NO APTO (listar bloqueantes)
```

---

## Gates de aceptación

Para considerar el análisis superado:
- [ ] 100% de REQ-ID con trazabilidad a código
- [ ] 0 archivos huérfanos (sin REQ-ID)
- [ ] 0 alucinaciones de contexto
- [ ] ≥ 80% de criterios de verificación cubiertos por tests
