### REQ-APPWRITE-10986 — Verificación de email obligatoria al vincular OAuth2

**MRS:**

> Como usuario autenticado,
quiero que el sistema rechace la vinculación de un proveedor OAuth2 a una cuenta de usuario cuando la dirección de correo electrónico asociada no haya sido verificada previamente, impidiendo la operación de enlace hasta que el email esté verificado,
para evitar que identidades externas se vinculen a cuentas cuya propiedad no ha sido validada, cerrando un vector de suplantación de identidad mediante proveedores OAuth.
Fuente: PR #10986

**Notas de derivacion:** No se identifico artefacto tecnico nombrable; se omite clausula de contexto
