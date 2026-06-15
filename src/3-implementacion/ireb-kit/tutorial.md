# Tutorial: Flujo IREB con SpecKit

> Guía práctica para el usuario final. Cada paso incluye el comando exacto,
> lo que produce SpecKit, el principio IREB que satisface y la referencia
> bibliográfica que lo respalda.

---

## Índice

1. [Preparación: antes de abrir SpecKit](#1-preparación-antes-de-abrir-speckit)
2. [Elicitación: identificar lo que necesitas](#2-elicitación-identificar-lo-que-necesitas)
3. [Documentación: formalizar el requisito](#3-documentación-formalizar-el-requisito)
4. [Validación: comprobar la calidad antes de implementar](#4-validación-comprobar-la-calidad-antes-de-implementar)
5. [Configurar SpecKit con el constitution IREB](#5-configurar-speckit-con-el-constitution-ireb)
6. [Ejecutar el pipeline SpecKit](#6-ejecutar-el-pipeline-speckit)
7. [Verificar el resultado](#7-verificar-el-resultado)
8. [Ejemplo completo: de changelog a PR](#8-ejemplo-completo-de-changelog-a-pr)

---

## 1. Preparación: antes de abrir SpecKit

Antes de ejecutar ningún comando, necesitas dos cosas que IREB exige
y que SpecKit por defecto no proporciona: **fuentes documentadas** y
**contexto del sistema**.

### 1.1 Identificar la fuente del requisito

IREB define que todo requisito debe tener una fuente trazable. Sin
fuente, no hay requisito.

> *Referencia*: IREB define Source como atributo fundamental: "The source
> from which a requirement has been derived" [1, Glossary]. ISO 29148
> §6.3.1 contempla fuentes documentales como origen válido siempre que
> sean identificables y trazables [2].

**Qué documentar**:
- Si el requisito viene de un changelog: versión, URL de release, entrada literal
- Si viene de un stakeholder: nombre, rol, fecha de la entrevista
- Si viene de un issue: URL del issue, autor, fecha
- Si viene de una PR: URL de la PR, commit SHA

**Ejemplo**:

```text
Fuente: Cal.com Release v6.0.10
(https://github.com/calcom/cal.com/releases/tag/v6.0.10)
PR #26598
Entrada literal: "fix(auth): block OAuth linking for unverified accounts"
```

### 1.2 Identificar stakeholders

Aunque trabajes con changelogs en lugar de entrevistas, IREB exige
identificar quién se ve afectado por el requisito. En proyectos
Open Source, los stakeholders suelen ser:

- **Usuarios finales**: los que usarán la funcionalidad
- **Mantenedores**: los que revisan y mergean el código
- **Desarrolladores**: los que implementan el cambio
- **Administradores del sistema**: los que despliegan y operan

> *Referencia*: IREB define stakeholder como "a person or organization who
> influences a system's requirements or who is impacted by that system"
> [1, Glossary]. IREB Principle 2 (Stakeholder Involvement) establece que
> RE busca satisfacer deseos y necesidades de las partes interesadas [1,
> pp. 16-18].

**Ejemplo**:

| Stakeholder | Afectación |
|---|---|
| Usuario de Cal.com | Quiere vincular su cuenta Google sin riesgos de suplantación |
| Administrador de Cal.com | Quiere reducir cuentas fraudulentas |
| Mantenedor del módulo auth | Responsable de que OAuth funcione correctamente |

### 1.3 Definir el contexto del sistema

IREB exige entender el sistema en su contexto: ¿qué actores externos
interactúan con él? ¿Qué interfaces tiene? ¿Qué restricciones operan?

> *Referencia*: IREB Principle 4 (System Context) establece que "el
> sistema no se entiende aislado de su entorno" [1, pp. 16-18].
> IREB define contexto como "the part of a system's environment being
> relevant for understanding the system and its requirements" [1,
> Glossary].

**Ejemplo**:

```text
Sistema: Cal.com — módulo de autenticación OAuth

Actores externos:
  - Usuario (navegador web)
  - Google OAuth API (proveedor de identidad externo)
  - Base de datos de usuarios de Cal.com

Interfaces:
  - POST /api/auth/oauth/link → vincula cuenta OAuth
  - Google OAuth redirect → recibe callback de Google

Restricciones:
  - El proveedor OAuth debe estar configurado en Cal.com
  - El usuario debe tener una sesión activa en Cal.com
```

---

## 2. Elicitación: identificar lo que necesitas

Esta fase responde a la pregunta: **¿qué necesita el sistema hacer?**

No redactas requisitos todavía. Recoges información de las fuentes.

### 2.1 Extraer información de la fuente

Si trabajas con changelogs (como en este tutorial), para cada entrada:

1. Anota el texto literal del changelog (sin parafrasear)
2. Identifica el verbo principal: ¿qué acción describe?
3. Identifica condiciones: ¿bajo qué circunstancias?
4. Identifica actores: ¿quién hace o recibe la acción?
5. Identifica el resultado esperado

> *Referencia*: IREB define elicitación como "the process of seeking,
> capturing and consolidating requirements from available sources,
> potentially including the re-construction or creation of requirements"
> [1, Glossary].

**Ejemplo con el changelog de Cal.com**:

```text
Texto literal: "fix(auth): block OAuth linking for unverified accounts"

Análisis:
  Verbo principal: BLOCK (bloquear/impedir)
  Objeto: vinculación de cuentas OAuth
  Condición: el email del usuario no está verificado
  Actor implícito: cualquier usuario con cuenta en Cal.com
  Resultado esperado: la operación de vinculación es rechazada
```

### 2.2 Identificar casos de uso

Un caso de uso describe una interacción entre actores y el sistema
que produce un resultado valioso.

> *Referencia*: IREB define use case como "a set of possible interactions
> between external actors and a system that provide a benefit for the
> actor(s) involved" [1, Glossary].

**Plantilla de caso de uso**:

```text
Nombre: [verbo + objeto]
Actor principal: [quién inicia la interacción]
Precondición: [qué debe ser cierto antes]
Flujo principal:
  1. [El actor hace X]
  2. [El sistema hace Y]
  3. [El sistema produce Z]
Postcondición: [qué debe ser cierto después]
Flujo alternativo: [qué pasa si falla algo]
```

**Ejemplo para Cal.com**:

```text
Nombre: Vincular cuenta OAuth

Actor principal: Usuario autenticado en Cal.com

Precondición:
  - El usuario tiene una sesión activa en Cal.com
  - El proveedor OAuth (Google) está configurado en la instancia

Flujo principal:
  1. El usuario solicita vincular su cuenta Google desde Ajustes
  2. El sistema redirige a Google OAuth para autenticación
  3. Google devuelve un token de autorización
  4. El sistema verifica que el email del usuario de Cal.com
     está verificado
  5. Si el email está verificado, el sistema vincula la cuenta
     Google al perfil del usuario
  6. El sistema muestra confirmación al usuario

Flujo alternativo (email no verificado):
  4a. El email del usuario NO está verificado
  4b. El sistema rechaza la vinculación
  4c. El sistema muestra mensaje: "Verifica tu email antes
      de vincular cuentas externas"

Flujo alternativo (cuenta ya vinculada):
  4a. La cuenta Google ya está vinculada a otro usuario
  4b. El sistema rechaza la vinculación
  4c. El sistema muestra mensaje: "Esta cuenta ya está vinculada"

Postcondición:
  - Éxito: la cuenta Google queda vinculada al perfil del usuario
  - Fallo: la vinculación es rechazada (email no verificado o
    cuenta duplicada)
```

---

## 3. Documentación: formalizar el requisito

Aquí conviertes la información elicitada en un requisito formal
usando la plantilla IREB de 12 atributos.

> *Referencia*: IREB define documentación como la especificación
> estructurada de requisitos con atributos y criterios de calidad [1,
> §Requirements Documentation]. La plantilla se basa en ISO 29148
> §6.3 (Requirements Attributes) [2] e INCOSE §Characteristics [3].

### 3.1 La plantilla IREB (12 atributos)

```text
ID:
REQ-[PROYECTO]-[NÚMERO]

Nombre:

Tipo:
[Funcional | Calidad | Restricción]

Descripción formal:
El sistema deberá [verbo observable] [objeto] [condición]

Fuente:

Rationale:

Prioridad:
[Alta | Media | Baja]

Verificación:

Estado:
[Borrador | Elaborado | Validado | Implementado | Archivado]

Versión:

Dependencias:

Módulo:
```

### 3.2 Reglas de redacción (INCOSE)

Cada regla está respaldada por la bibliografía:

| # | Regla | Referencia |
|---|---|---|
| 1 | El requisito expresa UNA única obligación | INCOSE §Singular [3] |
| 2 | Empieza por "El sistema deberá..." | INCOSE §Structure [3] |
| 3 | El verbo es observable: generar, registrar, rechazar, devolver, impedir, notificar, calcular, validar, bloquear | INCOSE §Characteristics [3] |
| 4 | Sin términos subjetivos: rápido, eficiente, intuitivo, adecuado, robusto | ISO 29148 §6.2.2 [2] |
| 5 | Con condiciones cuantificables: "en menos de 200ms", "para el 95% de las peticiones" | ISO 29148 §6.2.2 [2] |
| 6 | El requisito se entiende por sí solo, sin consultar otros | INCOSE §Complete [3] |
| 7 | Sin detalles de implementación (salvo restricciones explícitas) | INCOSE §Implementation-free [3] |

### 3.3 Ejemplo de requisito formalizado

```text
ID:
REQ-CALCOM-26598

Nombre:
Bloqueo de vinculación OAuth para emails no verificados

Tipo:
Funcional

Descripción formal:
El sistema deberá impedir la vinculación de cuentas OAuth para
usuarios cuya dirección de correo electrónico no haya sido
verificada.

Fuente:
Cal.com Release v6.0.10
(https://github.com/calcom/cal.com/releases/tag/v6.0.10)
PR #26598 (https://github.com/calcom/cal.com/pull/26598)
Entrada: "fix(auth): block OAuth linking for unverified accounts"

Rationale:
Evitar la suplantación de identidad mediante vinculación de cuentas
externas a perfiles cuya propiedad no ha sido validada. Sin esta
verificación, un atacante podría vincular su cuenta OAuth a un
perfil ajeno.

Prioridad:
Alta

Verificación:
1. Crear una cuenta en Cal.com con email NO verificado.
2. Iniciar sesión y navegar a Ajustes → Cuentas conectadas.
3. Intentar vincular una cuenta Google mediante OAuth.
4. Comprobar que la API devuelve un error (HTTP 403 o similar).
5. Comprobar que el mensaje de error indica "Email no verificado".

Estado:
Validado

Versión:
1.0

Dependencias:
(ninguna)

Módulo:
Auth / OAuth
```

### 3.4 Clasificación por tipo de requisito

IREB distingue tres tipos. Cada uno requiere un tratamiento distinto
en la verificación:

**Funcional** (el más común en changelogs):

```text
Tipo: Funcional
Descripción: El sistema deberá [acción observable]
Verificación: [comportamiento del sistema]
```

**Calidad** (rendimiento, seguridad, usabilidad):

```text
Tipo: Calidad
Descripción: El sistema deberá responder en menos de 200ms
             para el 95% de las peticiones de autenticación.
Verificación: Ejecutar 1000 peticiones y medir el percentil 95.
```

**Restricción** (tecnológica, regulatoria, de negocio):

```text
Tipo: Restricción
Descripción: El sistema deberá limitar el número máximo de
             nodos por workflow a 10 para cuentas gratuitas.
Verificación: Crear un workflow con 11 nodos desde cuenta
              gratuita y comprobar que es rechazado.
```

> *Referencia*: IREB distingue funcional, calidad y restricción [1,
> §Requirements Types]. ISO 29148 §5.2.1 establece diferentes categorías
> de requisitos [2].

---

## 4. Validación: comprobar la calidad antes de implementar

Antes de dar el requisito a SpecKit, debes validar que está bien
escrito. La rúbrica IREB tiene 12 criterios con 3 bloqueantes.

### 4.1 Rúbrica rápida (3 criterios bloqueantes)

Estos tres criterios son **condición necesaria**. Si falla cualquiera,
el requisito no puede pasar a SpecKit:

| # | Criterio | ¿Cómo comprobarlo? | Referencia |
|---|---|---|---|
| R5 | ¿Empieza por "El sistema deberá"? | Lectura directa | INCOSE §Structure [3] |
| R7 | ¿El verbo es observable? | ¿Puedo ver el resultado? (rechazar, devolver, impedir, notificar) vs. ¿es vago? (gestionar, manejar, facilitar) | INCOSE §Characteristics [3] |
| R9 | ¿Tiene criterio de verificación? | ¿Describe un comportamiento observable? No vale "se comprobará en QA" | ISO 29148 §6.2.2 [2] |

> *Referencia*: ISO 29148 §6.2.2 [2] e INCOSE [3]. Los criterios
> bloqueantes siguen la práctica de quality gates en ingeniería del
> software: ciertas propiedades son condición necesaria y no
> compensable por otras dimensiones de calidad.

### 4.2 Rúbrica completa (12 criterios)

Si los 3 bloqueantes pasan, evalúa los 12 criterios. Máximo 12 puntos:

- **Aceptado**: 11-12 → listo para SpecKit
- **Revisión menor**: 9-10 → listo si no afecta a R5, R7, R8, R9
- **Rechazado**: ≤ 8 → volver a redactar

La rúbrica completa está en [`checklist-ireb.md`](checklist-ireb.md).

### 4.3 Ciclo de estados del requisito

Cada requisito pasa por un workflow de estados:

```
Borrador → Elaborado → Validado → Implementado → Archivado
   ↑          ↑          ↑
   │          │          └── Supera la rúbrica (12 criterios)
   │          └── Revisado por el autor, atributos completos
   └── Derivado de la fuente, puede tener campos incompletos
```

> *Referencia*: IREB define el ciclo de vida del requisito con estados y
> transiciones explícitas [1, pp. 130-140].

---

## 5. Configurar SpecKit con el constitution IREB

Ahora que el requisito está formalizado y validado, abres SpecKit.

### 5.1 Inicializar el proyecto

```bash
cd tu-repositorio
specify init mi-proyecto --integration copilot
code .
```

Esto crea la estructura `.specify/` con las plantillas por defecto.

### 5.2 Cargar el constitution IREB

En Copilot Chat Agent, ejecuta:

```
/speckit.constitution [pega el contenido de constitution.md]
```

El constitution IREB reemplaza los 9 artículos por defecto (Library-First,
CLI Mandate, TDD) por principios de ingeniería de requisitos. Los
artículos clave que afectan a la generación son:

| Artículo IREB | Efecto en SpecKit |
|---|---|
| I. Verificabilidad | SpecKit exigirá criterios de verificación en cada tarea |
| II. Minimalidad | No generará features no solicitadas |
| III. Trazabilidad | Mantendrá la cadena requisito→plan→task→código |
| V. No ambigüedad | Rechazará términos subjetivos en la spec |

> *Referencia*: IREB Principles 1, 9 [1, pp. 16-18]; ISO 29148
> §6.2.2 [2]; INCOSE [3].

---

## 6. Ejecutar el pipeline SpecKit

### 6.1 Flujo recomendado (9 comandos)

Ejecuta estos comandos en orden dentro de Copilot Chat Agent:

```
1. /speckit.constitution
   [pega constitution.md]
   ↓ produce: memory/constitution.md

2. /speckit.specify
   [pega el REQ-*.md formalizado con la plantilla IREB]
   ↓ produce: specs/001-feature/spec.md

3. /speckit.clarify
   [SpecKit identifica ambigüedades y pide aclaraciones]
   ↓ produce: spec.md actualizado con [NEEDS CLARIFICATION] resueltos

4. /speckit.checklist
   [SpecKit genera checklist de calidad basado en ISO 29148]
   ↓ produce: checklist de calidad en el chat

5. /speckit.plan
   [SpecKit traduce la spec a arquitectura técnica]
   ↓ produce: plan.md, research.md, data-model.md, contracts/, quickstart.md

6. /speckit.tasks
   [SpecKit descompone el plan en tareas]
   ↓ produce: tasks.md con dependencias

7. /speckit.analyze
   [SpecKit verifica spec ↔ plan ↔ tasks consistencia]
   ↓ produce: informe de consistencia en el chat

8. /speckit.implement
   [SpecKit ejecuta las tareas y genera código]
   ↓ produce: PR con implementación + tests

9. /speckit.analyze
   [Verificación post-implementación]
   ↓ produce: informe de trazabilidad final
```

### 6.2 ¿Por qué este orden?

El orden sigue el principio IREB de calidad continua (Article IX del
constitution). Cada paso verifica antes de avanzar:

```
CONSTITUTION  → define las reglas
    ↓
SPECIFY       → formaliza el requisito
    ↓
CLARIFY       → detecta ambigüedades ANTES de planificar
    ↓
CHECKLIST     → valida calidad ANTES de implementar
    ↓
PLAN          → diseña la solución
    ↓
TASKS         → descompone en trabajo
    ↓
ANALYZE (pre) → verifica consistencia ANTES de implementar
    ↓
IMPLEMENT     → genera el código
    ↓
ANALYZE (post)→ verifica trazabilidad DESPUÉS de implementar
```

> *Referencia*: IREB Principle 9 (Systematic Work) requiere calidad
> continua, no solo al final [1, pp. 16-18]. Fagan (1976) demostró que
> la inspección temprana reduce el coste de los defectos [4].

### 6.3 Qué hace cada comando exactamente

**`/speckit.constitution`** — NO genera código. Define los 9 artículos
que SpecKit aplicará en todos los pasos siguientes. Si omites este paso,
SpecKit usará principios genéricos (Library-First, TDD, CLI Mandate).

**`/speckit.specify`** — NO genera código. Crea `spec.md` a partir de tu
entrada. Si tu entrada es un REQ-*.md formalizado, la spec resultante
tendrá estructura IREB. Si tu entrada es texto crudo, la spec será una
user story genérica.

**`/speckit.clarify`** — NO genera código. Lee la spec e identifica
áreas donde falta información. Te pregunta y actualiza la spec con tus
respuestas. Esencial para detectar ambigüedades antes de que se
propaguen al plan y la implementación.

**`/speckit.checklist`** — NO genera código. Produce una lista de
verificación de calidad. Puedes comparar el resultado con tu rúbrica
manual para ver si SpecKit detecta los mismos problemas que tú.

**`/speckit.plan`** — NO genera código. Traduce requisitos a decisiones
técnicas. Las Constitutional Gates del plan-template-ireb verifican
Verificabilidad, Anti-Ambiguity, Trazabilidad y Clasificación antes de
avanzar a la fase de diseño.

**`/speckit.tasks`** — NO genera código. Crea una lista de tareas
organizadas por requisito. Cada tarea debe ser trazable a un REQ-ID.

**`/speckit.analyze (pre)`** — NO genera código. Verifica que la spec,
el plan y las tareas son consistentes: ¿todos los requisitos tienen
tareas? ¿todas las tareas referencian un requisito? ¿hay tareas
huérfanas?

**`/speckit.implement`** — SÍ genera código. Ejecuta las tareas en orden
test-first: contracts → contract tests → integration tests → unit tests →
source files. Produce una PR completa.

**`/speckit.analyze (post)`** — NO genera código. Verifica que la
trazabilidad se mantiene después de la implementación. Detecta código
huérfano, tests sin requisito asociado, y requisitos sin cobertura.

---

## 7. Verificar el resultado

### 7.1 Métricas objetivas (automáticas)

Después de `/speckit.implement`, ejecuta:

```bash
# M1: ¿Generó PR?
ls -la specs/001-feature/
test -f "resultado/diff.patch" && echo "M1: OK" || echo "M1: FAIL"

# M2: ¿Compila?
npm run build && echo "M2: OK" || echo "M2: FAIL"

# M3: ¿Tests pasan?
npm test && echo "M3: OK" || echo "M3: FAIL"
```

### 7.2 Conformidad funcional (manual, ~3 min)

Aplica la rúbrica SRCI (C1-C6) al diff generado:

| # | Criterio | Pregunta clave |
|---|---|---|
| C1 | ¿Cubre la intención principal? | ¿El código hace lo que pedía el requisito? |
| C2 | ¿Respeta las condiciones? | ¿La implementación verifica el estado/permiso/condición? |
| C3 | ¿Resultado observable? | ¿Puedo ver que funciona (API response, test, log)? |
| C4 | ¿Tests alineados? | ¿Los tests verifican el requisito, no otra cosa? |
| C5 | ¿Sin desviaciones? | ¿Hay código que hace algo no pedido? |
| C6 | ¿Trazabilidad completa? | ¿Puedo seguir REQ→spec→plan→task→test→code? |

> *Referencia*: C1-C3 basados en ISO 29148 [2]; C4 basado en Fagan
> inspections [4]; C5 basado en consistencia RE; C6 basado en IREB
> traceability definition [1, Glossary].

---

## 8. Ejemplo completo: de changelog a PR

### 8.1 El changelog de entrada

```text
Fuente: n8n Release v1.80.0
(https://github.com/n8n-io/n8n/releases/tag/n8n@1.80.0)
PR #31371
Entrada: "feat: add node limit for free tier workflows"
```

### 8.2 Elicitación

```text
Análisis de la entrada:
  Verbo: ADD LIMIT (añadir límite)
  Objeto: número de nodos en workflows
  Condición: cuentas del plan gratuito (free tier)
  Actor: cualquier usuario con cuenta gratuita
  Resultado: el workflow no puede exceder N nodos

Stakeholders:
  - Usuario free tier: quiere automatizar tareas, pero con límites
  - n8n operations: quiere controlar consumo de recursos
  - Product manager: definió el límite de 10 nodos

Contexto:
  Sistema: n8n — motor de ejecución de workflows
  Actores: Usuario (web UI), API de n8n, base de datos de workflows
  Restricción: solo aplica a cuentas con plan "free"
```

### 8.3 Caso de uso

```text
Nombre: Crear workflow con límite de nodos (free tier)

Actor principal: Usuario con cuenta gratuita

Precondición:
  - El usuario tiene plan "free" activo
  - El usuario está autenticado en n8n

Flujo principal:
  1. El usuario crea un nuevo workflow en el editor
  2. El usuario añade nodos (máximo 10)
  3. Para cada nodo añadido, el sistema verifica que el total ≤ 10
  4. El usuario guarda y activa el workflow

Flujo alternativo (límite excedido):
  2a. El usuario intenta añadir el nodo número 11
  2b. El sistema rechaza la operación
  2c. El sistema muestra: "Free tier limit: 10 nodes per workflow"
  2d. El nodo NO se añade al workflow

Postcondición:
  - Éxito: workflow creado con ≤ 10 nodos
  - Fallo: la operación es rechazada al exceder el límite
```

### 8.4 Requisito formalizado

```text
ID:
REQ-N8N-31371

Nombre:
Límite de nodos en workflows gratuitos

Tipo:
Restricción

Descripción formal:
El sistema deberá limitar el número máximo de nodos por workflow
a 10 para cuentas del plan gratuito.

Fuente:
n8n Release v1.80.0, PR #31371

Rationale:
Control de consumo de recursos en el plan gratuito para garantizar
la estabilidad del servicio para todos los usuarios. Sin este límite,
un solo usuario gratuito podría consumir recursos desproporcionados.

Prioridad:
Alta

Verificación:
1. Crear una cuenta gratuita en n8n.
2. Crear un workflow y añadir 10 nodos. Verificar que se permite.
3. Intentar añadir el nodo número 11.
4. Verificar que el sistema rechaza la operación.
5. Verificar que se muestra el mensaje "Free tier limit:
   10 nodes per workflow".
6. Verificar que el nodo 11 NO aparece en el editor.

Estado:
Validado

Versión:
1.0

Dependencias:
(ninguna)

Módulo:
Workflows / Plans & Limits
```

### 8.5 Configurar SpecKit

```bash
cd n8n-repo
specify init n8n-e1 --integration copilot
code .
```

En Copilot Chat Agent:

```
/speckit.constitution
Este proyecto sigue principios IREB:
1. Verificabilidad obligatoria (Art I): todo req debe tener criterio
   de verificación observable (ISO 29148 §6.2.2).
2. Minimalidad funcional (Art II): implementar solo lo especificado.
3. Trazabilidad completa (Art III): req→intent→impl→evidence.
4. Clasificación por tipo (Art IV): Funcional, Calidad, Restricción.
5. No ambigüedad (Art V): sin términos subjetivos.
6. Obligación única (Art VI): un comportamiento por requisito.
7. Documentación de fuente (Art VII): origen trazable.
8. Rationale obligatorio (Art VIII): justificación del requisito.
9. Calidad continua (Art IX): validación en cada fase, no solo al final.
```

### 8.6 Ejecutar el pipeline

```
/speckit.specify
[pega el REQ-N8N-31371.md completo]

/speckit.clarify

/speckit.checklist

/speckit.plan

/speckit.tasks

/speckit.analyze

/speckit.implement

/speckit.analyze
```

### 8.7 Verificar

```bash
# M1: ¿PR generada?
ls specs/001-workflow-node-limit/

# M2: ¿Compila?
npm run build

# M3: ¿Tests pasan?
npm test

# M4: SRCI C1-C6 (~3 min de inspección manual)
```

---

## Referencias

[1] Glinz, M., van Loenhoud, H., Staal, S., Bühne, S. (2024).
    *CPRE Foundation Level Handbook*, v1.2.0. IREB.

[2] ISO/IEC/IEEE 29148:2018. *Systems and Software Engineering —
    Life Cycle Processes — Requirements Engineering*.

[3] INCOSE (2012). *Guide for Writing Requirements*.
    International Council on Systems Engineering.

[4] Fagan, M.E. (1976). "Design and Code Inspections to Reduce
    Errors in Program Development". *IBM Systems Journal*, 15(3).
