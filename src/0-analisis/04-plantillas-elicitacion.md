# 4. Análisis de Plantillas, Elicitación, Rúbricas y Fuentes

---

## 4.1 Plantillas: Qué información se puede crear

### 4.1.1 Plantillas actuales de SpecKit

SpecKit usa plantillas en `.specify/templates/`. Hay cuatro tipos:

| Tipo | Archivo | Propósito |
|---|---|---|
| Spec template | `spec-template.md` | Estructura de especificación de feature |
| Plan template | `plan-template.md` | Estructura de plan de implementación |
| Tasks template | `tasks-template.md` | Estructura de tareas ejecutables |
| Constitution template | `constitution-template.md` | Principios rectores del proyecto |

La plantilla de spec (`spec-template.md`) se puede ver en el código fuente del repositorio. Contiene:
- User stories con prioridades (P1, P2, P3)
- Acceptance criteria
- Funcional requirements
- Non-functional requirements (sección, no siempre presente)
- `[NEEDS CLARIFICATION]` markers

### 4.1.2 Qué información adicional se podría crear con plantillas IREB

Basado en IREB y la práctica profesional:

**Plantilla de registro de requisito individual (form template)**:
```
ID: REQ-[DOMINIO]-[NUM]
Nombre: [título breve]
Tipo: [Funcional | Calidad | Restricción]
Descripción: El sistema deberá [acción] [objeto] [condición]
Fuente: [stakeholder, documento, changelog, URL]
Rationale: [por qué existe este requisito]
Prioridad: [Alta | Media | Baja]
Estado: [Borrador | Elaborado | Validado | Implementado]
Verificación: [cómo se comprueba que se cumple]
Dependencias: [IDs de requisitos relacionados]
Versión: [x.y]
Creado: [fecha]
Última modificación: [fecha]
```

**Plantilla de especificación de sistema (document template)**:
```
1. Propósito y alcance
2. Definiciones y glosario
3. Contexto del sistema
   3.1 Diagrama de contexto
   3.2 Actores externos
   3.3 Interfaces
4. Requisitos funcionales (por módulo)
5. Requisitos de calidad (rendimiento, seguridad, usabilidad...)
6. Restricciones (tecnológicas, regulatorias, de negocio)
7. Matriz de trazabilidad
8. Anexos
```

**Plantilla de informe de elicitación**:
```
Fuente: [documento, stakeholder, sistema]
Técnica utilizada: [entrevista, análisis documental, observación]
Fecha: [dd/mm/aaaa]
Participantes: [lista]
Hallazgos:
  - [hallazgo 1 con trazabilidad]
  - [hallazgo 2 con trazabilidad]
Riesgos identificados:
Decisiones pendientes:
```

### 4.1.3 Cómo integrar estas plantillas en SpecKit

SpecKit permite **presets** que sobreescriben las plantillas core. Se podría crear un preset "IREB" que:

1. Modifique `spec-template.md` para incluir atributos IREB
2. Añada campos de clasificación (tipo, fuente, rationale, prioridad)
3. Incluya secciones de calidad y restricciones explícitas
4. Añada checklists de calidad basados en IREB/ISO 29148

También se pueden crear **extensiones** que añadan nuevos comandos:
- `/speckit.elicit` — Asistente de elicitación
- `/speckit.validate` — Validación contra criterios IREB
- `/speckit.trace` — Matriz de trazabilidad

---

## 4.2 Elicitación: Qué se puede hacer con SpecKit

### 4.2.1 Estado actual

SpecKit **no tiene capacidades de elicitación**. El punto de entrada es un prompt de usuario con la descripción de la feature.

### 4.2.2 Posibilidades de elicitación con SpecKit

Aunque SpecKit no elicita, su arquitectura permite cierto grado de elicitación asistida:

**Opción 1: `/speckit.clarify` como pseudo-elicitación**
- `speckit.clarify` identifica áreas subespecificadas y pide aclaración
- Esto es funcionalmente similar a una técnica de elicitación por cuestionamiento
- Limitación: solo opera sobre lo que el usuario ya mencionó, no descubre fuentes nuevas

**Opción 2: Constitution como fuente de restricciones**
- El usuario puede documentar en el constitution las restricciones conocidas
- SpecKit las aplica consistentemente en todas las features
- Esto es una forma de gestión de conocimiento de dominio

**Opción 3: Extensions de análisis de contexto**
- Teóricamente, una extensión podría analizar el repositorio existente (issues, PRs, docs) para sugerir requisitos
- Esto sería una forma de elicitación por análisis documental
- No existe actualmente en la comunidad

**Opción 4: Workflows con gates de revisión**
- Los workflows permiten insertar gates humanos de revisión
- Un revisor humano podría actuar como stakeholder, validando y aportando requisitos
- Esto no es elicitación automatizada, pero es un punto de control

### 4.2.3 Elicitación en el contexto del TFG

En este TFG, la elicitación se realiza mediante **análisis documental de changelogs**. Esto es una técnica de elicitación reconocida por IREB (requisitos derivados de fuentes documentales). SpecKit no participa en esta fase — la elicitación es previa y externa.

---

## 4.3 Rúbricas: Evaluación de calidad

### 4.3.1 Rúbricas actuales en el proyecto

El proyecto ya define dos rúbricas:

1. **Rúbrica de selección de cambios** (Fase 1): Evalúa si un changelog entry es viable para derivar requisitos
2. **Rúbrica de validación de formalización** (Fase 2): Quality gate con 10 criterios binarios basados en ISO 29148, IREB e INCOSE

### 4.3.2 Rúbrica de selección de cambios (Fase 1)

| Dimensión | Criterio |
|---|---|
| Trazabilidad | Referencia a PR/commit con diff localizable |
| Señales estructurales | Menciona superficie técnica, condición o actor |
| Utilidad para derivación | Describe comportamiento formalizable |
| Defendibilidad | Inclusión justificable con razonamiento explícito |

Esta rúbrica es pragmática: se descartó una basada en IEEE 830 porque rechazaba casi todas las entradas.

### 4.3.3 Rúbrica de formalización (Fase 2)

10 criterios en 3 bloques:

**Bloque A — Identificación y gestión:**
- R1: Identificador único (`REQ-[DOMINIO]-[NNN]`)
- R2: Clasificación válida (Funcional, Calidad, Restricción)
- R3: Fuente trazable
- R4: Prioridad asignada

**Bloque B — Redacción y verificabilidad:**
- R5: Estructura formal ("El sistema deberá...")
- R6: Obligación única
- R7: Verbo observable
- R8: Ausencia de ambigüedad crítica
- R9: Verificabilidad observable

**Bloque C — Completitud contextual:**
- R10: Autosuficiencia

Umbral: 9-10 aceptado, 7-8 revisión menor, ≤6 rechazado.
Criterios bloqueantes: R5, R7, R9 (sin ellos, rechazo automático).

### 4.3.4 Rúbricas que se podrían añadir

**Rúbrica de calidad IREB** (para evaluar el corpus completo):
- Cobertura de tipos (¿hay requisitos funcionales, de calidad y restricciones?)
- Balance de prioridades
- Consistencia entre requisitos
- Trazabilidad completa hacia fuentes

**Rúbrica de completitud de especificación**:
- ¿Se cubren todos los escenarios identificados en la fuente?
- ¿Hay requisitos para condiciones de error?
- ¿Se especifican los límites (timeouts, tamaños, volúmenes)?

---

## 4.4 Fuentes: De dónde vienen los requisitos

### 4.4.1 Fuentes en el contexto del TFG

Las fuentes son **changelogs y release notes** de 6 proyectos Open Source:

| Repo | Tipo de sistema | URL |
|---|---|---|
| Appwrite | Backend-as-a-Service (transaccional) | https://github.com/appwrite/appwrite |
| Authentik | Identity Provider | https://github.com/goauthentik/authentik |
| Cal.com | Scheduling colaborativo | https://github.com/calcom/cal.com |
| Directus | Headless CMS | https://github.com/directus/directus |
| Medusa | E-commerce | https://github.com/medusajs/medusa |
| n8n | Automatización de workflows | https://github.com/n8n-io/n8n |

### 4.4.2 Cómo se usan las fuentes (método)

1. Por cada release, se lee el changelog
2. Se identifican entradas con trazabilidad a PR
3. Se evalúa cada entrada con la rúbrica de selección
4. Las entradas seleccionadas se almacenan como evidencia literal (JSON)
5. En Fase 2, se convierten en requisitos formales

### 4.4.3 Limitaciones de las fuentes

- Los changelogs son artefactos de comunicación técnica, no especificaciones
- La granularidad es heterogénea (un changelog entry puede cubrir múltiples cambios o solo uno parcial)
- No hay stakeholders humanos entrevistables
- El "rationale" original puede perderse

### 4.4.4 Trazabilidad en el proyecto

Cada requisito incluye:
```
Fuente:
Release vX.Y.Z (URL)
PR #NNNN (URL)
Entry: "texto literal del changelog"
```

Esto asegura trazabilidad completa hacia la fuente original, alineado con IREB (atributo Source con referencia documental).

---

## 4.5 Conclusión

El proyecto actual ya implementa una forma de elicitación (análisis documental), documentación (plantilla IREB con 10 atributos) y validación (rúbrica SRCI). Lo que falta es:

1. **Elicitación más rica**: No se usa el diff completo ni el code review de la PR original como fuente adicional.
2. **Más tipos de fuentes**: Issues, discusiones, documentación oficial podrían complementar los changelogs.
3. **Validación iterativa**: Actualmente la validación es un gate, no un proceso continuo.
4. **Gestión de cambios**: No hay mecanismo para actualizar requisitos cuando la fuente cambia.

SpecKit aporta la **generación de código** y la **estructura de pipeline**. IREB aporta el **rigor metodológico** y los **criterios de calidad**. La integración está en las plantillas y rúbricas, no en el código.
