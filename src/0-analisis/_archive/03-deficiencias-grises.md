# 3. Deficiencias y Áreas Grises de SpecKit frente a IREB

> **Análisis basado en fuentes oficiales de SpecKit (v0.10.2, junio 2026) y el marco IREB CPRE Foundation Level.**

---

## 3.1 Deficiencias principales

### D1. Ausencia total de elicitación sistemática

SpecKit asume que el usuario llega con una descripción clara de lo que quiere construir. No hay:

- **Identificación de stakeholders**: ¿Quién se beneficia? ¿Quién usa el sistema? ¿Quién paga?
- **Análisis de fuentes**: No hay mecanismo para extraer requisitos de documentos, sistemas existentes, logs, issues.
- **Técnicas de elicitación**: No hay entrevistas, workshops, prototipado exploratorio, análisis de procesos.
- **Contexto del sistema**: No se modela el entorno donde operará el sistema.

**Impacto**: El riesgo de "build the wrong thing" (construir lo incorrecto) recae enteramente en la calidad del prompt inicial del usuario. SpecKit no mitiga este riesgo.

### D2. Sin clasificación de tipos de requisitos

IREB distingue **funcional**, **calidad** y **restricción**. SpecKit trata todo como user stories o descripciones funcionales. Esto implica:

- Los requisitos de calidad (rendimiento, seguridad, usabilidad) se mezclan con los funcionales.
- Las restricciones (tecnológicas, regulatorias, de negocio) aparecen en el constitution o en el prompt, no como requisitos explícitos.
- No hay forma de filtrar, priorizar o validar diferentemente según el tipo.

### D3. Sin atributos formales de requisito

La especificación de SpecKit (`spec.md`) es narrativa. No incluye atributos IREB esenciales:
- Identificador único de requisito
- Fuente documentada
- Rationale (justificación)
- Prioridad
- Estado (borrador, validado, implementado)
- Versión individual

### D4. Validación exclusivamente interna

SpecKit valida consistencia entre sus propios artefactos (`analyze`), pero:
- No valida contra necesidades reales de stakeholders
- No hay revisión externa estructurada
- No hay inspección formal (Fagan, checklist-based reading)
- El `gate` humano en workflows es opcional y no estructurado

### D5. Sin gestión de cambios de requisitos

Si un requisito cambia:
- No hay proceso de cambio formal
- No hay análisis de impacto
- No hay baselines
- No hay trazabilidad bidireccional (origen → requisito → implementación → test)

### D6. Ambigüedad no resuelta sistemáticamente

`[NEEDS CLARIFICATION]` es un mecanismo ligero, pero:
- Límite de 3 marcadores (puede ocultar ambigüedades)
- No hay criterios para identificar ambigüedad (IREB tiene definiciones precisas)
- No hay resolución obligatoria antes de implementar (el checklist lo sugiere, pero no lo fuerza)

---

## 3.2 Áreas grises (no claramente deficiencias, pero ambiguas)

### G1. ¿El constitution es un sustituto de especificación de requisitos?

El `constitution.md` define principios arquitectónicos y reglas de desarrollo, no requisitos del sistema. Sin embargo, en la práctica:
- Algunas restricciones (tecnológicas, de estilo) aparecen aquí
- Se mezclan reglas de desarrollo (TDD, Library-First) con restricciones del sistema

¿Debería el constitution incluir restricciones del sistema o solo reglas de proceso?

### G2. ¿Las user stories son suficientes como formato de requisito?

SpecKit usa user stories (formato ágil). IREB las considera una forma válida de documentación, pero:
- Las user stories son compromisos para una conversación, no especificaciones completas
- No tienen criterios de aceptación explícitos (aunque podrían incluirse)
- No diferencian entre functional, quality, constraint

### G3. ¿Dónde van los requisitos no funcionales?

SpecKit no tiene un lugar designado para requisitos de calidad. Pueden ir:
- En el constitution (si son restricciones generales)
- En el spec (si son parte de la feature)
- En el plan (si son decisiones técnicas)
- En ningún sitio (si nadie los menciona explícitamente)

Esta dispersión dificulta la verificabilidad y la gestión.

### G4. ¿La trazabilidad es bidireccional?

SpecKit traza spec → plan → tasks → implement (forward). Pero:
- No traza requisitos ← fuentes (backward)
- No traza tests ← requisitos (bidireccional)
- No hay matriz de trazabilidad explícita

### G5. ¿El `analyze` es validación o análisis de consistencia?

`/speckit.analyze` revisa consistencia entre artefactos, pero IREB distinguiría:
- **Análisis de consistencia**: No hay contradicciones entre requisitos
- **Validación**: Los requisitos reflejan necesidades reales

SpecKit hace lo primero, no lo segundo.

### G6. ¿Las plantillas de SpecKit cubren los criterios de calidad IREB?

Las plantillas de SpecKit incluyen checklists, pero estos checklists no están basados en:
- ISO/IEC/IEEE 29148 (quality characteristics for requirements)
- INCOSE Guide for Writing Requirements
- IREB Quality Criteria

Son checklists genéricos de completitud ("No [NEEDS CLARIFICATION] markers remain"), no de calidad de requisitos.

---

## 3.3 Comparativa: SpecKit vs. herramientas profesionales de RE

| Aspecto | SpecKit | IBM DOORS | Jama Connect | Polarion |
|---|---|---|---|---|
| Elicitación | ❌ No | ❌ No (herramienta de doc) | ❌ No | ❌ No |
| Tipos de requisitos | ❌ No | ✅ Sí | ✅ Sí | ✅ Sí |
| Atributos personalizados | ❌ No | ✅ Sí | ✅ Sí | ✅ Sí |
| Trazabilidad | ⚠️ Lineal | ✅ Bidireccional | ✅ Bidireccional | ✅ Bidireccional |
| Gestión de cambios | ❌ No | ✅ CCB, baselines | ✅ CCB, baselines | ✅ CCB, baselines |
| Versionado individual | ❌ No | ✅ Sí | ✅ Sí | ✅ Sí |
| Validación | ❌ No | ⚠️ Limitado | ⚠️ Limitado | ⚠️ Limitado |
| Generación de código | ✅ Sí | ❌ No | ❌ No | ❌ No |
| Integración con IA | ✅ Nativa | ❌ No | ❌ No | ⚠️ Parcial |

**Conclusión**: SpecKit no compite con herramientas RE profesionales. Su valor está en la generación de código, no en la gestión de requisitos.

---

## 3.4 Deficiencias específicas para el contexto del TFG

Para este TFG, las deficiencias más relevantes son:

1. **Sin fuente documentada**: No hay atributo "Source" en los requisitos que genera SpecKit. Esto es crítico porque nuestra metodología construye requisitos a partir de changelogs, y necesitamos trazabilidad hacia la fuente original.

2. **Sin criterio de verificación explícito**: SpecKit no exige que cada requisito tenga un método de verificación. Nuestra rúbrica SRCI (Fase 4) lo necesita.

3. **Sin distinción functional/quality/constraint**: Nuestro análisis podría beneficiarse de clasificar los requisitos por tipo.

4. **Validación externa ausente**: SpecKit no puede validar que el código generado satisface el requisito original. Eso es exactamente lo que hace nuestra Fase 4.

---

## 3.5 Fuentes

- IREB CPRE Foundation Level Handbook (syllabus oficial)
- IREB CPRE Glossary (cpre.ireb.org)
- ISO/IEC/IEEE 29148:2018 — Requirements Engineering
- INCOSE Guide for Writing Requirements
- IBM DOORS documentation, Jama Connect docs, Polarion docs (conocimiento general del sector)
