# Rúbrica de evaluación — TFG: Mapeo SDD/SpecKit contra flujo RE profesional
**Grado en Ingeniería Informática en Ingeniería del Software — UEX · Escuela Politécnica**

> Basada en: normativa TFG UEX, criterios de tribunal IS (rúbricas UPV/UA análogas), IREB CPRE Foundation Level, ISO/IEC/IEEE 29148, INCOSE Guide for Writing Requirements.
> Escala por criterio: **3 = Excelente · 2 = Bien · 1 = Suficiente · 0 = Insuficiente/Ausente**
> Ponderación total sobre 10. Umbral sobresaliente ≥ 8,5. Candidato a MH ≥ 9,0.

---

## Bloque A — Calidad de la memoria escrita (35 %)

### A1. Introducción y motivación del problema `peso: 8 %`

| Puntuación | Descriptor |
|---|---|
| 3 | El contexto del problema se presenta con datos verificables y referencias académicas/industriales. La pregunta de investigación es precisa y sus dos dimensiones (descriptiva + comparativa) están claramente enunciadas. Se justifica por qué el mapeo SDD↔RE-normativo es relevante y qué vacío cubre. |
| 2 | El contexto existe y tiene referencias, pero algunos argumentos son genéricos. La pregunta de investigación está presente aunque con alguna ambigüedad menor. |
| 1 | La introducción describe el área pero no formula con precisión el problema ni la pregunta central. Escasas referencias o de baja calidad. |
| 0 | Ausencia de contexto, pregunta de investigación no identificable o plagio/copia de fuentes sin elaboración. |

**Criterios específicos para este TFG:**
- [ ] Se explica qué es SpecKit y qué es el paradigma SDD sin asumir conocimiento previo del lector.
- [ ] Se presenta el flujo RE normativo (IREB/ISO 29148/INCOSE) como marco de referencia y se justifica la elección frente a alternativas (IEEE 830).
- [ ] Se incluye análisis de trabajos previos sobre evaluación de herramientas RE asistidas por IA/LLMs.
- [ ] Las dos dimensiones del mapeo (descriptiva + comparativa) están explicitadas y son coherentes con la metodología.

---

### A2. Estado del arte `peso: 7 %`

| Puntuación | Descriptor |
|---|---|
| 3 | Revisión sistemática de la literatura sobre: (a) herramientas RE asistidas por LLMs, (b) evaluación empírica de pipelines SDD, (c) aplicación de IREB/ISO 29148 en entornos ágiles. Mínimo 20 referencias académicas indexadas (IEEE, ACM, Springer). Tabla comparativa de trabajos relacionados con dimensión propia. |
| 2 | Revisión cubre los tres ámbitos pero de forma desigual. Entre 12 y 20 referencias, algunas no primarias. No hay tabla comparativa estructurada pero sí discusión comparativa. |
| 1 | El estado del arte describe las tecnologías pero no posiciona el trabajo respecto a la literatura. < 12 referencias. Mayoría de fuentes son documentación oficial o blogs. |
| 0 | Ausente o < 5 referencias. No diferencia entre fuentes primarias y secundarias. |

**Criterios específicos:**
- [ ] Se citan trabajos sobre evaluación empírica de herramientas RE (no solo papers teóricos).
- [ ] Se menciona literatura sobre uso de LLMs/agentes en generación de código y su relación con requisitos.
- [ ] Se identifican los gaps que justifican este TFG (i.e., "no existe un estudio que compare SDD con IREB en proyectos OS reales").
- [ ] Las referencias siguen estilo IEEE de forma consistente.

---

### A3. Metodología `peso: 10 %`

| Puntuación | Descriptor |
|---|---|
| 3 | Las cuatro fases están descritas con precisión operativa: criterios de selección de repositorios con justificación taxonómica, rúbricas de selección de cambios operativas, plantilla IREB completa con todos los atributos, protocolo de ejecución de SpecKit paso a paso, y rúbrica SRCI con criterios C1–C6 evaluables de forma independiente. Cada decisión metodológica tiene justificación explícita y alternativa descartada. Las amenazas a la validez están identificadas por fase con respuesta argumentada. |
| 2 | Las fases están descritas pero alguna carece de detalle operativo suficiente para ser reproducida. Las decisiones metodológicas están presentes pero sin justificar todas las alternativas descartadas. Las amenazas a la validez se mencionan pero no están todas respondidas. |
| 1 | La metodología describe el "qué" pero no el "cómo". Las fases no son distinguibles como actividades IREB. La rúbrica SRCI existe pero sus criterios no son independientemente evaluables. |
| 0 | No hay metodología estructurada. El proceso no es reproducible ni verificable. |

**Criterios específicos (todos obligatorios para nota ≥ 8):**
- [ ] La tabla de mapeo Fase / Propósito / Marco de referencia está presente y completa.
- [ ] Los seis repositorios están justificados con la taxonomía de tipos de sistema (no elegidos al azar).
- [ ] La rúbrica de selección de cambios (Fase 1) tiene ≥ 4 dimensiones con descripción operativa.
- [ ] La plantilla IREB tiene ≥ 10 atributos incluyendo Dependencias y Módulo.
- [ ] El protocolo de Fase 3 incluye los 9 comandos del pipeline ampliado en orden con justificación de la personalización del constitution.
- [ ] La rúbrica SRCI define C1–C6 con base normativa explícita para cada criterio.
- [ ] La tabla de categorización (Alineado / Alineación parcial / Desviado) incluye condiciones lógicas precisas.
- [ ] El control de consistencia intra-evaluador (re-análisis de 3–5 casos) está descrito.
- [ ] El apartado de defensibilidad incluye ≥ 3 preguntas difíciles con respuesta preparada.

---

### A4. Presentación de resultados `peso: 5 %`

| Puntuación | Descriptor |
|---|---|
| 3 | Los resultados se presentan en un mapa de alineación agregado (tabla de actividades IREB vs. comandos SpecKit con cobertura ✅/⚠️/❌) y en un análisis de patrones por tipo de requisito y por repositorio. Las evidencias están referenciadas con trazabilidad completa (ID de requisito → diff → test → categoría). Las estadísticas de ejecución (casos totales, filtro técnico, distribución de categorías) son visibles y comentadas. |
| 2 | El mapa de alineación existe pero le faltan algunas evidencias. Los patrones de comportamiento se describen cualitativamente sin estructura. |
| 1 | Los resultados son una lista de casos sin agregación ni análisis de patrones. No hay mapa de alineación. |
| 0 | Los resultados no están o no son interpretables. |

**Criterios específicos:**
- [ ] Tabla de actividades IREB × artefactos SpecKit con indicador de cobertura por celda.
- [ ] Distribución de categorías de mapeo (Alineado / Parcial / Desviado) por repositorio y por tipo de requisito.
- [ ] Al menos un caso "Alineado" y un caso "Desviado" descritos con detalle completo (E1–E5 + SRCI).
- [ ] Los fallos de filtro técnico (PRs que no compilan) están contabilizados y comentados.

---

### A5. Conclusiones y trabajo futuro `peso: 5 %`

| Puntuación | Descriptor |
|---|---|
| 3 | Las conclusiones responden directamente a la pregunta central del TFG (en qué medida SDD se alinea con el flujo RE normativo) con evidencia de los resultados. Se distinguen conclusiones sobre SpecKit como herramienta, sobre el enfoque SDD como paradigma, y sobre el marco metodológico del propio TFG. El trabajo futuro es específico, priorizado y conecta con las limitaciones identificadas. |
| 2 | Las conclusiones responden a la pregunta pero con generalidades. El trabajo futuro existe pero no está priorizado. |
| 1 | Las conclusiones son un resumen del trabajo, no una respuesta a la pregunta de investigación. |
| 0 | Conclusiones ausentes o que contradicen los resultados. |

---

## Bloque B — Calidad técnica del trabajo (40 %)

### B1. Corpus de requisitos — Fase 1 + Fase 2 `peso: 12 %`

| Puntuación | Descriptor |
|---|---|
| 3 | El corpus tiene ≥ 50 requisitos distribuidos entre los 6 repositorios (≥ 7 por repositorio). Cada requisito tiene trazabilidad completa hasta el commit. La diversidad de tipos de requisito (funcional, de información, no funcional) es equilibrada. La plantilla IREB está completa en todos los atributos para cada entrada. Los estados del workflow (Borrador → Elaborado → Validado) son coherentes. El dataset es reproducible (se referencia su ubicación en el repositorio del TFG). |
| 2 | 35–50 requisitos. Algún repositorio con < 5 entradas. Trazabilidad completa en > 80 % de los casos. Algún atributo IREB incompleto de forma sistemática. |
| 1 | < 35 requisitos o > 25 % sin trazabilidad hasta commit. La plantilla se aplica de forma inconsistente. |
| 0 | < 20 requisitos o dataset no reproducible. |

**Criterios específicos:**
- [ ] Los 6 tipos de sistema están representados con al menos 7 requisitos cada uno.
- [ ] La rúbrica de formalización (quality gate Fase 2) se ha aplicado y los rechazos están documentados.
- [ ] Los requisitos no funcionales incluyen métricas concretas (no "el sistema debe ser rápido").
- [ ] El campo Verificación de cada requisito contiene un criterio de aceptación operativo.
- [ ] Al menos 10 % de los requisitos tienen campo Dependencias rellenado con IDs válidos.

---

### B2. Ejecución de SpecKit — Fase 3 `peso: 15 %`

| Puntuación | Descriptor |
|---|---|
| 3 | Todos los casos del corpus tienen ejecución documentada. El entorno de cada caso está reproducido en el commit exacto anterior al cambio de referencia. Los 9 comandos del pipeline ampliado se aplican en orden con trazabilidad de cada artefacto generado. Las PRs generadas están archivadas o referenciadas. Los fallos de generación están registrados con causa identificada. El filtro técnico (compilación, tests, linting) se aplica y documenta para cada caso. |
| 2 | ≥ 80 % de los casos ejecutados. Algún comando del pipeline omitido con justificación. Los fallos están registrados pero sin causa identificada en todos los casos. El filtro técnico se aplica pero no está completamente documentado. |
| 1 | < 70 % de los casos ejecutados. El pipeline se aplica de forma parcial o inconsistente. No hay documentación de fallos. |
| 0 | La ejecución no es reproducible o los resultados no están documentados. |

**Criterios específicos:**
- [ ] El constitution personalizado con principios RE (verificabilidad, minimalidad, trazabilidad) está incluido en el repositorio del TFG.
- [ ] El entorno de cada caso (versión del repositorio, commit de inicio) está identificado y es verificable.
- [ ] La distinción entre fallo de generación y fallo de filtro técnico es explícita en los resultados.
- [ ] Las PRs generadas están enlazadas o archivadas en el repositorio del TFG.

---

### B3. Análisis del mapeo — Fase 4 `peso: 13 %`

| Puntuación | Descriptor |
|---|---|
| 3 | La rúbrica SRCI se aplica con evidencia explícita para cada criterio C1–C6 en cada caso analizable. La categorización final (Alineado / Parcial / Desviado) es consistente con los criterios y está justificada. El mapa de alineación agregado cubre todas las actividades IREB con indicador de cobertura respaldado por evidencias. Los patrones de comportamiento están identificados con al menos 3 condiciones contextuales (tipo de requisito, repositorio, complejidad). El control de consistencia intra-evaluador está ejecutado y las discrepancias documentadas. |
| 2 | La SRCI se aplica en ≥ 85 % de los casos pero algún criterio carece de evidencia explícita. Los patrones existen pero son descriptivos sin condiciones identificadas. El control de consistencia está ejecutado. |
| 1 | La SRCI se aplica de forma superficial. La categorización no es siempre consistente con los criterios. No hay análisis de patrones. |
| 0 | El análisis de mapeo es anecdótico o ausente. |

**Criterios específicos:**
- [ ] Para cada criterio C1–C6 se indica "Sí / Parcial / No" con referencia al diff o los tests como evidencia.
- [ ] La extracción I1–I5 está documentada para cada requisito antes del mapeo (no se mezcla con la evaluación SRCI).
- [ ] Los patrones identificados distinguen entre limitaciones de SpecKit como herramienta y limitaciones del enfoque SDD como paradigma.
- [ ] El re-análisis de consistencia identifica qué criterios SRCI son más ambiguos de aplicar.

---

## Bloque C — Calidad formal del documento (15 %)

### C1. Estructura y navegabilidad `peso: 4 %`

| Puntuación | Descriptor |
|---|---|
| 3 | Índice generado automáticamente con paginación correcta. Índice de figuras e índice de tablas. Lista de acrónimos (IREB, SDD, RE, SRCI, etc.). Numeración de secciones coherente. Cada capítulo comienza con un párrafo de introducción y termina con un resumen/transición. |
| 2 | Índice presente y correcto. Faltan el índice de figuras o de tablas. Alguna sección sin introducción. |
| 1 | El índice tiene errores de paginación o numeración. La estructura es inconsistente entre capítulos. |
| 0 | Sin índice o estructura no identificable. |

---

### C2. Redacción y ortografía `peso: 5 %`

| Puntuación | Descriptor |
|---|---|
| 3 | Cero errores ortográficos. Redacción formal sin coloquialismos. Terminología técnica RE usada con precisión (no se confunde "requisito" con "funcionalidad", "verificación" con "validación", etc.). Párrafos justificados. |
| 2 | ≤ 3 errores ortográficos menores. Redacción formal con algún giro coloquial aislado. Alguna imprecisión terminológica menor. |
| 1 | Varios errores ortográficos o gramaticales. Terminología mezclada o incorrecta en secciones técnicas. |
| 0 | Errores abundantes que dificultan la comprensión. |

**Nota crítica:** Para candidatura a MH en UEX, el umbral es 0 errores ortográficos. Un error por página descalifica automáticamente.

---

### C3. Figuras, tablas y código `peso: 3 %`

| Puntuación | Descriptor |
|---|---|
| 3 | Todas las figuras son vectoriales o de alta resolución, tienen numeración, título descriptivo y referencia desde el texto. Las tablas tienen título, numeración y están referenciadas. Los fragmentos de código tienen fondo blanco, numeración de líneas y se referencian desde el texto. Los diagramas UML/de arquitectura están explicados en detalle. |
| 2 | Mayoría de figuras y tablas correctas. Alguna imagen pixelada o sin referencia en el texto. |
| 1 | Figuras y tablas existen pero no tienen numeración consistente ni se referencian sistemáticamente. |
| 0 | Figuras ilegibles, sin título o no relacionadas con el texto. |

---

### C4. Bibliografía `peso: 3 %`

| Puntuación | Descriptor |
|---|---|
| 3 | Estilo IEEE consistente en todo el documento. Mínimo 20 referencias primarias (artículos indexados). Los estándares IREB, ISO 29148 e INCOSE están citados en sus versiones vigentes. Las fuentes web tienen fecha de acceso. Se usa Zotero o Mendeley (o equivalente). |
| 2 | Estilo IEEE con alguna inconsistencia menor. Entre 12 y 20 referencias. Algún estándar sin versión. |
| 1 | Estilo de citas inconsistente. Mayoría de fuentes son documentación oficial o blogs sin referencia académica. |
| 0 | Sin bibliografía o sin estilo reconocible. |

---

## Bloque D — Defensa oral (10 %)

### D1. Claridad y estructura de la exposición `peso: 4 %`

| Puntuación | Descriptor |
|---|---|
| 3 | La presentación abre con el problema y el resultado (no con el índice). El tiempo se distribuye proporcionalmente: ~2 min contexto, ~3 min metodología, ~5 min resultados y mapeo, ~2 min conclusiones + trabajo futuro. La audiencia puede seguir el hilo sin haber leído la memoria. El lenguaje es técnicamente preciso. |
| 2 | La estructura es lógica pero el tiempo no está bien distribuido (p.ej., demasiado en metodología, poco en resultados). |
| 1 | La exposición sigue el índice de la memoria sin síntesis ni narrativa propia. |
| 0 | La exposición es incoherente o no se ajusta al tiempo establecido. |

---

### D2. Respuesta a preguntas del tribunal `peso: 6 %`

| Puntuación | Descriptor |
|---|---|
| 3 | Responde directamente a las preguntas sin evasión. Cuando no conoce la respuesta exacta, delimita lo que sí sabe y lo que quedaría como trabajo futuro. Defiende las decisiones metodológicas con los argumentos documentados en la memoria. No se contradice entre la defensa y la memoria escrita. |
| 2 | Responde la mayoría de las preguntas correctamente pero se pone a la defensiva ante preguntas críticas. Alguna contradicción menor con la memoria. |
| 1 | Respuestas superficiales que no demuestran comprensión profunda. Dificultad para defender decisiones metodológicas. |
| 0 | No puede responder preguntas básicas sobre su propio trabajo. |

**Preguntas probables de tribunal para este TFG:**
- "¿Por qué IREB y no IEEE 830 como marco de referencia principal?"
- "¿Cómo garantiza que los requisitos derivados de changelogs capturan el comportamiento completo del diff?"
- "Si la mayoría de casos son 'Desviado', ¿qué conclusión extrae sobre SpecKit como herramienta RE?"
- "¿Qué diferencia hay entre una limitación de SpecKit-herramienta y una del paradigma SDD?"
- "¿Por qué una sola ejecución por requisito y no iteración con refinamiento?"
- "¿Son 50 casos suficientes para identificar patrones? ¿Cuál es el poder explicativo del estudio?"

---

## Puntuación final

```
Nota final = (A1×0,08 + A2×0,07 + A3×0,10 + A4×0,05 + A5×0,05) × (10/3)
           + (B1×0,12 + B2×0,15 + B3×0,13) × (10/3)
           + (C1×0,04 + C2×0,05 + C3×0,03 + C4×0,03) × (10/3)
           + (D1×0,04 + D2×0,06) × (10/3)
```

| Rango | Calificación |
|---|---|
| 9,0 – 10,0 | Sobresaliente (candidato a MH si es la nota más alta de la convocatoria) |
| 7,0 – 8,9 | Notable |
| 5,0 – 6,9 | Aprobado |
| < 5,0 | Suspenso |

---

## Checklist rápido de candidatura a MH

Para este TFG específico, los siguientes ítems son los que más discriminan entre sobresaliente y MH:

- [ ] **Corpus ≥ 50 requisitos** con trazabilidad completa y plantilla IREB íntegra.
- [ ] **Pipeline ejecutado en ≥ 80 % de los casos** con documentación de cada fallo.
- [ ] **Rúbrica SRCI con evidencias explícitas** en todos los criterios — no afirmaciones sin cita de diff/test.
- [ ] **Mapa de alineación agregado** que responde directamente a la pregunta de investigación.
- [ ] **Patrones identificados** con condiciones contextuales (no solo estadísticas de categorías).
- [ ] **Apartado de defensibilidad** con ≥ 5 preguntas y respuestas completas.
- [ ] **Cero errores ortográficos** en la versión final presentada al tribunal.
- [ ] **Estado del arte con ≥ 20 referencias primarias** posicionando el trabajo en la literatura.
- [ ] **Conclusiones que responden la pregunta central** con evidencia directa de los resultados.
- [ ] **Presentación oral que abre con problema + resultado** en los primeros 90 segundos.