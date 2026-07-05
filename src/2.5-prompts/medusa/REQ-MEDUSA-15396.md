### REQ-MEDUSA-15396 — Notificación de códigos promocionales omitidos por límites

**MRS:**

> Como administrador de comercio,
quiero que el sistema devuelva un array denominado `skipped_promo_codes` en la respuesta al aplicar o actualizar códigos promocionales en un carrito, detallando los códigos que no pudieron ser aplicados debido a restricciones de límite o presupuesto. Cada elemento de este array deberá contener el código omitido (`code`) y el motivo de su omisión (`reason`). Los...,
a traves de `skipped_promo_codes`,
para anteriormente, el sistema omitía silenciosamente los códigos promocionales que no podían ser aplicados por haber superado sus límites de uso o el presupuesto de su campaña.
Fuente: PR #15396
