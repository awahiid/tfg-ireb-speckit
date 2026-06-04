# Metodología

## Introducción y anclaje metodológico

### Objetivo y pregunta central

El objetivo de este trabajo es evaluar empíricamente la capacidad de GitHub SpecKit para operar dentro de un flujo de ingeniería de requisitos estructurado según el estándar IREB. La pregunta central que guía el diseño metodológico es: ¿puede un agente de generación de código producir implementaciones conformes cuando recibe requisitos formalizados siguiendo un proceso IREB real?

Esta pregunta tiene dos dimensiones complementarias. La primera es técnica: si SpecKit genera implementaciones que satisfacen los requisitos que recibe. La segunda es metodológica: si el proceso IREB, aplicado sobre fuentes documentales reales en lugar de sobre elicitación deliberada con stakeholders, produce requisitos suficientemente bien formados como para ser utilizados como entrada válida para un agente de este tipo.

El marco conceptual que estructura el pipeline es IREB (International Requirements Engineering Board), adoptado por indicación de los tutores del trabajo. IREB distingue tres actividades fundamentales en ingeniería de requisitos: elicitación, documentación y validación. Las cuatro fases de la metodología se mapean sobre estas actividades de la siguiente manera:

| Fase | Actividad IREB | Descripción |
|---|---|---|
| Fase 1. Extracción de evidencia | Elicitación | Identificación de cambios trazables en fuentes documentales reales |
| Fase 2. Formalización | Documentación | Transformación de evidencia en requisitos con propiedades IREB |
| Fase 3. Ejecución de SpecKit | — | Generación de implementaciones a partir de requisitos formalizados |
| Fase 4. Evaluación de conformidad | Validación | Verificación de que las implementaciones satisfacen los requisitos |

Se optó por IREB frente a IEEE 830 o el proceso unificado de requisitos porque IREB proporciona un marco suficientemente abstracto para adaptarse a fuentes no estructuradas como los changelogs, sin imponer una plantilla de especificación rígida que resultaría inapropiada para el tipo de material analizado. IEEE 830 presupone un proceso de elicitación deliberado con stakeholders, lo cual no se corresponde con el escenario estudiado.

### El problema de partida y la solución adoptada

La aplicación de un flujo IREB real requiere un corpus de requisitos que provenga de proyectos representativos de la industria y que disponga de una implementación de referencia verificable para poder evaluar conformidad. Este corpus no existe como recurso estándar: los datasets académicos disponibles son demasiado artificiales o carecen de implementación asociada, y los requisitos industriales reales raramente son públicos.

La solución adoptada consiste en construir ese corpus a partir de proyectos Open Source, aprovechando que los cambios mergeados en la rama principal han pasado por un proceso implícito de elicitación (issue, discusión, revisión de PR) y validación (CI, code review, merge). Esto los convierte en fuentes funcionalmente equivalentes a los artefactos que resultan de un proceso IREB de elicitación, con la ventaja adicional de que el diff asociado a cada cambio actúa como ground truth para la evaluación de conformidad posterior. Esta decisión justifica el diseño de la fase 1 y es la que permite cerrar el pipeline de evaluación de forma empíricamente sólida.

---

## Fase 1. Extracción de evidencia candidata

La primera fase corresponde a la actividad de elicitación en el mapeo IREB. Su objetivo es identificar y registrar cambios concretos en repositorios Open Source que sean suficientemente ricos y trazables como para derivar requisitos verificables en la fase siguiente.

En esta fase no se redactan requisitos. Únicamente se almacenan textos literales de cambios junto con su trazabilidad mínima: versión, URL de release, referencia a PR, commit asociado y señales explícitas presentes en el texto. La conservación del texto literal sin paráfrasis es una decisión deliberada que separa la observación de la formalización y mejora la auditabilidad del proceso, en línea con la distinción IREB entre elicitación y documentación.

### 1.1 Criterios de selección de repositorios

Los repositorios seleccionados deben cumplir los siguientes criterios:

- **Representatividad industrial**: el proyecto debe utilizarse en contextos reales de producción.
- **Actividad de mantenimiento**: debe tener un historial de versiones suficiente para extraer cambios significativos.
- **Calidad de trazabilidad**: los changelogs deben referenciar PRs o commits con diff localizable y verificable.
- **Sencillez relativa del dominio**: los cambios deben ser comprensibles sin conocimiento altamente especializado, de forma que la derivación de requisitos sea razonable y evaluable.

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
4. Reunir un conjunto inicial de aproximadamente diez entradas por repositorio, ampliable si la fase 2 descarta entradas.

### 1.4 Limitaciones y amenazas a la validez

Los changelogs no son especificaciones formales sino artefactos de comunicación técnica de granularidad heterogénea. Existe una amenaza de validez de constructo relevante: el requisito derivado en la fase 2 puede no capturar completamente el comportamiento implementado en el diff, sino solo una parte de él. Esta limitación implica que la evaluación mide la capacidad de SpecKit para implementar el requisito tal como fue derivado, no necesariamente el comportamiento completo del cambio original. Esta distinción se asume explícitamente como parte del diseño y se documenta en los resultados.

---

## Fase 2. Formalización de requisitos

La fase 2 corresponde a la actividad de documentación en el mapeo IREB. La evidencia extraída en la fase anterior se transforma en requisitos explícitos y verificables, siguiendo la plantilla de especificación definida para el trabajo. El objetivo no es reinterpretar libremente el contenido original, sino estructurarlo en una forma operativa que respete las propiedades IREB de verificabilidad, consistencia y completitud, y que sea directamente utilizable como entrada para SpecKit.

Cada requisito resultante debe superar el quality gate definido por la rúbrica de validación de formalización antes de incorporarse al corpus definitivo. Los requisitos que no alcancen el umbral mínimo se devuelven a revisión o se descartan, ampliando el conjunto de evidencia candidata si es necesario.

El principal riesgo de esta fase es la introducción de interpretación implícita al pasar de descripciones de cambios a formulaciones de requisitos. Para mitigarlo, los requisitos se redactan siguiendo una plantilla fija y el texto literal de la fuente se conserva como referencia en el dataset, manteniendo la trazabilidad entre requisito formalizado y evidencia de origen.

Se descartó una formalización mediante lenguaje controlado o notación formal como plantillas Rupp o especificación en lógica de primer orden por resultar desproporcionada para el tipo de fuente analizado y para el alcance de un TFG aplicado. La plantilla estructurada en lenguaje natural con criterios de verificación observables ofrece el equilibrio adecuado entre rigor y pragmatismo.

---

## Fase 3. Ejecución de SpecKit

En esta fase se ejecuta GitHub SpecKit sobre cada caso del corpus. Para cada requisito, el repositorio se instancia en la versión inmediatamente anterior al commit que introduce el cambio de referencia, obteniendo un entorno sin la implementación que se quiere generar. SpecKit recibe el requisito formalizado como entrada y produce una implementación en forma de pull request sobre ese entorno.

### 3.1 Protocolo de ejecución

Cada requisito se introduce en SpecKit en su forma textual final obtenida en la fase 2, sin reformulación ni adaptación adicional. Se realiza una única ejecución por requisito. Esta decisión elimina la variabilidad introducida por múltiples intentos y permite una evaluación más limpia del comportamiento del agente, sin corrección iterativa que contaminaría la medición.

El entorno de ejecución para cada caso se construye de la siguiente manera:

1. Checkout del repositorio en el commit inmediatamente anterior al cambio de referencia.
2. Verificación de que el entorno compila y los tests existentes pasan, descartando el caso si el estado base está roto.
3. Ejecución de SpecKit con el requisito como entrada.
4. Registro del resultado: PR generada o fallo de generación.

Si el agente no produce una PR, el caso se registra como fallo de generación, se excluye del análisis de conformidad y se contabiliza en los resultados globales. La entrada proporcionada, el estado del repositorio y la salida generada se almacenan para garantizar trazabilidad completa.

### 3.2 Limitaciones

La principal limitación es la propagación de errores desde fases previas: el agente no corrige ambigüedades ni errores de especificación, sino que los materializa. Esto es asumido como parte del diseño experimental, ya que aislar el comportamiento del agente ante la calidad real de los requisitos derivados es uno de los objetivos de la evaluación. Se descartó la ejecución iterativa con refinamiento del input porque introduciría intervención humana que contaminaría la medición.

---

## Fase 4. Evaluación de conformidad

La fase 4 corresponde a la actividad de validación en el mapeo IREB. La evaluación se estructura en dos pasos complementarios: una validación técnica automática inicial y una inspección estructurada de conformidad funcional. Este diseño se apoya en ISO/IEC/IEEE 29148, el INCOSE Systems Engineering Handbook y literatura consolidada de inspección de software, incluyendo Fagan inspections y enfoques derivados como checklist-based reading.

### 4.1 Validación técnica automática (quality gates)

Antes de la inspección de conformidad, cada PR generada debe superar una puerta técnica automática: compilación correcta, superación de tests existentes, ausencia de errores bloqueantes de linting y no introducción de regresiones críticas. Las PRs que no superen esta puerta se registran como técnicamente no evaluables y se excluyen del análisis de conformidad pero se contabilizan en los resultados.

### 4.2 Entradas del sistema de evaluación

Cada caso evaluado se compone de un conjunto fijo de artefactos:

- **E1. Requisito derivado**: texto final de la fase 2, con acción principal, condiciones y resultado esperado.
- **E2. Pull Request generada**: diff completo producido por SpecKit y commits asociados.
- **E3. Tests asociados**: tests añadidos o modificados por SpecKit, incluyendo assertions relevantes.
- **E4. Ground truth**: diff original del cambio de referencia, utilizado como apoyo interpretativo por el evaluador.
- **E5. Metadata de trazabilidad**: commit de referencia, versión del repositorio y referencia a PR original.

### 4.3 Extracción estructurada de intención

Antes de la inspección, un script asistido por LLM transforma los artefactos en una representación intermedia normalizada. Para cada requisito se generan las siguientes unidades verificables:

- **I1**: Acción principal del sistema.
- **I2**: Condición de activación o contexto.
- **I3**: Resultado observable esperado.
- **I4**: Restricción o regla implícita relevante.
- **I5**: Caso límite explícito, si existe.

El script produce adicionalmente un mapa de evidencia de la PR generada que agrupa los cambios por funcionalidad, módulos afectados, tests por comportamiento y señales de ejecución. Este paso no evalúa conformidad; únicamente estructura la evidencia para reducir la carga cognitiva del evaluador.

### 4.4 Inspección estructurada de conformidad (rúbrica SRCI)

La inspección de conformidad se realiza mediante la rúbrica SRCI (Structured Requirement Conformance Inspection). Cada criterio se evalúa de forma independiente como **Sí**, **Parcial** o **No**, con evidencia explícita del diff generado, los tests o los artefactos de ejecución. El ground truth se utiliza como referencia interpretativa, no como criterio de comparación directa.

**C1. Cobertura de intención principal**
Verifica si la implementación cubre la acción central del requisito. Evidencia: diff funcional, funciones modificadas o añadidas, tests asociados. Base: ISO/IEC/IEEE 29148.

**C2. Satisfacción de condición de activación**
Evalúa si se implementan correctamente las restricciones o el contexto del requisito. Ejemplos: permisos, estados, validaciones, flags. Base: INCOSE Systems Engineering Handbook.

**C3. Resultado observable consistente**
Comprueba si el sistema produce el resultado esperado de forma verificable. Ejemplos: respuesta de API, cambio de estado, evento o persistencia. Base: ISO 29148.

**C4. Correspondencia tests–intención**
Evalúa si los tests verifican directamente la intención funcional del requisito. Base: Fagan inspections y test-driven verification.

**C5. Ausencia de desviación funcional relevante**
Detecta comportamientos no solicitados o efectos secundarios no contemplados en el requisito. Base: consistencia en ingeniería de requisitos.

**C6. Trazabilidad completa**
Permite reconstruir la cadena requisito → intención → implementación → evidencia. Base: ISO/IEC/IEEE 29148.

### 4.5 Regla de decisión

| Resultado | Condición |
|---|---|
| **CONFORME** | C1=Sí, C3=Sí, C5=Sí, C6=Sí; y no se da que C2=No y C4=No simultáneamente |
| **PARCIALMENTE CONFORME** | C1=Sí y C3=Sí; al menos uno de C5 o C6 en Parcial; máximo un criterio en No |
| **NO CONFORME** | C1=No o C3=No; o dos o más criterios en No |

La categoría Parcialmente Conforme reconoce que las implementaciones generadas a partir de especificaciones derivadas de changelogs raramente satisfacen todos los criterios con igual solidez. Una escala binaria habría concentrado los resultados en el polo negativo, reduciendo la granularidad analítica y dificultando la identificación de patrones de fallo parcial.

### 4.6 Control de consistencia interna

Se re-evalúa un subconjunto de tres a cinco casos en un segundo momento aplicando la misma rúbrica SRCI. El objetivo es detectar inconsistencias evidentes en la aplicación de los criterios, no establecer un esquema formal de interevaluador. Las discrepancias se registran cualitativamente, identificando qué criterios presentan mayor ambigüedad de aplicación.

### 4.7 Justificación del diseño de evaluación

Frente a las alternativas consideradas, el diseño elegido ofrece el equilibrio más defendible para un contexto experimental aplicado. La evaluación manual no estructurada introduce alta variabilidad cognitiva y dificulta la replicabilidad. La automatización completa es inapropiada porque la relación entre un requisito en lenguaje natural y su implementación no es completamente formalizable sin pérdida de información semántica. Las métricas indirectas de calidad de código no capturan conformidad funcional con el requisito sino propiedades internas del software.

La inspección estructurada basada en checklist fija criterios explícitos, reduce la subjetividad mediante decisiones discretizadas y mantiene trazabilidad completa entre evidencia, requisito e implementación. Este enfoque está alineado con ISO/IEC/IEEE 29148, INCOSE y la literatura de inspección de software que demuestra que la estructuración de criterios mejora la consistencia respecto a revisiones no guiadas.

---

## Análisis de defensibilidad y nota estimada

### Fortalezas defendibles ante tribunal

La metodología tiene tres fortalezas principales. La primera es la coherencia del mapeo IREB: cada fase tiene una actividad IREB asignada, justificada y operacionalizada, lo que permite responder cualquier pregunta del tribunal conectándola con el marco conceptual de referencia. La segunda es la solución al problema de partida: la ausencia de un benchmark estándar está reconocida explícitamente y resuelta mediante una decisión metodológica justificada, lo que demuestra comprensión del estado del arte. La tercera es la separación limpia entre lo que evalúa el agente y lo que conoce el evaluador: SpecKit opera únicamente con el requisito y el estado del repositorio, sin acceso al ground truth, lo que garantiza que la evaluación mide capacidad generativa real.

### Vulnerabilidades residuales y respuestas preparadas

**"¿El requisito derivado captura completamente el comportamiento del diff original?"** No necesariamente, y no es necesario que lo haga. Lo que se evalúa es si SpecKit implementa el requisito tal como fue especificado. La correspondencia entre requisito y diff completo es una limitación documentada, no un defecto oculto.

**"¿Los proyectos OS son representativos de entornos industriales reales?"** Son la mejor aproximación disponible con ground truth verificable. Un entorno artificial reduciría la validez externa sin resolver el problema de la trazabilidad.

**"¿El volumen de casos es suficiente para generalizar?"** El trabajo se enmarca como estudio de caso exploratorio, no como experimento con validez estadística. Ese alcance es coherente con el objetivo declarado y con las limitaciones de un TFG individual.