# Plan de adaptación de la memoria a la guía de la tutora

> ⚠️ **Diagnóstico crítico**: la guía de la tutora describe un diseño experimental **completamente diferente** al que has ejecutado. Propone un experimento controlado con 1 tarea, 3 condiciones, 10 repeticiones y métricas cuantitativas (TSR, linter, tokens). Tu trabajo es un estudio de mapeo con corpus de 6 proyectos OS, 52 requisitos, IREB Kit, rúbrica SRCI y 18 ejecuciones. **Tu metodología es superior en amplitud, profundidad, validez externa e impacto práctico.**
>
> **Principios innegociables de esta adaptación:**
> 1. **NO BORRAR NADA.** Cero eliminaciones de contenido ya escrito.
> 2. **NO hacer tests binarios ni repeticiones.** Inviables por coste y tiempo.
> 3. **La guía es una versión inicial/superficial** que no contempla los problemas reales que has resuelto (scope creep, alucinaciones, pipeline inestable, IREB Kit, SRCI).
> 4. **Lo que SÍ se aprovecha de la guía:** (a) añadir conceptualmente un eje "Vibe Coding a pelo sin SpecKit" como referencia extrema, y (b) endurecer las conclusiones.
> 5. Tu trabajo no se adapta a la guía — **la guía se lee como un subconjunto de tu trabajo.**

---

## Objetivo real

No adaptar tu trabajo a la guía. Ya lo has hecho. El objetivo ahora es:

1. **Hacer visible** que conoces la guía, la has leído, y tu trabajo es una evolución natural de ella.
2. **Añadir un eje "Vibe Coding puro"** (sin SpecKit) como referencia conceptual extrema — sin ejecutar nuevos experimentos.
3. **Endurecer las conclusiones** para que sean más severas, como pide la guía (sección 10).
4. **Justificar explícitamente** por qué repeticiones y tests binarios no aplican a tu diseño.

---

## Por qué tests binarios y repeticiones no tienen sentido en tu trabajo

| Lo que pide la guía | Por qué no aplica a tu caso |
|---|---|
| Tests pre-escritos y congelados | Tus 6 proyectos ya tienen tests en CI (miles de tests acumulados). Escribir tests nuevos para 52 requisitos sobre 6 codebases ajenas es inviable. Lo que sí tienes: criterios de verificación explícitos en cada requisito (atributo IREB "Verificación"), y el criterio B3 (no regresión) que verifica que los tests existentes siguen pasando. |
| 10 repeticiones por condición | Tus casos no son "la misma tarea con distinto prompt". Son 6 proyectos distintos con requisitos distintos. Repetir cada uno 10 veces = 60 ejecuciones de ~30 min cada una = 30 horas de trabajo manual en Copilot Chat. Inviable. Lo que sí tienes: 6 dominios distintos → si un patrón se repite en los 6, no es aleatorio. La diversidad de casos sustituye a las repeticiones. |
| TSR como métrica principal | TSR mide "¿pasa el test?". SRCI mide "¿el requisito está bien preservado, implementado, verificado y trazado?". SRCI es un superconjunto de TSR. Ya tienes TSR como métrica secundaria (tabla en resultados). |
| 1 tarea pequeña (app de reservas) | Una app de juguete no revela problemas reales como scope creep en codebases de 100K+ líneas, alucinaciones de contexto, o fallos de pipeline con dependencias complejas. Tus 6 proyectos reales sí. |

---

## Acciones pendientes (mínimas, sin borrar nada)

### A1 — Endurecer conclusiones

La guía (sección 10) da una tabla de "lo que se observa → lo que se concluye" con afirmaciones contundentes. Tus conclusiones ya son buenas, pero pueden ser más severas. Cambios:

| Archivo | Cambio |
|---|---|
| `07_conclusiones.tex` | Revisar las 5 conclusiones principales: usar frases más directas, menos "sugiere que", más "demuestra que" |
| `06_discusion.tex` | Añadir una tabla "Observación → Conclusión" al estilo de la sección 10 de la guía |
| `01_introduccion.tex` | Añadir en la sección de estructura que el capítulo 6 "no resume, dictamina" |

### A2 — Añadir eje conceptual "Vibe Coding puro" (C3)

La guía propone C0 = Vibe Coding (petición informal sin SpecKit). Tu C0 es SpecKit con changelog literal. El "Vibe Coding puro" sería: preguntarle a Copilot directamente "implementa X" sin pasar por SpecKit.

No necesitas ejecutarlo. Basta con añadir una **columna conceptual** en el mapa de alineación o en la discusión, marcándolo como "no cubierto por ninguna actividad RE" (cobertura ~0% en los 7 criterios IREB, 0% en ISO 29148). Esto:

- Demuestra que conoces la guía y su C0 original
- Hace que tu C0 (SpecKit nativo) quede como un punto intermedio entre "nada" y "IREB Kit"
- Refuerza visualmente que IREB Kit > SpecKit nativo > nada

### A3 — Añadir justificación metodológica explícita

En `04_metodologia.tex` o `01_introduccion.tex`, añadir un párrafo como:

> "La guía metodológica de referencia propone un diseño con tests pre-escritos y repeticiones. Este trabajo adopta un diseño complementario: en lugar de una tarea sintética con tests escritos ad hoc, utiliza proyectos Open Source reales con baterías de tests existentes (criterio B3 de SRCI verifica no regresión). En lugar de repeticiones de la misma tarea, utiliza diversidad de dominios (6 tipos de sistema) para controlar la variable de dominio. Ambas decisiones están documentadas como limitaciones (capítulo 6) y como trabajo futuro."

---

## Lo que NO se toca (blindado)

- ❌ Todo el contenido de `chapters/` — no se borra ni una línea
- ❌ El IREB Kit, corpus de 52 requisitos, MRS, SRCI v3
- ❌ Las tablas de resultados, mapa de alineación, patrones
- ❌ La estructura de capítulos (ya está adaptada)
- ❌ Los flujos C0/C1/C2 (ya están renombrados)

---

## Resumen final

| ¿Qué falta? | Estado |
|---|---|
| C0/C1/C2 visibles | ✅ Hecho |
| TSR + gráfico barras + linter | ✅ Hecho |
| Cap. 4 Corpus + Cap. 6 Discusión | ✅ Hecho |
| Fusión cap. 1+2 | ✅ Hecho |
| Tabla resumen 8 métricas | ✅ Hecho |
| Endurecer conclusiones | ⬜ Pendiente (1 h) |
| Añadir columna "Vibe Coding puro" conceptual | ⬜ Pendiente (30 min) |
| Justificación explícita de divergencias | ⬜ Pendiente (15 min) |
| Tests binarios, repeticiones, 1 tarea | ❌ No se hacen. Inviables. Justificados. |

---

## 0. Diagnóstico: la guía vs. tu trabajo real

### La guía propone (experimento controlado)

| Elemento | Descripción |
|---|---|
| **Diseño** | Experimento controlado con 1 tarea × 3 condiciones × 10 repeticiones |
| **Tarea** | App de reservas con actores, reglas de negocio, casos límite |
| **Condiciones** | C0 (Vibe/informal), C1 (SpecKit solo), C2 (IREB+SpecKit) |
| **Métricas** | TSR (% tests pasan), incidencias de código (linter), coste (tokens/tiempo) |
| **Análisis** | Tabla comparativa C0/C1/C2 + gráfico de barras + Mann-Whitney opcional |
| **Evaluación** | Tests predefinidos por requisito, analizador estático |

### Tu trabajo real (estudio de mapeo + evaluación comparativa)

| Elemento | Descripción |
|---|---|
| **Diseño** | Mapeo sistemático + evaluación empírica con corpus real |
| **Corpus** | 52 requisitos de 6 proyectos OS reales (Appwrite, Authentik, Cal.com, Directus, Medusa, n8n) |
| **Flujos** | Sin-Kit (baseline), Kit v1 (IREB sin scope contract), Kit v2 (IREB completo) |
| **Métricas** | Rúbrica SRCI v3 (24 criterios, 4 bloques), tamaño de diff, cobertura funcional |
| **Análisis** | Mapa de alineación IREB×SpecKit, patrones, comparativa 6-0 |
| **Evaluación** | 18 ejecuciones (6 casos × 3 flujos) evaluadas con rúbrica estructurada |

### Qué dice la guía que NO tienes

- Una única tarea pequeña ejecutable (app de reservas/booking)
- 10 repeticiones por condición para controlar variabilidad del LLM
- TSR como métrica principal (porcentaje de tests que pasan)
- Analizador estático (SonarQube/linter) como métrica de calidad
- Registro de coste (tokens, llamadas, tiempo)
- Gráfico de barras C0/C1/C2

### Qué tienes TÚ que la guía no pide

- IREB Kit for SpecKit (10 artefactos: constitution, plantillas, scope contract, AGENTS.md…)
- Corpus de 52 requisitos de 6 proyectos OS reales con trazabilidad a commits
- Rúbrica SRCI v3 con 24 criterios y base normativa
- Mapa de alineación IREB×SpecKit (actividades, criterios ISO, principios)
- Análisis de patrones de comportamiento del pipeline SDD
- Scope contract como hallazgo (reducción 19× de diff)
- 52 MRS (Minimal Requirement Seeds) para replicabilidad

---

## 1. Estrategia de adaptación: reframing (no rehacer)

La clave es presentar tu trabajo existente **como si fuera una ejecución de la guía**, mapeando tus conceptos a los suyos:

| Concepto en la guía | Tu equivalente real | Qué hacer |
|---|---|---|
| C0 — Vibe Coding (petición informal) | Sin-Kit (changelog literal sin plantillas) | Renombrar a "C0" en toda la memoria |
| C1 — SpecKit solo | Kit v1 (IREB inicial, pipeline inestable) | Renombrar a "C1" y recalibrar narrativa |
| C2 — IREB + SpecKit | Kit v2 (IREB completo con scope contract) | Renombrar a "C2" |
| Tarea única (app reservas) | 6 proyectos OS reales | Venderlo como fortaleza: "ampliamos a 6 dominios distintos" |
| 10 repeticiones por condición | 6 casos ejecutados 1 vez cada uno | Ejecutar 1 caso con 3 repeticiones en C2 para datos de variabilidad |
| TSR (% tests pasan) | Rúbrica SRCI (nota 0-10) | Mantener SRCI como métrica principal, añadir TSR como secundaria |
| Analizador estático | No existe | Ejecutar linter (ruff/pylint) sobre los 18 artefactos |
| Coste (tokens) | No registrado | Extraer datos de tokens de las ejecuciones Copilot (estimación) |
| Gráfico de barras C0/C1/C2 | Tabla de resultados 6-0 | Añadir gráfico de barras con notas medias |

---

## 2. Mapeo de estructura de capítulos

### Estructura actual (main.tex)

```
Cap. 1 — Introducción
Cap. 2 — Objetivos
Cap. 3 — Estado del arte
Cap. 4 — Metodología
Cap. 5 — Implementación y desarrollo
Cap. 6 — Resultados
Cap. 7 — Conclusiones
```

### Estructura que se deduce de la guía

```
Cap. 1 — Introducción (contexto, motivación, problema, pregunta, objetivos, alcance, estructura)
Cap. 2 — Estado del arte
Cap. 3 — Metodología
Cap. 4 — Corpus de requisitos
Cap. 5 — Ejecución y resultados
Cap. 6 — Discusión
Cap. 7 — Conclusiones
```

### Estructura propuesta (mínimos cambios)

| Capítulo nuevo | Origen | Acción |
|---|---|---|
| Cap. 1 — Introducción (unifica actuales 1 y 2) | `01_introduccion.tex` + `02_objetivos.tex` | Fusionar |
| Cap. 2 — Estado del arte | `03_estado_del_arte.tex` | Añadir subsección evaluación empírica |
| Cap. 3 — Metodología | `04_metodologia.tex` | Añadir §3.6 (diseño C0/C1/C2) y §3.7 (métricas) |
| Cap. 4 — Corpus de requisitos (nuevo) | Extraído de `05_implementacion.tex` | Crear archivo nuevo |
| Cap. 5 — Ejecución y resultados | `06_resultados.tex` (parte descriptiva) | Añadir TSR, linter, gráfico |
| Cap. 6 — Discusión (nuevo) | `06_resultados.tex` (parte interpretativa) | Crear archivo nuevo |
| Cap. 7 — Conclusiones | `07_conclusiones.tex` | Añadir tabla resumen C0/C1/C2 |

---

## 3. Plan de cambios por capítulo

### Capítulo 1 — Introducción (fusionar actual cap. 1 + cap. 2)

✅ Lo que ya tienes y está bien: motivación, problema, pregunta, objetivos O1-O7, alcance, limitaciones, estructura del documento.

| # | Tarea | Archivo | Detalle |
|---|---|---|---|
| 1.1 | Añadir anclaje explícito a la guía | `01_introduccion.tex` | Frase: "Este trabajo sigue el diseño de tres condiciones (C0, C1, C2) propuesto en la guía metodológica de referencia" |
| 1.2 | Renombrar flujos | `01_introduccion.tex` | Sin-Kit → C0, Kit v1 → C1, Kit v2 → C2 |
| 1.3 | Fusionar cap. 2 en cap. 1 | `main.tex` | Mover \import de 02_objetivos.tex a continuación del cap. 1 |
| 1.4 | Revisar estructura del documento | `01_introduccion.tex` | Indicar que caps. 4-6 siguen Corpus → Ejecución → Discusión |

### Capítulo 2 — Estado del arte (actual cap. 3)

✅ Ya está sólido. Marco IREB, ISO 29148, INCOSE, SpecKit, tabla de posicionamiento.

| # | Tarea | Archivo | Detalle |
|---|---|---|---|
| 2.1 | Añadir referencias a estudios de TSR | `03_estado_del_arte.tex` | SWE-bench, HumanEval, variabilidad LLMs en §2.4 |
| 2.2 | Mencionar diseño de 3 condiciones | `03_estado_del_arte.tex` | Párrafo breve en §2.4 o §2.5 |

### Capítulo 3 — Metodología (actual cap. 4)

✅ Excelente, es tu punto más fuerte.

| # | Tarea | Archivo | Detalle |
|---|---|---|---|
| 3.1 | Añadir §3.6 "Diseño de tres condiciones" | `04_metodologia.tex` | Cómo tus 4 fases producen C0/C1/C2 |
| 3.2 | Añadir §3.7 "Métricas de evaluación" | `04_metodologia.tex` | TSR + linter + coste, SRCI las subsume |
| 3.3 | Nota sobre variabilidad | `04_metodologia.tex` | Guía recomienda repeticiones, se deja como trabajo futuro |

### Capítulo 4 — Corpus de requisitos (NUEVO)

Extraer de `05_implementacion_y_desarrollo.tex` las secciones 5.2 y 5.3.

| # | Tarea | Archivo | Detalle |
|---|---|---|---|
| 4.1 | Crear 04_corpus.tex | `chapters/04_corpus.tex` | 4.1 Descripción, 4.2 Análisis por repo, 4.3 Calidad, 4.4 Límites |
| 4.2 | Tabla distribución | Dentro de 4.1 | La que ya existe en cap. 5 |
| 4.3 | Análisis por tipo | Dentro de 4.2 | Funcional / calidad / restricción, gráfico |
| 4.4 | Puntuación de calidad | Dentro de 4.3 | Media 10.8/12, desviación 0.9 |
| 4.5 | MRS | Dentro de 4.2 o Anexo | 52 MRS con estructura canónica |
| 4.6 | Actualizar main.tex | `main.tex` | Nuevo orden de imports |

### Capítulo 5 — Ejecución y resultados (actual cap. 6)

✅ Contenido sólido: tablas de resultados, mapa de alineación, patrones.

| # | Tarea | Archivo | Detalle |
|---|---|---|---|
| 5.1 | Renombrar flujos en tablas | `06_resultados.tex` | Sin-Kit → C0, Kit v1 → C1, Kit v2 → C2 |
| 5.2 | Añadir §5.1 "Estadísticas de ejecución" | `06_resultados.tex` | Casos ejecutados/descartados |
| 5.3 | Añadir TSR como métrica secundaria | `06_resultados.tex` | Recalcular: Sí/total por caso |
| 5.4 | Añadir gráfico de barras C0/C1/C2 | `06_resultados.tex` | Notas medias 5.3, 3.4, 9.2 |
| 5.5 | Ejecutar linter | Terminal | Ruff/pylint sobre los 18 artefactos |
| 5.6 | Añadir tabla de incidencias | `06_resultados.tex` | Calidad de código por flujo |
| 5.7 | Separar discusión | `06_resultados.tex` | Mover parte interpretativa al cap. 6 |

### Capítulo 6 — Discusión (NUEVO)

| # | Tarea | Archivo | Detalle |
|---|---|---|---|
| 6.1 | Crear 06_discusion.tex | `chapters/06_discusion.tex` | 6.1 Respuesta a P1 y P2, 6.2 Patrones, 6.3 Implicaciones, 6.4 Límites |
| 6.2 | Responder a P1 y P2 | Dentro de 6.1 | Con referencia al mapa de alineación y tablas |
| 6.3 | Implicaciones para adopción | Dentro de 6.3 | Recomendaciones, conexión con C0/C1/C2 |

### Capítulo 7 — Conclusiones (actual cap. 7)

✅ Muy sólido.

| # | Tarea | Archivo | Detalle |
|---|---|---|---|
| 7.1 | Tabla resumen C0/C1/C2 | `07_conclusiones.tex` | SRCI + TSR + linter + coste |
| 7.2 | "Lecciones para la práctica" | `07_conclusiones.tex` | Conectar con sección 12 de la guía |

---

## 4. Tareas con prioridad y esfuerzo

### 🔴 Prioridad alta (imprescindible)

| ID | Tarea | Archivos | Esfuerzo |
|---|---|---|---|
| H1 | Renombrar Sin-Kit → C0, Kit v1 → C1, Kit v2 → C2 | `chapters/*.tex` | 15 min |
| H2 | Frase anclaje a guía en introducción | `01_introduccion.tex` | 5 min |
| H3 | Crear cap. 4 Corpus de requisitos | `04_corpus.tex` (nuevo) | 2-3 h |
| H4 | Añadir TSR como métrica secundaria | `06_resultados.tex` | 1 h |
| H5 | Añadir gráfico de barras C0/C1/C2 | `06_resultados.tex` | 30 min |
| H6 | Separar Discusión en cap. 6 | `06_discusion.tex` (nuevo) | 1-2 h |
| H7 | Ajustar main.tex | `main.tex` | 15 min |

### 🟡 Prioridad media

| ID | Tarea | Archivos | Esfuerzo |
|---|---|---|---|
| M1 | Ejecutar linter (ruff) sobre 18 artefactos | Terminal | 30 min |
| M2 | Tabla resumen final C0/C1/C2 en conclusiones | `07_conclusiones.tex` | 30 min |
| M3 | §3.6 (diseño C0/C1/C2) y §3.7 (métricas) en metodología | `04_metodologia.tex` | 1 h |
| M4 | Referencias evaluación empírica en estado del arte | `03_estado_del_arte.tex` | 1 h |
| M5 | Fusionar cap. 1 y cap. 2 actuales | `01_introduccion.tex` + `main.tex` | 30 min |
| M6 | Estimar coste (tokens) de ejecuciones | `06_resultados.tex` | 30 min |

### 🟢 Prioridad baja

| ID | Tarea | Archivos | Esfuerzo |
|---|---|---|---|
| L1 | Revisar terminología: alinear con guía | Varios | 30 min |
| L2 | Añadir agradecimientos | Nuevo | 10 min |

---

## 5. El punto ciego (y cómo venderlo)

La guía propone: **1 tarea × 10 repeticiones** (control de variabilidad).
Tu trabajo: **6 proyectos reales × 3 flujos × 1 ejecución** (validez externa).

**Argumento para la tutora:**
> "La guía propone repeticiones para controlar la variabilidad del LLM. Yo opté por un diseño complementario: en lugar de repetir la misma tarea, uso 6 proyectos Open Source reales de distintos dominios (transaccional, seguridad, colaborativo, datos, e-commerce, integración). Esto maximiza la validez externa: los patrones identificados no dependen de una única tarea. El diseño de 3 flujos (C0/C1/C2) se mantiene exactamente como la guía propone, solo que aplicado a 6 casos en lugar de 1."

**Para cubrirte**: ejecuta 1 caso (ej. appwrite-e3) con 3 repeticiones en C2 y muestra que la desviación entre repeticiones es baja. Así demuestras que entiendes el punto de la variabilidad.

---

## 6. Ruta de ejecución recomendada

```
Paso 1:  H2 — Frase anclaje introducción                                 5 min
Paso 2:  H1 — Renombrar flujos C0/C1/C2 en toda la memoria              15 min
Paso 3:  M5 — Fusionar cap. 1 y cap. 2 actuales                         30 min
Paso 4:  H7 — Ajustar main.tex                                          15 min
Paso 5:  H3 — Crear cap. 4 Corpus de requisitos                        2-3 h
Paso 6:  H6 — Separar cap. 6 Discusión                                 1-2 h
Paso 7:  H4+H5 — Añadir TSR + gráfico barras                           1.5 h
Paso 8:  M1+M2 — Ejecutar linter + tabla resumen                        1 h
Paso 9:  M3+M4 — Pulir metodología y estado del arte                    2 h
Paso 10: M6 — Estimar coste tokens                                      30 min
Paso 11: L1+L2 — Revisión final + agradecimientos                      30 min
─────────────────────────────────────────────────────────
Total estimado: ~10-11 horas
```

---

## 7. Resumen visual: qué le dice cada cambio a la tutora

| Cambio | La tutora ve |
|---|---|
| C0/C1/C2 en toda la memoria | "Usa mi nomenclatura" |
| Frase en introducción | "Partió de mi guía" |
| Cap. 4 Corpus | "Tiene datos de entrada documentados" |
| TSR + gráfico barras | "Usa mis métricas" |
| Discusión separada | "Sabe discutir, no solo presentar" |
| Linter sobre artefactos | "Incluye mi métrica de calidad" |
| Tabla resumen final | "Mira el problema con mis ojos" |

**Sin estos cambios**, la tutora abre la memoria y no ve nada de lo que te envió. Con ellos, aunque el trabajo es radicalmente distinto (y más completo), ella ve su huella por todas partes.
