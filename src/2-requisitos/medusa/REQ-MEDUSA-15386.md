### ID

REQ-MEDUSA-15386

### Nombre

Búsqueda indexada por SKU en opciones de valores de promociones y endpoint de productos

### Tipo

Funcional

### Descripción formal

El sistema deberá optimizar la búsqueda de productos en el endpoint de opciones de valores de reglas de promoción (`rule-value-options`) y en los endpoints de listado de productos (`/admin/products` y `/store/products`), utilizando el módulo de indexación (`IndexEngine`) cuando este esté habilitado.

Para lograr esto, el sistema deberá:
1.  **Habilitar el IndexEngine**: Utilizar `query.index()` en lugar de `query.graph()` o `remoteQuery` cuando la entidad a consultar sea `product` y el `IndexEngineFeatureFlag` esté activo.
2.  **Soporte de búsqueda por SKU**: Al realizar una búsqueda de texto libre (utilizando el parámetro `q`), el sistema deberá inyectar un filtro de variantes vacío (`variants: {}` o similar) si no existe previamente. Esta inyección forzará a la lógica de construcción de la consulta de indexación a considerar la columna vectorial de las variantes, permitiendo que la búsqueda coincida con los SKUs de los productos, alineando así el comportamiento de búsqueda del IndexEngine con el del motor de grafos estándar.
3.  **Paginación consistente**: Para las consultas que utilizan el IndexEngine en el endpoint de promociones, la respuesta deberá incluir tanto `count` como `estimate_count` con el valor de `metadata.estimate_count`, asegurando la compatibilidad con clientes que esperan un campo `count`.

### Fuente

Pull Request #15386 (https://github.com/medusajs/medusa/pull/15386)

### Rationale

Anteriormente, la búsqueda de productos para definir valores de reglas de promoción resultaba muy lenta en catálogos extensos, ya que no aprovechaba el módulo de indexación. Además, cuando el módulo de indexación estaba habilitado, las búsquedas de texto libre (`q`) no lograban encontrar productos basándose en el SKU de sus variantes, un comportamiento que sí funcionaba cuando el módulo de indexación estaba deshabilitado. Estos cambios mejoran significativamente el rendimiento de las búsquedas en las promociones y corrigen la regresión funcional de la búsqueda por SKU al usar el motor de índices.

### Prioridad

Alta

### Verificación

1.  **Búsqueda por SKU en productos (Index Engine activado)**:
    a. Asegurarse de que la característica `IndexEngineFeatureFlag` está habilitada.
    b. Crear un producto con una variante que tenga un SKU específico (ej. `SKU-TEST-123`).
    c. Realizar una petición a `/admin/products?q=SKU-TEST-123` (o `/store/products`).
    d. Verificar que el producto creado aparece en los resultados de la búsqueda.

2.  **Rendimiento y búsqueda en valores de reglas de promoción (Index Engine activado)**:
    a. Habilitar `IndexEngineFeatureFlag`.
    b. Realizar una petición al endpoint de opciones de valores de reglas de promoción configurado para buscar atributos de productos (`/admin/promotions/rule-value-options/product/...`).
    c. Incluir el parámetro `q` con un SKU válido.
    d. Verificar que la respuesta se obtiene rápidamente y contiene el producto correspondiente al SKU buscado.
    e. Comprobar que la respuesta incluye los campos de paginación adecuados (particularmente `count` mapeado a `estimate_count`).

### Estado

Borrador

### Versión

1.0
