### ID

REQ-CALCOM-26428

### Nombre

Corregir el `sub` del JWT en el inicio de sesión SAML iniciado por IdP

### Tipo

Funcional (Integración)

### Descripción formal

El sistema debe garantizar que, durante un flujo de inicio de sesión SAML iniciado por el proveedor de identidad (IdP), el `sub` (subject) del token JWT se establezca con el ID de usuario numérico de la base de datos, en lugar del NameID (correo electrónico) proporcionado por el IdP. Para lograr esto, el objeto de usuario devuelto por el proveedor de credenciales `saml-idp` debe incluir tanto el NameID (como `id`) como el ID de usuario real (como `userId`). El callback del JWT debe ser modificado para sobrescribir explícitamente el campo `sub` del token con el valor de `userId` cuando el proveedor sea `saml-idp`.

### Fuente

Pull Request #26428 (https://github.com/calcom/cal.com/pull/26428)

### Rationale

El inicio de sesión SAML iniciado por IdP estaba fallando porque el `sub` del token JWT se estaba poblando con el correo electrónico del usuario (NameID), pero la sesión del servidor espera que este campo contenga el ID de usuario numérico. Esta discrepancia causaba un error de "session subject mismatch", impidiendo la creación de una sesión de usuario válida. La corrección alinea la estructura del token JWT con las expectativas del servidor, asegurando que el inicio de sesión se complete con éxito sin romper la compatibilidad con el flujo de SAML de BoxyHQ, que espera que el campo `id` siga siendo el NameID.

### Prioridad

Alta

### Verificación

1.  Configurar una integración SAML SSO con un proveedor de identidad (por ejemplo, Okta) donde el NameID esté configurado para ser el correo electrónico del usuario.
2.  Iniciar un flujo de inicio de sesión desde el panel del proveedor de identidad (IdP-initiated login).
3.  Verificar que el usuario es redirigido a Cal.com y se inicia una sesión correctamente.
4.  Inspeccionar el token JWT generado por la aplicación.
5.  Confirmar que el campo `sub` del token contiene el ID numérico del usuario y no su dirección de correo electrónico.

### Estado

Borrador

### Versión

1.0
