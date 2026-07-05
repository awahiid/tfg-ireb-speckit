# Instrucciones para el agente: derivación de prompts MRS desde requisitos formalizados

> **Versión**: 1.0  
> **Uso**: Coloca este archivo en `2-requisitos/` junto a `plantilla.md` y `rubrica.md`.  
> El agente debe leerlo antes de procesar cualquier archivo `REQ-*.md`.

---

## 1. Propósito y marco teórico

Este documento instruye al agente para transformar cada requisito formalizado
(conforme a ISO/IEC/IEEE 29148 e IREB CPRE) en un **Minimal Requirement Seed
(MRS)**: el prompt mínimo, replicable y académicamente justificable que un
usuario convencional necesitaría formular para que el pipeline IREB/SpecKit
derive de forma autónoma el requisito formal equivalente.

Un MRS es válido si y solo si satisface tres propiedades:

| Propiedad | Definición operacional |
|---|---|
| **Suficiencia** | Contiene toda la información necesaria para inferir los campos obligatorios de la plantilla (Descripción formal, Verificación, Rationale, Tipo). |
| **Minimalidad** | No contiene información que el agente deba inferir por sí mismo (no sobredetermina la solución). |
| **Replicabilidad** | Dos agentes independientes que lean el MRS y la plantilla producen requisitos formales equivalentes. |

Estas propiedades se justifican en:
- **ISO/IEC/IEEE 29148:2018**, §5.2: un requisito debe ser necesario,
  no ambiguo, factible y verificable. El MRS es la semilla que garantiza
  estas propiedades al derivar el requisito.
- **IREB CPRE Foundation Handbook**, capítulo *Elicitation*: la elicitación
  por *problem framing* produce requisitos más estables que la elicitación
  por solución propuesta.
- **Reynolds & McDonell (2021)** y **Wei et al. (2022)**: los prompts con
  estructura `role + goal + constraint` maximizan la consistencia de salida
  en modelos de lenguaje.

---

## 2. Estructura canónica del MRS

Todo MRS debe seguir esta plantilla de tres líneas obligatorias y dos opcionales:

```
Como [ROL/ACTOR],
quiero que el sistema [COMPORTAMIENTO OBSERVABLE]
[cuando / en el contexto de / a través de] [CONTEXTO_TÉCNICO],
para [MOTIVACIÓN — estado indeseable actual o riesgo evitado].

[Restricción: RESTRICCIÓN_CONOCIDA]   ← incluir solo si existe en el REQ
[Fuente: REFERENCIA_TRAZABLE]         ← siempre incluir si el REQ tiene Fuente
```

### Reglas de extracción por campo del REQ

| Campo del MRS | Se extrae de | Regla de transformación |
|---|---|---|
| `ROL/ACTOR` | `Módulo` + `Descripción formal` | Inferir el actor más específico posible. Si el módulo es `Auth / OAuth`, el actor es `administrador` o `usuario autenticado`, no `usuario`. Si no hay módulo, usar `usuario del sistema`. |
| `COMPORTAMIENTO OBSERVABLE` | `Descripción formal` | Parafrasear en voz activa desde la perspectiva del actor. Eliminar la fórmula "El sistema deberá". Conservar el objeto y la condición. **Nunca incluir detalles de implementación** salvo que el Tipo sea `Restricción`. |
| `CONTEXTO_TÉCNICO` | `Descripción formal` + `Módulo` | Nombrar exactamente un artefacto concreto: variable de entorno, endpoint, componente, configuración. Si no existe artefacto nombrable, omitir la cláusula de contexto. |
| `MOTIVACIÓN` | `Rationale` | Describir el **estado indeseable actual** en una frase. Si el Rationale no existe, inferir la negación del comportamiento requerido. Marcar como `[inferido]` en ese caso. |
| `RESTRICCIÓN_CONOCIDA` | `Descripción formal` (condiciones negativas o límites) | Incluir solo si la descripción contiene una condición explícita del tipo "si X no está definido", "salvo que", "excepto cuando". |
| `FUENTE` | `Fuente` | Copiar la referencia más corta y trazable: número de PR, issue o versión. No copiar la URL completa salvo que sea la única referencia disponible. |

---

## 3. Procedimiento de derivación paso a paso

Para cada archivo `REQ-*.md` en el directorio procesado:

### Paso 1 — Leer y validar la entrada

Verificar que el requisito contiene al menos los campos obligatorios de la
plantilla: `ID`, `Descripción formal`, `Tipo`, `Verificación` y `Rationale`.

Si falta algún campo bloqueante (`Descripción formal`, `Verificación`),
registrar el requisito como `OMITIDO` en el manifiesto de salida con la razón.
No generar MRS para requisitos incompletos.

### Paso 2 — Identificar el COMPORTAMIENTO OBSERVABLE

Tomar la `Descripción formal`. Localizat el verbo principal (el que sigue
a "El sistema deberá"). Verificar que es observable según la rúbrica (R7):
`generar`, `registrar`, `rechazar`, `devolver`, `restringir`, `exponer`,
`aplicar`, `validar`, `retornar`, `bloquear`, `notificar`, etc.

Si el verbo no es observable (p. ej. `gestionar`, `optimizar`, `facilitar`),
buscar el verbo subsidiario más concreto en el mismo enunciado o en la
`Verificación`.

### Paso 3 — Construir el MRS

Aplicar la plantilla canónica del §2. Restricciones adicionales:

- **Longitud máxima**: 5 líneas (sin contar la línea de fuente).
- **No usar terminología de implementación** en el `COMPORTAMIENTO OBSERVABLE`
  salvo que el campo `Tipo` sea `Restricción`.
- **No duplicar información**: si el `CONTEXTO_TÉCNICO` ya está implícito en
  el `COMPORTAMIENTO OBSERVABLE`, omitir la cláusula de contexto.
- **Tiempo verbal**: presente de indicativo para el comportamiento, no
  condicional ni futuro.
- **Nombre del artefacto técnico**: si la `Descripción formal` menciona un
  artefacto específico (variable de entorno, atributo HTML, endpoint), incluirlo
  en backticks dentro del MRS.

### Paso 4 — Verificar la suficiencia del MRS

Antes de emitir el MRS, comprobar mentalmente que un agente que solo lea el
MRS y la `plantilla.md` podría inferir:

- [ ] El Tipo del requisito (Funcional / Calidad / Restricción)
- [ ] La estructura "El sistema deberá..." de la Descripción formal
- [ ] Al menos un criterio de Verificación observable
- [ ] El Rationale (motivación del cambio)

Si alguno de estos puntos no puede inferirse, ampliar el MRS con la información
mínima necesaria para resolverlo, manteniendo la forma natural del lenguaje.

### Paso 5 — Emitir la salida

Generar un bloque por requisito con el formato del §4.

---

## 4. Formato de salida

El agente debe producir un único archivo `mrs-prompts.md` en el mismo directorio
que los requisitos procesados, con la siguiente estructura:

```markdown
# MRS Prompts — [DOMINIO]

Generado: [fecha ISO]
Requisitos procesados: N
Requisitos omitidos: M (ver sección OMITIDOS)

---

## [REQ-DOMINIO-NNNNN] — [Nombre del requisito]

**MRS:**

> Como [ROL],
> quiero que el sistema [COMPORTAMIENTO],
> [contexto si aplica],
> para [MOTIVACIÓN].
>
> [Restricción: ...]   ← omitir si no aplica
> Fuente: [REFERENCIA]

**Notas de derivación:** [Solo si hubo decisiones no triviales, p. ej.:
"Rationale inferido. Verbo subsidiario tomado de Verificación (R7 aplicado)."]

---
```

Los requisitos `OMITIDOS` se listan al final con su ID y la razón de omisión:

```markdown
## Requisitos omitidos

| ID | Razón |
|---|---|
| REQ-XXX-NNN | Falta campo Descripción formal |
| REQ-XXX-MMM | Verbo no observable y Verificación ausente |
```

---

## 5. Ejemplos de referencia

### Ejemplo A — Requisito funcional con artefacto técnico nombrado

**REQ de entrada (fragmento):**
```
Tipo: Funcional
Descripción formal: El sistema deberá restringir la selección de archivos en
la interfaz de subida basándose en la lista de tipos MIME permitidos
configurada a través de `FILES_MIME_TYPE_ALLOW_LIST`, aplicándola como
atributo `accept` en el control de subida del navegador. Si la lista no está
definida o es `*/*`, permitirá cualquier tipo de archivo.
Rationale: La restricción solo se aplicaba en el servidor, por lo que el
usuario recibía el error tras enviar el archivo, no antes de seleccionarlo.
Módulo: Files / Upload Interface
Fuente: PR #26646
```

**MRS derivado:**
```
Como usuario del módulo de archivos,
quiero que el sistema restrinja los tipos de archivo seleccionables en la
interfaz de subida según la lista configurada en `FILES_MIME_TYPE_ALLOW_LIST`,
para evitar que el usuario seleccione archivos que el servidor rechazará,
recibiendo el error solo después de enviar el archivo.

Restricción: Si la lista no está definida o es `*/*`, el selector no aplica
ninguna restricción.
Fuente: PR #26646
```

**Verificación de suficiencia:**
- Tipo inferible: ✅ Funcional (comportamiento observable del sistema en UI)
- Descripción formal inferible: ✅ "El sistema deberá restringir... `accept`..."
- Verificación inferible: ✅ Probar con lista restrictiva vs. sin lista
- Rationale inferible: ✅ Explícito en la motivación

---

### Ejemplo B — Requisito de calidad sin artefacto técnico nombrado

**REQ de entrada (fragmento):**
```
Tipo: Calidad
Descripción formal: El sistema deberá responder a las peticiones de
autenticación en menos de 200 ms bajo carga nominal.
Rationale: Los tiempos de respuesta superiores a 500 ms degradan la
percepción de fluidez en flujos de login.
Módulo: Auth / Performance
Fuente: Issue #1042
```

**MRS derivado:**
```
Como usuario del sistema de autenticación,
quiero que el proceso de login complete en menos de 200 ms bajo carga nominal,
para que el flujo de autenticación no sea percibido como lento por el usuario.

Fuente: Issue #1042
```

**Notas de derivación:** No hay artefacto técnico nombrable en la descripción;
se omite la cláusula de contexto. El umbral cuantitativo (200 ms) se conserva
porque es la condición verificable que garantiza R9.

---

### Ejemplo C — Requisito con Rationale ausente (inferido)

**REQ de entrada (fragmento):**
```
Tipo: Funcional
Descripción formal: El sistema deberá impedir la vinculación de cuentas OAuth
para usuarios cuya dirección de correo electrónico no haya sido verificada.
Rationale: [vacío]
Módulo: Auth / OAuth
Fuente: PR #26598
```

**MRS derivado:**
```
Como administrador de Auth,
quiero que el sistema bloquee la vinculación de cuentas OAuth cuando el
correo electrónico del usuario no ha sido verificado,
para evitar la asociación de identidades externas a cuentas cuya propiedad
no ha sido validada. [inferido]

Fuente: PR #26598
```

**Notas de derivación:** Rationale inferido por negación del comportamiento
requerido. Marcado como `[inferido]` conforme al §2.

---

## 6. Consideraciones sobre replicabilidad

Un MRS es replicable cuando:

1. **El ROL es específico**: "administrador de Auth" es replicable;
   "usuario" no lo es sin contexto adicional.
2. **El artefacto técnico está nombrado**: dos agentes leerán `FILES_MIME_TYPE_ALLOW_LIST`
   y derivarán el mismo requisito; sin ese nombre, podrían divergir.
3. **La motivación describe el estado actual indeseable**: "para evitar que X"
   es más replicable que "para mejorar la experiencia", porque el primero
   es verificable y el segundo es subjetivo.
4. **Las restricciones condicionales están explícitas**: las condiciones del
   tipo "si X no está definido" son parte de la lógica del requisito y deben
   aparecer en el MRS, no dejarse para inferencia del agente.

Estas condiciones garantizan que el MRS cumpla la propiedad de replicabilidad
definida en el §1 y sean coherentes con el criterio de no ambigüedad de
IEEE 29148 (R8 de la rúbrica).

---

## 7. Uso en el pipeline SpecKit

Una vez generado `mrs-prompts.md`, cada bloque MRS puede usarse directamente
como valor del parámetro `--input spec=` en `run-ireb.sh`:

```bash
./run-ireb.sh ../repos/directus \
  "Como usuario del módulo de archivos, quiero que el sistema restrinja..." \
  full \
  opencode
```

El workflow IREB tomará el MRS como semilla y derivará, en orden:

```
MRS
 └─► REQ formal (plantilla.md + constitution)
      └─► Plan de implementación
           └─► Código + tests
                └─► Snapshot
```

La trazabilidad queda garantizada porque el `mrs-prompts.md` vincula cada
MRS con su `REQ-*.md` de origen a través del ID.