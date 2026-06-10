### ID

REQ-APPWRITE-11533

### Nombre

Impersonación de usuarios por administradores

### Tipo

Funcional

### Descripción formal

El sistema deberá permitir que un administrador autenticado asuma la identidad de un usuario del proyecto con fines de depuración y soporte, registrando cada operación de impersonación en el log de auditoría.

### Fuente

Release 1.9.0 (https://github.com/appwrite/appwrite/releases/tag/1.9.0), PR #11533 (https://github.com/appwrite/appwrite/pull/11533), entrada: "User impersonation — Admins can now impersonate users for debugging and support".

### Rationale

Facilitar la resolución de incidencias permitiendo al equipo de soporte reproducir el contexto exacto del usuario afectado sin necesidad de conocer sus credenciales.

### Prioridad

Media

### Verificación

Autenticarse como administrador, solicitar la impersonación de un usuario existente, verificar que las operaciones subsiguientes se ejecutan en el contexto del usuario impersonado, y comprobar que la acción queda registrada en el log de auditoría con el identificador del administrador y del usuario impersonado.

### Estado

Borrador

### Versión

1.0
