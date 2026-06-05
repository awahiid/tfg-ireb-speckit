### ID

REQ-CALCOM-26598

### Nombre

Bloquear vinculación OAuth para cuentas no verificadas

### Tipo

Funcional (Seguridad)

### Descripción formal

El sistema debe impedir que una cuenta de Cal.com cuyo correo electrónico no ha sido verificado (`emailVerified: false`) se vincule a un proveedor de identidad OAuth (Google o SAML). Si un usuario con una cuenta no verificada intenta iniciar sesión a través de OAuth, el proceso debe ser bloqueado y el usuario debe ser redirigido a una página de error que muestre el mensaje `unverified-email`.

### Fuente

Pull Request #26598 (https://github.com/calcom/cal.com/pull/26598)

### Rationale

Permitir que una cuenta no verificada se vincule a un proveedor de OAuth crea una vulnerabilidad de seguridad conocida como "pre-hijacking". Un atacante podría crear una cuenta con el correo electrónico de una víctima y, si la víctima luego intenta registrarse con OAuth, el atacante podría obtener control sobre la cuenta. Al exigir la verificación del correo electrónico antes de la vinculación, se mitiga este riesgo.

### Prioridad

Alta

### Verificación

1.  Habilitar la bandera de funcionalidad `email-verification`.
2.  Crear una nueva cuenta en Cal.com con un correo electrónico y contraseña, pero no realizar el paso de verificación de correo.
3.  Intentar iniciar sesión utilizando un proveedor OAuth (por ejemplo, Google) con el mismo correo electrónico.
4.  Verificar que el inicio de sesión se bloquea y se redirige a una página de error.
5.  Verificar que la página de error muestra un mensaje informativo que instruye al usuario a iniciar sesión con su contraseña para reenviar el correo de verificación.
6.  Iniciar sesión con la contraseña, verificar el correo electrónico y luego confirmar que el inicio de sesión con OAuth funciona correctamente.

### Estado

Borrador

### Versión

1.0
