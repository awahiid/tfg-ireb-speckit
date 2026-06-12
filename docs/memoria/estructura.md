# Estructura de la memoria — TFG: Mapeo SDD/SpecKit contra flujo RE profesional
**Guía de índice, extensión y contenido por sección**

> Extensión orientativa total: **80–100 páginas** (sin anexos).
> Formato: A4, márgenes 2,5 cm, cuerpo 12pt, interlineado 1,5, párrafos justificados.
> Herramienta recomendada: LaTeX (Overleaf) con plantilla UEX, o Word con estilos definidos desde el inicio.

---

## Portada y preliminares `~5 páginas, no cuentan en el total`

```
Portada oficial UEX
  · Título completo
  · Nombre del autor
  · Nombre del tutor/es
  · Titulación: Grado en Ingeniería Informática en Ingeniería del Software
  · Escuela Politécnica · Universidad de Extremadura
  · Curso académico · Ciudad · Año
  · Logo UEX

Resumen (español)                                     1 página
  · Contexto del problema (2-3 frases)
  · Objetivo y pregunta central (1-2 frases)
  · Metodología empleada (3-4 frases)
  · Principales resultados (2-3 frases)
  · Conclusión y relevancia (1-2 frases)
  · 6-8 palabras clave

Abstract (inglés)                                     1 página
  · Traducción fiel del resumen
  · Keywords (mismas palabras clave en inglés)

Agradecimientos                                       ½ página (opcional)

Índice de contenidos                                  2-3 páginas
Índice de figuras
Índice de tablas
Lista de acrónimos y abreviaturas
  · SDD, RE, IREB, CPRE, SRCI, OS, PR, MH, etc.
```

---

## Capítulo 1 — Introducción `10–12 páginas`

### 1.1 Contexto y motivación `3–4 páginas`

El propósito es situar al lector en el problema antes de presentar el trabajo. Describe:

- El paradigma Spec-Driven Development (SDD) y por qué emerge en el contexto de LLMs y agentes de código.
- GitHub SpecKit como implementación concreta de SDD: qué es, qué hace, qué promete.
- La ingeniería de requisitos profesional basada en normas (IREB, ISO 29148, INCOSE) como marco de referencia para evaluar cualquier proceso que pretenda gestionar requisitos.
- La brecha que existe: las herramientas SDD se adoptan en la industria sin validación empírica frente a marcos RE establecidos.

> Nota: incluir datos concretos — crecimiento de GitHub Copilot, adopción de agentes de código en el sector, citas de IREB sobre el estado de la profesión RE.

### 1.2 Problema y pregunta de investigación `1–2 páginas`

Enunciar con precisión:

- **Problema**: no existe un análisis sistemático que documente en qué medida los pipelines SDD implementados con herramientas como SpecKit se alinean con las actividades, criterios de calidad y artefactos definidos por un flujo RE profesional basado en normas.
- **Pregunta central**: *¿En qué medida se alinea el pipeline SDD de SpecKit con las actividades, criterios de calidad y artefactos definidos por un flujo RE profesional basado en normas (IREB, ISO 29148, INCOSE)?*
- Las dos dimensiones: descriptiva (documentar el flujo de SpecKit) y comparativa (contrastar con el flujo normativo).

### 1.3 Objetivos `1 página`

- **Objetivo principal**: construir un mapa de alineación entre el pipeline SDD de SpecKit y el flujo RE normativo.
- **Objetivos específicos** (4-6, numerados):
  1. Construir un corpus de requisitos derivados de proyectos Open Source representativos.
  2. Formalizar el corpus siguiendo la plantilla IREB + ISO 29148.
  3. Ejecutar el pipeline ampliado de SpecKit sobre el corpus y registrar los artefactos generados.
  4. Aplicar la rúbrica SRCI para categorizar cada caso de mapeo.
  5. Identificar patrones de alineación y desviación por tipo de requisito y tipo de sistema.
  6. Derivar implicaciones para la adopción de SDD en entornos con requisitos de calidad RE.

### 1.4 Alcance y limitaciones `½–1 página`

Declarar explícitamente:

- El estudio es cualitativo/exploratorio, no estadístico.
- El corpus se limita a proyectos Open Source con changelogs trazables.
- SpecKit es una herramienta en desarrollo activo — los resultados son válidos para la versión usada.
- El mapeo evalúa el requisito formalizado tal como se derivó, no el comportamiento completo del diff original.

### 1.5 Estructura del documento `½ página`

Párrafo por capítulo describiendo su contenido y cómo contribuye al objetivo principal.

---

## Capítulo 2 — Estado del arte `12–15 páginas`

### 2.1 Ingeniería de requisitos basada en normas `3–4 páginas`

- IREB y el modelo de actividades RE (elicitación, documentación, validación + gestión).
- ISO/IEC/IEEE 29148: criterios de calidad de requisitos (verificabilidad, consistencia, completitud, trazabilidad).
- INCOSE Guide for Writing Requirements: buenas prácticas de redacción.
- Comparación IREB vs. IEEE 830 — justificación de la elección de IREB.
- Tabla resumen de criterios de calidad de los tres marcos.

### 2.2 Herramientas RE asistidas por LLMs `3–4 páginas`

- Panorama actual: GitHub Copilot, Cursor, Devin, SWE-agent, SpecKit.
- Revisión de estudios empíricos sobre generación de código a partir de requisitos con LLMs.
- Trabajos sobre evaluación de calidad RE en entornos ágiles/automatizados.
- Gap identificado: ausencia de mapeos sistemáticos SDD↔RE-normativo.

### 2.3 Spec-Driven Development como paradigma `2–3 páginas`

- Origen del paradigma y diferencia con TDD y BDD.
- El flujo SDD: especificación → planificación → implementación → validación.
- GitHub SpecKit: arquitectura, comandos, artefactos generados.
- Análisis de la documentación oficial de SpecKit como fuente primaria.

### 2.4 Evaluación empírica de pipelines de desarrollo `2–3 páginas`

- Metodologías de evaluación de herramientas de ingeniería del software.
- Uso de proyectos Open Source como corpus en estudios empíricos de SE.
- Estudios de mining de repositorios relevantes (MSR conference, papers de changelogs como fuente).
- Justificación de la aproximación de este TFG frente a alternativas.

### 2.5 Posicionamiento del trabajo `1 página`

Tabla comparativa de trabajos relacionados con columnas: referencia / objeto de estudio / marco RE / tipo de evaluación / gap cubierto. Indicar en qué columna este TFG es diferente.

---

## Capítulo 3 — Metodología `18–22 páginas`

> Este capítulo está muy desarrollado en el documento de metodología existente. La estructura aquí es la directa traducción de ese documento al formato de memoria.

### 3.1 Diseño metodológico y marcos de referencia `2–3 páginas`

- Tabla de fases / propósito / marco de referencia.
- Justificación del diseño como mapeo cualitativo estructurado.
- Relación entre la pregunta de investigación y cada fase.

### 3.2 Fase 1 — Extracción de evidencia candidata `4–5 páginas`

- Criterios de selección de repositorios (tabla con los 6 repos + tipo de sistema + justificación).
- Rúbrica de selección de cambios (tabla con las 4 dimensiones y descriptores).
- Procedimiento paso a paso.
- Fuentes complementarias y cuándo se usan.
- Limitaciones y amenazas a la validez de esta fase.

### 3.3 Fase 2 — Formalización de requisitos `3–4 páginas`

- Plantilla IREB con los 12 atributos y descripción de cada uno.
- Flujo de estados (Borrador → Elaborado → Validado).
- Quality gate de formalización con criterios de rechazo.
- Ejemplo ilustrativo de un requisito en tres estados (borrador → validado).
- Limitaciones: riesgo de interpretación al pasar de changelog a requisito.

### 3.4 Fase 3 — Ejecución de SpecKit `3–4 páginas`

- Protocolo de construcción del entorno por caso.
- Los 9 comandos del pipeline ampliado con función de cada uno.
- El constitution personalizado con principios RE y diferencia con el por defecto.
- Política de única ejecución: justificación y implicaciones.
- Registro de resultados: PR generada / fallo de generación / fallo de filtro técnico.
- Limitaciones: propagación de errores desde fases previas.

### 3.5 Fase 4 — Análisis del mapeo `4–5 páginas`

- Filtro técnico: criterios de calidad gate y qué pasa con los casos excluidos.
- Entradas del análisis por caso (E1–E5).
- Extracción de intención (I1–I5): procedimiento y ejemplo.
- Rúbrica SRCI: descripción de C1–C6 con base normativa y escala Sí/Parcial/No.
- Tabla de categorización con condiciones lógicas precisas.
- Control de consistencia intra-evaluador.
- Productos del análisis (mapa agregado + patrones).

### 3.6 Análisis de defensibilidad `1–2 páginas`

- Fortalezas del diseño metodológico.
- Vulnerabilidades residuales con respuesta preparada (las 3 preguntas principales).

---

## Capítulo 4 — Corpus de requisitos `8–10 páginas`

> Este capítulo documenta el resultado de las Fases 1 y 2. No repite la metodología; presenta el corpus.

### 4.1 Descripción del corpus `2 páginas`

- Estadísticas globales: número de requisitos por repositorio, por tipo (funcional/info/no-funcional), por estado final.
- Distribución de prioridades.
- Cobertura de tipos de sistema.
- Requisitos descartados en el quality gate y razones principales.

### 4.2 Análisis por repositorio `4–5 páginas`

Para cada uno de los 6 repositorios (~½ página cada uno):

```
[Nombre del repositorio]
- Tipo de sistema y por qué es representativo
- Número de requisitos en el corpus
- Características dominantes (tipo, complejidad, áreas funcionales)
- Ejemplo de un requisito representativo (extracto de la plantilla IREB)
- Principales dificultades de derivación encontradas
```

### 4.3 Análisis de calidad del corpus `2 páginas`

- Aplicación de las propiedades ISO 29148 al corpus: ¿qué porcentaje de requisitos es completamente verificable? ¿Qué porcentaje tiene criterio de aceptación operativo?
- Dependencias entre requisitos: grafo resumido o tabla de relaciones.
- Reflexión sobre las limitaciones del corpus (changelogs como fuente).

---

## Capítulo 5 — Ejecución y resultados `15–18 páginas`

### 5.1 Estadísticas de ejecución `2 páginas`

- Casos ejecutados / descartados (entorno roto) / fallos de generación / fallos de filtro técnico.
- Distribución por repositorio.
- Tiempos aproximados de ejecución por caso (si son relevantes).
- Tabla resumen: caso | repositorio | estado de ejecución | categoría SRCI.

### 5.2 Análisis de casos — muestra representativa `8–10 páginas`

Describir en detalle 6–8 casos (uno o dos por repositorio), seleccionados para cubrir las tres categorías de mapeo y diferentes tipos de requisito. Para cada caso:

```
Caso REQ-[ID]: [Nombre breve]
  Repositorio: [Nombre] | Versión: [X.Y.Z] | Tipo: [funcional/no-func/información]

  Requisito derivado (E1): [extracto de la plantilla IREB]
  Intención extraída (I1-I5): [tabla]
  
  Resultado de ejecución:
    - Pipeline completado: [sí/no]
    - PR generada: [sí/no + referencia]
    - Filtro técnico: [pasa/falla + detalle]
  
  Análisis SRCI:
    | Criterio | Evaluación | Evidencia |
    |----------|------------|-----------|
    | C1 ...   | Sí/Parcial/No | [diff/test referenciado] |
    ...
  
  Categoría de mapeo: [Alineado / Alineación parcial / Desviado]
  Observaciones: [insights específicos de este caso]
```

### 5.3 Mapa de alineación agregado `3–4 páginas`

- Tabla principal: actividades IREB (filas) × artefactos/comandos SpecKit (columnas) con indicador ✅/⚠️/❌ y nota explicativa por celda.
- Tabla secundaria: criterios ISO 29148 × comportamiento observado de SpecKit.
- Discusión de las celdas más relevantes (alineaciones fuertes, brechas importantes, áreas grises).

### 5.4 Patrones de comportamiento del pipeline SDD `2–3 páginas`

Identificar y describir ≥ 3 patrones, por ejemplo:

- *Patrón de cobertura funcional*: SpecKit cubre C1 (intención principal) en tipos de requisito X pero no en tipo Y.
- *Patrón de desviación en condiciones de activación*: C2 es el criterio con mayor tasa de Parcial en requisitos con restricciones de seguridad.
- *Patrón de generación de tests*: C4 (correspondencia tests-intención) baja significativamente en requisitos no funcionales.

Cada patrón: nombre descriptivo, condición contextual, evidencia de casos, interpretación.

---

## Capítulo 6 — Discusión `6–8 páginas`

### 6.1 Respuesta a la pregunta de investigación `2 páginas`

Sintetizar en qué medida SpecKit se alinea con el flujo RE normativo, con referencia directa a los patrones y al mapa de alineación. No repetir resultados — interpretar.

### 6.2 Implicaciones para adopción de SDD `2 páginas`

- ¿En qué condiciones SpecKit puede usarse como complemento a un proceso RE formal?
- ¿Qué actividades IREB quedan sin cobertura y deben hacerse "fuera" del pipeline SDD?
- Recomendaciones prácticas para equipos que quieran combinar SDD con RE normativo.

### 6.3 Implicaciones para el diseño de herramientas SDD `1–2 páginas`

- Qué propiedades IREB/ISO 29148 debería incorporar SpecKit (o herramientas similares) para alinearse mejor con RE profesional.

### 6.4 Limitaciones del estudio `1–2 páginas`

- Corpus limitado a proyectos OS y a una versión de SpecKit.
- El mapeo mide el requisito derivado, no el comportamiento completo del diff.
- Control de consistencia intra-evaluador vs. inter-evaluador.
- Posible sesgo en la derivación de requisitos.

---

## Capítulo 7 — Conclusiones y trabajo futuro `4–5 páginas`

### 7.1 Conclusiones `2–3 páginas`

Tres bloques diferenciados:

1. **Sobre SpecKit como herramienta**: qué hace bien, qué hace mal, cómo se comporta con distintos tipos de requisito.
2. **Sobre el paradigma SDD**: qué cobertura RE ofrece el enfoque como tal, más allá de SpecKit.
3. **Sobre el marco metodológico**: qué ha aportado la rúbrica SRCI y el diseño de corpus OS como aproximación para este tipo de análisis.

### 7.2 Trabajo futuro `1–2 páginas`

Específico y priorizado:

1. Replicar el estudio con otras herramientas SDD (Devin, SWE-agent) para comparabilidad.
2. Ampliar el corpus con requisitos derivados directamente de stakeholders reales (no solo changelogs).
3. Desarrollar una versión automatizada de la rúbrica SRCI asistida por LLM.
4. Estudiar la evolución del mapeo a medida que SpecKit incorpora nuevas versiones.

---

## Bibliografía `3–5 páginas`

Estilo IEEE. Ordenada por número de citación en el texto.

Fuentes obligatorias:
- IREB: *IREB CPRE Foundation Level Syllabus* (versión vigente).
- ISO/IEC/IEEE 29148:2018 — *Systems and software engineering — Life cycle processes — Requirements engineering*.
- INCOSE: *Guide for Writing Requirements* (versión vigente).
- GitHub SpecKit: repositorio oficial y documentación.
- Papers sobre evaluación empírica de herramientas RE con LLMs.
- Papers de Mining Software Repositories sobre uso de changelogs.

---

## Anexos `sin límite de páginas`

### Anexo A — Corpus completo de requisitos

Dataset completo en formato tabla o como referencia al repositorio del TFG. Para cada requisito: ID, repositorio, tipo, descripción formal, fuente, estado, versión.

### Anexo B — Constitution de SpecKit personalizado

Texto completo del fichero `speckit.constitution` con los principios RE configurados.

### Anexo C — Resultados completos de ejecución

Para todos los casos no incluidos en el capítulo 5: tabla con caso / estado de ejecución / resultados SRCI resumidos.

### Anexo D — Control de consistencia intra-evaluador

Los 3–5 casos re-analizados con la segunda aplicación de SRCI y tabla de discrepancias.

### Anexo E — Informe de horas (Clockify o equivalente)

Captura del informe total por fase: Fase 1 / Fase 2 / Fase 3 / Fase 4 / Documentación / Presentación. Total ≥ 300 horas.

### Anexo F — Manual de reproducción

Instrucciones para reproducir la ejecución de un caso desde cero:
1. Clonar el repositorio del TFG.
2. Checkout del repositorio objetivo en el commit de referencia.
3. Instalar SpecKit con la versión usada.
4. Ejecutar el pipeline con el requisito indicado.
5. Verificar los resultados.

---

## Resumen de extensión por capítulo

| Capítulo | Contenido | Páginas orientativas |
|---|---|---|
| Preliminares | Portada, resumen, índices | ~5 (no cuentan) |
| Cap. 1 | Introducción | 10–12 |
| Cap. 2 | Estado del arte | 12–15 |
| Cap. 3 | Metodología | 18–22 |
| Cap. 4 | Corpus de requisitos | 8–10 |
| Cap. 5 | Ejecución y resultados | 15–18 |
| Cap. 6 | Discusión | 6–8 |
| Cap. 7 | Conclusiones | 4–5 |
| Bibliografía | Referencias | 3–5 |
| Anexos | Material complementario | variable |
| **Total sin anexos** | | **76–95 páginas** |

---

## Notas de escritura para este TFG específico

**Terminología a usar con precisión constante:**

| Término correcto | Evitar |
|---|---|
| Requisito | Feature, funcionalidad, historia |
| Verificación | Validación (no es lo mismo en IREB) |
| Elicitación | Captura, recopilación |
| Formalización | Documentación, escritura |
| Pipeline SDD | Flujo, proceso (usar SDD pipeline consistentemente) |
| Mapeo | Comparación, análisis (mapeo es más preciso para el objetivo) |
| Categoría de alineación | Nota, puntuación, evaluación |

**Capítulos que determinan la candidatura a MH:**

El capítulo 3 (Metodología) ya tiene nivel de MH según lo analizado. El capítulo 5 (Resultados) es el que más va a pesar en el tribunal — es donde se demuestra que el trabajo realmente se hizo. El capítulo 6 (Discusión) es donde se demuestra madurez investigadora: no repetir resultados, sino interpretarlos. Muchos TFGs buenos fracasan en la discusión porque confunden "discutir" con "resumir".

**Sobre la presentación oral:**

Los 15 minutos distribuidos óptimamente para este TFG:
- 0:00–1:30 — Problema y resultado (antes de que el tribunal se aburra)
- 1:30–4:00 — Metodología (énfasis en el diseño del corpus y la SRCI)
- 4:00–10:00 — Resultados: mapa de alineación + 2 casos representativos
- 10:00–13:00 — Discusión: 3 patrones clave + implicaciones
- 13:00–15:00 — Conclusiones y trabajo futuro