# 8. Partes personalizables de SpecKit y productos faltantes

> Análisis de todas las capas personalizables de SpecKit v0.10.2, estado actual de los productos IREB y qué falta generar.

---

## 8.1 Arquitectura de personalización de SpecKit

SpecKit se personaliza desde arriba (más prioritario) hacia abajo (core):

```
⬆ 1. Project-Local Overrides     .specify/templates/overrides/     (ajustes one-off)
│ 2. Presets                      .specify/presets/                 (paquete reutilizable)
│ 3. Extensions                   .specify/extensions/              (nuevos comandos)
⬇ 4. SpecKit Core                 .specify/templates/               (built-in SDD)
```

---

## 8.2 Capas personalizables — inventario completo

### Capa 1: Templates (`.specify/templates/`)

Son las plantillas que SpecKit usa para generar artefactos. Al sobreescribirlas, cambias lo que produce `/speckit.specify`, `/speckit.plan` y `/speckit.tasks`.

| # | Archivo | Función | ¿Personalizable para IREB? |
|---|---|---|---|
| T1 | `constitution-template.md` | Esqueleto del constitution. El usuario rellena los placeholders `[PROJECT_NAME]`, `[PRINCIPLE_X_NAME]`, etc. | ✅ Añadir secciones de tipos de req, criterios de calidad, política de trazabilidad |
| T2 | `spec-template.md` | Esqueleto de spec.md. Define la estructura de la especificación de feature. | ✅ Añadir campos: Tipo, Fuente, Rationale, Prioridad, Verificación, Dependencias, Módulo |
| T3 | `plan-template.md` | Esqueleto de plan.md. Define la estructura del plan técnico con las Constitutional Gates. | ✅ Añadir compuertas IREB: Verificabilidad Gate, Trazabilidad Gate |
| T4 | `tasks-template.md` | Esqueleto de tasks.md. Define la estructura de la lista de tareas. | ✅ Bajo — las tareas son técnicas, no RE |

### Capa 2: Commands (`.specify/templates/commands/`)

Son los prompts que guían al agente de IA al ejecutar cada comando `/speckit.*`. Al modificarlos, cambias CÓMO piensa SpecKit.

| # | Archivo | Función | ¿Personalizable para IREB? |
|---|---|---|---|
| C1 | `speckit.constitution.md` | Prompt del comando `/speckit.constitution` | ✅ Bajo — ya se personaliza con los principios RE en el input |
| C2 | `speckit.specify.md` | Prompt del comando `/speckit.specify` | ✅ Alto — añadir instrucciones para clasificar requisitos por tipo, verificar verbos observables, pedir fuente/rationale |
| C3 | `speckit.clarify.md` | Prompt del comando `/speckit.clarify` | ✅ Medio — añadir criterios de ambigüedad basados en ISO 29148 |
| C4 | `speckit.checklist.md` | Prompt del comando `/speckit.checklist` | ✅ Alto — checklist de calidad basada en ISO 29148 e INCOSE |
| C5 | `speckit.plan.md` | Prompt del comando `/speckit.plan` | ⬜ Medio — añadir verificación de que el plan cubre todos los requisitos |
| C6 | `speckit.tasks.md` | Prompt del comando `/speckit.tasks` | ⬜ Bajo — las tareas son técnicas |
| C7 | `speckit.analyze.md` | Prompt del comando `/speckit.analyze` | ✅ Alto — añadir criterios de trazabilidad normativos |
| C8 | `speckit.implement.md` | Prompt del comando `/speckit.implement` | ⬜ Bajo — la implementación es técnica |

### Capa 3: Constitution (`.specify/memory/constitution.md`)

Es el archivo activo (no template) que define los principios rectores del proyecto. Se genera al ejecutar `/speckit.constitution`.

| # | Elemento | ¿Personalizable? |
|---|---|---|
| M1 | `constitution.md` (activo) | ✅ Es el producto principal: sustituir los 9 artículos genéricos (Library-First, TDD, CLI Mandate...) por principios RE (Verificabilidad, Trazabilidad, Minimalidad, Clasificación por tipos) |

### Capa 4: Workflows (`.specify/workflows/`)

Pipelines multi-paso definidos en YAML con gates de revisión humana.

| # | Elemento | ¿Personalizable? |
|---|---|---|
| W1 | `workflow.yml` | Definir un pipeline IREB con gates de revisión de calidad entre cada fase |

### Capa 5: Presets (`.specify/presets/`)

Paquete que agrupa templates + commands + workflows. Instalable con `specify preset add`.

| # | Elemento | ¿Personalizable? |
|---|---|---|
| P1 | `preset.yml` (manifest) | Metadatos del preset: nombre, versión, descripción, autor |
| P2 | Templates sobreescritos | Agrupa T1-T4 personalizados |
| P3 | Commands sobreescritos | Agrupa C1-C8 personalizados |
| P4 | Workflow | Incluye W1 |

---

## 8.3 Productos existentes vs faltantes

### ✅ Ya existen (fuera de SpecKit, para uso humano)

| Producto | Ubicación | Estado |
|---|---|---|
| Plantilla REQ (12 atributos) | `src/2-requisitos/plantilla.md` | ✅ Completo |
| Rúbrica de calidad (12 criterios) | `src/2-requisitos/rubrica.md` | ✅ Completo |
| Análisis del flujo SpecKit | `src/0-analisis/01-flujo-speckit.md` | ✅ Completo |
| Mapeo IREB vs SpecKit | `src/0-analisis/02-mapeo-ireb-speckit.md` | ✅ Completo |
| Análisis de gaps | `src/0-analisis/07-gaps-metodologia-funciones-no-usadas.md` | ✅ Completo |
| Metodología completa | `src/metodologia.md` | ✅ Completo |

### 🔴 Faltan (necesarios para Flow B)

| # | Producto | Prioridad | Descripción |
|---|---|---|---|
| F1 | **`constitution.md` (activo)** | 🔴 Crítica | Archivo que SpecKit usará en Flow B. Sustituye los 9 artículos genéricos por principios RE. Se pega como input de `/speckit.constitution`. |
| F2 | **`spec-template.md` IREB** | 🟡 Alta | Plantilla de spec que incluya los 12 atributos IREB en lugar de user stories genéricas. |
| F3 | **`checklist-template.md` IREB** | 🟡 Alta | Checklist de calidad basado en ISO 29148 (no ambigüedad, completitud, verificabilidad, singularidad, trazabilidad). |

### 🔵 Opcionales (mejoran pero no bloquean)

| # | Producto | Prioridad | Descripción |
|---|---|---|---|
| F4 | **Workflow YAML IREB** | 🟢 Media | Pipeline YAML con gates de revisión entre fases, incluyendo los comandos opcionales (clarify, checklist, analyze). |
| F5 | **Preset IREB** | 🔵 Baja | Empaquetar F1-F4 como preset instalable con `specify preset add ireb`. |

---

## 8.4 ¿Cuáles debo generar YA para que Flow B funcione?

### Mínimo viable (2 productos)

Solo necesitas **2 productos** para que Flow B sea distinto de Flow A:

**1. `constitution.md` IREB** — Lo pegas en `/speckit.constitution` al iniciar Flow B:

```
/speckit.constitution Este proyecto sigue principios de ingeniería de requisitos
basados en IREB:

1. Verificabilidad obligatoria: todo requisito debe incluir un criterio de
   verificación observable (prueba, inspección, demostración).
2. Minimalidad funcional: implementar exactamente lo especificado, sin features
   no solicitadas.
3. Trazabilidad completa: toda implementación debe poder trazarse hasta el
   requisito que la motiva.
4. Clasificación por tipo: distinguir requisitos funcionales, de calidad y
   restricciones.
5. No ambigüedad: evitar términos subjetivos (rápido, eficiente, intuitivo);
   usar métricas concretas.
```

**2. REQ-*.md formalizado** — Ya lo tienes para los 52 casos. Es el input de `/speckit.specify`.

**Conclusión**: Flow B ya se puede ejecutar AHORA. Los otros productos (F2-F5) son para la memoria/discusión, no bloquean la ejecución.

### Diferencia real entre Flow A y Flow B

```
Flow A:  changelog crudo → default SpecKit (4 comandos)
Flow B:  REQ-*.md IREB   → SpecKit con constitution RE + pipeline completo (9 comandos)
```

La constitución personalizada (F1) es lo ÚNICO que tienes que crear ahora mismo para que Flow B sea distinto. El REQ-*.md ya existe.

---

## 8.5 Conclusión

| ¿Qué tengo que generar? | ¿Cuándo? | Esfuerzo |
|---|---|---|
| F1: `constitution.md` IREB | **AHORA** (para Flow B) | 5 minutos → copiar el texto de arriba |
| F2: `spec-template.md` IREB | Durante la redacción de la memoria | 30 min → documentar cómo sería |
| F3: `checklist-template.md` IREB | Durante la redacción de la memoria | 30 min → documentar cómo sería |
| F4: Workflow YAML | Opcional (si sobra tiempo) | 30 min |
| F5: Preset IREB | Opcional (si sobra tiempo) | 1h |
