# 9. Análisis de Divergencias y Puntos de Encuentro: IREB vs SpecKit

> **Objetivo**: Documentar sistemáticamente (a) dónde SpecKit se desvía de los métodos estandarizados de ingeniería de requisitos, y (b) dónde y cómo se puede implementar un flujo estandarizado usando los mecanismos que SpecKit ya ofrece.
>
> **Basado en**: IREB CPRE Foundation Level Handbook [1], ISO/IEC/IEEE 29148:2018 [2], INCOSE Guide for Writing Requirements [3], documentación oficial de SpecKit v0.10.2 [4], spec-driven.md [5].

---

## Parte A: Divergencias — métodos estandarizados vs flujo SpecKit

Cada divergencia identifica **qué dice la norma**, **qué hace SpecKit por defecto**, y **por qué es una divergencia**.

### A1. Elicitación de requisitos

| Dimensión | Método estandarizado (IREB) | SpecKit por defecto | Divergencia |
|---|---|---|---|
| **A1.1 Identificación de stakeholders** | IREB exige identificar a las personas u organizaciones que influyen en los requisitos o se ven afectadas por el sistema [1, Glossary]. SpecKit no tiene concepto de stakeholder. | `/speckit.specify` recibe una descripción de funcionalidad sin preguntar por el actor o beneficiario. | **Crítica**. Sin stakeholders, los requisitos no tienen contexto de valor. IREB Principle 2 (Stakeholder Involvement) [1, pp. 16-18]. |
| **A1.2 Análisis de fuentes** | IREB define elicitación como el proceso de buscar y consolidar requisitos desde fuentes disponibles [1, Glossary]. ISO 29148 §5.3 requiere identificación de fuentes. | SpecKit asume que el usuario ya tiene clara la necesidad. No analiza fuentes documentales. | **Crítica**. SpecKit no descubre requisitos, los recibe ya formulados. |
| **A1.3 Técnicas de elicitación** | IREB reconoce entrevistas, workshops, prototipado, observación, análisis documental [1, §Elicitation]. | SpecKit ofrece `/speckit.clarify` para identificar áreas subespecificadas, pero no es una técnica de elicitación. | **Parcial**. `clarify` es reactivo (pregunta sobre lo ya escrito), no proactivo (no descubre fuentes nuevas). |
| **A1.4 Modelado de contexto** | IREB exige modelar el contexto del sistema: actores externos, interfaces, límites del sistema [1, Glossary]. | SpecKit no genera diagramas de contexto, modelos de dominio ni identifica actores externos. | **Crítica**. Sin contexto, los requisitos pueden ser incompletos o inconsistentes con el entorno. |
| **A1.5 Glosario de términos** | IREB Principle 5 (Common Language) exige un lenguaje compartido entre stakeholders [1, pp. 16-18]. | SpecKit no genera glosario. Los términos se usan sin definir, asumiendo comprensión compartida. | **Media**. La ambigüedad terminológica es una fuente de defectos en RE. |

### A2. Documentación de requisitos

| Dimensión | Método estandarizado (IREB) | SpecKit por defecto | Divergencia |
|---|---|---|---|
| **A2.1 Tipos de requisitos** | IREB distingue Funcional, Calidad y Restricción [1, §Requirements Types]. ISO 29148 §5.2.1 establece categorías [2]. | SpecKit trata todo como user stories. No hay campo "Tipo". | **Crítica**. Impide análisis diferenciado por tipo (una restricción se valida distinto que un funcional). |
| **A2.2 Atributos de requisitos** | IREB define atributos mínimos: ID, Nombre, Fuente, Rationale, Prioridad, Estado, Versión [1, §Requirements Documentation]. | SpecKit no asigna atributos a los requisitos. La spec.md es texto narrativo. | **Crítica**. Sin atributos no hay gestión de requisitos posible. |
| **A2.3 Estructura formal** | INCOSE exige estructura uniforme: "El sistema deberá [verbo] [objeto] [condición]" [3, §Structure]. | SpecKit usa user stories en lenguaje libre. No impone estructura. | **Crítica**. El lenguaje libre introduce ambigüedad. |
| **A2.4 Verificabilidad** | ISO 29148 §6.2.2 exige que todo requisito sea verificable mediante prueba, análisis, inspección o demostración [2]. | SpecKit no exige criterios de verificación en los requisitos de entrada. | **Crítica**. Sin verificación, no se puede determinar si la implementación satisface el requisito. |
| **A2.5 Trazabilidad hacia fuentes** | IREB define trazabilidad como capacidad de trazar un requisito hacia sus orígenes [1, Glossary]. | SpecKit no registra la fuente de los requisitos. La trazabilidad es interna al pipeline (spec→plan→tasks→code). | **Crítica**. Sin trazabilidad hacia fuentes, no se puede auditar el origen de las decisiones. |

### A3. Validación de requisitos

| Dimensión | Método estandarizado (IREB) | SpecKit por defecto | Divergencia |
|---|---|---|---|
| **A3.1 Validación con stakeholders** | IREB Principle 6 (Validation) exige confirmar que los requisitos reflejan necesidades reales [1, pp. 16-18]. | SpecKit no contacta stakeholders. La validación es interna al pipeline. | **Crítica**. SpecKit no puede validar que el requisito es correcto, solo que es consistente. |
| **A3.2 Inspección estructurada** | Fagan (1976) demostró que la inspección formal reduce defectos. ISO 29148 recomienda revisiones estructuradas. | `/speckit.analyze` verifica consistencia entre artefactos, pero no es una inspección formal. | **Media**. `analyze` es útil pero limitado a consistencia interna. |
| **A3.3 Prototipado para validación** | IREB reconoce el prototipado como técnica de validación [1, §Prototyping]. | SpecKit genera código directamente, no prototipos exploratorios. | **Media**. La generación directa de código puede ocultar errores de especificación. |

### A4. Gestión de requisitos

| Dimensión | Método estandarizado (IREB) | SpecKit por defecto | Divergencia |
|---|---|---|---|
| **A4.1 Control de versiones individual** | IREB exige versionado individual de requisitos [1, pp. 130-140]. | Git versiona archivos, pero no hay versionado semántico individual de requisitos. | **Media**. Los cambios a un requisito no tienen historial independiente. |
| **A4.2 Baselines** | IREB define baseline como una configuración estable de requisitos [1, Glossary]. | SpecKit no tiene concepto de baseline de requisitos. | **Crítica**. No se puede congelar un conjunto de requisitos para una release. |
| **A4.3 Gestión de cambios** | IREB exige proceso de cambio: solicitud → análisis de impacto → aprobación → implementación [1, §Requirements Management]. | Los cambios se gestionan manualmente via Git. No hay CCB ni análisis de impacto. | **Crítica**. Sin gestión de cambios, la evolución de requisitos no es controlable. |
| **A4.4 Análisis de impacto** | ISO 29148 §6.5 requiere análisis de impacto ante cambios [2]. | SpecKit no ofrece análisis de impacto. Cambiar un requisito no señala qué plan/tasks/código se ven afectados. | **Crítica**. Los cambios pueden propagar errores silenciosamente. |

---

## Parte B: Puntos de encuentro — dónde implementar RE estandarizado con SpecKit

Cada punto de encuentro identifica **qué mecanismo de SpecKit se usa**, **qué práctica RE se implementa**, y **cómo se configura**.

### B1. Puntos de encuentro en Templates

| # | Mecanismo SpecKit | Práctica RE implementada | Cómo se configura | Referencia |
|---|---|---|---|---|
| **B1.1** | `spec-template.md` | Atributos IREB en la especificación. Se sobreescribe la plantilla para añadir campos: Tipo, Fuente, Rationale, Prioridad, Verificación. | Copiar `ireb-kit/spec-template-ireb.md` a `.specify/templates/overrides/spec-template.md` | IREB §Doc. [1], ISO 29148 [2] |
| **B1.2** | `plan-template.md` | Constitutional Gates IREB. Las compuertas de Simplicidad/Anti-Abstraction/Integration-First se sustituyen por Verificabilidad/Trazabilidad/Clasificación/No-Ambigüedad. | Copiar `ireb-kit/plan-template-ireb.md` a `.specify/templates/overrides/plan-template.md` | Fagan [6], INCOSE [3] |
| **B1.3** | `tasks-template.md` | Trazabilidad requisito→tarea. Se modifica para que cada tarea referencie explícitamente un REQ-ID. | Editar el campo "Implements requirement" en la plantilla de tasks | IREB Traceability [1] |
| **B1.4** | `constitution-template.md` | Principios RE como base del proyecto. Se reemplazan los 9 artículos SDD por 9 artículos IREB. | Usar `ireb-kit/constitution.md` como input de `/speckit.constitution` | IREB Principles [1] |

### B2. Puntos de encuentro en Commands

| # | Mecanismo SpecKit | Práctica RE implementada | Cómo se configura | Referencia |
|---|---|---|---|---|
| **B2.1** | `/speckit.constitution` | Gobernanza de requisitos. Se cargan principios RE que SpecKit aplicará en todas las fases siguientes. | Pegar `ireb-kit/constitution.md` como argumento del comando | IREB Principles 1-9 [1] |
| **B2.2** | `/speckit.specify` | Documentación estructurada de requisitos. Con la entrada formalizada (REQ-*.md), la spec resultante tiene estructura IREB. | Pasar el archivo REQ-*.md como entrada (no texto crudo) | IREB §Doc. [1] |
| **B2.3** | `/speckit.clarify` | Detección de ambigüedad (IREB Quality Criterion: Unambiguity). Identifica áreas subespecificadas antes de planificar. | Ejecutar después de `/speckit.specify` y antes de `/speckit.plan` | ISO 29148 §6.2.2 [2], INCOSE [3] |
| **B2.4** | `/speckit.checklist` | Quality gate de requisitos (IREB Quality Assurance). Genera checklist basado en ISO 29148. | Ejecutar después de `/speckit.clarify`. Usar `ireb-kit/checklist-ireb.md` como referencia. | ISO 29148 §6.2.2 [2] |
| **B2.5** | `/speckit.analyze` (pre) | Verificación de consistencia (IREB Validation). Detecta gaps entre spec, plan y tasks antes de implementar. | Ejecutar después de `/speckit.tasks` y antes de `/speckit.implement` | IREB Principle 6 [1] |
| **B2.6** | `/speckit.analyze` (post) | Validación de trazabilidad (IREB Traceability). Verifica que la cadena REQ→spec→plan→task→code es completa. | Ejecutar después de `/speckit.implement` | IREB Traceability [1] |

### B3. Puntos de encuentro en Workflows

| # | Mecanismo SpecKit | Práctica RE implementada | Cómo se configura | Referencia |
|---|---|---|---|---|
| **B3.1** | `workflow.yml` | Pipeline automatizado con gates de revisión humana. Cada gate es una validación IREB: constitution → specify → clarify → checklist → plan → tasks → analyze → implement → analyze. | Instalar `ireb-kit/workflow-ireb.yml` en `.specify/workflows/ireb/` y ejecutar `specify workflow run ireb` | IREB Principle 9 [1], Fagan [6] |
| **B3.2** | Gates de revisión (type: gate) | Inspección estructurada (Fagan inspections). Cada gate requiere aprobación humana antes de continuar. | Definir gates en `workflow.yml` con review-spec, review-plan, review-analysis, review-final | Fagan [6], ISO 29148 §5.3 [2] |

### B4. Puntos de encuentro en Presets

| # | Mecanismo SpecKit | Práctica RE implementada | Cómo se configura | Referencia |
|---|---|---|---|---|
| **B4.1** | `preset.yml` | Empaquetado de todas las personalizaciones IREB como preset instalable. Un solo comando aplica todos los cambios. | `specify preset add ireb --from ireb-kit/preset-ireb.yml` | Documentación de presets [4] |

### B5. Puntos de encuentro en Proceso Humano (externo a SpecKit)

| # | Mecanismo (manual) | Práctica RE implementada | Cuándo se aplica | Referencia |
|---|---|---|---|---|
| **B5.1** | Análisis de changelog | Elicitación por análisis documental (IREB). Extraer verbos, objetos, condiciones de la fuente. | Antes de abrir SpecKit. Paso 1 del tutorial. | IREB §Elicitación [1] |
| **B5.2** | Identificación de stakeholders | Stakeholder analysis (IREB Principle 2). Aunque no haya stakeholders entrevistables, se documentan los afectados. | Durante la elicitación. | IREB Principle 2 [1] |
| **B5.3** | Redacción con plantilla IREB | Documentación formal (INCOSE). Rellenar los 12 atributos. | Después de la elicitación, antes de SpecKit. | INCOSE [3] |
| **B5.4** | Aplicación de rúbrica de 12 criterios | Quality gate (ISO 29148). Validar que el requisito cumple los criterios bloqueantes. | Después de redactar, antes de SpecKit. | ISO 29148 [2] |
| **B5.5** | Verificación SRCI post-implementación | Inspección de conformidad (Fagan + ISO 29148). Evaluar C1-C6 sobre el diff generado. | Después de SpecKit. | Fagan [6], ISO 29148 [2] |

---

## Parte C: Mapa de cobertura — qué se puede y qué no se puede implementar

### C1. Implementable con SpecKit (con configuración IREB)

| Práctica RE | Mecanismo | Esfuerzo | Efectividad esperada |
|---|---|---|---|
| Documentación estructurada (12 atributos) | Plantilla IREB + input formalizado | Bajo | Alta — la estructura guía al LLM |
| Quality gate (checklist) | `/speckit.checklist` + checklist IREB | Bajo | Alta — el LLM aplica criterios |
| Detección de ambigüedad | `/speckit.clarify` | Bajo | Media — detecta lo evidente |
| Consistencia cruzada | `/speckit.analyze` | Bajo | Alta — encuentra gaps entre artefactos |
| Trazabilidad forward | Constitution + pipeline | Medio | Alta — se fuerza la cadena req→code |
| Clasificación por tipo | Plantilla + constitution | Medio | Alta — el LLM clasifica si se lo pides |
| Gobernanza RE | Constitution personalizado | Bajo | Alta — aplica principios en toda la sesión |
| Pipeline con gates | Workflow YAML | Medio | Alta — automatiza con revisión humana |

### C2. NO implementable en SpecKit (requiere proceso humano externo)

| Práctica RE | Por qué no es implementable | Dónde hacerlo |
|---|---|---|
| Elicitación con stakeholders | SpecKit no contacta personas | Fase 1 manual (antes de SpecKit) |
| Context modeling | SpecKit no modela, genera código | Documentación aparte (diagrama de contexto) |
| Glosario de términos | SpecKit no gestiona vocabulario | Documento aparte o en la propia plantilla |
| Versionado individual de reqs | SpecKit no tiene BD de requisitos | Git + control manual |
| Baselines de requisitos | SpecKit no congela conjuntos | Git tags + documentación |
| Análisis de impacto | SpecKit no conoce dependencias entre reqs | Análisis manual |
| Validación con stakeholders | SpecKit no tiene acceso a personas | Revisión externa |
| Trazabilidad bidireccional | SpecKit solo traza forward | Matriz manual complementaria |

### C3. Tabla resumen: cobertura por actividad IREB

| Actividad IREB | SpecKit sin config | SpecKit con kit IREB | Proceso humano externo |
|---|---|---|---|
| Elicitación | ❌ No | ❌ No | ✅ Manual (changelog + stakeholders) |
| Documentación | ⚠️ 5/10 | ✅ 8/10 | ✅ Plantilla + rúbrica |
| Validación | ❌ 2/10 | ⚠️ 5/10 | ✅ SRCI post-implementación |
| Gestión | ❌ 2/10 | ❌ 2/10 | ⚠️ Git manual |

---

## Referencias

[1] Glinz, M. et al. (2024). *CPRE Foundation Level Handbook*, v1.2.0. IREB.
[2] ISO/IEC/IEEE 29148:2018. *Systems and Software Engineering — Life Cycle Processes — Requirements Engineering*.
[3] INCOSE (2012). *Guide for Writing Requirements*.
[4] GitHub SpecKit (2026). *Documentación oficial*. https://github.github.io/spec-kit/
[5] GitHub SpecKit (2026). *Spec-Driven Development*. https://github.com/github/spec-kit/blob/main/spec-driven.md
[6] Fagan, M.E. (1976). "Design and Code Inspections to Reduce Errors in Program Development". *IBM Systems Journal*, 15(3).
