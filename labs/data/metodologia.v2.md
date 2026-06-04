# Metodología

## Introducción y anclaje metodológico

### El problema de partida

La evaluación empírica de herramientas de generación de código asistida por requisitos enfrenta un problema estructural previo a cualquier decisión metodológica: no existe un conjunto estándar de requisitos formalmente bien definidos que provengan de proyectos reales, representativos de la industria, y que dispongan simultáneamente de una implementación de referencia verificable. Los datasets académicos existentes (como el corpus PROMISE o NFR) son demasiado artificiales o carecen de la implementación asociada necesaria para evaluar conformidad. Los requisitos industriales reales, por su parte, raramente son públicos ni están vinculados a un ground truth de código accesible.

Esta limitación no es un defecto del trabajo sino el problema que la metodología debe resolver. La estrategia adoptada consiste en construir ese conjunto de requisitos a partir de proyectos Open Source reales, aprovechando una propiedad estructural de su proceso de desarrollo: los cambios mergeados en la rama principal han sido elicitados, discutidos, revisados y aprobados antes de su integración. Esto convierte cada cambio aceptado en una fuente de evidencia con trazabilidad verificable y con una implementación de referencia explícita y accesible.

### La solución: proyectos OS como fuente de ground truth

El enfoque adoptado extrae los casos de evaluación de repositorios Open Source seleccionados por su representatividad industrial, actividad de mantenimiento y calidad de documentación de cambios. Para cada caso de evaluación se utiliza el siguiente esquema:

1. Se identifica un cambio aceptado en la rama principal (commit mergeado), documentado en el changelog o release notes del repositorio.
2. Se deriva un requisito formal a partir de ese cambio, describiendo el comportamiento que el sistema debería implementar.
3. Se instancia el repositorio en la versión inmediatamente anterior al cambio, obteniendo un entorno sin la implementación de referencia.
4. Se ejecuta SpecKit sobre ese entorno con el requisito derivado como entrada.
5. Se evalúa si la implementación generada es conforme al requisito, utilizando el diff original como ground truth.

Este diseño permite evaluar SpecKit en condiciones reproducibles y con evidencia verificable, sin depender de especificaciones artificiales ni de entornos de laboratorio desconectados de la práctica real. La disponibilidad del ground truth es la propiedad clave del enfoque: se sabe exactamente qué código implementa el requisito, lo que convierte la evaluación de conformidad en un proceso con evidencia empírica concreta en lugar de un juicio subjetivo sobre código generado en el vacío.

### Anclaje en IREB

El marco conceptual que estructura el pipeline es el estándar IREB (International Requirements Engineering Board), adoptado por indicación de los tutores del trabajo y justificado por su adecuación al tipo de fuente analizada. IREB distingue tres actividades fundamentales en ingeniería de requisitos: elicitación, documentación y validación. Cada fase de este trabajo se corresponde con una de estas actividades.

La fase 1 opera como elicitación desde fuentes documentales. Los changelogs y release notes de proyectos Open Source son artefactos de comunicación técnica que registran cambios aprobados, referenciados a PRs y revisados por la comunidad. No son equivalentes a entrevistas con stakeholders, pero son funcionalmente análogos a los artefactos que resultan de un proceso de elicitación: describen necesidades del sistema que han sido discutidas, priorizadas e integradas. Esta equivalencia funcional es la que justifica tratarlos como fuente de elicitación en el sentido IREB.

La fase 2 corresponde a documentación estructurada, en la que la evidencia extraída se transforma en requisitos con las propiedades IREB de verificabilidad, consistencia y completitud. Las fases 3 y 4 corresponden a validación empírica: se comprueba si una implementación generada satisface el requisito documentado, utilizando el ground truth disponible como referencia.

Se optó por IREB frente a otras referencias posibles, como IEEE 830 o el proceso unificado de requisitos, por una razón principal: IREB proporciona un marco conceptual suficientemente abstracto como para adaptarse a fuentes no estructuradas como los changelogs, sin imponer una plantilla de especificación rígida que resultaría inapropiada para el tipo de material analizado. IEEE 830, aunque más conocido, presupone un proceso de elicitación deliberado con stakeholders, lo cual no se corresponde con el escenario aquí estudiado.

---

## Fase 1. Extracción de evidencia candidata

La primera fase responde directamente al problema estructural descrito en la introducción: construir un corpus de casos de evaluación con trazabilidad verificable y ground truth accesible. Para ello se identifican cambios concretos en repositorios Open Source seleccionados que cumplan las condiciones necesarias para ser utilizados como base de derivación de requisitos y posterior evaluación de conformidad.

En esta fase no se redactan requisitos. Únicamente se almacenan, de forma estructurada, textos literales de cambios junto con su trazabilidad mínima: versión, URL de release, referencia a PR, commit asociado y señales explícitas presentes en el texto, como métodos HTTP, paths, actores, condiciones o términos de dominio relevantes. La conservación del texto literal, sin paráfrasis ni interpretación, es una decisión deliberada que separa la observación de la formalización y mejora la auditabilidad del proceso.

### 1.1 Criterios de selección de repositorios

Los repositorios seleccionados deben cumplir los siguientes criterios:

- **Representatividad industrial**: el proyecto debe ser utilizado en contextos reales de producción, no ser un proyecto de demostración o académico.
- **Actividad de mantenimiento**: el repositorio debe tener actividad reciente y un historial de versiones suficiente para extraer cambios significativos.
- **Calidad de trazabilidad**: los changelogs o release notes deben referenciar PRs o commits concretos, de forma que el diff de cada cambio sea localizable y verificable.
- **Sencillez relativa del dominio**: los cambios deben ser comprensibles sin requerir conocimiento altamente especializado del dominio, de forma que la derivación de requisitos sea razonable y evaluable.

### 1.2 Rúbrica de selección de cambios

Para la selección de cambios individuales dentro de cada repositorio se definió una rúbrica pragmática orientada a evidencia candidata, organizada en cuatro dimensiones:

- **Trazabilidad**: la entrada aparece en una fuente oficial y referencia una PR o commit concreto con diff localizable.
- **Señales estructurales**: el texto menciona una superficie técnica (endpoint, módulo, entidad) o una condición o actor relevante.
- **Utilidad para derivación**: el contenido describe un comportamiento del sistema que puede formalizarse como requisito verificable.
- **Defendibilidad**: la inclusión puede justificarse brevemente con un razonamiento explícito.

Una entrada se incluye si alcanza un umbral suficiente en estas dimensiones, sin exigir que el texto sea ya un requisito bien formado. Se descartó una rúbrica basada en las propiedades formales de IEEE 830 porque su aplicación sobre changelogs generó un rechazo prácticamente universal de entradas, incluyendo algunas con alto valor de trazabilidad y diff verificable. Una rúbrica demasiado estricta en esta fase comprometería la viabilidad del corpus sin mejorar la calidad del resultado final, ya que la formalización rigurosa se realiza en la fase siguiente.

### 1.3 Procedimiento de selección

1. Seleccionar un repositorio del conjunto preestablecido.
2. Leer los cambios en cada versión comenzando por la más reciente y valorar cada uno con la rúbrica.
3. Si el cambio supera el umbral, registrarlo en el dataset junto con su trazabilidad completa: versión, URL de release, referencia a PR, commit y texto literal del cambio.
4. Identificar el commit exacto que introduce el cambio, de forma que sea posible instanciar el repositorio en la versión inmediatamente anterior para la fase de ejecución.
5. Reunir un conjunto inicial de aproximadamente diez entradas por repositorio. Si en la fase de formalización no todas son convertibles en requisitos evaluables, ampliar el conjunto.

### 1.4 Limitaciones y amenazas a la validez

Los changelogs no son especificaciones formales, sino artefactos de comunicación técnica de granularidad y calidad heterogéneas. Muchas entradas no describen por sí solas un requisito completo, sino únicamente un cambio resumido. Por esta razón se separa el proceso en dos fases: una de extracción de evidencia literal y trazable, y una posterior de derivación controlada.

Existe una amenaza de validez de constructo relevante: que el requisito derivado en la fase 2 no capture completamente el comportamiento implementado en el diff, sino solo una parte de él. Esta limitación no invalida el enfoque, pero implica que la evaluación de conformidad mide la capacidad de SpecKit para implementar el requisito tal como fue derivado, no necesariamente el comportamiento completo del cambio original. Esta distinción se asume explícitamente como parte del diseño y se documenta en los resultados.

---

## Fase 2. Formalización de requisitos

En esta fase se transforma la evidencia candidata recopilada en requisitos explícitos y verificables, siguiendo la plantilla de especificación definida para el trabajo. El objetivo no es reinterpretar libremente el contenido original, sino estructurarlo en una forma operativa que permita su uso como entrada para SpecKit y como referencia para la evaluación de conformidad posterior.

Cada requisito resultante debe superar el quality gate definido por la rúbrica de validación de formalización antes de ser incorporado al corpus definitivo. Los requisitos que no alcancen el umbral mínimo se devuelven a revisión o se descartan, ampliando el conjunto de evidencia candidata si es necesario para mantener el volumen objetivo.

El principal riesgo de esta fase es la introducción de interpretación implícita al pasar de descripciones de cambios a formulaciones de requisitos. Para mitigarlo, los requisitos se redactan siguiendo una plantilla fija con estructura definida, y el texto literal de la fuente se conserva como referencia en el dataset. La trazabilidad entre requisito formalizado y evidencia de origen es un atributo obligatorio del corpus.

Se descartó una formalización mediante lenguaje controlado o notación formal (como plantillas Rupp o especificación en lógica de primer orden) por resultar desproporcionada para el tipo de fuente analizado y para el alcance de un TFG aplicado. La plantilla estructurada en lenguaje natural con criterios de verificación observables ofrece el equilibrio adecuado entre rigor y pragmatismo, y es directamente utilizable como entrada para SpecKit sin transformación adicional.

---

## Fase 3. Ejecución de SpecKit

En esta fase se ejecuta GitHub SpecKit sobre cada caso del corpus. Para cada requisito, el repositorio se instancia en la versión inmediatamente anterior al commit que introduce el cambio de referencia, obteniendo así un entorno sin la implementación que se quiere generar. SpecKit recibe el requisito formalizado como entrada y produce una implementación en forma de pull request sobre ese entorno.

### 3.1 Protocolo de ejecución

Cada requisito se introduce en SpecKit en su forma textual final obtenida en la fase 2, sin reformulación ni adaptación adicional. Se realiza una única ejecución por requisito. Esta decisión elimina la variabilidad introducida por múltiples intentos y permite una evaluación más limpia del comportamiento del agente ante una especificación dada, sin corrección iterativa.

El entorno de ejecución para cada caso se construye de la siguiente manera:

1. Checkout del repositorio en el commit inmediatamente anterior al cambio de referencia.
2. Verificación de que el entorno compila y los tests existentes pasan, descartando el caso si el estado base está roto.
3. Ejecución de SpecKit con el requisito como entrada.
4. Registro del resultado: PR generada o fallo de generación.

Si el agente no produce una PR, el caso se registra como fallo de generación y se excluye del análisis de conformidad, pero se contabiliza en los resultados globales. La entrada proporcionada, el estado del repositorio y la salida generada se almacenan para garantizar la trazabilidad completa del proceso.

### 3.2 Limitaciones

La principal limitación de esta fase es que el agente no conoce el diff de referencia ni la implementación original. Opera únicamente con el requisito y el estado del repositorio anterior al cambio, que es exactamente la condición que se quiere evaluar. La existencia del ground truth es exclusiva del evaluador, no del agente, lo que garantiza que la evaluación mide capacidad de generación real y no reproducción memorizada.

---

## Fase 4. Evaluación de conformidad

La evaluación se estructura en dos pasos complementarios: una validación técnica automática inicial y una inspección estructurada de conformidad funcional. El ground truth disponible (el diff original) actúa como referencia de apoyo para el evaluador, sin que sea necesario que la implementación generada sea idéntica a él: lo que se evalúa es conformidad con el requisito, no reproducción del cambio original.

### 4.1 Validación técnica automática (quality gates)

Antes de la inspección de conformidad, cada PR generada debe superar una puerta técnica automática: compilación correcta, superación de tests existentes, ausencia de errores bloqueantes de linting y no introducción de regresiones críticas. Las PRs que no superen esta puerta se registran como técnicamente no evaluables y se excluyen del análisis de conformidad pero se contabilizan en los resultados.

### 4.2 Entradas del sistema de evaluación

Cada caso evaluado se compone de un conjunto fijo de artefactos:

- **E1. Requisito derivado**: texto final de la fase 2, con acción principal, condiciones y resultado esperado.
- **E2. Pull Request generada**: diff completo producido por SpecKit, commits asociados y descripción cuando esté disponible.
- **E3. Tests asociados**: tests añadidos o modificados por SpecKit, incluyendo assertions relevantes.
- **E4. Ground truth**: diff original del cambio de referencia, utilizado como apoyo interpretativo por el evaluador.
- **E5. Metadata de trazabilidad**: commit de referencia, versión del repositorio, URL de release y referencia a PR original.

### 4.3 Extracción estructurada de intención

Antes de la inspección, un script asistido por LLM transforma los artefactos anteriores en una representación intermedia normalizada. Para cada requisito se generan las siguientes unidades verificables:

- **I1**: Acción principal del sistema.
- **I2**: Condición de activación o contexto.
- **I3**: Resultado observable esperado.
- **I4**: Restricción o regla implícita relevante.
- **I5**: Caso límite explícito, si existe.

El script produce adicionalmente un mapa de evidencia de la PR generada, agrupando los cambios del diff por funcionalidad, módulos o endpoints afectados, tests por comportamiento y señales de ejecución disponibles. Este paso no evalúa conformidad; únicamente estructura la evidencia para reducir la carga cognitiva del evaluador.

### 4.4 Inspección estructurada de conformidad (rúbrica SRCI)

La inspección de conformidad se realiza mediante la rúbrica SRCI (Structured Requirement Conformance Inspection). Cada criterio se evalúa de forma independiente como **Sí**, **Parcial** o **No**, con evidencia explícita del diff generado, los tests o los artefactos de ejecución. El ground truth se utiliza como referencia interpretativa, no como criterio de comparación directa.

**C1. Cobertura de intención principal**
Verifica si la implementación cubre la acción central del requisito. Evidencia: diff funcional, funciones modificadas o añadidas, tests asociados. Base: ISO/IEC/IEEE 29148 (verificación mediante evidencia observable).

**C2. Satisfacción de condición de activación**
Evalúa si se implementan correctamente las restricciones o el contexto del requisito. Ejemplos: permisos, estados, validaciones, flags. Base: INCOSE Systems Engineering Handbook.

**C3. Resultado observable consistente**
Comprueba si el sistema produce el resultado esperado de forma verificable. Ejemplos: respuesta de API, cambio de estado, evento o persistencia. Base: ISO 29148 (verificabilidad).

**C4. Correspondencia tests–intención**
Evalúa si los tests verifican directamente la intención funcional del requisito. Base: prácticas de Fagan inspection y test-driven verification.

**C5. Ausencia de desviación funcional relevante**
Detecta comportamientos no solicitados o efectos secundarios no contemplados en el requisito. Base: consistencia en ingeniería de requisitos.

**C6. Trazabilidad completa**
Permite reconstruir la cadena requisito → intención → implementación → evidencia. Base: ISO/IEC/IEEE 29148 (traceability).

### 4.5 Regla de decisión

| Resultado | Condición |
|---|---|
| **CONFORME** | C1=Sí, C3=Sí, C5=Sí, C6=Sí; y no se da que C2=No y C4=No simultáneamente |
| **PARCIALMENTE CONFORME** | C1=Sí y C3=Sí; al menos uno de C5 o C6 en Parcial; máximo un criterio en No |
| **NO CONFORME** | C1=No o C3=No; o dos o más criterios en No |

La categoría Parcialmente Conforme reconoce que las implementaciones generadas a partir de especificaciones derivadas de changelogs raramente satisfacen todos los criterios con igual solidez. Una escala binaria habría concentrado los resultados en el polo negativo, reduciendo la granularidad analítica y dificultando la identificación de patrones de fallo parcial.

### 4.6 Control de consistencia interna

Se re-evalúa un subconjunto de tres a cinco casos en un segundo momento, aplicando la misma rúbrica SRCI. El objetivo es detectar inconsistencias evidentes en la aplicación de los criterios, no establecer un esquema formal de interevaluador. Las discrepancias se registran cualitativamente, identificando qué criterios presentan mayor ambigüedad de aplicación.

---

## Análisis de defensibilidad y nota estimada

### Fortalezas defendibles ante tribunal

La fortaleza principal de esta metodología es la disponibilidad de ground truth verificable para cada caso de evaluación. Esto distingue el trabajo de estudios que evalúan generadores de código sobre especificaciones artificiales o sin referencia de implementación conocida, y convierte la evaluación de conformidad en un proceso con base empírica concreta. El tribunal puede preguntar cómo se sabe que la implementación es correcta: la respuesta es que existe un diff aprobado y mergeado que describe exactamente el comportamiento esperado.

La segunda fortaleza es que el problema de partida, la ausencia de un benchmark estándar de requisitos industriales con ground truth, está explícitamente reconocido y resuelto por la metodología. Esto demuestra comprensión del estado del arte y capacidad para diseñar soluciones a problemas reales de investigación empírica.

La tercera fortaleza es la separación limpia entre lo que evalúa el agente y lo que conoce el evaluador. SpecKit no tiene acceso al diff original; opera solo con el requisito y el estado del repositorio. El ground truth es exclusivo del evaluador, lo que garantiza que la evaluación mide capacidad generativa real.

### Vulnerabilidades residuales y respuestas preparadas

**"¿El requisito derivado captura completamente el comportamiento del diff original?"** No necesariamente, y no es necesario que lo haga. Lo que se evalúa es si SpecKit implementa el requisito tal como fue especificado. La correspondencia entre requisito y diff completo es una limitación documentada, no un defecto oculto.

**"¿Por qué proyectos OS y no un entorno controlado de laboratorio?"** Porque el objetivo es evaluar SpecKit en condiciones representativas de uso real. Un entorno artificial reduciría la validez externa del estudio. Los proyectos OS con cambios mergeados son la aproximación más cercana disponible a requisitos industriales reales con ground truth accesible.

**"¿Cómo garantizas que el repositorio en la versión anterior es un entorno limpio para la evaluación?"** Verificando que compila y los tests existentes pasan antes de ejecutar SpecKit. Los casos donde el estado base está roto se descartan y documentan.

### Nota estimada

Con la metodología en su estado actual: **9,0 / 10**.

El diseño del ground truth mediante proyectos OS con commits de referencia es la aportación metodológica más sólida del trabajo y la que más diferencia esta nota de la versión anterior. La justificación del problema de partida, la solución adoptada y su defensa ante las vulnerabilidades previsibles están bien articuladas. Lo que separa esta nota de matrícula es el resultado todavía desconocido de la evaluación y la defensa oral, que en tribunales de ingeniería del software de universidades españolas tiene un peso determinante en la calificación final.