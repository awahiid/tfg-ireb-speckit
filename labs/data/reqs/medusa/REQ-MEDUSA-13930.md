### ID

REQ-MEDUSA-13930

### Nombre

Búsqueda de productos por SKU de variante en la API de administración

### Tipo

Funcional

### Descripción formal

El sistema deberá permitir la búsqueda de productos a través del endpoint de administración (`GET /admin/products`) utilizando el identificador de mantenimiento de existencias (SKU) de cualquiera de sus variantes. Al utilizar el parámetro de consulta de búsqueda libre (`q`), el sistema deberá:

1.  **Búsqueda transversal**: Extender el alcance de la búsqueda de texto libre no solo a los campos del producto (título, subtítulo, descripción), sino también a los campos indexados de sus variantes (`sku`, `title`, `barcode`, `ean`, `upc`).
2.  **Coincidencia parcial y exacta**: Soportar tanto coincidencias exactas como parciales del término de búsqueda en el SKU (ej. buscar `ABC` deberá devolver productos con variantes cuyo SKU sea `ABC-123`).
3.  **Insensibilidad a mayúsculas y minúsculas**: Realizar la búsqueda ignorando diferencias entre mayúsculas y minúsculas (case-insensitive).
4.  **Respuesta integral**: Retornar el producto completo, incluyendo todas sus variantes, si al menos una de las variantes del producto coincide con el término de búsqueda proporcionado.

### Fuente

Pull Request #13930 (https://github.com/medusajs/medusa/pull/13930), Issue #15239 (https://github.com/medusajs/medusa/issues/15239)

### Rationale

En versiones anteriores (v2), la búsqueda de productos en la API de administración no consideraba el SKU de las variantes del producto, una funcionalidad crítica presente en la versión 1. Integraciones con Sistemas de Gestión de Almacenes (WMS), sistemas ERP y operaciones internas dependen del SKU como identificador principal. Al habilitar la búsqueda transversal hacia los campos de las variantes, se restaura esta funcionalidad esencial, permitiendo a los representantes de atención al cliente y administradores de inventario localizar productos eficientemente utilizando sus códigos de barras o SKUs.

### Prioridad

Alta

### Verificación

1.  **Coincidencia exacta de SKU**:
    a. Crear un producto con una variante que posea un SKU único (ej. `SKU-UNICO-123`).
    b. Realizar una petición a `GET /admin/products?q=SKU-UNICO-123`.
    c. Verificar que el producto creado se devuelve en los resultados.

2.  **Coincidencia parcial y multi-variante**:
    a. Crear un producto con dos variantes: una con SKU `PARCIAL-TEST-1` y otra con SKU `OTRO-SKU-2`.
    b. Realizar una petición a `GET /admin/products?q=TEST`.
    c. Verificar que se devuelve el producto y que el objeto del producto incluye ambas variantes.

3.  **Insensibilidad a mayúsculas/minúsculas**:
    a. Crear un producto con una variante cuyo SKU sea `MAsCula-123`.
    b. Realizar una petición a `GET /admin/products?q=mascula-123`.
    c. Verificar que el producto se devuelve en los resultados.

4.  **Búsqueda no existente**:
    a. Realizar una petición con un SKU o término que no exista en el sistema (`GET /admin/products?q=SKU-INEXISTENTE`).
    b. Verificar que la respuesta devuelve una lista vacía de productos (`products: []`).

### Estado

Borrador

### Versión

1.0
