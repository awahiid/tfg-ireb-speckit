# Metodología

## Introducción y anclaje metodológico

La metodología propuesta tiene como objetivo construir un pipeline reproducible que permita evaluar la capacidad de GitHub SpecKit para generar implementaciones conformes a partir de requisitos derivados de changelogs reales. El diseño se organiza en cuatro fases secuenciales: extracción de evidencia candidata, formalización de requisitos, ejecución del agente generativo y evaluación de conformidad.

El marco conceptual que estructura el pipeline es el estándar IREB (International Requirements Engineering Board), que distingue tres actividades fundamentales en ingeniería de requisitos: elicitación, documentación y validación. Cada fase de este trabajo se corresponde con una de estas actividades: la fase 1 opera como elicitación desde fuentes documentales (changelogs como artefactos de trazabilidad técnica), la fase 2 como documentación estructurada bajo las propiedades IREB de verificabilidad, consistencia y completitud, y las fases 3 y 4 como validación empírica de la implementación resultante. Este mapeo permite evaluar hasta qué punto SpecKit es compatible con un flujo IREB real, lo cual constituye la contribución central del trabajo.

Se optó por IREB frente a otras referencias posibles, como IEEE 830 o el proceso unificado de requisitos, por dos razones. En primer lugar, IREB proporciona un marco conceptual suficientemente abstracto como para adaptarse a fuentes no estructuradas como los changelogs, sin imponer una plantilla de especificación rígida que resultaría inapropiada para el tipo de material analizado. En segundo lugar, IREB es el estándar de referencia en la certificación profesional europea en ingeniería de requisitos, lo que refuerza la relevancia práctica del trabajo más allá del ámbito académico. IEEE 830, aunque más conocido, presupone un proceso de elicitación deliberado con stakeholders, lo cual no se corresponde con el escenario aquí estudiado.

---

## Fase 1. Extracción de evidencia candidata

La primera fase construye un dataset de evidencia candidata a partir de release notes y changelogs de repositorios seleccionados, comenzando por las versiones más recientes. En esta fase no se redactan requisitos. Únicamente se almacenan, de forma estructurada, textos literales de cambios junto con su trazabilidad mínima: versión, URL de release, referencia a PR y señales explícitas presentes en el texto, como métodos HTTP, paths, actores, condiciones o términos de dominio relevantes.

La selección no busca los cambios más elaborados posibles, sino entradas suficientemente buenas para una derivación posterior, es decir, con trazabilidad verificable y contenido bastante rico como para sugerir una futura formalización en forma de requisito.

### 1.1 Rúbrica de selección

Para la selección inicial de cambios no se empleó una rúbrica de calidad de requisito, ya que esa aproximación resultó excesivamente restrictiva para textos de changelog. En su lugar se definió una rúbrica pragmática orientada a evidencia candidata, organizada en cuatro dimensiones:

- **Trazabilidad**: la entrada aparece en una fuente oficial y referencia una PR o commit concreto.
- **Señales estructurales**: el texto menciona una superficie técnica (endpoint, módulo, entidad) o una condición o actor relevante.
- **Utilidad para derivación**: el contenido sugiere un comportamiento del sistema que podría formalizarse como requisito.
- **Defendibilidad**: la inclusión puede justificarse brevemente con un razonamiento explícito.

Una entrada se incluye si alcanza un umbral suficiente en estas dimensiones, sin exigir que el texto sea ya un requisito bien formado. Esta decisión prioriza la utilidad práctica y la consistencia del corpus frente a una exactitud prematura que no se corresponde con la naturaleza de los changelogs.

Se descartó una rúbrica basada en las propiedades formales de IEEE 830 (verificabilidad, no ambigüedad, completitud) porque su aplicación sobre changelogs generó un rechazo prácticamente universal de entradas, incluyendo algunas con alto valor de trazabilidad. Una rúbrica demasiado estricta en esta fase comprometería la viabilidad del corpus completo.

### 1.2 Procedimiento de selección

1. Seleccionar un repositorio del conjunto preestablecido.
2. Leer cada cambio en cada versión comenzando por la más reciente y valorarlo con la rúbrica.
3. Si el cambio supera el umbral, añadirlo al dataset con sus metadatos de trazabilidad.
4. Reunir un conjunto inicial de aproximadamente diez entradas por repositorio. Si en la fase de formalización no todas son convertibles en requisitos, ampliar el conjunto.

### 1.3 Limitaciones y amenazas a la validez

Los changelogs no son especificaciones formales, sino artefactos de comunicación técnica de granularidad y calidad heterogéneas. Muchas entradas no describen por sí solas un requisito completo, sino únicamente un cambio resumido, frecuentemente dependiente de contexto adicional como la PR asociada o los tests. Por esta razón se decidió separar el proceso en dos fases: una de extracción de evidencia literal y trazable, y una posterior de derivación controlada. Esta separación evita introducir redacción interpretativa prematura en el dataset base y mejora la auditabilidad del proceso.

La principal amenaza a la validez interna reside en la dependencia de fuentes semiestructuradas cuyo contenido no sigue un estándar uniforme entre repositorios. Existe también una amenaza de validez de constructo: el concepto de cambio suficientemente bueno para derivación no equivale al de requisito bien definido, por lo que el corpus de esta fase no debe interpretarse como un dataset final de requisitos. Finalmente, la aplicación de la rúbrica pragmática incluye juicio humano en la valoración de utilidad y defendibilidad, lo que introduce un sesgo del evaluador que no puede eliminarse completamente. Estas amenazas se mitigan mediante el uso exclusivo de texto literal en el dataset, la separación explícita entre evidencia e interpretación y la documentación de las razones de inclusión por cada candidato.

---

## Fase 2. Formalización de requisitos

En esta fase se selecciona un subconjunto de la evidencia previamente recopilada y se transforma en requisitos explícitos y verificables. El objetivo no es reinterpretar libremente el contenido original, sino estructurarlo en una forma operativa que permita su uso en la evaluación posterior. El proceso introduce un nivel necesario de abstracción respecto a los changelogs, manteniendo al mismo tiempo la trazabilidad con la evidencia de origen.

El equilibrio de esta fase se sitúa entre la fidelidad a los cambios reales del software y la necesidad de producir especificaciones suficientemente claras para ser evaluadas de forma consistente. Cada requisito resultante debe contener al menos: una acción principal del sistema, las condiciones o contexto de ejecución relevantes, y el resultado esperado. Esta estructura es coherente con las propiedades de verificabilidad y completitud definidas en IREB y con los criterios de IEEE 29148, que establece que un requisito debe poder verificarse mediante evidencia observable.

El principal riesgo de esta etapa es la introducción de interpretación implícita al pasar de descripciones de cambios a formulaciones de requisitos. Para mitigarlo, el proceso se apoya en una estructuración controlada del contenido: los requisitos se redactan siguiendo una plantilla fija que reduce la ambigüedad inherente al lenguaje natural y permite comparaciones consistentes en la fase de evaluación.

Se descartó una formalización mediante lenguaje controlado o notación formal (como plantillas Rupp o especificación en lógica de primer orden) por resultar desproporcionada para el tipo de fuente analizado y para el alcance de un TFG aplicado. La plantilla libre pero estructurada ofrece el equilibrio adecuado entre rigor y pragmatismo.

---

## Fase 3. Ejecución de SpecKit

En esta fase se introduce GitHub SpecKit como agente de generación de código. Toma como entrada los requisitos validados en la fase anterior y produce implementaciones en forma de pull requests sobre el repositorio correspondiente. El objetivo es evaluar la capacidad del sistema para traducir especificaciones estructuradas en artefactos ejecutables sin intervención manual en el proceso de implementación.

### 3.1 Protocolo de ejecución

Cada requisito se introduce en SpecKit en su forma textual final obtenida en la fase 2, sin reformulación ni adaptación adicional. Se realiza una única ejecución por requisito. Esta decisión elimina la variabilidad introducida por múltiples intentos y permite una evaluación más limpia del comportamiento del agente ante una especificación dada, sin corrección iterativa.

Si el agente no produce una PR, el caso se registra como fallo de generación y se excluye del análisis de conformidad, pero se contabiliza en los resultados globales como dato relevante sobre las limitaciones del sistema. La entrada proporcionada y la salida generada (o la ausencia de ella) se almacenan para garantizar la trazabilidad completa del proceso.

### 3.2 Limitaciones

La principal limitación de esta fase deriva de la dependencia directa de la calidad de los requisitos generados anteriormente. El agente no corrige ambigüedades ni errores de especificación, sino que los materializa. Esto implica una propagación natural de errores desde fases previas, lo cual se asume como parte del diseño experimental: aislar el comportamiento del agente ante la calidad real de los requisitos derivados es precisamente uno de los objetivos de la evaluación.

Se descartó un protocolo de ejecución iterativa (con refinamiento del input hasta obtener una PR válida) porque introduciría intervención humana que contaminaría la medición del agente. La ejecución única, aunque más exigente, es metodológicamente más limpia y defendible.

---

## Fase 4. Evaluación de conformidad

La evaluación se estructura en dos pasos complementarios: una validación técnica automática inicial y una inspección estructurada de conformidad funcional. Este diseño se apoya en principios de verificación de requisitos de ISO/IEC/IEEE 29148, en el INCOSE Systems Engineering Handbook y en literatura consolidada de inspección de software, incluyendo las Fagan inspections y enfoques derivados como checklist-based reading y scenario-based reading.

### 4.1 Validación técnica automática (quality gates)

Antes de la inspección de conformidad, cada PR generada supera una puerta técnica automática orientada a verificar su integridad como artefacto software: compilación correcta, superación de tests obligatorios, ausencia de errores bloqueantes de linting o análisis estático y no introducción de regresiones críticas. Este paso no evalúa la satisfacción del requisito, sino la aptitud técnica mínima de la implementación para ser considerada evaluable. Las PRs que no superan esta puerta se registran como no evaluables y se excluyen del análisis de conformidad.

### 4.2 Entradas del sistema de evaluación

Cada caso evaluado se compone de un conjunto fijo de artefactos:

- **E1. Requisito derivado**: texto final de la fase 2, con acción principal, condiciones y resultado esperado.
- **E2. Pull Request**: diff completo, commits asociados y descripción cuando esté disponible.
- **E3. Tests asociados**: tests añadidos o modificados, incluyendo assertions relevantes y fixtures necesarios.
- **E4. Evidencia de ejecución**: outputs de API, logs, estados del sistema, respuestas JSON o snapshots según el proyecto.
- **E5. Metadata de trazabilidad**: enlaces a commits o PR, referencias cruzadas con el requisito e identificadores del dataset.

### 4.3 Fase 1 del análisis: extracción estructurada

Antes de la evaluación humana, un script (asistido por LLM cuando sea necesario) transforma los artefactos anteriores en una representación intermedia normalizada que reduce la complejidad y homogeniza la evidencia. Para cada requisito se generan entre tres y cinco unidades verificables que descomponen su contenido funcional:

- **I1**: Acción principal del sistema.
- **I2**: Condición de activación o contexto.
- **I3**: Resultado observable esperado.
- **I4**: Restricción o regla implícita relevante.
- **I5**: Caso límite explícito, si existe.

Adicionalmente, el script produce un mapa de evidencia de la PR que agrupa los cambios del diff por funcionalidad, los módulos o endpoints afectados, los tests por comportamiento y las señales de ejecución disponibles. Este paso no evalúa conformidad; únicamente estructura la evidencia para reducir la carga cognitiva del evaluador.

### 4.4 Fase 2 del análisis: inspección estructurada de conformidad (rúbrica SRCI)

La inspección de conformidad se realiza mediante la rúbrica SRCI (Structured Requirement Conformance Inspection), aplicada criterio a criterio sobre la representación estructurada generada en el paso anterior. La evaluación no es global ni intuitiva: cada criterio se evalúa de forma independiente como **Sí**, **Parcial** o **No**, con evidencia explícita del diff, los tests o los artefactos de ejecución.

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

La incorporación de la categoría **Parcialmente Conforme** responde a una limitación real del dominio: las implementaciones generadas a partir de changelogs raramente satisfacen la totalidad de los criterios con igual solidez. Una escala binaria CONFORME/NO CONFORME habría concentrado los resultados en el polo negativo, reduciendo la granularidad analítica del estudio y dificultando la identificación de patrones de fallo parcial. Esta categoría intermedia es coherente con esquemas de evaluación gradual presentes en literatura de inspección de software y permite una discusión más matizada de los resultados.

Se descartó una escala de cinco niveles de madurez (al estilo CMMI) por introducir complejidad evaluativa desproporcionada para el volumen de casos esperado y por requerir calibración interobservador más exigente que la que permite el alcance de un TFG.

### 4.6 Control de consistencia interna

Para mitigar la amenaza residual de sesgo del evaluador único, se re-evalúa un subconjunto de tres a cinco casos en un segundo momento, aplicando la misma rúbrica SRCI. El objetivo no es establecer un esquema formal de interevaluador ni realizar análisis estadístico, sino detectar posibles inconsistencias evidentes en la aplicación de los criterios. Las discrepancias, si las hay, se registran de forma cualitativa, identificando qué criterios presentan mayor ambigüedad o dificultad de aplicación. Este control actúa como verificación de estabilidad del juicio más que como evaluación independiente, y su coste de ejecución es mínimo.

### 4.7 Justificación del diseño de evaluación

Frente a las alternativas consideradas, el diseño elegido ofrece el equilibrio más defendible para un contexto experimental aplicado.

La **evaluación puramente manual no estructurada** introduce alta variabilidad cognitiva y sesgo del evaluador, dificultando la replicabilidad y la comparación entre casos. La **automatización completa** es inapropiada en este dominio porque la relación entre un requisito en lenguaje natural derivado de changelogs y su implementación no es completamente formalizable sin pérdida de información semántica relevante. Las **métricas indirectas de calidad de código** (cobertura, complejidad, linting) no capturan conformidad funcional con el requisito, sino propiedades internas del software, lo que las hace inadecuadas como criterio principal de evaluación.

La inspección estructurada basada en checklist permite controlar estos problemas al fijar criterios explícitos, reducir la subjetividad mediante decisiones discretizadas y mantener trazabilidad completa entre evidencia, requisito e implementación. Este enfoque es coherente con ISO/IEC/IEEE 29148, con el INCOSE Systems Engineering Handbook y con la literatura de inspección de software que demuestra que la estructuración de criterios mejora la consistencia respecto a revisiones no guiadas.

---

### Fortalezas

La metodología presenta cuatro fortalezas que la hacen especialmente sólida en una defensa oral. En primer lugar, la separación en fases con responsabilidades distintas y bien delimitadas es una decisión difícil de atacar: cada fase tiene un propósito claro, entradas y salidas definidas, y una justificación explícita de por qué no se fusionó con las adyacentes. En segundo lugar, el anclaje en IREB da coherencia conceptual al conjunto: el tribunal puede preguntar por cualquier decisión metodológica y la respuesta siempre puede conectarse con una de las tres actividades del marco. En tercer lugar, las referencias a ISO 29148, INCOSE y Fagan inspections son estándares reconocidos que no requieren justificación adicional; su mención transmite familiaridad con el estado del arte. En cuarto lugar, el reconocimiento explícito de amenazas y limitaciones es señal de madurez metodológica: un tribunal de ingeniería del software valora más a un estudiante que conoce los límites de su método que a uno que los ignora.

### Vulnerabilidades residuales

Quedan dos puntos donde el tribunal puede presionar. El primero es el volumen de casos: si el número final de requisitos evaluados es pequeño (por ejemplo, menos de diez), el tribunal puede cuestionar la generalidad de los resultados. La respuesta correcta es encuadrarlo como estudio de caso exploratorio, no como experimento con validez estadística, y señalar que ese alcance es coherente con el objetivo declarado del trabajo. El segundo es la dependencia del evaluador único en la rúbrica SRCI: aunque el control de consistencia interna mitiga esta amenaza, no la elimina. La respuesta es reconocerlo directamente y argumentar que la estructura de la rúbrica reduce la variabilidad más que cualquier otra alternativa viable en el contexto de un TFG individual.