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
| gestionar, manejar | Verbo débil | "crear, modificar, eliminar" |
| soportar | Verbo débil | "aceptar, procesar, validar" |

- [ ] ¿Hay términos de la lista anterior en la especificación?
- [ ] ¿Hay otros términos ambiguos no listados?

---

## 2. Criterios de verificación ausentes

Cada requisito debe tener al menos un criterio de verificación observable.
Formatos válidos: respuesta HTTP, cambio de estado, evento emitido,
persistencia confirmada, validación aplicada.

- [ ] ¿Algún requisito no tiene criterio de verificación?
- [ ] ¿Algún criterio usa verbos no observables?

---

## 3. Clasificación faltante

Todo requisito debe tener Tipo (Functional | Quality | Constraint).

- [ ] ¿Algún requisito no tiene Tipo asignado?
- [ ] ¿Algún Tipo no es uno de los tres válidos?

---

## 4. Atributos incompletos

Revisar los 12 atributos IREB: ID, Name, Type, Description, Source,
Rationale, Priority, Verification, Status, Version, Dependencies, Module.

- [ ] ¿Campos obligatorios vacíos?
- [ ] ¿Source solo dice "changelog" sin versión/PR/commit?
- [ ] ¿Rationale está vacío o es genérico?

---

## 5. Alucinación de contexto ← CRÍTICO

El modelo NUNCA debe inventar información que no está en el input original.

- [ ] ¿La Source menciona stakeholders no presentes en el input?
- [ ] ¿El Rationale inventa objetivos de negocio no declarados?
- [ ] ¿Se asume un "equipo", "departamento" o "cliente" no mencionado?
- [ ] ¿Se referencian issues, PRs o documentos no presentes en el input?

Si se detecta cualquiera de estos → ❌ ALUCINACIÓN DE CONTEXTO.
El requisito debe reescribirse sin información inventada.

---

## Formato de salida

```markdown
## Informe de Clarify

### Ambigüedades detectadas
- [REQ-ID] "término" → sugerencia (no vinculante)

### Criterios de verificación faltantes
- [REQ-ID] sin criterio de verificación

### Clasificación faltante
- [REQ-ID] sin Tipo

### Atributos incompletos
- [REQ-ID] campo X vacío

### Alucinaciones de contexto
- [REQ-ID] inventa stakeholder Y no presente en el input original

### Resumen
- Total problemas: N
- Bloqueantes (alucinaciones): M
```
