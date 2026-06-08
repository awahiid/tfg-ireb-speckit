### ID

REQ-MEDUSA-15396

### Nombre

Notificación de códigos promocionales omitidos por límites

### Tipo

Funcional

### Descripción formal

El sistema deberá devolver un array denominado `skipped_promo_codes` en la respuesta al aplicar o actualizar códigos promocionales en un carrito, detallando los códigos que no pudieron ser aplicados debido a restricciones de límite o presupuesto. Cada elemento de este array deberá contener el código omitido (`code`) y el motivo de su omisión (`reason`). Los motivos soportados deberán ser `promotion_limit_exceeded` (cuando el código promocional ha alcanzado su límite de uso) y `campaign_budget_exceeded` (cuando la campaña asociada a la promoción ha agotado su presupuesto).

### Fuente

Pull Request #15396 (https://github.com/medusajs/medusa/pull/15396)

### Rationale

Anteriormente, el sistema omitía silenciosamente los códigos promocionales que no podían ser aplicados por haber superado sus límites de uso o el presupuesto de su campaña. Exponer esta información explícitamente en la respuesta de la API permite a los clientes (como el frontend de una tienda de e-commerce) informar al usuario final sobre por qué un código no fue aplicado, mejorando la transparencia y la experiencia de compra.

### Prioridad

Media

### Verificación

1.  **Límite de uso de promoción excedido**:
    a. Configurar un código promocional (`code`) con un límite de uso configurado y agotado.
    b. Intentar aplicar el código promocional a un carrito mediante la API de actualización de promociones del carrito.
    c. Verificar que la respuesta contiene el campo `skipped_promo_codes` incluyendo un objeto con dicho código y el motivo `promotion_limit_exceeded`.

2.  **Presupuesto de campaña agotado**:
    a. Configurar una campaña con un presupuesto de uso y agotarlo.
    b. Configurar un código promocional asociado a esa campaña.
    c. Intentar aplicar el código promocional a un carrito.
    d. Verificar que la respuesta contiene el campo `skipped_promo_codes` incluyendo el código y el motivo `campaign_budget_exceeded`.

3.  **Aplicación exitosa sin omisiones**:
    a. Intentar aplicar un código promocional válido que tenga usos disponibles y presupuesto.
    b. Verificar que la respuesta contiene el campo `skipped_promo_codes` como un array vacío `[]`.

4.  **Respuesta mixta**:
    a. Intentar aplicar simultáneamente un código promocional válido y uno que exceda su límite de uso.
    b. Verificar que el código válido se aplica correctamente al carrito, mientras que el campo `skipped_promo_codes` reporta únicamente el código inválido con el motivo correspondiente.

### Estado

Borrador

### Versión

1.0
