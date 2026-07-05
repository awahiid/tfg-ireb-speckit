# 5. Sistemas Profesionales de Especificación de Requisitos

> **Análisis comparativo de cómo los sistemas profesionales manejan la especificación de requisitos y cómo se puede trasladar a SpecKit.**

---

## 5.1 Sistemas analizados

| Sistema | Tipo | Enfoque |
|---|---|---|
| **IBM Engineering Requirements Management DOORS** | Clásico (1991) | Base de datos de requisitos con atributos, trazabilidad, baselines |
| **Jama Connect** | Moderno (2011) | Trazabilidad bidireccional, revisión, gestión de riesgos |
| **Siemens Polarion** | Web moderno | Live docs, trazabilidad, workflow de aprobación |
| **ReqView** | Ligero | Especificaciones en formato tabular, exportación |
| **SpecKit** | AI-native | Generación de código desde especificaciones narrativas |

*Nota: El análisis se basa en documentación pública y conocimiento general del sector, no en instalaciones licenciadas.*

---

## 5.2 Cómo especifican requisitos los sistemas profesionales

### 5.2.1 Estructura de datos

Todos los sistemas profesionales comparten un modelo de datos común:

```
Requisito:
  ├── ID (único, jerárquico: REQ-001, REQ-001.1)
  ├── Tipo (Functional, Performance, Safety, Interface, Physical...)
  ├── Texto (descripción formal)
  ├── Atributos (personalizables por proyecto)
  │   ├── Fuente (stakeholder, documento, normativa)
  │   ├── Prioridad (Alta/Media/Baja o MoSCoW)
  │   ├── Estado (Draft, Reviewed, Approved, Implemented, Verified)
  │   ├── Rationale
  │   ├── Riesgo (Alto/Medio/Bajo)
  │   ├── Cobertura de test
  │   └── Versión (individual)
  ├── Trazabilidad
  │   ├── Hacia arriba (a requisitos de negocio)
  │   ├── Hacia abajo (a diseño, implementación, tests)
  │   └── Horizontal (a requisitos relacionados)
  └── Historial de cambios
```

### 5.2.2 Proceso de especificación

```
1. Elicitación (externa a la herramienta)
    └── Entrevistas, workshops, análisis documental

2. Ingreso en la herramienta
    └── Creación de requisitos con atributos mínimos

3. Revisión por pares
    └── Workflow de aprobación (Draft → In Review → Approved)

4. Gestión de cambios
    └── Solicitud de cambio → Análisis de impacto → Aprobación → Implementación

5. Trazabilidad
    └── Vinculación manual o semiautomática a diseño, código, tests

6. Verificación
    └── Asignación de casos de test, resultados de verificación
```

### 5.2.3 Elicitación: qué hacen los sistemas profesionales

**Ningún sistema profesional de requisitos hace elicitación automática.** Todos requieren que un humano introduzca los requisitos. Las herramientas ayudan en:

- **Organización**: Una vez elicitados, estructurar y clasificar
- **Análisis**: Detectar duplicados, inconsistencias, huecos
- **Trazabilidad**: Vincular requisitos entre sí y con otros artefactos
- **Reporting**: Matrices de trazabilidad, informes de cobertura

SpecKit, en contraste, podría hacer elicitación asistida por IA (analizando issues, PRs, documentación), pero actualmente no lo hace.

---

## 5.3 Comparativa detallada

| Característica | DOORS | Jama | Polarion | ReqView | SpecKit |
|---|---|---|---|---|---|
| **Modelo de datos** | Rígido | Flexible | Flexible | Tabular | Libre (narrativo) |
| **Atributos personalizables** | ✅ | ✅ | ✅ | ✅ | ❌ (solo plantillas) |
| **Clasificación por tipo** | ✅ | ✅ | ✅ | ✅ | ❌ |
| **Trazabilidad bidireccional** | ✅ | ✅ | ✅ | ⚠️ | ❌ (solo forward) |
| **Baselines** | ✅ | ✅ | ✅ | ✅ | ❌ |
| **Workflow de aprobación** | ✅ | ✅ | ✅ | ❌ | ⚠️ (gates opcionales) |
| **Versionado individual** | ✅ | ✅ | ✅ | ✅ | ❌ |
| **Análisis de impacto** | ✅ | ✅ | ✅ | ❌ | ❌ |
| **Colaboración** | ✅ | ✅ | ✅ | ❌ | ❌ |
| **Generación de código** | ❌ | ❌ | ❌ | ❌ | ✅ (core) |
| **Integración IA** | ❌ | ❌ | ⚠️ | ❌ | ✅ (nativa) |
| **Precio** | $$$$$ | $$$$ | $$$$ | $ | Gratis (OSS) |

---

## 5.4 Qué se puede aprender de los sistemas profesionales

### 5.4.1 Atributos que importan

De los sistemas profesionales se extrae que los atributos mínimos para gestión seria de requisitos son:

1. **ID único** — No reutilizable, jerarquizable
2. **Tipo** — Funcional, calidad, restricción
3. **Texto** — Descripción formal, una obligación por requisito
4. **Fuente** — Origen trazable
5. **Prioridad** — Para negociación y planificación
6. **Estado** — Para seguimiento del ciclo de vida
7. **Rationale** — Para comprensión y mantenimiento
8. **Verificación** — Criterio objetivo de cumplimiento
9. **Versión** — Para control de cambios

**Nuestro proyecto ya implementa estos 9 atributos** en la plantilla de Fase 2 (ver `src/2-requisitos/plantilla.md`).

### 5.4.2 Trazabilidad que funciona

Los sistemas profesionales demuestran que la trazabilidad efectiva requiere:

- **Bidireccionalidad**: Poder navegar de requisito a implementación y viceversa
- **Granularidad adecuada**: No demasiado fina (cuesta mantener) ni demasiado gruesa (pierde precisión)
- **Automática cuando sea posible**: Enlazar commits, tests, código
- **Humana para decisiones**: El rationale de las relaciones debe documentarse

SpecKit tiene trazabilidad forward (spec→plan→tasks→implement), pero no backward ni a fuentes externas.

### 5.4.3 Gestión de cambios que escala

Los sistemas profesionales gestionan cambios mediante:

1. **Solicitud de cambio**: Quién pide, qué cambia, por qué
2. **Análisis de impacto**: Qué requisitos, diseños, tests se ven afectados
3. **Aprobación**: CCB (Change Control Board) o similar
4. **Implementación**: Actualización de requisitos y artefactos vinculados
5. **Nueva baseline**: Versión congelada del conjunto

SpecKit no tiene nada de esto. Los cambios se gestionan manualmente via Git.

---

## 5.5 Cómo trasladar esto a SpecKit

### 5.5.1 Usando presets

Un preset "IREB Professional" podría:

1. **Añadir atributos a spec-template.md**: Tipo, fuente, rationale, prioridad, estado, verificación, versión
2. **Añadir checklist de calidad**: Basado en ISO 29148 / INCOSE
3. **Estructurar por módulos**: Organizar requisitos por subsistema o componente
4. **Incluir sección de trazabilidad**: Matriz requisito→test→código

### 5.5.2 Usando extensiones

Extensiones posibles:

- **`speckit.trace`**: Generar matriz de trazabilidad desde los artefactos existentes
- **`speckit.impact`**: Analizar impacto de cambio de un requisito
- **`speckit.baseline`**: Congelar un conjunto de requisitos como baseline
- **`speckit.coverage`**: Analizar cobertura de requisitos en tests

### 5.5.3 Usando workflows

Un workflow "IREB-compliant" podría incluir:

```yaml
steps:
  - id: specify
    command: speckit.specify
  - id: review-ireb
    type: gate
    message: "Validar requisito contra criterios IREB"
  - id: trace-analysis
    command: speckit.trace
  - id: impact-assessment
    command: speckit.impact (opcional)
  - id: plan
    command: speckit.plan
  - id: tasks
    command: speckit.tasks
  - id: implement
    command: speckit.implement
  - id: verify-coverage
    command: speckit.coverage
```

---

## 5.6 Conclusión

Los sistemas profesionales de requisitos son **herramientas de gestión**, no de generación. SpecKit es una **herramienta de generación**, no de gestión. La complementariedad es clara:

| SpecKit hace bien | Sistemas profesionales hacen bien |
|---|---|
| Generar código desde especificaciones | Gestionar el ciclo de vida de requisitos |
| Mantener consistencia spec→plan→tasks→code | Trazabilidad bidireccional |
| Iterar rápido en implementaciones | Control de cambios y baselines |
| Integrar IA nativamente | Colaboración multi-stakeholder |
| Gratuito y open source | Cumplimiento normativo (DO-178C, IEC 62304) |

Para el TFG, la pregunta relevante no es si SpecKit puede reemplazar a DOORS (no puede), sino si **un proceso IREB aplicado manualmente puede alimentar a SpecKit con requisitos suficientemente buenos** para generar implementaciones conformes.
