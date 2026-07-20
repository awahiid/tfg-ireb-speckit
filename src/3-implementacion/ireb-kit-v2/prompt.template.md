# Prompt Template for IREB Requirement Generation

> Use this template to generate IREB-compliant requirements.
> Fill in the `[PLACEHOLDERS]` or feed this entire template to an LLM
> with your source text. Every field is mandatory unless marked optional.

---

## How to use this template

**Option A — Manual**: Read the source text, answer each prompt question,
and assemble the final REQ-*.md.

**Option B — LLM-assisted**: Paste this entire template into an LLM
along with your source text. The LLM will generate the requirement.

---

## Prompt (copy from here)

```
You are a Requirements Engineer certified in IREB CPRE Foundation Level.
Your task is to generate a complete, formal requirement from a source text.

Follow these rules exactly. All rules are based on standards:
- IREB CPRE Foundation Level Handbook (Glinz et al., 2024)
- ISO/IEC/IEEE 29148:2018 §6.2.2
- INCOSE Guide for Writing Requirements (2012)

---

## SOURCE TEXT

[PASTE YOUR SOURCE TEXT HERE — changelog entry, issue, PR description,
stakeholder note, regulation text, etc.]

---

## INSTRUCTIONS

Generate a requirement with the following 12 attributes. For each
attribute, follow the rules AND the example pattern shown.

### 1. ID

**Rule**: Format REQ-[PROJECT]-[NUMBER]. Use the project short name
(appwrite, authentik, calcom, directus, medusa, n8n, or specify).
Number from the source (PR number, issue number). Never reuse IDs.

**Reference**: IREB defines unique identification as a basic
attribute for traceability [Glinz 2024, §Requirements Documentation].
ISO 29148 requires unambiguous identification of every requirement [2].

**Example**: `REQ-CALCOM-26598`

**Generate**:
REQ-______________-______________

---

### 2. Name

**Rule**: 2-8 words. Describe the main capability or need. Start with
a noun or gerund. Avoid implementation details (no technologies,
no file names, no class names). Use title case for the first word only.

**Reference**: IREB includes Name as a descriptive attribute for
navigation, review, and communication [Glinz 2024, §Name].

**Example**: `Bloqueo de vinculación OAuth para emails no verificados`

**Generate**:
______________

---

### 3. Type

**Rule**: Choose EXACTLY ONE from: Functional | Quality | Constraint.

- **Functional**: describes a behavior or result the system must provide
  (what the system DOES). Use when the source describes an action.
- **Quality**: describes how well the system performs (performance,
  security, usability, reliability). Use when the source contains
  metrics (time, throughput, accuracy, availability).
- **Constraint**: limits the solution space (technology, regulation,
  business rule, organizational policy). Use when the source
  restricts what can be done, not what must be done.

**Reference**: IREB distinguishes functional requirements, quality
requirements, and constraints [Glinz 2024, §Requirements Types].
ISO 29148 §5.2.1 establishes different categories [2].

**Decision tree**:
- Does it describe an ACTION the system takes? → Functional
- Does it describe HOW WELL the system must perform? → Quality
- Does it describe a LIMIT on what can be done? → Constraint

**Generate**:
______________

---

### 4. Formal Description

**Rule**: Follow the structure: "El sistema deberá [VERB] [OBJECT]
[CONDITION]". This is the MOST IMPORTANT field. It must follow 8 sub-rules:

**Sub-rule 4a — Start exactly with "El sistema deberá"** (INCOSE §Structure [3]).

**Sub-rule 4b — Use an OBSERVABLE verb.** The verb must describe something
you can see or measure. ALLOWED: generar, registrar, rechazar, devolver,
prevenir, impedir, notificar, calcular, validar, bloquear, almacenar,
enviar, limitar, verificar, mostrar, ocultar, permitir, denegar,
actualizar, eliminar, crear, restaurar, exportar, importar, convertir.
FORBIDDEN: gestionar, manejar, procesar, soportar, facilitar, mejorar,
proveer, permitir que, asegurar que, posibilitar, optimizar.

If you are tempted to use a forbidden verb, ask: "What exactly does
the system DO? What can I observe after it does it?" Then rewrite.

**Sub-rule 4c — One behavior per requirement.** Do not use "and" to
chain two independent actions. If the source describes multiple
actions, generate multiple separate requirements.

**Sub-rule 4d — Avoid subjective terms.** FORBIDDEN: rápido, eficiente,
intuitivo, adecuado, apropiado, suficiente, amigable, robusto, fiable,
escalable, mantenible, seguro (unless quantified).
If you need to express quality, use numbers: "en menos de 200ms",
"con una precisión del 99.9%", "para el 95% de las peticiones".

**Sub-rule 4e — Include a CONDITION clause when the behavior depends
on context.** Use "cuando", "si", "para [actor]", "a menos que",
"siempre que". The condition must be observable, not a vague situation.

**Sub-rule 4f — Be self-sufficient.** A reader who knows the domain
but has NOT read the source should understand the requirement
completely. Do not reference "el paso anterior" or "el proceso descrito".

**Sub-rule 4g — No implementation details.** Do not mention technologies,
file names, class names, database tables, API endpoints, or algorithms
UNLESS the source specifically constrains these (Constraint type).

**Sub-rule 4h — Singular and complete.** The description must contain
enough information to verify the requirement without consulting other
sources. It must state the action, the object, and the condition (if any).

**Reference**: ISO 29148 §6.2.2 [2]; INCOSE §Singular, §Structure,
§Unambiguous, §Verifiable, §Complete [3].

**Examples**:

✅ CORRECT:
"El sistema deberá impedir la vinculación de cuentas OAuth para
usuarios cuya dirección de correo electrónico no haya sido verificada."

✅ CORRECT:
"El sistema deberá limitar el número máximo de nodos por workflow a
10 para cuentas del plan gratuito."

✅ CORRECT:
"El sistema deberá notificar a todos los participantes de una reunión
cuando el organizador modifique la hora programada."

❌ WRONG (forbidden verb):
"El sistema deberá gestionar las cuentas OAuth de los usuarios."

❌ WRONG (multiple obligations):
"El sistema deberá generar un token y enviarlo por correo electrónico."

❌ WRONG (subjective term):
"El sistema deberá responder rápidamente a las peticiones de autenticación."

**Generate**:
El sistema deberá _______________________________________________
_______________________________________________
_______________________________________________

---

### 5. Source

**Rule**: Document the origin with enough detail to locate it. Minimum:
document type, version/date, and an identifier (URL, PR number, issue
number). If the source is a stakeholder, include name, role, and date
of communication.

**Reference**: IREB defines Source as the origin from which a
requirement has been derived [Glinz 2024, Glossary]. ISO 29148 §6.3.1
contemplates documentary sources as valid origins [2].

**Example**:
```
Cal.com Release v6.0.10
(https://github.com/calcom/cal.com/releases/tag/v6.0.10)
PR #26598 (https://github.com/calcom/cal.com/pull/26598)
Entrada literal: "fix(auth): block OAuth linking for unverified accounts"
```

**Generate**:
______________
______________
______________

---

### 6. Rationale

**Rule**: Answer WHY this requirement exists. What problem does it solve?
What benefit does it provide? What risk does it mitigate? If the source
does not state the rationale explicitly, INFER it from context. Mark
inferred rationales with "[Inferred]".

**Reference**: IREB defines Rationale as the justification of the
requirement [Glinz 2024, §Rationale]. INCOSE considers rationale key
for understanding the underlying need [3].

**Example (explicit)**:
"Evitar la suplantación de identidad mediante vinculación de cuentas
externas a perfiles cuya propiedad no ha sido validada."

**Example (inferred)**:
"[Inferred] Control de consumo de recursos en el plan gratuito para
garantizar la estabilidad del servicio para todos los usuarios."

**Generate**:
______________
______________

---

### 7. Priority

**Rule**: Choose EXACTLY ONE from: Alta | Media | Baja.

- **Alta**: The requirement blocks core functionality, affects security,
  or prevents user workflows. Without it, the system is broken or unsafe.
- **Media**: The requirement improves functionality or fixes a non-critical
  issue. The system works without it, but with reduced quality.
- **Baja**: The requirement is cosmetic, a nice-to-have, or an edge case
  that affects very few users.

**Reference**: IREB includes priority as an attribute for negotiation
and scope management [Glinz 2024, §Stakeholder Priority].

**Decision tree**:
- Does it fix a security issue or prevent data loss? → Alta
- Does it fix a bug that affects many users? → Alta
- Does it add a new feature requested by users? → Media
- Does it improve UI/UX without changing functionality? → Baja
- Is it a minor edge case fix? → Baja

**Generate**:
______________

---

### 8. Verification

**Rule**: Describe HOW to confirm that the requirement is fulfilled.
This is the second most important field after the formal description.
The verification must be:

- **Observable**: describes a test, inspection, or demonstration
  that produces a visible result.
- **Specific**: mentions expected outputs, error codes, state
  changes, or log entries.
- **Repeatable**: another person should be able to execute the
  verification and get the same result.
- **Independent**: does not require knowledge of the implementation
  details (only the requirement itself).

**Reference**: ISO 29148 §6.2.2 requires requirements to be
verifiable [2]. INCOSE states that verification can be performed
through testing, analysis, inspection, or demonstration [3].

**Structure**: Numbered steps. Each step is an action. Include the
expected result in the final step.

**Example**:
```
1. Crear una cuenta con email NO verificado en Cal.com.
2. Iniciar sesión y navegar a Ajustes → Cuentas conectadas.
3. Intentar vincular una cuenta Google mediante OAuth.
4. Comprobar que la operación es rechazada.
5. Comprobar que la respuesta de la API es HTTP 403.
6. Comprobar que el mensaje de error indica "Email no verificado".
```

**Generate**:
1. ______________
2. ______________
3. ______________
...

---

### 9. Status

**Rule**: Choose EXACTLY ONE from: Borrador | Elaborado | Validado |
Implementado | Archivado.

- **Borrador**: first draft, some fields may be incomplete.
- **Elaborado**: all fields filled, reviewed by the author.
- **Validado**: passed the IREB quality rubric (12 criteria).
- **Implementado**: code has been generated and merged.
- **Archivado**: no longer active, kept for historical reference.

**Reference**: IREB Requirements Management describes the need to
manage states and transitions [Glinz 2024, §Requirements Management].

**Generate**:
______________

---

### 10. Version

**Rule**: Format Mayor.Menor (e.g., 1.0, 1.1, 2.0). Start at 1.0.
Increment Mayor when the requirement meaning changes (backward
incompatible). Increment Menor when clarifying or fixing typos.

**Generate**:
______________

---

### 11. Dependencies (optional)

**Rule**: List REQ-IDs of other requirements that this one depends on.
Leave empty if none. Format: comma-separated list of REQ-[PROJECT]-[N].

**Example**: `REQ-CALCOM-26801, REQ-CALCOM-26812`

**Generate**:
______________

---

### 12. Module

**Rule**: Specify the subsystem or functional area. Use the naming
convention of the source project. If unsure, look at the directory
structure or the PR labels of the source.

**Example**: `Auth / OAuth` or `Workflows / Plans & Limits`

**Generate**:
______________

---

## VALIDATION CHECKLIST

Before outputting the final requirement, verify ALL of the following:

- [ ] ID follows format REQ-[PROJECT]-[NUMBER]
- [ ] Type is exactly one of: Functional, Quality, Constraint
- [ ] Formal description starts with "El sistema deberá"
- [ ] Formal description uses an observable verb (NOT: gestionar, manejar, procesar)
- [ ] Formal description contains no subjective terms (rápido, eficiente, etc.)
- [ ] Formal description describes exactly ONE behavior (no "and" chaining)
- [ ] Formal description is self-sufficient (no "previous step" references)
- [ ] Formal description contains no implementation details
- [ ] Source includes document type, version/date, and identifier
- [ ] Rationale answers "why does this requirement exist"
- [ ] Priority is one of: Alta, Media, Baja
- [ ] Verification describes observable steps with expected results
- [ ] Verification does NOT say "se comprobará durante QA" or similar vague statements
- [ ] Status is one of: Borrador, Elaborado, Validado, Implementado, Archivado
- [ ] Version follows Mayor.Menor format
- [ ] Module is specific (not "General", not "Varios")

If any checkbox is empty, fix the corresponding field before outputting.

---

## OUTPUT FORMAT

Output ONLY the completed requirement in this exact format:

```
ID:
REQ-[PROJECT]-[NUMBER]

Nombre:
[NAME]

Tipo:
[TYPE]

Descripción formal:
El sistema deberá [VERB] [OBJECT] [CONDITION]

Fuente:
[SOURCE]

Rationale:
[RATIONALE]

Prioridad:
[PRIORITY]

Verificación:
[VERIFICATION STEPS]

Estado:
[STATUS]

Versión:
[VERSION]

Dependencias:
[DEPENDENCIES or empty]

Módulo:
[MODULE]
```

Do not add explanations, commentary, or apologies. Output ONLY the
requirement in the format above. If any field is genuinely impossible
to determine from the source, mark it as `[NEEDS CLARIFICATION: why]`
with a specific question about what is missing.
