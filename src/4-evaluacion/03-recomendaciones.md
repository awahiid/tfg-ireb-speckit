# Producto 3 — Recomendaciones

> **Objetivo**: cómo aproximar SpecKit a un flujo normativo y qué limitaciones son inherentes al enfoque SDD.

---

## 3.1 Recomendaciones para aproximar SpecKit a un flujo IREB

### R0. NUNCA alucinar contexto (REGLA DE ORO) ← NUEVO

**Qué**: El modelo puede expandir detalles de implementación (cómo), pero NUNCA debe inventar contexto (por qué, quién, de dónde).

**Ejemplos de lo que NO debe hacer**:
- ❌ "Solicitado por el equipo de seguridad para cumplir con FIPS 140-2"
- ❌ "Este cambio mejorará la experiencia del usuario final en un 30%"
- ❌ "Los stakeholders del departamento de operaciones requirieron..."
- ❌ "Surge del issue #1234 donde se discutió..."

**Ejemplos de lo que SÍ puede hacer**:
- ✅ Definir mejor la firma de una función
- ✅ Elegir entre dos enfoques técnicos
- ✅ Añadir validaciones o manejo de errores

**Implementación en el pipeline v2**:
- Constitution: principio anti-alucinación explícito
- Specify: reglas estrictas para Source y Rationale
- Clarify: detector de alucinaciones de contexto (marcado ❌)
- Checklist: criterio R13 "NO ALUCINACIÓN DE CONTEXTO" (bloqueante)
- Scope contract: prohibición de comentarios inventados en el código

### R1. Usar pipeline-ireb-v2.sh (con scope contract)

**Qué**: La versión mejorada del pipeline IREB mantiene TODA la documentación (8 pasos, 11 artefactos) pero resuelve el scope creep con 3 mecanismos:

1. **Scope Contract (paso 7.5)**: antes de implementar, se genera un contrato de alcance vinculante que lista exactamente qué archivos tocar, qué comportamiento implementar y qué NO hacer.

2. **Contexto destilado**: el paso implement NO recibe los 7 pasos completos (que suman miles de líneas de contexto). Solo recibe: spec IREB + scope contract + tareas. Esto reduce el prompt de ~15K tokens a ~3K tokens.

3. **Restricciones duras**: 10 reglas explícitas en el prompt de implementación que prohíben refactorizar, añadir features, borrar código existente o modificar configuraciones.

4. **Alerta de diff**: si el diff supera 500 líneas, el script lanza un warning. Si supera 1000, alerta de posible scope creep.

**Script**: `ireb-kit/pipeline-ireb-v2.sh` — mismo uso que v1.

```bash
./pipeline-ireb-v2.sh repos/cal-e1 ../../2-requisitos/cal/REQ-CALCOM-26801.md
```

**Impacto esperado**: mismo output documental que v1, pero implementaciones 2-5x más enfocadas (sin feature-opt-in no solicitado, sin reescrituras masivas de archivos).

**Qué**: Configurar `/speckit.constitution` con principios explícitos de ingeniería de requisitos antes de cualquier `specify`.

**Principios recomendados** (los usados en Flow B):

```markdown
1. VERIFICABILIDAD — Todo requisito debe tener un criterio de verificación
   observable (respuesta HTTP, cambio de estado, evento, persistencia).

2. MINIMALIDAD — Implementar solo lo necesario para satisfacer el requisito.
   No añadir funcionalidad no solicitada.

3. TRAZABILIDAD — Cada decisión de implementación debe poder vincularse
   con el requisito que la motiva.

4. SINGULARIDAD — Un requisito por declaración. No mezclar comportamientos
   independientes.

5. NO AMBIGÜEDAD — Sin términos subjetivos (rápido, eficiente, robusto, intuitivo).
   Usar criterios cuantificables o comportamientos observables.
```

**Impacto**: Estos principios se propagan a `specify`, `plan`, `tasks` e `implement`, mejorando la alineación con ISO 29148 en todos los niveles.

**Evidencia**: El constitution es el punto de mayor palanca (Patrón P3).

---

### R2. Formalizar el input antes de pasarlo a SpecKit

**Qué**: No pasar el changelog crudo a `/speckit.specify`. Aplicar una capa de formalización ligera:

1. Identificar el **comportamiento observable** (verbo principal).
2. Especificar la **condición de activación** (cuándo ocurre).
3. Definir el **resultado esperado** (cómo se verifica).
4. Acotar el **alcance** (qué NO debe hacer).

**Formato recomendado** (MRS — Minimal Requirement Seed):

```
Como [actor],
quiero que el sistema [comportamiento observable]
cuando [condición],
para [motivación].

Verificación: [criterio concreto y medible]
```

**Impacto**: Reduce la ambigüedad del input y acota el scope creep (Patrones P1, P2).

---

### R3. Ejecutar el pipeline completo (no solo specify → implement)

**Qué**: No saltarse `clarify`, `checklist` ni `analyze`. El pipeline completo de 8 pasos genera un expediente de trazabilidad que es la principal contribución de SpecKit a un flujo RE.

**Pipeline mínimo recomendado**:

```
constitution → specify → clarify → checklist → plan → tasks → analyze → implement → analyze
```

**Impacto**: Cada paso adicional añade una capa de calidad que aproxima el flujo a una revisión RE estructurada (Patrón P6).

---

### R4. Usar el post-analyze como gate de aceptación

**Qué**: Tras `implement`, ejecutar `/speckit.analyze` para verificar la cadena de trazabilidad completa. Si el post-analyze detecta enlaces rotos, tests faltantes o criterios no cumplidos, iterar.

**Criterios de aceptación**:

- [ ] Todos los REQ tienen al menos un test asociado
- [ ] No hay código huérfano (sin trazabilidad a requisito)
- [ ] Los criterios de verificación del spec se cumplen en los tests
- [ ] El diff no contiene cambios no solicitados

---

### R5. Mantener un registro de requisitos externo

**Qué**: SpecKit no tiene gestión de requisitos. Usar una herramienta externa (incluso un simple directorio de archivos Markdown, como el usado en este TFG) para mantener el registro de requisitos con sus 12 atributos IREB.

**Formato**: Un archivo `REQ-{PROYECTO}-{ID}.md` por requisito, con la plantilla IREB completa.

**Impacto**: Cubre la brecha de gestión de cambios y versionado que SpecKit no aborda.

---

## 3.2 Limitaciones inherentes al enfoque SDD

Estas limitaciones **no se pueden resolver** con configuración o prompts. Son estructurales al enfoque SpecKit:

### L1. Sin elicitación real

SpecKit no entrevista stakeholders, no analiza documentos, no observa usuarios. El input lo proporciona un humano que ya ha hecho la elicitación (o la ha omitido). Esto es inherente a cualquier herramienta SDD: la elicitación es una actividad humana que requiere juicio, contexto organizacional y negociación.

**Consecuencia**: SpecKit no puede sustituir la fase de elicitación de IREB. Solo puede procesar requisitos ya elicitados.

---

### L2. Sin validación externa

`clarify` y `checklist` son autoevaluaciones del LLM. No hay un stakeholder que confirme que el requisito es correcto, completo y necesario. La validación IREB requiere la participación de fuentes externas al pipeline.

**Consecuencia**: SpecKit puede generar requisitos bien formados pero incorrectos (no reflejan la necesidad real). La validación debe hacerse fuera del pipeline.

---

### L3. Sin negociación entre requisitos

SpecKit procesa un requisito a la vez. No detecta conflictos entre requisitos (dos requisitos que piden comportamientos incompatibles) ni negocia prioridades.

**Consecuencia**: En proyectos con múltiples requisitos, SpecKit puede generar implementaciones inconsistentes entre sí. La negociación debe hacerse fuera del pipeline.

---

### L4. Sin gestión de cambios

Cada ejecución de SpecKit es independiente. No hay versionado de requisitos, no hay historial de cambios, no hay trazabilidad de la evolución de un requisito a lo largo del tiempo.

**Consecuencia**: SpecKit es adecuado para la implementación inicial de un requisito, pero no para el mantenimiento evolutivo donde los requisitos cambian.

---

### L5. Dependencia del modelo LLM subyacente

La calidad de la salida de SpecKit depende del modelo LLM utilizado. Cambiar de modelo (GPT-4o → DeepSeek → Claude) puede producir resultados diferentes para el mismo input. Esto introduce una variabilidad que no existe en un proceso RE humano.

**Consecuencia**: Los resultados de SpecKit no son deterministas ni perfectamente reproducibles. Cualquier evaluación debe especificar el modelo utilizado.

---

## 3.3 Resumen: qué esperar de SpecKit en un contexto IREB

| Aspecto | ¿Lo cubre SpecKit? | ¿Se puede mejorar? | ¿Cómo? |
|---|---|---|---|
| Elicitación | ❌ No | ❌ No | Debe hacerse fuera del pipeline |
| Documentación | ⚠️ Parcial | ✅ Sí | Constitution + plantilla IREB (R1, R2) |
| Validación | ⚠️ Parcial | ⚠️ Limitado | Clarify + checklist (R3) pero requiere validación externa |
| Negociación | ❌ No | ❌ No | Debe hacerse fuera del pipeline |
| Verificación | ⚠️ Parcial | ✅ Sí | Analyze pre/post (R3, R4) |
| Trazabilidad | ⚠️ Interna | ✅ Sí | Analyze + registro externo (R4, R5) |
| Gestión de cambios | ❌ No | ⚠️ Parcial | Registro externo (R5) |
| Implementación | ✅ Sí | ✅ Sí | Pipeline completo (R3) |

---

## 3.4 Recomendación final

**SpecKit es una herramienta de generación, no de gestión de requisitos.** Su valor en un flujo IREB está en la *mitad derecha* del proceso: tomar requisitos ya elicitados, documentados y validados, y transformarlos en implementaciones trazables. Para la *mitad izquierda* (elicitación, negociación, gestión de cambios), se necesitan herramientas complementarias o procesos manuales.

La configuración recomendada (Flow B + constitution IREB + MRS + pipeline completo) maximiza la alineación con IREB dentro de las limitaciones estructurales de SpecKit. No convierte a SpecKit en una herramienta RE, pero sí en un complemento valioso para la fase de implementación dentro de un proceso RE más amplio.
