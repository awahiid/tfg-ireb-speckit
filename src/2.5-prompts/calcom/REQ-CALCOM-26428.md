### REQ-CALCOM-26428 — Corregir el `sub` del JWT en el inicio de sesión SAML iniciado por IdP

**MRS:**

> Como cliente de la API,
quiero que el sistema garantice que, durante un flujo de inicio de sesión SAML iniciado por el proveedor de identidad (IdP), el `sub` (subject) del token JWT se establezca con el ID de usuario numérico de la base de datos, en lugar del NameID (correo electrónico) proporcionado por el IdP,
a traves de `sub`,
para el inicio de sesión SAML iniciado por IdP estaba fallando porque el `sub` del token JWT se estaba poblando con el correo electrónico del usuario (NameID), pero la sesión del servidor espera que este campo contenga el ID de usuario numérico.
Fuente: PR #26428
