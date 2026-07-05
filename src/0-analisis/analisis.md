# Análisis de Conformidad: SpecKit frente al Marco Normativo de Ingeniería de Requisitos

> **Referencias**: IREB CPRE FL Handbook v1.2.0 · ISO/IEC/IEEE 29148:2018 · INCOSE Guide for Writing Requirements · SpecKit v0.10.2 · Fagan (1976)

---

## Resumen ejecutivo

SpecKit es una herramienta diseñada para acelerar el desarrollo de software mediante especificaciones en lenguaje natural que el agente de IA transforma en código. Su propuesta de valor es indiscutible en el ámbito del desarrollo ágil y asistido por IA. Sin embargo, cuando se evalúa contra los estándares consolidados de la disciplina de Ingeniería de Requisitos —IREB CPRE FL, ISO/IEC/IEEE 29148:2018 e INCOSE—, se constatan lagunas estructurales que comprometen la trazabilidad, la verificabilidad y el control del ciclo de vida de los requisitos.

Este documento caracteriza SpecKit, mapea su funcionamiento contra dichos estándares, cuantifica las divergencias y —lo más importante— propone un conjunto de acciones concretas y accionables para cerrar esa brecha sin abandonar las ventajas que la herramienta ofrece.

> **Conclusión central:** SpecKit y las herramientas profesionales de RE no son alternativas excluyentes; son piezas complementarias de un mismo ecosistema. El kit IREB propuesto en este trabajo actúa como conector entre ambos mundos.

---

## 1. SpecKit: naturaleza y funcionamiento

SpecKit es un toolkit open source (MIT, ~112 000 estrellas en GitHub) que implementa la metodología Spec-Driven Development (SDD). La premisa es sencilla pero poderosa: antes de escribir una sola línea de código, el equipo produce una especificación estructurada en Markdown que el agente de IA —integrado en Copilot Chat mediante comandos slash— convierte sucesivamente en plan de implementación, desglose de tareas y, finalmente, en código con tests.

El flujo completo describe un pipeline de ocho etapas, con pasos opcionales de revisión intercalados:

| Comando | Artefacto generado | Propósito |
|---|---|---|
| `/speckit.constitution` | `memory/constitution.md` | Principios rectores del proyecto |
| `/speckit.specify` | `spec.md` | Especificación funcional en user stories |
| `/speckit.clarify` | Actualiza `spec.md` | Resolución de ambigüedades marcadas |
| `/speckit.checklist` | Informe en chat | Autoverificación de calidad |
| `/speckit.plan` | `plan.md` + `contracts/` | Arquitectura, modelo de datos, contratos |
| `/speckit.tasks` | `tasks.md` | Grafo de dependencias de tareas |
| `/speckit.analyze` | Informe en chat | Consistencia cruzada entre artefactos |
| `/speckit.implement` | PR con código + tests | Implementación completa |

### 1.1 Mecanismos de calidad incorporados

SpecKit no es una herramienta naive: incorpora ciertos mecanismos de aseguramiento de calidad que conviene reconocer antes de señalar sus carencias:

- El marcador `[NEEDS CLARIFICATION]` identifica ambigüedades durante la especificación y las convierte en preguntas explícitas (máximo tres por spec, para evitar parálisis).
- Las plantillas de spec, plan y tasks incluyen checklists internos que el agente verifica antes de continuar.
- Los Constitutional Gates —Simplicity Gate, Anti-Abstraction Gate, Integration-First Gate— actúan como filtros arquitectónicos que evitan sobreingeniería temprana.
- El pensamiento test-first orienta el diseño desde los contratos de interfaz hacia la implementación, no al revés.

### 1.2 Extensibilidad: la clave para la integración con RE

La arquitectura de SpecKit es deliberadamente extensible. Esto es precisamente lo que hace viable —y justificado— el enfoque propuesto en este trabajo:

| Mecanismo | Descripción | Relevancia para RE |
|---|---|---|
| Templates | Plantillas Markdown de spec, plan, tasks y constitution | Permiten añadir los 12 atributos ISO 29148 |
| Commands | Prompts de ocho comandos slash configurables | Permiten incrustar criterios IREB |
| Workflows | Pipelines YAML con gates de revisión humana | Permiten formalizar la validación externa |
| Presets | Paquete instalable de plantillas + comandos + workflows | Un único comando activa el kit IREB completo |
| Extensions | Comandos adicionales de la comunidad | Permiten añadir `/speckit.elicit`, `/speckit.trace` |

---

## 2. Marco normativo de referencia

Para evaluar SpecKit con rigor, es necesario establecer con precisión qué exige la disciplina de Ingeniería de Requisitos. Los tres referentes empleados en este análisis son complementarios y representan el estado del arte de la profesión.

### 2.1 Las tres actividades nucleares según IREB

El estándar IREB CPRE FL Handbook v1.2.0 organiza la RE en torno a tres actividades fundamentales, con la gestión como actividad transversal que las atraviesa:

| Actividad | Definición |
|---|---|
| **Elicitación** | Búsqueda activa, captura y consolidación de requisitos a partir de fuentes diversas: stakeholders, documentación existente, sistemas legados, normativa. |
| **Documentación** | Especificación de requisitos con atributos formales y criterios de calidad medibles. |
| **Validación** | Confirmación de que los requisitos documentados reflejan fielmente las necesidades reales de los stakeholders. |
| **Gestión** (transversal) | Almacenamiento, versionado, trazabilidad bidireccional y control de cambios a lo largo del ciclo de vida. |

### 2.2 Los nueve principios IREB

Más allá de las actividades, IREB establece nueve principios que deben impregnar cualquier proceso de RE maduro. Son el criterio de referencia con el que se contrasta la filosofía de SpecKit en la sección 3:

| # | Principio | Implicación práctica |
|---|---|---|
| 1 | Orientación al valor | Cada requisito justifica su utilidad para el negocio o el usuario. |
| 2 | Implicación de stakeholders | Personas y organizaciones afectadas participan activamente. |
| 3 | Entendimiento compartido | El equipo y los stakeholders leen los requisitos de forma idéntica. |
| 4 | Contexto del sistema | Se modelan actores, interfaces externas y límites del sistema. |
| 5 | Lenguaje común | Un glosario unívoco elimina ambigüedades terminológicas. |
| 6 | Validación | Los requisitos se verifican contra necesidades reales, no solo internamente. |
| 7 | Evolución | El cambio es inevitable; debe gestionarse con baselines y control de versiones. |
| 8 | Innovación | RE es también el momento de explorar soluciones alternativas. |
| 9 | Trabajo sistemático | El proceso es reproducible, auditable y predecible. |

### 2.3 Los ocho criterios de calidad (ISO 29148 / INCOSE)

Un requisito bien escrito debe satisfacer simultáneamente ocho propiedades. No son opcionales: la ausencia de cualquiera de ellas compromete la capacidad de verificar la conformidad del sistema implementado.

| Criterio | Definición operativa |
|---|---|
| Necesario | El sistema no puede cumplir su propósito sin satisfacer este requisito. |
| Singular | Expresa una única obligación; no contiene conjunciones encubiertas. |
| Completo | Incluye toda la información necesaria para que la implementación no requiera suposiciones. |
| Verificable | Puede comprobarse mediante prueba, análisis, inspección o demostración. |
| No ambiguo | Admite una única interpretación razonable. |
| Consistente | No contradice ningún otro requisito del mismo conjunto. |
| Trazable | Su origen (fuente) y su satisfacción (implementación) están documentados y enlazados. |
| Autosuficiente | Comprensible sin necesidad de consultar documentos externos no referenciados. |

---

## 3. Mapeo SpecKit ↔ IREB: estado actual

El análisis sistemático de SpecKit frente a cada actividad, principio y criterio del marco normativo arroja un panorama que puede resumirse en una frase: SpecKit sobresale en automatización de la documentación y en trazabilidad hacia adelante, pero carece por completo de los mecanismos necesarios para elicitar, validar con stakeholders y gestionar el ciclo de vida de los requisitos.

### 3.1 Cobertura por actividad IREB

| Actividad | SpecKit por defecto | Con kit IREB |
|---|---|---|
| **Elicitación** | ✗ 1/10 — Sin técnicas de elicitación; el sistema espera recibir descripciones ya elaboradas. | ✗ 1/10 — SpecKit no puede elicitar; esta actividad es intrínsecamente humana. |
| **Documentación** | ⚠ 5/10 — Las plantillas cubren la estructura, pero sin atributos formales ni glosario. | ✓ 8/10 — La plantilla IREB incorpora los 12 atributos ISO 29148 y reglas INCOSE. |
| **Validación** | ✗ 2/10 — Solo verifica consistencia interna; no contrasta con stakeholders. | ⚠ 5/10 — Los gates, el checklist y el analyze añaden rigor, pero la validación externa sigue siendo manual. |
| **Gestión** | ✗ 2/10 — Trazabilidad forward básica; sin baselines ni control de cambios. | ✗ 2/10 — Limitación estructural; requiere integración con herramienta profesional. |

### 3.2 Cobertura por principio IREB

| Principio | Cobertura en SpecKit | Observación |
|---|---|---|
| 1. Valor | ✓ Cubierto | SDD centra la especificación como fuente de valor de negocio. |
| 2. Stakeholders | ✗ Ausente (crítico) | No existe el concepto de stakeholder en ningún artefacto ni comando. |
| 3. Entendimiento | ⚠ Parcial | Las plantillas estructuran el lenguaje, pero no existe validación externa. |
| 4. Contexto | ✗ Ausente (crítico) | No se modela ningún diagrama de contexto, actor externo o interfaz del sistema. |
| 5. Lenguaje común | ⚠ Parcial | Markdown accesible, pero sin glosario de términos del dominio. |
| 6. Validación | ✗ Ausente (crítico) | La validación es puramente interna; no hay mecanismo para involucrar al cliente final. |
| 7. Evolución | ✗ Ausente | Sin versionado de conjuntos de requisitos ni procedimiento de cambio. |
| 8. Innovación | ⚠ Parcial | Las ramas de exploración favorecen la innovación, pero sin contexto de RE. |
| 9. Sistemático | ✓ Cubierto | El pipeline es reproducible, ordenado y auditable por diseño. |

### 3.3 Cobertura por criterio de calidad ISO 29148

| Criterio | Estado en SpecKit | Evidencia |
|---|---|---|
| Necesario | ✗ No cubierto | No existe distinción entre requisitos esenciales y deseables. |
| Singular | ✗ No cubierto | Las user stories pueden encapsular múltiples comportamientos en una sola cláusula. |
| Completo | ✗ No cubierto | No hay verificación de que ningún caso de uso quede sin especificar. |
| Verificable | ⚠ Parcial | El checklist de plantillas induce verificabilidad, pero sin criterio formal ni métrica. |
| No ambiguo | ⚠ Parcial | `[NEEDS CLARIFICATION]` detecta ambigüedades, pero solo hasta tres por spec y de forma reactiva. |
| Consistente | ⚠ Parcial | `/speckit.analyze` revisa consistencia, pero con alcance limitado a los artefactos propios. |
| Trazable | ✓ Cubierto | La cadena spec → plan → tasks → código es explícita y navegable. |
| Autosuficiente | ⚠ Parcial | Depende directamente de la calidad y completitud del input proporcionado. |

---

## 4. Divergencias identificadas

Del mapeo anterior se derivan veinte divergencias concretas entre SpecKit y el marco normativo. Para orientar la toma de decisiones, se clasifican en dos grupos: críticas —que ninguna configuración de SpecKit puede resolver por sí sola— y parciales —que el kit IREB propuesto cubre en gran medida.

### 4.1 Divergencias críticas

Estas diez divergencias apuntan a ausencias estructurales que no pueden subsanarse únicamente con plantillas o comandos adicionales. Requieren un proceso humano complementario o la integración con una herramienta profesional de RE:

| # | Divergencia | Consecuencia si no se atiende |
|---|---|---|
| D1 | SpecKit no identifica stakeholders ni sus necesidades. | Los requisitos se escriben sin perspectiva de valor real; se construye lo técnicamente correcto pero no lo necesario. |
| D2 | No existen técnicas de elicitación; solo procesa lo que recibe. | Riesgo máximo de "build the wrong thing": los requisitos no descubiertos son los más peligrosos. |
| D3 | No modela el contexto del sistema (actores, interfaces, límites). | Requisitos que ignoran dependencias externas; integración fallida en producción. |
| D4 | No distingue entre requisitos funcionales, de calidad y restricciones. | La validación es homogénea cuando debería ser diferenciada por tipo. |
| D5 | Sin atributos formales: ID, fuente, rationale, prioridad, estado. | Imposible priorizar, auditar o gestionar el conjunto de requisitos como activo del proyecto. |
| D6 | No exige criterio de verificación para cada requisito. | En la revisión de aceptación, no hay criterio objetivo para decidir si el requisito está satisfecho. |
| D7 | Trazabilidad solo hacia adelante; el origen del requisito no se documenta. | No se puede auditar la fuente de un requisito; ante un cambio, no se sabe a quién consultar. |
| D8 | No hay mecanismo de validación externa con stakeholders. | El equipo valida internamente; el cliente descubre la discrepancia en el momento de la entrega. |
| D9 | Sin procedimiento de gestión de cambios ni análisis de impacto. | Los cambios se incorporan ad hoc, rompiendo la consistencia del conjunto de requisitos. |
| D10 | Sin baselines: no existe la noción de conjunto de requisitos congelado. | No hay punto de referencia para medir el alcance; los proyectos sufren scope creep silencioso. |

### 4.2 Divergencias parciales

Estas ocho divergencias son cubiertas en mayor o menor medida por el kit IREB propuesto, que actúa sobre los mecanismos extensibles de SpecKit:

| # | Divergencia | Solución en el kit IREB |
|---|---|---|
| D11 | Las user stories usan lenguaje libre sin patrón formal (INCOSE). | `spec-template-ireb.md` impone el patrón "sujeto + verbo modal + condición + criterio de verificación". |
| D12 | Sin glosario de términos del dominio. | La plantilla incluye una sección de glosario de cumplimentación obligatoria. |
| D13 | Los tipos de requisito no están clasificados; todo se mezcla. | Constitution Art. IV + campo `Type` en cada `REQ-*.md`. |
| D14 | Los requisitos son planos; no hay priorización explícita. | Constitution Art. VIII + campo `Priority` con escala MoSCoW. |
| D15 | La detección de ambigüedad no es sistemática. | `/speckit.clarify` + checklist IREB con comprobación de los ocho criterios ISO 29148. |
| D16 | La consistencia no se verifica de forma cruzada entre spec y plan. | `/speckit.analyze` ejecutado tanto antes como después de la implementación. |
| D17 | No hay quality gate formal; requisitos de baja calidad pasan al pipeline. | `/speckit.checklist` con los doce criterios, tres de ellos bloqueantes. |
| D18 | La constitution es genérica (SDD); no contiene principios de RE. | `constitution.md` IREB con los nueve artículos que traducen los principios IREB a directivas del agente. |

---

## 5. Cómo implementar RE estandarizado con SpecKit

Una vez caracterizadas las divergencias, la pregunta práctica es: ¿cómo se cierra la brecha sin abandonar SpecKit? La respuesta se articula en cuatro vías complementarias, que se pueden adoptar de forma incremental o conjunta.

### 5.1 Vía commands: acción inmediata sin instalación adicional

El primer nivel de adopción no requiere ninguna configuración especial. Simplemente cambia el input y el orden de uso de los comandos existentes:

| Comando | Práctica RE que activa | Modo de uso |
|---|---|---|
| `/speckit.constitution` | Gobernanza RE (nueve principios IREB) | Cargar `constitution.md` IREB como input en lugar de la plantilla genérica. |
| `/speckit.specify` | Documentación con doce atributos ISO 29148 | Pasar el formulario `REQ-*.md` formalizado en lugar de texto libre. |
| `/speckit.clarify` | Detección sistemática de ambigüedad | Ejecutar siempre tras specify; no es opcional en el flujo IREB. |
| `/speckit.checklist` | Quality gate con criterios bloqueantes | Ejecutar tras clarify; ningún REQ pasa al plan si falla un criterio bloqueante. |
| `/speckit.analyze` (pre) | Verificación de consistencia antes de codificar | Ejecutar antes de implement para detectar contradicciones entre spec y plan. |
| `/speckit.analyze` (post) | Validación de trazabilidad post-implementación | Ejecutar tras implement; confirma que cada REQ está satisfecho por al menos una tarea. |

### 5.2 Vía templates: personalización permanente

El segundo nivel instala plantillas personalizadas que fuerzan la estructura normativa en cada nueva especificación, haciéndola el default del equipo:

| Template | Modificación IREB que incorpora |
|---|---|
| `spec-template-ireb.md` | Doce atributos formales (ID, Type, Source, Rationale, Priority, Stability, Verification Method, Acceptance Criteria, Dependencies, Status, Author, Date). Sección de glosario obligatoria. |
| `plan-template-ireb.md` | Los gates SDD son sustituidos por gates IREB: Verificabilidad, Trazabilidad de origen y Clasificación correcta por tipo. |
| `tasks-template-ireb.md` | Cada tarea referencia el REQ-ID al que contribuye; la cadena de trazabilidad se hace explícita. |
| `constitution-template.md` | Nueve artículos que traducen los principios IREB a directivas que el agente respeta durante todo el pipeline. |

### 5.3 Vía workflow: automatización con gates de revisión humana

El tercer nivel define un pipeline YAML de catorce pasos que reproduce el proceso normativo completo, incluyendo cuatro gates de revisión humana inspirados en la inspección estructurada de Fagan (1976):

```
constitution → [GATE 1: revisión humana] → specify → clarify → checklist
→ [GATE 2: revisión de calidad] → plan → [GATE 3: revisión de trazabilidad]
→ tasks → analyze (pre) → [GATE 4: revisión de consistencia]
→ implement → analyze (post) → [GATE final: cierre]
```

### 5.4 Vía preset: instalación en un único comando

El cuarto nivel empaqueta las tres vías anteriores en un preset instalable que convierte el kit IREB en el default del entorno de desarrollo con una sola línea:

```bash
specify preset add ireb --from src/3-implementacion/ireb-kit/preset-ireb.yml
```

Tras la instalación, cualquier `/speckit.specify` lanzado en ese entorno usará automáticamente las plantillas IREB, el workflow de catorce pasos y los criterios bloqueantes del checklist. No se requiere ninguna acción adicional del desarrollador.

---

## 6. SpecKit en el contexto de las herramientas profesionales de RE

Una pregunta recurrente al evaluar SpecKit en entornos regulados o de alta criticidad es: ¿puede reemplazar a herramientas como DOORS, Jama Connect o Polarion? La respuesta directa es no, ni lo pretende. La pregunta más útil es cómo se complementan:

| Característica | DOORS / Jama / Polarion | SpecKit |
|---|---|---|
| Atributos personalizables por campo | ✓ Sí, con validación | ⚠ Solo mediante plantillas editables |
| Clasificación formal por tipo | ✓ Sí, con taxonomía configurable | ✗ No, todo se mezcla en spec.md |
| Trazabilidad bidireccional | ✓ Sí, hacia fuentes y hacia código | ⚠ Solo forward: spec → plan → tasks → código |
| Baselines y versionado de conjuntos | ✓ Sí, con control de acceso | ✗ No existe el concepto |
| Gestión de cambios y análisis de impacto | ✓ Sí, con CCB integrado | ✗ Sin procedimiento formal |
| Generación de código con IA | ✗ No | ✓ Sí, es su razón de ser |
| Integración nativa con agentes de IA | ✗ No | ✓ Sí, pipeline completo |
| Curva de aprendizaje | ✗ Alta; semanas de formación | ✓ Baja; operativo en horas |
| Coste de adopción | ✗ Alto (licencias enterprise) | ✓ Cero (MIT open source) |

> La conclusión no es elegir una herramienta u otra: es usar DOORS o equivalente para gestionar el ciclo de vida de los requisitos, y SpecKit para acelerar la transformación de esos requisitos en código. El kit IREB propuesto en este trabajo es precisamente el conector entre ambos mundos.

---

## 7. Artefactos del kit IREB

El resultado práctico de este análisis es un conjunto de ocho artefactos listos para usar, ubicados en `src/3-implementacion/ireb-kit/`:

| Artefacto | Función | Se usa en |
|---|---|---|
| `constitution.md` | Nueve artículos IREB que gobiernan el comportamiento del agente durante todo el pipeline. | `/speckit.constitution` |
| `spec-template-ireb.md` | Plantilla de especificación con doce atributos, glosario y reglas de escritura INCOSE. | `/speckit.specify` |
| `plan-template-ireb.md` | Plantilla de plan con gates IREB y enfoque test-first alineado con verificabilidad. | `/speckit.plan` |
| `checklist-ireb.md` | Doce criterios de calidad ISO 29148 con tres criterios marcados como bloqueantes. | `/speckit.checklist` |
| `workflow-ireb.yml` | Pipeline YAML de catorce pasos con cuatro gates de revisión humana (inspección Fagan). | Workflows |
| `preset-ireb.yml` | Preset instalable que activa todo el kit con un único comando. | `specify preset add ireb` |
| `prompt-template.md` | Prompt para que un LLM genere `REQ-*.md` formalizados a partir de cualquier fuente. | Elicitación asistida |
| `tutorial.md` | Guía paso a paso para el usuario final con ejemplos comentados. | Incorporación de nuevos miembros |

---

## 8. Conclusiones y acciones recomendadas

### Conclusión 1: SpecKit no puede elicitar requisitos, y no debe intentarlo

La elicitación —entrevistar stakeholders, analizar documentación existente, observar procesos— es una actividad esencialmente humana que requiere criterio, empatía y conocimiento del dominio. Pretender que un pipeline automatizado la realice llevaría a un conjunto de requisitos que refleja lo que el equipo técnico imagina que necesita el cliente, no lo que el cliente realmente necesita.

> **Acción:** Antes de invocar cualquier comando de SpecKit, el equipo debe completar una sesión de elicitación estructurada (entrevistas, talleres, análisis de documentación) y registrar sus resultados en fichas `REQ-*.md` usando el `prompt-template.md` del kit IREB. SpecKit empieza donde termina la elicitación humana.

---

### Conclusión 2: Sin atributos formales, los requisitos son inauditables

Un requisito sin identificador único, sin fuente documentada, sin rationale explícito y sin criterio de verificación es, a efectos prácticos, inútil para cualquier proceso de auditoría, revisión o gestión de cambios. El formato libre de user stories de SpecKit es adecuado para comunicación interna de equipo, pero insuficiente para entornos que exigen trazabilidad completa.

> **Acción:** Instalar `spec-template-ireb.md` como plantilla por defecto del entorno. Configurar `/speckit.checklist` para rechazar cualquier spec que carezca de ID, Source, Verification Method o Acceptance Criteria. Estos cuatro campos son no negociables y deben declararse bloqueantes en `checklist-ireb.md`.

---

### Conclusión 3: La validación interna no sustituye a la validación con stakeholders

`/speckit.analyze` es un mecanismo valioso para detectar inconsistencias entre artefactos del mismo pipeline. Pero verifica que el plan es consistente con la spec, no que la spec es consistente con las necesidades reales del cliente. Son dos tipos de validación distintos y ambos son necesarios. Confundir uno con el otro es el error más frecuente en proyectos que usan herramientas automatizadas de RE.

> **Acción:** Incorporar en el `workflow-ireb.yml` un gate de validación externa obligatorio entre `/speckit.checklist` y `/speckit.plan`. Este gate consiste en una revisión formal del conjunto de `REQ-*.md` con al menos un representante del cliente o del usuario final. Ningún artefacto de planificación se genera sin el registro escrito de esta revisión.

---

### Conclusión 4: Sin baselines, el alcance del proyecto es una ilusión

Los proyectos que no congelan conjuntos de requisitos en momentos acordados no pueden medir si el alcance está creciendo, si los cambios son consecuencia de una petición legítima del cliente o de una decisión técnica unilateral, ni si la implementación entregada corresponde a lo que se contrató. Git proporciona versionado de artefactos individuales, pero no el concepto de baseline —conjunto de requisitos aprobados en una fecha, firmados por las partes y base para medir el cambio.

> **Acción:** Para proyectos de alta criticidad, integrar SpecKit con una herramienta de gestión de requisitos (DOORS, Jama Connect, Polarion, o un repositorio Git con release tags) que proporcione baselines formales. Para proyectos de menor criticidad, establecer el convenio de que cada PR de `/speckit.implement` se etiqueta con el conjunto de REQ-IDs que satisface, creando una baseline implícita en el historial de Git.

---

### Conclusión 5: El kit IREB reduce la brecha de forma significativa, pero no la elimina

Las ocho divergencias parciales —desde la ausencia de glosario hasta la falta de quality gate— quedan cubiertas por el kit IREB propuesto. Las diez divergencias críticas requieren proceso humano o integración con herramienta especializada. Es un resultado honesto: ninguna configuración de SpecKit puede reemplazar la participación de stakeholders, la elicitación sistemática o la gestión formal del ciclo de vida. Lo que sí puede hacer —y hace bien— es elevar significativamente la calidad documental del 80 % del proceso que sí está dentro de su alcance.

> **Acción:** Adoptar el kit IREB completo (`preset-ireb.yml`) como baseline de configuración para cualquier proyecto que deba cumplir con estándares de calidad de requisitos. Complementarlo con el workflow de catorce pasos para proyectos regulados. Documentar explícitamente en el plan de proyecto qué actividades de RE se realizan fuera de SpecKit y quién es responsable de cada una.

---

### Conclusión 6: SpecKit y las herramientas profesionales de RE son aliados, no competidores

La pregunta correcta no es "SpecKit o DOORS". La pregunta es cómo integrar el mejor ciclo de vida de requisitos posible con la mayor velocidad de implementación posible. SpecKit no tiene competencia en la segunda dimensión; DOORS y equivalentes no tienen competencia en la primera. La arquitectura objetivo para entornos maduros es: herramienta profesional para gestionar el ciclo de vida, SpecKit para generar código a partir de los requisitos aprobados, kit IREB como conector entre ambos mundos.

> **Acción:** En proyectos con requisitos normativos estrictos (ISO 26262, DO-178C, IEC 62443, etc.), no usar SpecKit como herramienta de RE primaria. Usarlo como generador de código alimentado por requisitos gestionados en una herramienta certificada. El kit IREB proporciona el formato de intercambio (`REQ-*.md`) que permite exportar requisitos desde cualquier herramienta y usarlos como input de SpecKit.

---

### Resumen de acciones

| # | Acción | Prioridad | Esfuerzo |
|---|---|---|---|
| A1 | Establecer proceso de elicitación humana previo a SpecKit, usando `prompt-template.md`. | Alta | Medio |
| A2 | Instalar `spec-template-ireb.md` y configurar cuatro campos bloqueantes en el checklist. | Alta | Bajo |
| A3 | Añadir gate de validación externa obligatorio entre checklist y plan en el workflow. | Alta | Bajo |
| A4 | Definir convenio de etiquetado de PRs con REQ-IDs para baselines implícitas en Git. | Media | Bajo |
| A5 | Instalar el preset completo: `specify preset add ireb --from preset-ireb.yml`. | Alta | Muy bajo |
| A6 | Para proyectos regulados: integrar con herramienta profesional de RE como fuente de verdad. | Alta (regulados) | Alto |
| A7 | Formar al equipo con `tutorial.md`; el kit IREB es ineficaz si el equipo no entiende el porqué. | Media | Medio |
| A8 | Revisar y actualizar el kit IREB cada vez que se actualice la versión de SpecKit. | Baja | Bajo |

---

## Referencias

1. IREB — International Requirements Engineering Board. *CPRE Foundation Level Handbook v1.2.0*. ireb.org, 2023.
2. ISO/IEC/IEEE 29148:2018. *Systems and software engineering — Life cycle processes — Requirements engineering*. IEEE, 2018.
3. INCOSE. *Guide for Writing Requirements*. INCOSE-TP-2010-006-04. San Diego, 2023.
4. SpecKit GitHub Repository. github.com/speckit-dev/speckit (v0.10.2), 2024.
5. SpecKit Documentation. docs.speckit.dev, 2024.
6. Fagan, M.E. *Design and Code Inspections to Reduce Errors in Program Development*. IBM Systems Journal, 15(3), 182–211, 1976.