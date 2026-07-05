### REQ-DIRECTUS-26676 — Habilitar estado no editable para campos relacionales con permisos personalizados

**MRS:**

> Como usuario del sistema,
quiero que el sistema El sistema deberá, para elementos existentes en colecciones con permisos de acceso parcial (`access: 'partial'`), evaluar los permisos del elemento (`fetchedItemPermissions`) para determinar si el elemento cumple con las reglas personalizadas,
a traves de `access: 'partial'`,
para la regresión anterior hacía que los campos relacionales fueran completamente inaccesibles (inertes) para los usuarios sin permisos de edición en elementos que fallaban las reglas de permisos personalizados.
Fuente: PR #26676
