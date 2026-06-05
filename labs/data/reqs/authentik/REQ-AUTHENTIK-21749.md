### ID

REQ-AUTHENTIK-21749

### Nombre

Prevención de auto-configuración de redirect_uri

### Tipo

Funcional

### Descripción formal

El sistema no deberá guardar ni configurar automáticamente el parámetro `redirect_uri` proporcionado en una solicitud de autorización OAuth2 en la lista de URLs permitidas del proveedor (OAuth2Provider) cuando este tenga su lista `redirect_uris` vacía, debiendo tratarlo siempre de acuerdo a la lógica estricta de validación y fallando si la URL no está previamente autorizada explícitamente.

### Fuente

Pull Request #21749 (https://github.com/goauthentik/authentik/pull/21749) y PR original #21746.

### Rationale

Evitar que la primera petición de autorización en un proveedor sin configurar modifique de forma transparente y persistente su configuración de seguridad estableciendo la URL recibida como un destino válido (`RedirectURIMatchingMode.STRICT`), previniendo posibles brechas de seguridad y obligando al administrador a configurar explícitamente las URLs permitidas.

### Prioridad

Alta

### Verificación

Validación mediante ejecución de tests (`test_authorize.py`), verificando que se ha eliminado la aserción anterior (`test_invalid_redirect_uri_empty`) y que una petición con `redirect_uri` no autorizado hacia un proveedor OAuth2 sin URLs configuradas levanta una excepción `RedirectUriError` sin alterar el modelo de base de datos del proveedor (`provider.redirect_uris`).

### Estado

Borrador

### Versión

1.0