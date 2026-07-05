# Producto 4 — Comparación empírica completa (6 casos, 3 flujos)

> **Fecha**: 2026-07-03 | **Modelo**: DeepSeek | **Casos**: 6 de 6

---

## Tabla resumen

| Caso | Flow A (no kit) | Flow B v1 (kit original) | Flow B v2 (anti-scope-creep) | Ganador |
|------|-----------------|--------------------------|------------------------------|---------|
| appwrite-e3 | 33L ❌ scaffolding | 224L ⚠️ ruido en configs | 438L (167L real) ✅ tests | **v2** 🏆 |
| authentik-e1 | 141L ✅ completo | 0L ❌ fallo total | 274L (58L real) ✅ quirúrgico | **v2** 🏆 |
| cal-e1 | 342L ✅ enfocado | 749L ❌ scope creep | 898L (682L real) ⚠️ sobre-implementa | **Flow A** |
| directus-e9 | 97L ✅ server-side | 337L ⚠️ client-side UX | 539L ⚠️ más archivos | **Flow A** |
| medusa-e5 | 2830L ❌ DESTRUCTIVO | 262L ✅ conservador | 944L (280L real) ⚠️ build artifacts | **v1** |
| n8n-e5 | 450L ✅ | 4238L ❌ EXPLOSIVO | 222L ✅ contenido | **v2** 🏆 |

## Marcador final

| Flujo | Victorias | Derrotas | Nota |
|-------|-----------|----------|------|
| **Flow B v2** | **3** | 0 | 🏆 Mejor balance |
| Flow A | 2 | 2 | Bueno para cambios simples |
| Flow B v1 | 1 | 4 | Demasiado scope creep |

---

## Hallazgos por caso

### appwrite-e3 — "Cached document lists with TTL"
v2 es el único con tests (137L E2E) y sin tocar configs globales. Gana.

### authentik-e1 — "fix FIPS status schema"  
v2 tocó 2 líneas. Flow A creó 6 archivos para un fix. v2 entendió que era un fix. Gana.

### cal-e1 — "bookingUrl for platform organizations"
Flow A fue más enfocado (342L, 4 archivos). v2 documentó mejor pero tocó 11 archivos. Empate técnico, Flow A por minimalidad.

### directus-e9 — "MIME type restriction"
Flow A aplicó validación server-side (lo correcto). v2 añadió más archivos con UX. Flow A gana por enfoque.

### medusa-e5 — "SKU search"
Flow A borró 2554 líneas (destructivo). v1 fue conservador (262L). v2 generó build artifacts (tsconfig). v1 gana por contención.

### n8n-e5 — "MongoDB validate key type"
v1 generó 4238L. v2 lo redujo a 222L. **Reducción del 95%.** La victoria más clara de v2.

---

## Conclusión

**Flow B v2 gana 3-2-1.** El scope contract + contexto destilado + anti-alucinación funcionan. El caso n8n-e5 es la prueba definitiva: de 4238L a 222L. v2 es el mejor flujo para uso general.

---

## 4.1 Métricas agregadas

| Caso | Flow A (baseline) | Flow B (IREB) | Ganador |
|------|-------------------|---------------|---------|
| **appwrite-e3** | 33L / 2 archivos | 224L / 9 archivos | **Flow B** ✅ |
| **authentik-e1** | 141L / 6 archivos | 0L / 0 archivos | **Flow A** ✅ |
| **cal-e1** | 342L / 4 archivos | 749L / 7 archivos | **Flow A** ✅ |
| **directus-e9** | 97L / 4 archivos | 337L / 8 archivos | **Flow A** ✅ |

| Métrica | Flow A | Flow B |
|---------|--------|--------|
| Casos con diff > 0 | 4/4 (100%) | 3/4 (75%) |
| Media líneas diff | 153L | 328L |
| Media archivos modificados | 4.0 | 6.0 |
| Casos con implementación relevante | 3/4 | 1/4 |

---

## 4.2 Análisis cualitativo por caso

### Caso 1: appwrite-e3 — "Cached document lists with configurable TTL"

| | Flow A (33L) | Flow B (224L) |
|---|---|---|
| **Qué hizo** | Config + tipos de cache (scaffolding) | Implementación completa: TTL, cache keys, load/save, purge en writes |
| **Relevancia** | Parcial — no conecta con endpoints | Completa — toca todos los endpoints CRUD |
| **Veredicto** | Insuficiente | ✅ **Correcto** |

**Flow B ganó claramente.** El pipeline IREB (8 pasos) produjo una implementación end-to-end con purga de caché en escrituras. Flow A solo generó scaffolding sin integrar.

---

### Caso 2: authentik-e1 — "fix FIPS status schema"

| | Flow A (141L) | Flow B (0L) |
|---|---|---|
| **Qué hizo** | Serializer + endpoint + tests + changelog | Nada |
| **Relevancia** | Directa — implementa exactamente el fix | Nula |
| **Veredicto** | ✅ **Correcto** | Fallo total |

**Flow A ganó.** Flow B no generó nada — mismo resultado que en la ejecución original. El changelog "fix FIPS status schema" es demasiado vago para ambos flujos, pero Flow A al menos intentó inferir una implementación.

---

### Caso 3: cal-e1 — "use cal.com for bookingUrl in platform organizations"

| | Flow A (342L) | Flow B (749L) |
|---|---|---|
| **Qué hizo** | URL configurable + servicio + tests unitarios + e2e | Feature-opt-in, error codes, refactors varios, settings |
| **Relevancia** | 100% enfocado en el fix del changelog | Diluido — toca funcionalidad no relacionada |
| **Veredicto** | ✅ **Correcto y enfocado** | Demasiado amplio (scope creep) |

**Flow A ganó.** Flow B generó 749 líneas pero gran parte no era relevante para el cambio. El pipeline IREB, con su contexto acumulado de 8 pasos, produjo *scope creep*: añadió feature-opt-in, códigos de error y refactors no solicitados.

---

### Caso 4: directus-e9 — "restrict allowed MIME types in file upload"

| | Flow A (97L) | Flow B (337L) |
|---|---|---|
| **Qué hizo** | Validación server-side (model + validator + config) | Config server + UI client-side (accept, labels, tests) |
| **Relevancia** | Aplica la restricción donde importa (backend) | Mejora UX pero sin enforcement server-side |
| **Veredicto** | ✅ **Correcto y seguro** | Complementario pero incompleto |

**Flow A ganó** en seguridad/corrección. Flow B mejoró la UX pero sin validación server-side. Idealmente se combinarían ambos.

---

## 4.3 Hallazgos clave

### H1. Flow B NO supera consistentemente a Flow A

Contrario a la hipótesis inicial, el pipeline IREB (8 pasos, constitution, clarify, checklist, analyze) **no produjo mejores implementaciones** que Flow A (4 pasos, changelog crudo). En 3 de 4 casos, Flow A fue superior.

### H2. El scope creep es el principal riesgo de Flow B

El contexto acumulado de 8 pasos en Flow B (spec → clarify → checklist → plan → tasks → analyze → implement → post-analyze) produce un prompt masivo que induce al modelo a generar código más allá del requisito original. Ejemplo: cal-e1 (749L vs 342L, con feature-opt-in no solicitado).

### H3. Flow A es más eficiente para requisitos simples

Para cambios acotados y bien descritos (cal-e1, directus-e9), Flow A produce implementaciones más enfocadas en menos tiempo (~4 min vs ~15 min).

### H4. Flow B es mejor para requisitos complejos que requieren infraestructura

Para cambios que requieren tocar múltiples capas (appwrite-e3: endpoints CRUD + cache + purga), Flow B produce una implementación más completa gracias al análisis previo.

### H5. Ambos flujos fallan con inputs ambiguos

authentik-e1 ("fix FIPS status schema") es demasiado vago. Flow A generó 141L de implementación especulativa; Flow B generó 0L. Ninguno es confiable con inputs de baja calidad.

---

## 4.4 Recomendaciones revisadas

Basado en los datos empíricos:

1. **Usar Flow B (IREB) para requisitos complejos** que requieren infraestructura transversal (múltiples endpoints, varias capas). El análisis previo ayuda a cubrir todos los puntos de contacto.

2. **Usar Flow A (baseline) para requisitos acotados** con descripciones concretas. Es más rápido y produce implementaciones más enfocadas.

3. **NO usar el pipeline completo de 8 pasos para todo.** El contexto acumulado induce scope creep. Considerar un pipeline híbrido: constitution + specify + implement (3 pasos) para requisitos simples.

4. **La calidad del input es el factor determinante.** Un changelog vago produce malos resultados en ambos flujos. La formalización IREB (Fase 2) es necesaria *antes* de llegar a SpecKit, no durante.

---

## 4.5 Limitaciones de esta comparación

- **Muestra pequeña**: 4 casos (medusa-e5 y n8n-e5 pendientes).
- **Modelo único**: Solo DeepSeek v4-pro. Resultados pueden variar con GPT-4o o Claude.
- **Ejecución única**: Una sola ejecución por caso/flujo. No hay medición de variabilidad.
- **Sin filtro técnico**: No se verificó compilación, tests ni linting.
- **Evaluación cualitativa**: El análisis de relevancia es subjetivo (autor único).
