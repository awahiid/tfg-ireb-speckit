### REQ-MEDUSA-15386 — Búsqueda indexada por SKU en opciones de valores de promociones y endpoint de productos

**MRS:**

> Como administrador del sistema,
quiero que el sistema optimice la búsqueda de productos en el endpoint de opciones de valores de reglas de promoción (`rule-value-options`) y en los endpoints de listado de productos (`/admin/products` y `/store/products`), utilizando el módulo de indexación (`IndexEngine`) cuando este esté habilitado,
a traves de `rule-value-options`,
para anteriormente, la búsqueda de productos para definir valores de reglas de promoción resultaba muy lenta en catálogos extensos, ya que no aprovechaba el módulo de indexación.

Restriccion: si no existe previamente
Fuente: PR #15386
