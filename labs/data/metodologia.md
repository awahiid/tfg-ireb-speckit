# 1. Primera fase. Extracción de datos
La metodología se organiza en dos fases separadas. En la primera fase se construye un dataset de evidencia candidata a partir de release notes y changelogs de repositorios seleccionados, comenzando por las versiones más recientes. En esta fase no se redactan requisitos. Solo se almacenan, de forma estructurada, textos literales de cambios junto con su trazabilidad mínima: versión, URL de release, referencia a PR y señales explícitas presentes en el texto, como métodos HTTP, paths, actores, condiciones o términos de dominio relevantes. La selección no busca los “mejores” cambios posibles, sino cambios suficientemente buenos para una derivación posterior, es decir, entradas con trazabilidad verificable y con contenido bastante rico como para sugerir una futura formalización en forma de requisito.

Para la selección inicial de cambios no se utilizó una rúbrica fuerte de calidad de requisito, ya que esa aproximación resultó excesivamente restrictiva para textos de changelog. En su lugar se definió una rúbrica pragmática orientada a evidencia candidata, centrada en cuatro dimensiones: trazabilidad, señales estructurales, utilidad para derivación y defendibilidad. Cada entrada se valora de forma simple según si aparece en una fuente oficial, referencia una PR, menciona una superficie técnica o una condición/actor relevante, y si puede justificarse brevemente como candidata razonable a derivación posterior. Una entrada se incluye si alcanza un umbral suficiente de puntuación, sin exigir que el texto sea ya un requisito bien formado. Esta decisión metodológica prioriza la utilidad práctica y la consistencia del corpus frente a una exactitud prematura que no se corresponde con la naturaleza de los changelogs.

Pasos exactos: 

1. Escoger un repositorio de los seleccionados
2. Leer cada cambio en cada versión empezando desde el mas nuevo y valorarlo
3. Si el cambio cumple con la rubrica suficientemente bien, añadirlo
4. Continuar seleccionando un conjunto de 10 por ejemplo. Si finalmente no todos se pueden convertir en requisitos se añade otro conjunto de cambios.

## 1.1 Limitaciones y justificación de decisiones metodológicas

La metodología adoptada presenta varias limitaciones que deben reconocerse explícitamente. En primer lugar, los changelogs y release notes no son especificaciones formales, sino artefactos de comunicación técnica de granularidad y calidad heterogéneas. Esto implica que muchas entradas no describen por sí solas un requisito completo, verificable y no ambiguo, sino únicamente un cambio resumido, a menudo dependiente de contexto adicional como la PR, los tests o la documentación asociada. Por esta razón, se decidió separar el proceso en dos fases: una primera fase de extracción de evidencia candidata, centrada en textos literales y trazables, y una segunda fase de derivación controlada de requisitos. Esta decisión evita introducir redacción interpretativa prematura en el dataset base y mejora la auditabilidad del proceso, al distinguir claramente entre evidencia observada y formalización posterior.

En segundo lugar, la selección de entradas “suficientemente buenas” no elimina completamente el juicio humano. Aunque se definió una rúbrica pragmática con criterios explícitos —trazabilidad, señales estructurales, utilidad para derivación y defendibilidad—, sigue existiendo un componente interpretativo en la valoración de ciertos casos frontera. Esta limitación se consideró aceptable porque una rúbrica completamente rígida, diseñada para requisitos formales, resultó excesivamente restrictiva para el tipo de fuente analizada. En lugar de perseguir una objetividad ficticia, se optó por una estrategia de suficiencia defendible: cada entrada incluida puede justificarse mediante un razonamiento breve y explícito, y los elementos no verificables se marcan como indeterminados en lugar de inferirse. Asimismo, se asumió que no todos los repositorios ofrecerían la misma calidad de señal; de hecho, esa heterogeneidad forma parte del problema estudiado y constituye una observación relevante por sí misma.

## 1.2 Amenazas a la validez de la metodología

La principal amenaza a la validez interna de la metodología reside en la dependencia de fuentes semiestructuradas cuyo contenido no sigue un estándar uniforme entre repositorios ni entre versiones. Esto puede afectar tanto a la consistencia de la selección como a la comparabilidad entre proyectos, ya que algunos repositorios publican changelogs altamente trazables y otros ofrecen notas más breves o menos enlazadas a PRs concretas. Existe también una amenaza de validez de constructo: el concepto de “cambio suficientemente bueno para derivación posterior” no equivale al de “requisito bien definido”, por lo que el corpus de la primera fase no debe interpretarse como un dataset final de requisitos. Finalmente, hay una amenaza de sesgo del evaluador, dado que la aplicación de la rúbrica pragmática incluye juicio humano en la valoración de utilidad y defendibilidad. No obstante, estas amenazas se mitigaron mediante varias decisiones: uso exclusivo de texto literal en el JSON, separación entre evidencia e interpretación, documentación explícita de limitaciones por candidato y aplicación consistente del mismo criterio de selección sobre todos los repositorios.

## 1.3 Conclusión metodológica y justificación para continuar
A pesar de estas amenazas y limitaciones, se considera justificado continuar con la metodología adoptada. La razón principal es que ofrece un equilibrio razonable entre formalidad y pragmatismo para el objetivo real del trabajo: construir un corpus trazable y utilizable como base para derivar posteriormente requisitos con los que evaluar herramientas como GitHub Speckit y agentes de implementación. Una metodología más rígida habría reducido drásticamente el volumen de evidencia aprovechable, mientras que una metodología más laxa habría debilitado la defendibilidad del corpus. El enfoque elegido no pretende resolver de forma perfecta la extracción automática de requisitos a partir de changelogs, sino producir una base suficientemente sólida, auditada y explícita para una segunda fase de formalización. En este contexto, continuar no solo es razonable, sino metodológicamente coherente: las amenazas identificadas son reales, pero conocidas, acotadas y compatibles con el alcance de un TFG aplicado.

# Segunda fase. Formalización de requisitos 
En esta fase se selecciona un subconjunto de la evidencia previamente recopilada para transformarla en requisitos explícitos y verificables. El objetivo no es reinterpretar libremente el contenido original, sino estructurarlo en una forma operativa que permita su uso en evaluación posterior. Esta transformación introduce un nivel necesario de abstracción respecto a los changelogs, manteniendo al mismo tiempo la trazabilidad con la evidencia de origen. El equilibrio de esta fase se sitúa entre la fidelidad a los cambios reales del software y la necesidad de producir especificaciones suficientemente claras para ser evaluadas de forma consistente.

El principal riesgo de esta etapa es la introducción de interpretación implícita al pasar de descripciones de cambios a formulaciones de requisitos. Para mitigar esta limitación, el proceso se apoya en una estructuración controlada del contenido, de forma que los requisitos resultantes mantengan una forma homogénea y reduzcan la ambigüedad inherente al lenguaje natural. Esta decisión prioriza la consistencia y la evaluabilidad frente a una formalización excesivamente rígida que no sería representativa del material original ni viable en un contexto de datos reales.

# Tercera fase. Ejecución de SpecKit 
En esta fase se introduce un agente de generación de código que toma como entrada los requisitos previamente validados y produce implementaciones funcionales en forma de cambios de software. El objetivo es evaluar la capacidad del sistema para traducir especificaciones estructuradas en artefactos ejecutables, sin intervenir manualmente en el proceso de implementación. De este modo, la fase actúa como un punto de transición entre la definición del problema y su materialización en código.

El equilibrio de esta etapa reside en la separación estricta entre especificación y generación, evitando cualquier ajuste manual del resultado del agente. La principal limitación deriva de la dependencia directa de la calidad de los requisitos generados en la fase anterior, ya que la ejecución no corrige ambigüedades ni errores de especificación, sino que los materializa. Esto permite mantener una evaluación más limpia del sistema generativo, aunque introduce una propagación natural de errores desde fases previas, lo cual se asume como parte del diseño experimental.

# Cuarta fase. Evaluación
La evaluación se estructura en dos pasos complementarios. En primer lugar, se aplica una puerta técnica automática sobre la PR generada, orientada a comprobar su integridad como artefacto software: compilación correcta, superación de tests obligatorios, ausencia de errores bloqueantes de linting o análisis estático y no introducción de regresiones críticas. Este primer paso no evalúa la satisfacción del requisito, sino la aptitud técnica mínima de la implementación para ser considerada evaluable.

Tras la validación automática inicial mediante quality gates, la segunda fase de la evaluación consiste en una inspección estructurada de conformidad entre el requisito derivado y la implementación contenida en la PR. Esta inspección no se plantea como una revisión libre, sino como un proceso guiado por una rúbrica predefinida de criterios observables (cobertura del comportamiento principal, adecuación del contexto de ejecución, observabilidad del resultado, alineación de pruebas, ausencia de desviaciones funcionales y trazabilidad completa). Cada caso se evalúa como una unidad requisito–PR utilizando únicamente evidencia explícita del diff, los tests y los artefactos generados. Este enfoque se alinea con prácticas de verificación de requisitos orientadas a la trazabilidad y la verificabilidad definidas en estándares como ISO/IEC/IEEE 29148, que establecen que un requisito debe poder ser verificado mediante criterios claros y observables, así como con técnicas clásicas de inspección de software basadas en checklist o lectura guiada, ampliamente estudiadas en la literatura de software engineering experimental por su capacidad de mejorar consistencia y reducir variabilidad interevaluador.

Frente a alternativas como la evaluación puramente manual no estructurada, la automatización completa o el uso de métricas indirectas de calidad de código, este enfoque ofrece un equilibrio más defendible para un contexto experimental aplicado. La revisión libre introduce alta variabilidad cognitiva y sesgo del evaluador, dificultando la replicabilidad. La automatización total, por su parte, es inapropiada en este dominio porque la relación entre requisito en lenguaje natural derivado de changelogs y su implementación no es completamente formalizable sin perder información semántica relevante. Finalmente, las métricas de calidad de código (cobertura, complejidad, linting) no capturan conformidad funcional con el requisito, sino propiedades internas del software. La inspección estructurada basada en checklist permite controlar estos problemas al fijar criterios explícitos, reducir la subjetividad mediante decisiones discretizadas y mantener trazabilidad completa entre evidencia, requisito e implementación, lo que la convierte en una aproximación más robusta y defendible en términos de validez interna y constructo dentro de un TFG aplicado.

La fase de análisis se estructura como un proceso de verificación de conformidad requisito–implementación basado en evidencia, separado en dos niveles: (1) transformación de artefactos de desarrollo en una representación evaluable y (2) inspección estructurada de conformidad funcional. Este diseño se apoya en principios establecidos en ISO/IEC/IEEE 29148 (verificabilidad y trazabilidad de requisitos) y en literatura de inspección de software (Fagan inspections, checklist-based reading y scenario-based reading), donde se asume que la consistencia se logra reduciendo la libertad interpretativa del evaluador mediante estructura y evidencia explícita.

Entradas del sistema de evaluación

Cada caso evaluado se compone de un conjunto fijo de artefactos que definen el contexto completo de verificación.

E1. Requisito derivado
Texto final obtenido en la fase de derivación. Debe contener acción principal, condiciones o contexto de ejecución y resultado esperado.

E2. Pull Request (PR)
Incluye el diff completo, commits asociados y descripción de la PR cuando esté disponible.

E3. Tests asociados
Tests añadidos o modificados, incluyendo assertions relevantes y, cuando sea necesario, fixtures que ayuden a interpretar el comportamiento.

E4. Evidencia de ejecución
Dependiente del proyecto: outputs de API, logs, estados del sistema, respuestas JSON o snapshots de UI.

E5. Metadata de trazabilidad
Enlaces a commits o PR, referencias cruzadas con el requisito e identificadores internos del dataset.

Fase 1 del análisis: extracción estructurada (script + LLM)

Antes de la evaluación humana, un script (posiblemente asistido por LLM) transforma los artefactos anteriores en una representación intermedia normalizada que reduce complejidad y homogeniza la evidencia.

Salida del script: “Estructura de intención operativa”

Para cada requisito se generan entre tres y cinco unidades verificables que descomponen su contenido funcional:

I1: Acción principal del sistema
I2: Condición de activación o contexto
I3: Resultado observable esperado
I4: Restricción o regla implícita relevante
I5: Caso límite explícito si existe

Ejemplo:

Requisito: “Allow users to reset password only if token is valid”

→

I1: User can reset password
I2: Only if token is valid
I3: Password is updated in system
I4: Invalid token blocks operation

Salida adicional del script: “Mapa de evidencia PR”

Incluye la agrupación de información relevante del diff de la PR:

cambios relevantes organizados por funcionalidad
funciones o módulos afectados
endpoints modificados
tests agrupados por comportamiento
señales de ejecución (outputs o logs)

Este paso no evalúa conformidad, únicamente estructura la evidencia disponible.

Fase 2: inspección de conformidad (evaluador humano)

En esta fase se aplica una rúbrica fija de inspección estructurada. La evaluación no es global ni intuitiva, sino descompuesta criterio a criterio.

Cada requisito se evalúa mediante una matriz:

Elemento de intención | Evidencia PR | Resultado

Checklist SRCI (Structured Requirement Conformance Inspection)

Cada criterio se evalúa como Sí, Parcial o No.

C1. Cobertura de intención principal
Verifica si la implementación cubre la acción central del requisito.

Evidencia: diff funcional, funciones modificadas o añadidas, tests asociados.
Base: ISO/IEC/IEEE 29148 (verificación mediante evidencia observable).

C2. Satisfacción de condición de activación
Evalúa si se implementan correctamente las restricciones o contexto del requisito.

Ejemplos: permisos, estados, validaciones, flags.
Base: INCOSE Systems Engineering Handbook.

C3. Resultado observable consistente
Comprueba si el sistema produce el resultado esperado de forma verificable.

Ejemplos: respuesta API, cambio de estado, evento o persistencia.
Base: ISO 29148 (verificabilidad).

C4. Correspondencia tests–intención
Evalúa si los tests verifican directamente la intención funcional del requisito.

Base: prácticas de Fagan inspection y test-driven verification.

C5. Ausencia de desviación funcional relevante
Detecta comportamientos no solicitados o efectos secundarios no contemplados.

Base: consistencia en ingeniería de requisitos.

C6. Trazabilidad completa
Permite reconstruir la cadena requisito → intención → implementación → evidencia.

Base: ISO/IEC/IEEE 29148 (traceability).

Regla de decisión

CONFORME si:
C1 = Sí
C3 = Sí
C5 = Sí
C6 = Sí
y no se da el caso de que C2 y C4 sean ambos No

NO CONFORME si:
C1 o C3 o C5 o C6 = No
o dos o más criterios están en No o Parcial

Justificación metodológica

El diseño se fundamenta en tres pilares consolidados.

ISO/IEC/IEEE 29148 establece que los requisitos deben ser verificables, trazables y evaluables mediante evidencia observable, lo que justifica la evaluación basada en resultados y no en interpretación libre.

INCOSE Systems Engineering Handbook formaliza la verificación como un proceso basado en inspección, análisis o prueba, siempre apoyado en evidencia empírica del sistema.

La literatura de inspección de software (Fagan inspections y enfoques derivados como checklist-based reading) demuestra que la estructuración de criterios reduce la variabilidad del evaluador y mejora la consistencia respecto a revisiones no guiadas.

Rol del script y del evaluador

El script o LLM actúa como un mecanismo de reducción de complejidad: transforma PRs y requisitos en una representación estructurada de intención y agrupa evidencia relevante sin tomar decisiones.

El evaluador humano aplica la rúbrica SRCI, interpreta la correspondencia entre intención y evidencia y determina la conformidad.

Propiedades del diseño

El esquema mitiga tres problemas principales:

la subjetividad abierta se reduce mediante criterios discretos,
la carga cognitiva se reduce mediante preprocesamiento estructurado,
la falta de trazabilidad se controla mediante una representación explícita de evidencias.

Conclusión

La fase constituye un sistema híbrido de verificación estructurada que combina preprocesamiento automático de evidencia, inspección humana guiada por checklist y criterios alineados con estándares industriales. El objetivo no es eliminar el juicio humano, sino acotarlo dentro de un marco reproducible de conformidad funcional observable del requisito.

Dentro de este esquema de análisis, existe una mejora potencial de carácter ligero que incrementa la solidez metodológica sin alterar la naturaleza pragmática del enfoque. Actualmente, la evaluación depende de un único proceso de inspección estructurada realizado sobre la base de la representación de intención y la evidencia del PR. Aunque este diseño ya reduce la variabilidad mediante criterios explícitos, sigue existiendo una amenaza residual a la validez interna asociada al hecho de que el juicio de conformidad recae en un único evaluador humano.

Para mitigar parcialmente esta limitación sin introducir complejidad adicional significativa, puede incorporarse un control mínimo de consistencia en una muestra reducida de casos. Este control consiste en re-evaluar un subconjunto pequeño de requisitos mediante la misma rúbrica SRCI, bien por el mismo evaluador en un segundo momento o mediante una revisión secundaria ligera. El objetivo no es establecer un esquema formal de interevaluador ni realizar análisis estadístico, sino detectar posibles inconsistencias evidentes en la aplicación de los criterios o en la interpretación de la evidencia. En caso de discrepancias, estas se registran de forma cualitativa, identificando qué criterios presentan mayor ambigüedad o dificultad de aplicación.

Esta mejora es coherente con la literatura de inspección de software, donde se reconoce que la repetición parcial de inspecciones y la revisión cruzada en muestras limitadas puede mejorar la estabilidad del proceso sin necesidad de formalizar experimentos completos de validación. En términos prácticos, este control actúa como una verificación de estabilidad del juicio más que como una evaluación independiente, y su inclusión refuerza la credibilidad del procedimiento al introducir una señal explícita de consistencia interna sin incrementar de forma significativa el coste de ejecución del método.

En conjunto, esta extensión mantiene intacto el equilibrio entre formalidad y pragmatismo del diseño original, al tiempo que refuerza una de sus principales amenazas metodológicas: la dependencia de un único juicio estructurado para la determinación final de conformidad.