# Rúbrica de validación de formalización de requisitos

La presente rúbrica opera como quality gate sobre los requisitos derivados en la fase de formalización, determinando si un requisito alcanza la calidad mínima necesaria para ser utilizado como entrada válida en la fase de evaluación de conformidad. Su diseño se basa en las características de calidad definidas por ISO/IEC/IEEE 29148, las recomendaciones de IREB CPRE Foundation Level Handbook y los criterios de redacción de INCOSE Guide for Writing Requirements.

## Consideración sobre el contexto de aplicación

Los requisitos evaluados mediante esta rúbrica no provienen de un proceso deliberado de elicitación con stakeholders, sino que han sido derivados a partir de changelogs y release notes de repositorios de software. Esta condición de origen tiene implicaciones directas sobre cómo deben interpretarse algunos criterios:

- El atributo **Fuente** hace referencia al artefacto técnico de origen (versión del changelog, URL de release, referencia a PR), no a un stakeholder humano. Esta forma de trazabilidad es igualmente válida y está contemplada en ISO 29148 como fuente documental.
- El atributo **Rationale** puede ser inferido del contexto del cambio cuando no está declarado explícitamente en la fuente. En ese caso se documenta como inferido, lo que no penaliza el requisito siempre que la inferencia sea razonable y trazable.
- Las condiciones de verificación se formulan en términos de comportamiento observable del sistema, no necesariamente como pruebas E2E formales, dado que el contexto es de derivación desde evidencia técnica y no de especificación original.

Este ajuste de interpretación no rebaja el rigor de la rúbrica, sino que lo adapta al tipo de fuente analizada, evitando penalizar requisitos correctamente formalizados por razones ajenas a su calidad intrínseca. Esta decisión es coherente con el principio de adecuación al propósito (*fitness for purpose*) que INCOSE aplica a la evaluación de especificaciones en contextos de ingeniería aplicada.

---

## Criterios de evaluación

La rúbrica organiza sus diez criterios en tres bloques funcionales: **Identificación y gestión**, **Redacción y verificabilidad** y **Completitud contextual**. Esta organización facilita la localización de deficiencias por tipo y es coherente con la estructura de atributos de IREB.

Cada criterio se evalúa de forma binaria:

- **1 punto** → Cumple el criterio según las condiciones descritas.
- **0 puntos** → No cumple el criterio.

---

### Bloque A. Identificación y gestión

| # | Criterio | Condición de cumplimiento | Justificación | Ejemplo |
|---|---|---|---|---|
| **R1** | **Identificador único** | El requisito dispone de un ID estable, no reutilizable, con formato `REQ-[DOMINIO]-[NNN]`. | IEEE 29148 e IREB consideran la identificación única un atributo esencial para trazabilidad y gestión de cambios. | ✔ `REQ-AUTH-007` ✘ Sin identificador o duplicado |
| **R2** | **Clasificación válida** | El atributo Tipo contiene exactamente uno de los valores: Funcional, Calidad o Restricción. | IREB distingue estas tres categorías para facilitar análisis, priorización y validación diferenciada. | ✔ `Funcional` ✘ `Importante` o campo vacío |
| **R3** | **Fuente trazable** | Se documenta el origen del requisito de forma que permita localizar la evidencia. En contexto de changelogs: versión, URL de release o referencia a PR. No se exige stakeholder humano. | IREB define Source como atributo para soportar trazabilidad hacia el origen. ISO 29148 contempla fuentes documentales como origen válido. | ✔ `Changelog v3.2.1, PR #1042` ✘ Campo vacío o `varias fuentes` |
| **R4** | **Prioridad asignada** | El atributo Prioridad contiene uno de los valores: Alta, Media o Baja. | IREB incorpora la prioridad para apoyar negociación y gestión del alcance. | ✔ `Media` ✘ Campo vacío o valor no estándar |

---

### Bloque B. Redacción y verificabilidad

| # | Criterio | Condición de cumplimiento | Justificación | Ejemplo |
|---|---|---|---|---|
| **R5** | **Estructura formal** | La descripción sigue el patrón "El sistema deberá [verbo] [objeto] [condición]". Se acepta la omisión de condición cuando el comportamiento es suficientemente preciso sin ella. | IEEE 29148 e INCOSE recomiendan una estructura uniforme para reducir ambigüedad y facilitar verificación. | ✔ `El sistema deberá registrar la fecha de creación...` ✘ `Sería conveniente que el sistema...` |
| **R6** | **Obligación única** | El requisito describe un único comportamiento principal. Se permiten condiciones adicionales sobre ese comportamiento (cuándo, cómo, bajo qué restricción), pero no dos verbos de acción independientes. | INCOSE establece que los requisitos deben ser singulares (*singular*). Una condición no es una obligación adicional. | ✔ `...generar un token firmado si la sesión está activa` ✘ `...generar un token y enviarlo por correo` |
| **R7** | **Verbo observable** | El verbo principal describe un comportamiento que puede observarse o medirse directamente. | INCOSE recomienda verbos que permitan verificar objetivamente el cumplimiento. | ✔ `generar`, `registrar`, `rechazar`, `devolver` ✘ `facilitar`, `optimizar`, `mejorar`, `gestionar` |
| **R8** | **Ausencia de ambigüedad crítica** | El enunciado no contiene términos subjetivos o expresiones abiertas a interpretaciones múltiples que afecten a su verificación. Se tolera terminología técnica de dominio cuando es estándar en el repositorio analizado. | IEEE 29148 e INCOSE exigen requisitos no ambiguos. La ambigüedad técnica de dominio no equivale a ambigüedad de especificación. | ✔ `en menos de 200 ms` ✘ `rápidamente`, `de forma eficiente`, `cuando proceda` |
| **R9** | **Verificabilidad observable** | Existe al menos un criterio de verificación que describe cómo comprobar el cumplimiento mediante evidencia observable: comportamiento del sistema, respuesta de API, cambio de estado, log o test. No se exige prueba E2E formal. | IEEE 29148 exige que los requisitos sean verificables. INCOSE establece que la verificación puede realizarse mediante prueba, análisis, inspección o demostración. | ✔ `La API deberá devolver HTTP 401 si el token ha expirado` ✘ `Se comprobará durante las pruebas` |

---

### Bloque C. Completitud contextual

| # | Criterio | Condición de cumplimiento | Justificación | Ejemplo |
|---|---|---|---|---|
| **R10** | **Autosuficiencia** | El requisito puede comprenderse sin necesidad de consultar otros requisitos o documentos externos. Se acepta la referencia a conceptos técnicos de dominio estándar. No se penaliza la ausencia de rationale explícito si el contexto de origen lo hace evidente. | IEEE 29148 establece que un requisito debe ser completo y comprensible. La autosuficiencia no implica explicar el dominio, sino que el comportamiento requerido esté claro en sí mismo. | ✔ Describe acción, objeto y condición suficientes para su verificación ✘ `El sistema deberá completar el proceso anterior` |

---

## Puntuación y umbral de aceptación

La puntuación total es la suma directa de criterios cumplidos, sobre un máximo de 10 puntos.

| Puntuación | Resultado | Acción |
|---|---|---|
| **9–10** | **Aceptado** | El requisito es válido como entrada para la fase de evaluación. |
| **7–8** | **Revisión menor** | El requisito puede aceptarse condicionalmente si las deficiencias no afectan a R5, R7, R8 o R9. En caso contrario requiere corrección. |
| **≤ 6** | **Rechazado** | El requisito no alcanza el nivel mínimo de calidad y debe reformularse antes de continuar. |

### Criterios bloqueantes

Con independencia de la puntuación total, un requisito se rechaza automáticamente si incumple cualquiera de los siguientes criterios, dado que su ausencia hace inviable la evaluación de conformidad posterior:

- **R5** (estructura formal ausente): sin estructura definida no es posible identificar la obligación del sistema.
- **R7** (verbo no observable): sin comportamiento verificable el requisito no puede evaluarse.
- **R9** (sin verificabilidad): un requisito sin criterio de verificación no puede usarse como entrada para inspección de conformidad.

La existencia de criterios bloqueantes independientes de la puntuación global es coherente con la práctica de quality gates en ingeniería de software, donde ciertas propiedades son condición necesaria y no compensable por otras dimensiones de calidad.

---

## Justificación del umbral y del diseño binario

El umbral de 9/10 se mantiene como nivel de aceptación plena, pero se introduce la categoría de revisión menor (7–8) para evitar el rechazo automático de requisitos que presentan deficiencias menores no bloqueantes. Esta decisión reconoce que la derivación desde changelogs produce requisitos con calidad desigual en atributos de gestión (R3, R4) sin que eso comprometa su utilidad como especificación verificable.

La evaluación binaria se mantiene frente a escalas graduales porque maximiza la reproducibilidad entre evaluadores, incluidos evaluadores automatizados basados en LLM. Una escala de tres niveles por criterio introduce ambigüedad en los casos intermedios que es difícil de calibrar sin datos de entrenamiento específicos del dominio.

Se descartó una ponderación diferencial de criterios (por ejemplo, dar más peso a R9 que a R1) porque introduce complejidad de calibración sin beneficio claro en el contexto de un corpus homogéneo derivado de la misma metodología de formalización. Si todos los requisitos se han producido siguiendo la misma plantilla, la variación esperada entre criterios es reducida y una ponderación uniforme es suficientemente discriminante.