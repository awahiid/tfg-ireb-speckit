# Fase 2.5 — Derivación de Prompts MRS (Minimal Requirement Specification) desde Requisitos Formalizados

> **Propósito**: Transformar cada requisito formalizado IREB/ISO 29148 en un *Minimal Requirement Specification* (MRS) que sirva como entrada replicable al pipeline SpecKit.

---

## 1. ¿Qué es esta fase?

La Fase 2.5 es un paso intermedio entre la formalización de requisitos (Fase 2) y la ejecución del pipeline SpecKit (Fase 3). Su objetivo es **derivar prompts MRS**: especificaciones mínimas en lenguaje natural que contienen la información estrictamente necesaria para que un agente SpecKit (o cualquier LLM) infiera de forma autónoma el requisito formal completo.

Un MRS no es el requisito formal en sí. Es el input que garantiza que dos agentes independientes, partiendo del mismo MRS, produzcan requisitos formales equivalentes.

## 2. Mapeo con IREB

| Actividad IREB | Artefacto en esta fase |
|---|---|
| Elicitación por *problem framing* | El MRS captura el problema (estado indeseable) sin prescribir la solución |
| Documentación | El MRS se deriva del REQ formalizado (Fase 2) |
| Validación | Cada MRS se verifica con tres propiedades: suficiencia, minimalidad y replicabilidad |
| Gestión de requisitos | `mrs-prompts.md` vincula cada MRS con su `REQ-*.md` de origen |

## 3. Estructura del directorio

```
2.5-prompts/
├── instrucciones.md          ← Instrucciones completas para el agente derivador
├── README.md                 ← Este archivo
└── mrs-prompts.md            ← Salida: MRS generados para todos los repositorios
```

## 4. Propiedades de un MRS válido

| Propiedad | Definición operacional | Fundamento normativo |
|---|---|---|
| **Suficiencia** | Contiene toda la información necesaria para inferir los campos obligatorios de la plantilla (Descripción formal, Verificación, Rationale, Tipo) | ISO 29148 §5.2 |
| **Minimalidad** | No contiene información que el agente deba inferir por sí mismo | IREB Elicitación por problem framing |
| **Replicabilidad** | Dos agentes independientes producen requisitos formales equivalentes | Reynolds & McDonell (2021), Wei et al. (2022) |

## 5. Estructura canónica del MRS

```
Como [ROL/ACTOR],
quiero que el sistema [COMPORTAMIENTO OBSERVABLE]
[cuando / en el contexto de / a través de] [CONTEXTO_TÉCNICO],
para [MOTIVACIÓN — estado indeseable actual o riesgo evitado].

[Restricción: RESTRICCIÓN_CONOCIDA]
[Fuente: REFERENCIA_TRAZABLE]
```

## 6. Procedimiento

1. Leer cada `REQ-*.md` en `src/2-requisitos/<repo>/`
2. Validar campos obligatorios (ID, Descripción formal, Tipo, Verificación, Rationale)
3. Identificar el verbo observable (R7 de la rúbrica)
4. Construir el MRS aplicando la plantilla canónica
5. Verificar suficiencia del MRS
6. Emitir `mrs-prompts.md`

Las instrucciones detalladas paso a paso se encuentran en [`instrucciones.md`](./instrucciones.md).

## 7. Uso en el pipeline SpecKit

Cada MRS generado se usa directamente como parámetro `--input spec=` en el script `run-ireb.sh` de la Fase 3:

```bash
./run-ireb.sh ../repos/directus \
  "Como usuario del módulo de archivos, quiero que el sistema restrinja..." \
  full \
  opencode
```

## 8. Relación con otras fases

```
Fase 1 (Evidencia)  →  Fase 2 (Formalización)  →  Fase 2.5 (MRS)  →  Fase 3 (SpecKit)  →  Fase 4 (Evaluación)
     ↑                        ↑                        ↑                    ↑                    ↑
  changelogs              REQ-*.md              mrs-prompts.md         snapshots           informe SRCI
```

## 9. Referencias normativas

- ISO/IEC/IEEE 29148:2018 — Systems and software engineering — Requirements engineering
- IREB CPRE Foundation Level Handbook — Elicitation, Documentation, Requirements Management
- INCOSE Guide for Writing Requirements — Characteristics of Individual Requirements
- Reynolds & McDonell (2021) — Prompt Programming for Large Language Models
- Wei et al. (2022) — Chain-of-Thought Prompting Elicits Reasoning in Large Language Models
