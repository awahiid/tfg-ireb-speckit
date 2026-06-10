### ID

REQ-APPWRITE-10986

### Nombre

Verificación de email obligatoria al vincular OAuth2

### Tipo

Funcional

### Descripción formal

El sistema deberá rechazar la vinculación de un proveedor OAuth2 a una cuenta de usuario cuando la dirección de correo electrónico asociada no haya sido verificada previamente, impidiendo la operación de enlace hasta que el email esté verificado.

### Fuente

Release 1.9.0 (https://github.com/appwrite/appwrite/releases/tag/1.9.0), PR #10986 (https://github.com/appwrite/appwrite/pull/10986), entrada: "OAuth email verification — Enforce email verification when linking OAuth2 providers".

### Rationale

Evitar que identidades externas se vinculen a cuentas cuya propiedad no ha sido validada, cerrando un vector de suplantación de identidad mediante proveedores OAuth.

### Prioridad

Alta

### Verificación

Intentar vincular un proveedor OAuth2 desde una cuenta con email no verificado, comprobar que la operación es rechazada con un código de error apropiado, verificar el email y repetir la vinculación comprobando que ahora es aceptada.

### Estado

Borrador

### Versión

1.0
