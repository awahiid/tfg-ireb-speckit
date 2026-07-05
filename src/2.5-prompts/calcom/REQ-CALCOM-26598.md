### REQ-CALCOM-26598 — Bloquear vinculación OAuth para cuentas no verificadas

**MRS:**

> Como usuario autenticado,
quiero que el sistema impida que una cuenta de Cal.com cuyo correo electrónico no ha sido verificado (`emailVerified: false`) se vincule a un proveedor de identidad OAuth (Google o SAML),
a traves de `emailVerified: false`,
para permitir que una cuenta no verificada se vincule a un proveedor de OAuth crea una vulnerabilidad de seguridad conocida como "pre-hijacking".
Fuente: PR #26598
