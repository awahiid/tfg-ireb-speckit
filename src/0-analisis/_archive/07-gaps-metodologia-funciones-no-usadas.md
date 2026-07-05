# 7. Gaps en la Metodología y Funciones de SpecKit No Utilizadas

> **Análisis de brechas entre el pipeline actual del TFG y lo que SpecKit v0.10.2 ofrece + lo que IREB recomienda.**

---

## 7.1 Resumen ejecutivo

El pipeline actual del TFG usa **5 de los 8 comandos core** de SpecKit y **0 de sus mecanismos avanzados** (workflows, presets, extensions, analyze, clarify, checklist). Esto deja sin aprovechar capacidades que podrían:

1. **Detectar ambigüedades** en los requisitos antes de implementar (`clarify`)
2. **Validar calidad** de la especificación contra criterios (`checklist`)
3. **Verificar consistencia cruzada** entre artefactos (`analyze`)
4. **Automatizar el pipeline** con gates de revisión humana (workflows)
5. **Personalizar plantillas** con semántica IREB (presets)

---

## 7.2 Funciones de SpecKit No Utilizadas

### 7.2.1 Catálogo completo de comandos SpecKit

| Comando | ¿Se usa? | Prioridad | Potencial IREB |
|---|---|---|---|
| `/speckit.constitution` | ✅ Sí | Core | Define principios rectores |
| `/speckit.specify` | ✅ Sí | Core | Genera especificación inicial |
| **`/speckit.clarify`** | ❌ **No** | **Alta** | **Identifica ambigüedad (crítico IREB)** |
| `/speckit.plan` | ✅ Sí | Core | Plan técnico |
| `/speckit.tasks` | ✅ Sí | Core | Descomposición en tareas |
| **`/speckit.checklist`** | ❌ **No** | **Alta** | **Checklist de calidad (validation IREB)** |
| **`/speckit.analyze`** (pre) | ❌ **No** | **Alta** | **Consistencia cruzada (verificación IREB)** |
| `/speckit.implement` | ✅ Sí | Core | Generación de código |
| **`/speckit.analyze`** (post) | ❌ **No** | **Media** | **Revisión post-implementación** |
| `/speckit.taskstoissues` | ❌ No | Baja | Conversión a issues GitHub |
| **Workflow `speckit`** | ❌ **No** | **Alta** | **Pipeline automatizado con gates** |
| **Presets** | ❌ **No** | **Media** | **Personalización IREB de plantillas** |
| **Extensions** | ❌ **No** | **Media** | **Extensiones de calidad/arquitectura** |

### 7.2.2 Análisis detallado de cada función no usada

#### F1. `/speckit.clarify` — Clarificación de ambigüedades (Alta prioridad)

**Qué hace**: Identifica áreas subespecificadas en la spec y genera preguntas al usuario. Esencialmente, fuerza al LLM a marcar lo que no está claro con `[NEEDS CLARIFICATION: pregunta concreta]`.

**Por qué no se usa**: El pipeline actual va directo de `/speckit.specify` a `/speckit.plan`, saltándose la clarificación.

**Impacto IREB**: La **no ambigüedad** es uno de los criterios de calidad fundamentales de IREB (CPRE Foundation Level Handbook, sección Quality Criteria). Saltarse este paso significa que ambigüedades en el requisito pueden propagarse al plan, las tasks y la implementación sin ser detectadas.

**Cómo integrarlo**: Insertar `/speckit.clarify` después de `/speckit.specify`. Permite al investigador:
- Ver qué partes del requisito SpecKit considera ambiguas
- Aclarar antes de que se propague a plan/implementación
- Documentar qué decisiones se tomaron para resolver la ambigüedad

#### F2. `/speckit.checklist` — Checklist de calidad (Alta prioridad)

**Qué hace**: Genera checklists de calidad personalizados que validan completitud, claridad y consistencia de los requisitos. La documentación oficial lo describe como "unit tests for English".

**Por qué no se usa**: Se desconocía su existencia al diseñar el pipeline.

**Impacto IREB**: IREB define checklists como técnica de validación (CPRE Foundation Level, sección Validation). Un checklist generado por SpecKit podría complementar la rúbrica de formalización (Fase 2), proporcionando una validación adicional desde la perspectiva del LLM.

**Cómo integrarlo**: Ejecutar `/speckit.checklist` después de clarificar y antes de planificar. El checklist resultante se puede comparar con la rúbrica de formalización para identificar discrepancias entre la evaluación humana y la del LLM.

#### F3. `/speckit.analyze` pre-implementación — Consistencia cruzada (Alta prioridad)

**Qué hace**: Analiza spec, plan y tasks para detectar inconsistencias, gaps y áreas donde los artefactos no están alineados.

**Por qué no se usa**: Se desconocía o se consideró que el análisis manual era suficiente.

**Impacto IREB**: La **consistencia** entre requisitos es un criterio IREB fundamental (ISO 29148). Específicamente, verificar que el plan técnico implementa correctamente la especificación y que las tasks cubren todo el plan es equivalente a una verificación de trazabilidad descendente.

**Cómo integrarlo**: Ejecutar `/speckit.analyze` después de `/speckit.tasks` y antes de `/speckit.implement`. Los resultados pueden:
- Alertar sobre requisitos no cubiertos en tasks
- Detectar contradicciones entre spec y plan
- Registrar métricas de consistencia para el análisis de resultados

#### F4. `/speckit.analyze` post-implementación — Revisión final (Media prioridad)

**Qué hace**: El mismo análisis de consistencia pero aplicado sobre la implementación generada.

**Por qué no se usa**: La Fase 4 (evaluación SRCI) ya evalúa la implementación manualmente.

**Impacto IREB**: Proporciona una verificación automatizada adicional que puede compararse con la evaluación manual SRCI.

#### F5. Workflow `specify workflow run speckit` — Pipeline automatizado (Alta prioridad)

**Qué hace**: Automatiza el pipeline completo `specify → plan → tasks → implement` con gates de revisión humana entre cada paso. Definido en YAML:

```yaml
steps:
  - id: specify
    command: speckit.specify
  - id: review-spec
    type: gate
    message: "Review the generated spec before planning."
  - id: plan
    command: speckit.plan
  - id: review-plan
    type: gate
    message: "Review the plan before generating tasks."
  - id: tasks
    command: speckit.tasks
  - id: implement
    command: speckit.implement
```

**Por qué no se usa**: El protocolo actual ejecuta comandos manualmente en Copilot Chat. No se exploró la vía de workflows.

**Impacto IREB**: Los gates de revisión humana son el equivalente a **validación por inspección** (IREB). Además, la automatización del pipeline mejora la **reproducibilidad** del experimento, un criterio de calidad metodológica.

**Limitación**: Los workflows requieren la CLI `specify workflow run`, que puede no estar disponible en todos los entornos o puede tener limitaciones de integración con Copilot Chat. Habría que validar experimentalmente que funciona con `--integration copilot`.

#### F6. Presets — Personalización de plantillas (Media prioridad)

**Qué hace**: Los presets sobreescriben las plantillas core de SpecKit. Un preset "IREB" podría modificar `spec-template.md` para incluir atributos como tipo, fuente, rationale, prioridad.

**Por qué no se usa**: No se consideró la personalización de SpecKit.

**Impacto IREB**: Directo: permitiría que SpecKit genere specs con estructura IREB-compliant en lugar de user stories genéricas.

#### F7. Constitution personalizado — Principios RE (Media prioridad)

**Qué hace**: El constitution se genera con valores por defecto (Library-First, CLI, TDD). No se personaliza para RE.

**Por qué no se usa**: El script `preparar-caso.sh` ejecuta `/speckit.constitution` sin argumentos, generando un constitution genérico.

**Impacto IREB**: El constitution podría incluir principios como "Verificabilidad obligatoria", "Trazabilidad completa", "Clasificación por tipo", que SpecKit aplicaría consistentemente en todas las fases.

---

## 7.3 Gaps IREB en la Metodología

### 7.3.1 Mapa de cobertura IREB actual vs. deseable

```
Actividad IREB           Actual    Deseable    Gap
─────────────────────────────────────────────────────
Elicitación               1/10       5/10      🔴 -4
  - Fuentes múltiples      ❌         ✅        
  - Stakeholders           ❌         ⚠️        
  - Contexto del sistema   ❌         ⚠️        
  - Glosario               ❌         ✅        

Documentación             5/10       7/10      🟡 -2
  - Plantilla atributos    ✅         ✅        
  - Tipos de req.          ⚠️         ✅        
  - Matriz trazabilidad    ❌         ✅        
  - Versionado real        ❌         ✅        
  - Agrupación modular     ❌         ✅        

Validación                2/10       6/10      🔴 -4
  - Rúbrica SRCI           ✅         ✅        
  - Clarify (SpecKit)      ❌         ✅        
  - Checklist (SpecKit)    ❌         ✅        
  - Analyze (SpecKit)      ❌         ✅        
  - Validación externa     ❌         ❌ (No aplica)

Management                2/10       4/10      🟡 -2
  - Trazabilidad forward   ✅         ✅        
  - Trazabilidad backward  ❌         ✅        
  - Gestión cambios        ❌         ❌ (No aplica)
  - Baselines              ❌         ❌ (No aplica)
```

### 7.3.2 Gaps específicos por fase

#### Gap G1: Fase 1 — Fuentes de elicitación incompletas

**Problema**: Solo se usan changelogs como fuente. IREB recomienda múltiples fuentes (stakeholders, documentos, sistemas existentes, observaciones).

**Qué se podría añadir**:
- **Diff completo de la PR**: El changelog entry es un resumen; el diff contiene el comportamiento real implementado. Leer el diff podría enriquecer la derivación de requisitos.
- **Issues asociados**: Muchos cambios referencean issues que contienen discusión, alternativas descartadas, contexto de decisión.
- **Comentarios de code review**: Contienen restricciones implícitas, casos borde, rationales no documentados.

**Cómo afecta a SpecKit**: Requisitos derivados de fuentes más ricas son menos ambiguos y más completos, lo que debería mejorar la tasa de éxito de SpecKit.

#### Gap G2: Fase 2 — Atributos de gestión no operativos

**Problema**: La plantilla incluye `Estado` y `Versión`, pero en la práctica:
- `Estado` siempre es `Validado` (nunca pasa por Borrador → Elaborado → Validado)
- `Versión` siempre es `1.0` (nunca se actualiza)

**Solución**: O se usan realmente (registrando el estado en cada fase) o se eliminan de la plantilla para no crear falsa sensación de gestión.

#### Gap G3: Fase 2 — Sin matriz de trazabilidad

**Problema**: No hay un artefacto que relacione requisitos entre sí (dependencias, conflictos, jerarquías).

**Solución**: Añadir un campo `Dependencias` a la plantilla que referencie otros REQ IDs cuando sea relevante.

#### Gap G4: Fase 2 — Sin agrupación modular

**Problema**: Los requisitos de un repositorio son una lista plana. No se agrupan por módulo, subsistema o funcionalidad.

**Solución**: Añadir un campo `Módulo` a la plantilla.

#### Gap G5: Fase 3 — Constitution genérico

**Problema**: El constitution se genera con el template por defecto (Library-First, CLI Mandate, TDD, etc.). Estos principios son para desarrollo de librerías, no para evaluación de conformidad de requisitos.

**Impacto**: SpecKit podría generar código que sigue principios irrelevantes para el experimento (ej. estructurar todo como librería cuando el cambio original era una modificación in-line).

**Solución**: Personalizar el constitution con principios alineados a RE:
- "Verificabilidad: toda implementación debe incluir tests que verifiquen el requisito"
- "Minimalidad: implementar exactamente lo especificado, sin features especulativas"
- "Trazabilidad: el código debe mantener la estructura descrita en el plan"

#### Gap G6: Fase 4 — Sin validación automatizada complementaria

**Problema**: La rúbrica SRCI es completamente manual. No hay una validación automatizada que pueda compararse.

**Solución**: Usar `/speckit.analyze` post-implementación para obtener una evaluación automatizada de consistencia que pueda contrastarse con la evaluación manual SRCI.

---

## 7.4 Propuesta de Pipeline Mejorado

### 7.4.1 Pipeline actual

```
Fase 1 (manual): Changelog → Evidencia candidata (JSON)
Fase 2 (manual): Evidencia → REQ-*.md (plantilla IREB) → Rúbrica calidad
Fase 3 (SpecKit): constitution → specify → plan → tasks → implement
Fase 4 (manual): SRCI sobre diff generado
```

### 7.4.2 Pipeline mejorado

```
Fase 1 (manual ampliada):
  Changelog + diff PR + issues → Evidencia candidata enriquecida

Fase 2 (manual + atributos operativos):
  Evidencia → REQ-*.md (plantilla IREB + dependencias + módulo)
  → Rúbrica calidad + Estado=Borrador→Elaborado→Validado

Fase 3 (SpecKit optimizado):
  constitution PERSONALIZADO (principios RE)
  → specify
    → clarify ← NUEVO (detecta ambigüedades)
      → checklist ← NUEVO (checklist de calidad)
        → plan
          → tasks
            → analyze ← NUEVO (consistencia cruzada)
              → implement
                → analyze ← NUEVO (post-implementación)

  Alternativa: workflow automatizado con gates:
    specify workflow run speckit  (con gates de revisión entre fases)

Fase 4 (evaluación mixta):
  SRCI manual + resultados de analyze (SpecKit) 
  → Comparación entre evaluación humana y automatizada
```

### 7.4.3 Impacto esperado

| Mejora | Impacto en calidad RE | Impacto en el experimento |
|---|---|---|
| `/speckit.clarify` | Detecta ambigüedades antes de que se propaguen | Reduce falsos negativos por specs ambiguas |
| `/speckit.checklist` | Valida calidad contra criterios | Proporciona métrica adicional de calidad de spec |
| `/speckit.analyze` pre | Verifica consistencia spec↔plan↔tasks | Evita implementaciones basadas en planes inconsistentes |
| `/speckit.analyze` post | Verifica consistencia implementación | Proporciona validación automatizada contrastable con SRCI |
| Constitution RE | Alinea SpecKit con objetivos del experimento | Evita principios de desarrollo irrelevantes |
| Workflow automatizado | Gates de revisión estructurados | Mejora reproducibilidad del experimento |
| Fuentes enriquecidas | Requisitos más completos y trazables | Mejora calidad del corpus de entrada |

---

## 7.5 Decisiones y compensaciones

### 7.5.1 Qué NO es recomendable añadir

| Propuesta | Riesgo | Decisión |
|---|---|---|
| Usar preset IREB | Requiere crear y mantener un preset; podría alterar el comportamiento de SpecKit | **Aplazar** — interesante pero fuera de alcance del TFG actual |
| Usar extensiones de terceros | Dependencia externa no controlada; podrían cambiar entre ejecuciones | **No recomendado** — compromete reproducibilidad |
| Workflow completo automatizado | Los workflows son relativamente nuevos (v0.10+); podrían tener bugs o limitaciones de integración con Copilot | **Evaluar experimentalmente** — si funciona, usarlo; si no, mantener manual con los comandos adicionales |
| Múltiples fuentes de elicitación (diff, issues, code review) | Aumenta significativamente el trabajo manual de Fase 1 | **Depende de disponibilidad** — hacerlo cuando sea viable, documentar cuándo no |

### 7.5.2 Prioridades recomendadas

| Prioridad | Acción | Esfuerzo |
|---|---|---|
| 🔴 **Crítica** | Añadir `/speckit.clarify` tras specify | 0 (solo añadir comando) |
| 🔴 **Crítica** | Personalizar constitution con principios RE | Bajo (editar instructions) |
| 🟡 **Alta** | Añadir `/speckit.analyze` pre y post | 0 (solo añadir comando) |
| 🟡 **Alta** | Añadir `/speckit.checklist` | 0 (solo añadir comando) |
| 🟢 **Media** | Añadir campo Dependencias y Módulo a plantilla | Bajo (editar plantilla) |
| 🟢 **Media** | Usar workflow si es viable | Medio (validación técnica) |
| 🔵 **Baja** | Enriquecer fuentes de Fase 1 con diffs | Alto (trabajo manual extra) |

---

## 7.6 Fuentes

- Documentación oficial SpecKit: github.github.io/spec-kit/ (junio 2026)
- spec-driven.md: github/spec-kit (commit f92e7e8, abril 2026)
- Quickstart Guide: docs/quickstart.md (flujo recomendado con clarify, checklist, analyze)
- IREB CPRE Foundation Level Handbook (syllabus oficial v3.x)
- ISO/IEC/IEEE 29148:2018
- 01-flujo-speckit.md (este repositorio, src/0-analisis/)
- 03-deficiencias-grises.md (este repositorio, src/0-analisis/)
