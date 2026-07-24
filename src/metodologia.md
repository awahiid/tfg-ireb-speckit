# Metodología

## Introducción y anclaje metodológico

### Objetivos y preguntas centrales

Este trabajo persigue **dos objetivos complementarios**:

**Objetivo 1 — Mapear**: mapear sistemáticamente el flujo de trabajo de SpecKit (SDD) contra un flujo profesional de ingeniería de requisitos basado en normas (IREB, ISO/IEC/IEEE 29148, INCOSE), identificando alineaciones, brechas y áreas grises entre ambos.

**Objetivo 2 — Evaluar**: evaluar si las diferencias identificadas en el mapeo se traducen en resultados medibles, comparando cuatro condiciones experimentales (C0–C3) que cubren el espectro desde "sin metodología" (Vibe Coding) hasta "IREB completo con scope contract".

Las preguntas que guían el diseño metodológico son:

1. *¿En qué medida se alinea el pipeline SDD de SpecKit con las actividades, criterios de calidad y artefactos definidos por un flujo RE profesional basado en normas?*
2. *¿Mejora la calidad de la implementación generada cuando los requisitos de entrada se formalizan siguiendo IREB y se añaden mecanismos de robustez (AGENTS.md, scope contract), en comparación con usar la entrada sin tratar o sin pipeline?*

El marco normativo de referencia es IREB, complementado con ISO/IEC/IEEE 29148 e INCOSE. Las fases de la metodología se estructuran así:

| Fase | Propósito | Marco de referencia |
|---|---|---|
| Fase 1. Extracción de evidencia | Obtener requisitos del mundo real | IREB Elicitación |
| Fase 2. Formalización | Producir requisitos con atributos normativos | IREB Documentación + ISO 29148 |
| Fase 2.5. Derivación MRS | Transformar requisitos en prompts replicables | IREB Elicitación (problem framing) |
| Fase 3. Ejecución comparativa | Ejecutar 4 flujos (C0–C3) sobre 24 casos (4 por repositorio) | SpecKit SDD + opencode |
| Fase 4. Evaluación | Análisis automático (6 herramientas + comparación PR real) | IREB + ISO 29148 + ISO 25010 |

### Diseño experimental: 4 condiciones (C0–C3)

| Flujo | Pipeline | Entrada | Pasos |
|---|---|---|---|
| **C0** — SpecKit vanilla | `pipeline-c0.sh` | Changelog literal | 4 (specify → plan → tasks → implement) |
| **C1** — IREB v1 | `pipeline-c1.sh` | REQ formalizado (12 attr.) + constitución IREB | 9 (sin AGENTS.md ni scope contract) |
| **C2** — IREB v2 | `pipeline-c2.sh` | REQ + constitución + AGENTS.md + scope contract | 10 |
| **C3** — Vibe Coding | `pipeline-c3.sh` | MRS (3–5 líneas, sin SpecKit) | 1 |

### Evaluación en dos fases

**Fase 4 — Automática**: semgrep, eslint, phpcs, shellcheck, pyflakes, cloc sobre los 96 artefactos generados. Comparación del diff generado con el PR real mediante métricas de precisión, recall y F1. La evaluación manual (rúbrica SRCI v3) queda pendiente.

### Resultados clave (análisis automático, medias de 24 casos por flujo)

| Métrica | C0 | C1 | C2 | C3 |
|---|---|---|---|---|
| F1 vs PR real | 0.46 | 0.52 | **0.62** | **0.62** |
| Precisión | 49.5% | 53.2% | 70.2% | **83.0%** |
| Recall | 54.0% | **64.8%** | 62.5% | 57.8% |
| Archivos fuente | 14 | 15 | 15 | 3 |
| Líneas de código | 13,453 | 19,696 | 12,491 | 3,221 |
| Artefactos pipeline | **100%** | 48% | 57% | --- |
| Coste | $0.057 | $0.092 | $0.076 | **$0.019** |

**Conclusión**: cada nivel de madurez metodológica mejora la alineación con el PR real: C0 (0.46) → C1 (0.52) → C2 (0.62). C3 iguala a C2 en F1 (0.62) pero con un perfil opuesto: precisión del 83% sobre solo 3 archivos, frente al equilibrio de C2 (70% sobre 15 archivos). El pipeline no solo mejora la precisión, sino que permite cubrir más alcance sin sacrificarla en exceso.

Se optó por IREB como norma principal frente a IEEE 830 porque IREB proporciona un marco más abstracto y adaptable, mientras que IEEE 830 prescribe una plantilla de especificación concreta que presupone un proceso de elicitación deliberado con stakeholders. ISO 29148 e INCOSE se incorporan como complementos para criterios de calidad de requisitos y buenas prácticas de redacción, respectivamente.

### El problema de partida y la solución adoptada

Para realizar un mapeo significativo entre SpecKit y un flujo RE basado en normas se necesitan dos cosas: (a) una caracterización precisa del flujo de SpecKit, y (b) ejemplos concretos de requisitos reales sobre los que observar el comportamiento del pipeline. El primer componente se obtiene de la documentación oficial de SpecKit (repositorio, docs site, spec-driven.md). El segundo requiere un corpus de requisitos que provenga de proyectos representativos de la industria y que pueda ser procesado por SpecKit para generar implementaciones.

Este corpus no existe como recurso estándar: los datasets académicos disponibles son demasiado artificiales o carecen de implementación asociada, y los requisitos industriales reales raramente son públicos. La solución adoptada consiste en construir ese corpus a partir de proyectos Open Source, aprovechando que los cambios aceptados en la rama principal han pasado por un proceso implícito de elicitación (issue, discusión, revisión de PR) y validación (CI, code review, merge). Esto los convierte en fuentes funcionalmente equivalentes a los artefactos que resultan de un proceso IREB de elicitación, con la ventaja adicional de que el diff asociado a cada cambio actúa como referencia para el análisis del mapeo. Los requisitos así obtenidos se formalizan siguiendo la plantilla IREB y se introducen en SpecKit para observar cómo el pipeline SDD los procesa, qué artefactos genera y qué nivel de alineación se produce con el flujo normativo.

---

## Fase 1. Extracción de evidencia candidata

La primera fase corresponde a la actividad de elicitación en el marco IREB y tiene como objetivo **construir un corpus de cambios reales sobre los que observar el comportamiento del pipeline SpecKit**. Se identifican y registran cambios concretos en repositorios Open Source que sean suficientemente ricos y trazables como para derivar requisitos verificables en la fase siguiente. Este corpus no es una "muestra estadística" sino un conjunto de casos representativos para el mapeo cualitativo.

En esta fase no se redactan requisitos. Únicamente se almacenan textos literales de cambios junto con su trazabilidad mínima: versión, URL de release, referencia a PR, commit asociado y señales explícitas presentes en el texto. La conservación del texto literal sin paráfrasis es una decisión deliberada que separa la observación de la formalización y mejora la auditabilidad del proceso, en línea con la distinción IREB entre elicitación y documentación.

### 1.1 Criterios de selección de repositorios

Los repositorios seleccionados deben cumplir los siguientes criterios:

- **Representatividad industrial**: el proyecto debe utilizarse en contextos reales de producción.
- **Actividad de mantenimiento**: debe tener un historial de versiones suficiente para extraer cambios significativos.
- **Calidad de trazabilidad**: los changelogs deben referenciar PRs o commits con diff localizable y verificable.
- **Sencillez relativa del dominio**: los cambios deben ser comprensibles sin conocimiento altamente especializado, de forma que la derivación de requisitos sea razonable y evaluable.

Los repositorios no se escogen al azar. Cada uno representa un tipo distinto de problema dentro del espectro del desarrollo de software, cubriendo de forma equilibrada los dominios que dominan las taxonomías empíricas de la ingeniería de software (construcción, diseño, requisitos, mantenimiento). La clasificación se basa en la naturaleza del sistema, no en el dominio de negocio, siguiendo la premisa de que el software se divide por tipo de problema a resolver, no por sector. Los seis tipos seleccionados y su asignación son:

1. **Transactional systems** (sistemas transaccionales): SaaS, CRUD, REST APIs, aplicaciones de negocio. Representado por **Appwrite**, un backend-as-a-service que expone APIs REST transaccionales para datos, autenticación, almacenamiento y funciones.

2. **Financial / state consistency systems** (sistemas financieros y de consistencia de estado): e-commerce, sistemas de facturación, pedidos, pagos. Representado por **Medusa**, plataforma de comercio electrónico con gestión de órdenes, pagos y control de estado transaccional.

3. **Identity & security systems** (sistemas de identidad y seguridad): autenticación, RBAC, sesiones, flujos de autorización. Representado por **Authentik**, proveedor de identidad open source con soporte para múltiples protocolos y control de acceso basado en roles.

4. **Collaboration systems** (sistemas colaborativos): estado multiusuario, manejo de concurrencia, notificaciones, workflows compartidos. Representado por **Cal.com**, plataforma de scheduling colaborativo con gestión de disponibilidad y notificaciones entre múltiples actores.

5. **Data / content systems** (sistemas de datos y contenido): CMS, esquemas dinámicos, flujos editoriales, pipelines de contenido. Representado por **Directus**, headless CMS con esquemas dinámicos, API autogenerada y flujos de contenido configurables.

6. **Integration / service composition systems** (sistemas de integración y composición de servicios): agregación de APIs, webhooks, sistemas guiados por eventos, orquestación de servicios. Representado por **n8n**, plataforma de automatización de workflows con composición visual de servicios y webhooks.

Esta clasificación garantiza que el corpus cubra un espectro amplio de tipos de sistemas software, lo que refuerza la validez externa del estudio al no limitar la evaluación a un único tipo de aplicación. Cada repositorio aporta cambios característicos de su categoría: reglas de negocio transaccionales en Medusa, flujos de autorización en Authentik, sincronización de estado multiusuario en Cal.com, transformaciones de contenido en Directus y composición dirigida por eventos en n8n. Appwrite añade el patrón de API transaccional CRUD que subyace a la mayoría de aplicaciones SaaS modernas.

### 1.2 Rúbrica de selección de cambios

Para la selección de cambios individuales se definió una rúbrica pragmática orientada a evidencia candidata, organizada en cuatro dimensiones:

- **Trazabilidad**: la entrada referencia una PR o commit concreto con diff localizable.
- **Señales estructurales**: el texto menciona una superficie técnica o una condición o actor relevante.
- **Utilidad para derivación**: el contenido describe un comportamiento del sistema que puede formalizarse como requisito verificable.
- **Defendibilidad**: la inclusión puede justificarse con un razonamiento explícito.

Se descartó una rúbrica basada en las propiedades formales de IEEE 830 porque su aplicación sobre changelogs generó un rechazo prácticamente universal de entradas, incluyendo algunas con alto valor de trazabilidad. Una rúbrica demasiado estricta en esta fase compromete la viabilidad del corpus sin mejorar la calidad del resultado final, dado que la formalización rigurosa se realiza en la fase 2.

### 1.3 Procedimiento

1. Seleccionar un repositorio del conjunto preestablecido.
2. Leer los cambios en cada versión comenzando por la más reciente y valorar cada uno con la rúbrica.
3. Si el cambio supera el umbral, registrarlo con su trazabilidad completa e identificar el commit exacto que lo introduce.
4. Consultar fuentes complementarias (diff de PR, issues, code review) cuando estén disponibles y el changelog sea insuficiente para derivar el comportamiento.
5. Reunir un conjunto inicial de aproximadamente diez entradas por repositorio, ampliable si la fase 2 descarta entradas.

### 1.4 Fuentes complementarias (cuando estén disponibles)

Además de los changelogs, cuando sea viable se consultan fuentes complementarias para enriquecer la elicitación:

- **Diff completo de la PR**: El changelog entry es un resumen; el diff contiene el comportamiento real implementado. Su consulta permite validar que el requisito derivado captura correctamente el cambio.
- **Issues asociados**: Cuando el changelog o la PR referencian un issue, este puede contener discusión sobre alternativas, casos borde y rationales no documentados en el changelog.
- **Comentarios de code review**: Pueden revelar restricciones implícitas o decisiones arquitectónicas que no aparecen en el changelog.

Estas fuentes no siempre están disponibles o accesibles. Cuando se utilizan, se documentan en el campo Fuente del requisito. Cuando no, el requisito se deriva exclusivamente del changelog, lo que se documenta como limitación.

### 1.5 Limitaciones y amenazas a la validez

Los changelogs no son especificaciones formales sino artefactos de comunicación técnica de granularidad heterogénea. Existe una amenaza de validez de constructo relevante: el requisito derivado en la fase 2 puede no capturar completamente el comportamiento implementado en el diff, sino solo una parte de él. Esta limitación implica que la evaluación mide la capacidad de SpecKit para implementar el requisito tal como fue derivado, no necesariamente el comportamiento completo del cambio original. Esta distinción se asume explícitamente como parte del diseño y se documenta en los resultados.

---

## Fase 2. Formalización de requisitos

La fase 2 corresponde a la actividad de documentación en el marco IREB y tiene como objetivo **producir requisitos con atributos y criterios de calidad normativos** (basados en ISO 29148 e INCOSE) para utilizarlos como entrada en el pipeline SpecKit. La evidencia extraída en la fase anterior se transforma en requisitos explícitos y verificables, siguiendo la plantilla de especificación definida para el trabajo. El objetivo no es reinterpretar libremente el contenido original, sino estructurarlo en una forma operativa que respete las propiedades IREB de verificabilidad, consistencia y completitud, y que sea directamente utilizable como entrada para SpecKit.

Cada requisito resultante debe superar el quality gate definido por la rúbrica de validación de formalización antes de incorporarse al corpus definitivo. Los requisitos que no alcancen el umbral mínimo se devuelven a revisión o se descartan, ampliando el conjunto de evidencia candidata si es necesario.

El principal riesgo de esta fase es la introducción de interpretación implícita al pasar de descripciones de cambios a formulaciones de requisitos. Para mitigarlo, los requisitos se redactan siguiendo una plantilla fija y el texto literal de la fuente se conserva como referencia en el dataset, manteniendo la trazabilidad entre requisito formalizado y evidencia de origen.

La plantilla incluye dos atributos adicionales para mejorar la gestión:

- **Dependencias**: IDs de otros requisitos relacionados, permitiendo construir un grafo de dependencias entre requisitos del mismo corpus.
- **Módulo**: Agrupación por subsistema o componente funcional dentro del repositorio, facilitando el análisis por área.

Estos atributos complementan los diez existentes (ID, Nombre, Tipo, Descripción formal, Fuente, Rationale, Prioridad, Verificación, Estado, Versión) y se documentan en la plantilla completa en `src/2-requisitos/plantilla.md`. El campo `Estado` se utiliza de forma operativa: los requisitos comienzan como `Borrador` tras la derivación, pasan a `Elaborado` tras la revisión del autor y a `Validado` tras superar la rúbrica de formalización.

Se descartó una formalización mediante lenguaje controlado o notación formal como plantillas Rupp o especificación en lógica de primer orden por resultar desproporcionada para el tipo de fuente analizado y para el alcance de un TFG aplicado. La plantilla estructurada en lenguaje natural con criterios de verificación observables ofrece el equilibrio adecuado entre rigor y pragmatismo.

---

## Fase 2.5. Derivación de Prompts MRS (Minimal Requirement Seed)

La Fase 2.5 es un paso intermedio entre la formalización (Fase 2) y la ejecución del pipeline SpecKit (Fase 3). Su objetivo es **transformar cada requisito formalizado IREB/ISO 29148 en un *Minimal Requirement Seed* (MRS)**: un prompt mínimo, replicable y académicamente justificable que un usuario convencional necesitaría formular para que el pipeline IREB/SpecKit derive de forma autónoma el requisito formal equivalente.

### 2.5.1 Justificación

La Fase 2.5 surge de una necesidad metodológica concreta: el Flow B de la Fase 3 (IREB-enhanced) requiere que el agente SpecKit reciba como entrada un requisito formalizado siguiendo la plantilla IREB. Sin embargo, SpecKit es una herramienta diseñada para recibir descripciones en lenguaje natural, no documentos estructurados con doce atributos. El MRS actúa como **puente**: es una semilla de lenguaje natural que contiene la información estrictamente necesaria para que SpecKit (o cualquier LLM) infiera el requisito formal completo, pero no sobredetermina la solución.

### 2.5.2 Propiedades de un MRS válido

Un MRS es válido si y solo si satisface tres propiedades, justificadas normativamente:

| Propiedad | Definición operacional | Fundamento |
|---|---|---|
| **Suficiencia** | Contiene toda la información necesaria para inferir los campos obligatorios de la plantilla (Descripción formal, Verificación, Rationale, Tipo) | ISO 29148 §5.2: un requisito debe ser necesario, no ambiguo, factible y verificable |
| **Minimalidad** | No contiene información que el agente deba inferir por sí mismo (no sobredetermina la solución) | IREB CPRE: la elicitación por *problem framing* produce requisitos más estables que la elicitación por solución propuesta |
| **Replicabilidad** | Dos agentes independientes que lean el MRS y la plantilla producen requisitos formales equivalentes | Reynolds & McDonell (2021), Wei et al. (2022): prompts con estructura `role + goal + constraint` maximizan la consistencia |

### 2.5.3 Estructura canónica

Todo MRS sigue una plantilla de tres líneas obligatorias y dos opcionales:

```
Como [ROL/ACTOR],
quiero que el sistema [COMPORTAMIENTO OBSERVABLE]
[a través de / cuando] [CONTEXTO_TÉCNICO],
para [MOTIVACIÓN — estado indeseable actual o riesgo evitado].

[Restricción: RESTRICCIÓN_CONOCIDA]
[Fuente: REFERENCIA_TRAZABLE]
```

### 2.5.4 Procedimiento de derivación

Para cada `REQ-*.md` generado en la Fase 2:

1. **Validar la entrada**: verificar que el REQ contiene los campos bloqueantes (Descripción formal, Verificación). Los requisitos incompletos se registran como omitidos.
2. **Identificar el comportamiento observable**: localizar el verbo principal (el que sigue a "El sistema deberá") y verificar que es observable según la rúbrica de formalización (R7).
3. **Construir el MRS**: aplicar la plantilla canónica extrayendo el actor más específico posible del Módulo y la Descripción formal, parafraseando en voz activa, y nombrando exactamente un artefacto concreto (variable de entorno, endpoint, componente) como contexto.
4. **Verificar suficiencia**: comprobar que un agente que solo lea el MRS y la plantilla podría inferir el Tipo, la Descripción formal, al menos un criterio de Verificación y el Rationale.
5. **Emitir la salida**: generar `mrs-prompts.md` con un bloque por requisito, vinculando cada MRS con su `REQ-*.md` de origen a través del ID.

Las instrucciones completas para el agente derivador, incluyendo ejemplos de referencia y reglas de extracción por campo, se documentan en `src/2.5-prompts/instrucciones.md`.

### 2.5.5 Producto

El producto de esta fase es un único archivo `mrs-prompts.md` que contiene los 52 MRS derivados de los 52 requisitos formalizados, organizados por repositorio. Cada bloque MRS es directamente utilizable como valor del parámetro `--input spec=` en el script `run-ireb.sh` de la Fase 3.

### 2.5.6 Limitaciones

La derivación de MRS introduce un paso adicional de transformación que puede alterar sutilmente el significado del requisito original. Para mitigarlo, cada MRS conserva la trazabilidad hacia el `REQ-*.md` de origen mediante el ID, y el script de generación aplica reglas deterministas documentadas en `instrucciones.md`. Adicionalmente, el campo `Notas de derivación` documenta cualquier decisión no trivial (rationale inferido, verbo subsidiario, omisión de contexto).

---

## Fase 3. Ejecución comparativa: Flow A vs Flow B

En esta fase cada caso del corpus se ejecuta **dos veces** sobre el mismo repositorio (en el mismo commit pre-PR), cambiando únicamente el tratamiento del requisito de entrada y la configuración de SpecKit. Esto permite aislar el efecto del marco IREB: el resto de variables (repositorio, commit, entorno) permanecen constantes.

### 3.1 Protocolo general

Para cada caso:

1. Checkout del repositorio en el commit inmediatamente anterior al cambio de referencia.
2. Verificación de que el entorno compila y los tests existentes pasan.
3. Dos ejecuciones de SpecKit sobre ese mismo entorno:

   **Flow A (baseline) — SpecKit sin marco IREB:**
   ```
   /speckit.specify          (pegando el texto LITERAL del changelog)
   → /speckit.plan
   → /speckit.tasks
   → /speckit.implement
   ```
   En este flujo no se ejecuta `/speckit.constitution` (se usa el que venga por defecto), ni se usan `clarify`, `checklist` ni `analyze`. La entrada es el texto del changelog sin ningún tratamiento.

   **Flow B (IREB-enhanced) — SpecKit con marco IREB:**
   ```
   /speckit.constitution       (con principios RE personalizados:
                                 verificabilidad, minimalidad, trazabilidad)
   → /speckit.specify          (pegando el REQ-*.md formalizado)
   → /speckit.clarify          (detección de ambigüedades)
   → /speckit.checklist        (checklist de calidad)
   → /speckit.plan
   → /speckit.tasks
   → /speckit.analyze          (consistencia cruzada pre)
   → /speckit.implement
   → /speckit.analyze          (consistencia post)
   ```

4. Registro del resultado de cada flujo por separado.

### 3.2 Selección de casos para la comparación

Se seleccionan **24 casos (4 por repositorio)** de los 6 repositorios del corpus, ejecutados en 4 flujos (C0–C3) mediante scripts automatizados que usan `opencode` + DeepSeek V4 Flash, produciendo 96 ejecuciones. Los 28 casos restantes del corpus se formalizan y documentan, pero no se ejecutan comparativamente.

### 3.3 Limitaciones

La ejecución se realiza mediante scripts automatizados sobre `opencode`, lo que garantiza reproducibilidad sin intervención humana. Cada caso se ejecuta una sola vez por flujo para observar el comportamiento nativo del pipeline sin sesgo de iteración. El tamaño de la muestra (24 casos, 96 ejecuciones) ofrece una base suficiente para identificar tendencias, aunque la variabilidad del modelo hace recomendable repetir cada ejecución varias veces en trabajos futuros.

---

## Fase 4. Análisis del mapeo y comparación de flujos

La fase 4 constituye el núcleo analítico del trabajo e integra **los dos objetivos**: (a) contrastar el flujo de SpecKit con el flujo normativo de referencia (mapa de alineación) y (b) comparar los resultados de Flow A y Flow B para evaluar si el marco IREB produce diferencias medibles. El marco normativo de referencia es IREB, ISO/IEC/IEEE 29148 e INCOSE.

**Producto 1 — Mapa de alineación.** Se contrasta el flujo observado de SpecKit (comandos, artefactos, mecanismos de calidad) con cada actividad IREB y cada criterio de calidad ISO 29148, documentando la cobertura como alineado, parcial o no cubierto. El ground truth se utiliza como referencia interpretativa. El resultado no es una "nota de aprobado", sino un mapa que permite identificar dónde encaja SpecKit respecto a un flujo RE profesional.

**Producto 2 — Comparación de flujos.** Para cada caso ejecutado en los cuatro flujos, se comparan las métricas de F1 (precisión, recall), calidad de código (linters, semgrep), cumplimiento del pipeline (artefactos IREB) y coste. La comparación permite determinar si el marco IREB mejora los resultados y en qué dimensiones.

### 4.1 Filtro técnico (quality gate)

Antes del análisis de mapeo, cada PR generada debe superar un filtro técnico: compilación correcta, superación de tests existentes, ausencia de errores bloqueantes de linting y no introducción de regresiones críticas. Las PRs que no superen este filtro se registran como técnicamente no analizables y se excluyen del mapeo detallado, pero se contabilizan en los resultados globales como casos donde SpecKit no logró producir una implementación funcional.

### 4.2 Entradas del análisis

Cada caso analizado se compone de un conjunto fijo de artefactos:

- **E1. Requisito derivado**: texto final de la fase 2, con acción principal, condiciones y resultado esperado.
- **E2. Pull Request generada**: diff completo producido por SpecKit y commits asociados.
- **E3. Tests asociados**: tests añadidos o modificados por SpecKit, incluyendo assertions relevantes.
- **E4. Ground truth**: diff original del cambio de referencia, utilizado como apoyo interpretativo.
- **E5. Metadata de trazabilidad**: commit de referencia, versión del repositorio y referencia a PR original.

### 4.3 Extracción estructurada de intención

Antes del mapeo, un script asistido por LLM transforma los artefactos en una representación intermedia normalizada. Para cada requisito se generan las siguientes unidades verificables:

- **I1**: Acción principal del sistema.
- **I2**: Condición de activación o contexto.
- **I3**: Resultado observable esperado.
- **I4**: Restricción o regla implícita relevante.
- **I5**: Caso límite explícito, si existe.

El script produce adicionalmente un mapa de evidencia de la PR generada que agrupa los cambios por funcionalidad, módulos afectados, tests por comportamiento y señales de ejecución. Este paso no realiza el mapeo; únicamente estructura la evidencia para facilitar el análisis posterior.

### 4.4 Rúbrica de mapeo SRCI

El mapeo se realiza mediante la rúbrica SRCI (Structured Requirement Conformance Inspection). Cada criterio se evalúa de forma independiente como **Sí**, **Parcial** o **No**, con evidencia explícita del diff generado, los tests o los artefactos de ejecución.

**C1. Cobertura de intención principal**
Evalúa si la salida de SpecKit cubre la acción central del requisito. Evidencia: diff funcional, funciones modificadas o añadidas, tests asociados. Base: ISO/IEC/IEEE 29148.

**C2. Satisfacción de condición de activación**
Evalúa si se implementan correctamente las restricciones o el contexto del requisito. Ejemplos: permisos, estados, validaciones, flags. Base: INCOSE Systems Engineering Handbook.

**C3. Resultado observable consistente**
Comprueba si el sistema produce el resultado esperado de forma verificable. Ejemplos: respuesta de API, cambio de estado, evento o persistencia. Base: ISO 29148.

**C4. Correspondencia tests–intención**
Evalúa si los tests generados verifican directamente la intención funcional del requisito. Base: Fagan inspections y test-driven verification.

**C5. Ausencia de desviación funcional relevante**
Detecta comportamientos no solicitados o efectos secundarios no contemplados en el requisito. Base: consistencia en ingeniería de requisitos.

**C6. Trazabilidad completa**
Permite reconstruir la cadena requisito → intención → implementación → evidencia. Base: ISO/IEC/IEEE 29148.

### 4.5 Categorización del mapeo y comparación

La rúbrica SRCI se aplica tanto a Flow A como a Flow B, permitiendo comparar la conformidad de cada flujo. Las categorías son las siguientes:

| Categoría | Condición | Significado |
|---|---|---|
| **Alineado** | C1=Sí, C3=Sí, C5=Sí, C6=Sí; y no se da C2=No y C4=No simultáneamente | La implementación es conforme con el requisito |
| **Alineación parcial** | C1=Sí y C3=Sí; al menos uno de C5 o C6 en Parcial; máximo un criterio en No | La implementación se aproxima pero con desviaciones |
| **Desviado** | C1=No o C3=No; o dos o más criterios en No | La implementación no es conforme |

La categoría de alineación parcial reconoce que la transformación de requisitos formalizados a implementación mediante un pipeline SDD raramente satisface todos los criterios con igual solidez. Una escala binaria habría concentrado los resultados en el polo negativo, reduciendo la granularidad analítica y dificultando la identificación de patrones de desviación parcial.

### 4.6 Control de consistencia del mapeo

Se re-analiza un subconjunto de tres a cinco casos en un segundo momento aplicando la misma rúbrica SRCI. El objetivo es detectar inconsistencias en la aplicación de los criterios, no establecer un esquema formal de interevaluador. Las discrepancias se registran cualitativamente, identificando qué criterios presentan mayor ambigüedad de aplicación.

### 4.7 Productos del análisis

El análisis produce tres tipos de resultados:

1. **Mapa de alineación agregado**: tablas que contrastan cada actividad IREB y cada criterio de calidad contra los comandos y artefactos de SpecKit, indicando cobertura (✅, ⚠️, ❌) con evidencia de los casos.

2. **Comparación de flujos (Flow A vs Flow B)**: tablas que contrastan los resultados de cada flujo para las métricas M1-M4, permitiendo identificar si el marco IREB mejora la generación, compilación, tests o conformidad.

3. **Patrones de comportamiento del pipeline SDD**: identificación de en qué condiciones SpecKit se alinea mejor con el flujo normativo (por tipo de requisito, por complejidad, por repositorio).

Estos resultados no pretenden ser una evaluación estadística, sino un **análisis cualitativo estructurado** que permita entender las fortalezas y limitaciones del enfoque SDD desde la perspectiva de la ingeniería de requisitos basada en normas.

---

## Análisis de defensibilidad

### Fortalezas defendibles ante tribunal

La metodología tiene tres fortalezas principales. La primera es la **coherencia del marco de mapeo**: cada fase está vinculada a un marco normativo explícito (IREB, ISO 29148, INCOSE) y produce evidencia que alimenta el mapa de alineación final. La segunda es la **solución al problema de partida**: la ausencia de un corpus estándar de requisitos con implementación asociada está reconocida explícitamente y resuelta mediante una decisión metodológica justificada (proyectos Open Source con diff trazable), lo que demuestra comprensión del estado del arte. La tercera es la **separación entre el flujo observado y el analista**: SpecKit opera sin intervención sobre el ground truth, lo que garantiza que el mapeo refleja el comportamiento nativo del pipeline SDD.

### Vulnerabilidades residuales y respuestas preparadas

**"¿El requisito derivado captura completamente el comportamiento del diff original?"** No necesariamente, pero para el mapeo no es necesario. Lo que se analiza es la relación entre el requisito formalizado (entrada) y la implementación generada (salida). La correspondencia con el diff original es una referencia interpretativa, no un criterio de comparación directa.

**"¿Los proyectos OS son representativos de entornos industriales reales?"** Son la mejor aproximación disponible con trazabilidad verificable. Un entorno artificial reduciría la validez del mapeo sin resolver el problema de la disponibilidad de datos.

**"¿El volumen de casos es suficiente para generalizar el mapeo?"** El trabajo se enmarca como estudio de caso exploratorio, no como análisis estadístico. El objetivo es identificar patrones cualitativos de alineación y desviación, no cuantificar proporciones. Ese alcance es coherente con el objetivo declarado y con las limitaciones de un TFG individual.