### ID

REQ-APPWRITE-11033

### Nombre

API de gestión de webhooks

### Tipo

Funcional

### Descripción formal

El sistema deberá exponer endpoints de administración para crear, listar, actualizar y eliminar configuraciones de webhooks, permitiendo a los administradores definir URLs de destino, eventos suscritos y cabeceras personalizadas para cada webhook.

### Fuente

Release 1.9.0 (https://github.com/appwrite/appwrite/releases/tag/1.9.0), PR #11033 (https://github.com/appwrite/appwrite/pull/11033) y PR #11566 (https://github.com/appwrite/appwrite/pull/11566), entrada: "Webhooks API — First-class webhooks management endpoints for creating, listing, and managing webhook configurations".

### Rationale

Proporcionar una API de primera clase para la gestión de webhooks, eliminando la dependencia de configuración manual y permitiendo la automatización de integraciones externas.

### Prioridad

Alta

### Verificación

Crear una configuración de webhook mediante POST, listar las configuraciones existentes mediante GET, actualizar una configuración mediante PUT, eliminar una configuración mediante DELETE y verificar que cada operación modifica correctamente el estado de los webhooks registrados.

### Estado

Borrador

### Versión

1.0
