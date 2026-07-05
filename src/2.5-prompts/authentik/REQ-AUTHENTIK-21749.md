### REQ-AUTHENTIK-21749 — Prevención de auto-configuración de redirect_uri

**MRS:**

> Como usuario autenticado,
quiero que el sistema no guarde ni configurar automáticamente el parámetro `redirect_uri` proporcionado en una solicitud de autorización OAuth2 en la lista de URLs permitidas del proveedor (OAuth2Provider) cuando este tenga su lista `redirect_uris` vacía, debiendo tratarlo siempre de acuerdo a la lógica estricta de validación y fallando si la URL no está previamente...,
a traves de `redirect_uri`,
para evitar que la primera petición de autorización en un proveedor sin configurar modifique de forma transparente y persistente su configuración de seguridad estableciendo la URL recibida como un destino válido (`RedirectURIMatchingMode.
Fuente: PR #21749
