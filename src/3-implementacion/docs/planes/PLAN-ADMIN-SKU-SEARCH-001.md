# Implementation Plan — REQ-ADMIN-SKU-SEARCH-001: Búsqueda de productos por SKU de variante via query param `q`

> **Branch**: `dev` (day-to-day)
> **Date**: 2026-07-05
> **Spec**: Constitución IREB v1.0 (Artículos I-IX)
> **Context**: PR #13930 no verificable; rationale v1→v2 inventado. REQ reescrito con fuente honesta.

---

## Phase 0: Pre-Implementation Gates (IREB)

### Gate Decisión

Tras aplicar los gates IREB, el plan **no implementa** el requisito original `REQ-ADMIN-SKU-SEARCH-001` porque:

| Gate | Resultado | Razón |
|------|-----------|-------|
| Contextual Integrity (Art. 0) | ❌ | Source `PR #13930` no verificable. Rationale v1→v2 inventado. |
| Verifiability (Art. I) | ❌ | R9: verificación incompleta (solo un caso de prueba). |
| Unambiguity (Art. V) | ❌ | R8: "coincida total o parcialmente" no define algoritmo de búsqueda. |

**Decisión**: **BLOCK**. No se procede a implementación hasta que el requisito sea reescrito con fuente y rationale documentados, algoritmo de búsqueda definido, y verificación completa.

Este plan documenta el **análisis técnico** de lo que implicaría implementar la funcionalidad asumiendo que el requisito se reescribe, y sirve como artefacto de trazabilidad.

---

### Verifiability Gate (Article I)

- [ ] ❌ **R9**: Verificación incompleta. Solo prueba coincidencia exacta. No cubre:
  - Coincidencia parcial (subcadena en cualquier posición)
  - Case-insensitive vs case-sensitive
  - SKU vacío (`?q=`)
  - SKU inexistente (sin resultados)
  - SKU con caracteres especiales
  - Paginación con filtro `q`
  - Producto sin variantes
  - Múltiples variantes, una con SKU coincidente
  - Límites: que el `q` no se confunda con filtro `variants[sku]`

### Anti-Ambiguity Gate (Article V)

- [ ] ❌ **R8**: "coincida total o **parcialmente**" ambiguo. Sin definir:
  - ¿Prefijo, subcadena (LIKE `%q%`), tokenización?
  - ¿Case-sensitive o insensitive?
  - ¿Aplica a todas las variantes del producto o solo a la primera?
  - ¿El `q` se combina con OR o AND respecto a la búsqueda en campos del Product (title, subtitle, description)?

### Traceability Gate (Articles III, VII)

- [ ] ❌ **R3**: Source `PR #13930` sin repositorio, URL, ni fecha → fuente no localizable.
- [ ] ❌ **R13 (BLOQUEANTE)**: Rationale (regresión v1→v2) completamente inventado. No hay input que lo documente.
- [ ] ✅ **R4/R11**: Priority y Status declarados "No documentado en la fuente original" — correcto.

### Classification Gate (Article IV)

- [ ] ✅ Type: Functional — describe comportamiento observable.

### Minimality Gate (Article II)

- [ ] ✅ Plan cubre solo los archivos necesarios para la funcionalidad descrita.
- [ ] Sin cambios arquitectónicos, refactors, ni adiciones de dependencias.

### Single Obligation Gate (Article VI)

- [ ] ✅ Una sola obligación: "devolver productos cuyo SKU de variante coincida con `q`".

---

## Phase 1: Technical Design (Análisis — no implementación)

### 1.1 Technology Stack

| Component | Technology | Justification |
|-----------|-----------|---------------|
| Runtime | Node.js, TypeScript, MikroORM | Ya existente en Medusa |
| Search mechanism | MikroORM free-text search filter (`$ilike` sobre campos `.searchable()`) | Ya implementado para Product y ProductVariant |
| API layer | Zod validators + Express route handler | Patrón existente en `packages/medusa/src/api/admin/products/` |
| Testing | Jest (integration tests HTTP) | `integration-tests/http/__tests__/product/admin/product.spec.ts` |

### 1.2 Architecture Analysis

#### Estado actual

`GET /admin/products?q=<value>` actualmente busca solo en campos `.searchable()` del modelo **Product**:
- `Product.title`, `Product.subtitle`, `Product.description`

El modelo **ProductVariant** tiene `.searchable()` en:
- `ProductVariant.title`, `ProductVariant.sku`, `ProductVariant.barcode`, `ProductVariant.ean`, `ProductVariant.upc`
- `ProductVariant.product` (relación, también `.searchable()`)

**Problema**: La relación `Product.variants` **NO** está marcada como `.searchable()`. El free-text search filter de MikroORM (`mikro-orm-free-text-search-filter.ts`) solo recorre relaciones marcadas como `searchable: true`. Por tanto, `q` no penetra en `variants` y no busca por SKU.

#### Cómo funciona la conexión actual

1. **Validator**: `AdminGetProductsParams` (validators.ts:36-49) acepta `q` vía `GetProductsParams` (common-validators:25-29)
2. **Route**: `GET /admin/products` (route.ts:17-36) pasa `req.filterableFields` a `refetchEntities`
3. **Service**: `ProductModuleService.listAndCountProducts` → `productService_.listAndCount` → `AbstractService_.applyFreeTextSearchFilter` → configura filtro solo en `Product`
4. **Filter**: `mikroOrmFreeTextSearchFilterOptionsFactory("Product")` genera `$or` sobre propiedades escalares `.searchable()` de Product, sin penetrar en `variants` porque esa relación no es `.searchable()`

#### Cambio necesario (si se procediera)

Para que `q` busque también en `ProductVariant.sku` (y en cualquier campo searchable de las variantes), hay dos enfoques:

**Enfoque A — Marcar `Product.variants` como `.searchable()`** (1 línea):
```typescript
// En product.ts, línea 34
variants: model.hasMany(() => ProductVariant, {
  mappedBy: "product",
}).searchable(),  // <-- añadir .searchable()
```
Esto haría que el free-text search filter recorra la relación y genere:
```sql
WHERE (product.title ILIKE '%q%' OR product.subtitle ILIKE '%q%' OR product.description ILIKE '%q%'
  OR EXISTS (SELECT 1 FROM product_variant WHERE product_variant.product_id = product.id
    AND (product_variant.title ILIKE '%q%' OR product_variant.sku ILIKE '%q%'
      OR product_variant.barcode ILIKE '%q%' OR product_variant.ean ILIKE '%q%'
      OR product_variant.upc ILIKE '%q%')))
```

**Enfoque B — Filtro explícito en el servicio**:
Modificar `ProductModuleService.listAndCountProducts` para añadir lógica de búsqueda condicional cuando `filters.q` está presente y combinarlo con un join a variantes. Más complejo, más mantenimiento.

**Recomendación**: Enfoque A. Es el cambio mínimo, consistente con la arquitectura existente (el free-text search filter ya soporta relaciones anidadas), y no requiere nueva lógica.

### 1.3 Data Model

No se modifican entidades. El cambio es puramente en la definición del modelo Product.

| Entidad | Campo | Cambio |
|---------|-------|--------|
| `Product.variants` | Relación `hasMany` | Añadir `.searchable()` |

### 1.4 Impacto en búsquedas existentes

| Escenario | Antes | Después |
|-----------|-------|---------|
| `q=SKU-123` | Busca solo en title/subtitle/description | Busca también en variant.sku/barcode/ean/upc/title |
| `q=test-title` | Encuentra por title del producto | Sigue encontrando (más resultados de variantes) |
| `q=small` | No encuentra (no searchable) | Encuentra si alguna variante tiene title="small" |
| Sin `q` | Sin cambios | Sin cambios |
| `variants[sku]=SKU-123` | Filtro exacto (sin cambios) | Sin cambios |

---

## Phase 2: Implementation Strategy (Hipotético — solo si el requisito se reescribe)

### 2.1 File Creation Order (Test-First)

1. **Test existente**: `integration-tests/http/__tests__/product/admin/product.spec.ts`
   - Añadir test: `"returns a list of products with free text query matching variant SKU"`
   - Añadir test: `"returns a list of products with free text query partially matching variant SKU"`
   - Añadir test: `"returns empty list when free text query matches no variant SKU"`
   - Añadir test: `"returns a list of products with free text query matching variant barcode"`
2. **Modelo**: `packages/modules/product/src/models/product.ts`
   - Añadir `.searchable()` a la relación `variants`
3. **Ejecutar tests**: `yarn test:integration:http`

### 2.2 Implementation Tasks

| Task | Archivo | Cambio |
|------|---------|--------|
| T1 | `models/product.ts:34-37` | `variants: model.hasMany(() => ProductVariant, { mappedBy: "product" }).searchable()` |
| T2 | `product.spec.ts` | 4 nuevos tests de integración HTTP |
| T3 | Verificar no regresión en tests de `variants[sku]` existentes |

### 2.3 Riesgos

1. **Performance**: `$ilike '%value%'` en `sku` no puede usar índices B-tree. Si la tabla `product_variant` es grande, la consulta puede degradarse. Mitigación: índice GIN o trigram (fuera del scope de este requisito; documentar para seguimiento).
2. **Falsos positivos**: Si el `q` coincide con `sku` pero también con otro campo searchable de la variante (barcode, ean, upc), el producto se devuelve igual. Esto es correcto por diseño (el requisito dice "coincida total o parcialmente").
3. **Confusión con `variants[sku]` existente**: El filtro `variants[sku]=SKU-123` (exacto) y `q=SKU-123` (parcial) conviven. `variants[sku]` opera a nivel de filtro MikroORM (exact match), mientras `q` opera a nivel de free-text search (ILIKE). No hay conflicto.

---

## Phase 3: Verification Strategy (Hipotético)

### 3.1 Verification by Requirement

| Caso | Input | Expected |
|------|-------|----------|
| Coincidencia exacta SKU | `?q=SKU-123` | Producto con variante SKU=SKU-123 en resultados |
| Coincidencia parcial SKU | `?q=SKU` | Producto con variante SKU=SKU-123 en resultados |
| SKU inexistente | `?q=ZZZZ` | Lista vacía |
| SKU vacío | `?q=` | Mismos resultados que sin `q` |
| Case insensitive | `?q=sku-123` | Producto con variante SKU=SKU-123 en resultados |
| Barcode/EAN/UPC | `?q=1234567890` | Producto con variante barcode=1234567890 |
| Paginación + SKU | `?q=SKU&limit=1&offset=0` | Primer producto, count total correcto |
| Sin variantes | Query con SKU de producto sin variantes | No incluido en resultados |
| Sin `q` | `?q` no presente | Sin cambios en comportamiento actual |

### 3.2 Regression Gate (Verificación post-implementación)

- [ ] Tests de `variants[sku]` existentes siguen pasando
- [ ] Tests de `q` existentes siguen pasando (title/subtitle/description)
- [ ] Tests nuevos de `q` con SKU pasan
- [ ] Trazabilidad: REQ → spec → plan → task → test → code

---

## Complexity Tracking

| Decisión | Violación | Justificación | Estado |
|----------|-----------|---------------|--------|
| R3: PR #13930 no verificable | Art. 0, Art. VII | Source no localizable. Se requiere que el usuario documente la fuente real (URL de PR/changelog) o acepte "No documentado en la fuente original". | ❌ Bloqueante |
| R8: "parcialmente" ambiguo | Art. V | Sin definir algoritmo de búsqueda (prefijo/subcadena/case-sensitive). Se requiere decisión del usuario. | ❌ Bloqueante |
| R9: verificación incompleta | Art. I | Solo un caso de prueba. Se requiere lista de casos mínimos (ver Phase 3). | ❌ Bloqueante |
| Performance `$ilike '%sku%'` | Art. I (practicalidad) | Full-scan en `sku` para cada búsqueda. No mitigable sin índice dedicado. Documentar como deuda técnica. | ⚠️ Observación |

---

## Resumen

| Fase | Resultado |
|------|-----------|
| Pre-Implementation Gates | **BLOCK** — 3 fallos bloqueantes (R3, R8, R9) + 1 bloqueante contextual (R13) |
| Technical Design | Completado (análisis) |
| Implementation | No procede (gate bloqueado) |
| Verification Strategy | No procede (gate bloqueado) |

**Acción requerida**: Reescribir `REQ-ADMIN-SKU-SEARCH-001` con:
1. Source verificable o "No documentado en la fuente original"
2. Rationale honesto o "No documentado en la fuente original"
3. Algoritmo de búsqueda definido (ej. `ILIKE %q%` sobre todos los campos searchable de variante)
4. Verificación con lista de casos (Phase 3.1)
