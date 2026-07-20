# IREB Kit v1 — Versión inestable (sin AGENTS.md ni scope contract)

> ⚠️ **ADVERTENCIA**: Esta es la versión del Kit que causaba verborrea y alucinaciones.
> Se conserva como condición experimental C1 para comparación con Kit v2.

## Qué le falta respecto a Kit v2

| Componente | Kit v1 | Kit v2 |
|---|---|---|
| AGENTS.md (reglas universales R0-R4) | ❌ Ausente | ✅ 5 reglas |
| constitution.md (Art. 0 anti-alucinación) | ✅ | ✅ |
| spec/clarify/checklist/plan/tasks/analyze | ✅ | ✅ |
| Scope contract (paso 07.5) | ❌ Ausente | ✅ |
| pipeline.sh con scope contract | ❌ | ✅ |

## Efectos observados

- **Sin AGENTS.md**: el agente no recibe reglas universales. Cada comando `/speckit.*` puede comportarse de forma inconsistente.
- **Sin scope contract**: el paso `implement` modifica archivos sin restricciones, causando scope creep (hasta 4238 líneas en n8n-e5).
- **Resultado**: 3 de 6 casos no completan el pipeline. Puntuación media SRCI: 3.4/10.
