### REQ-CALCOM-26286 — Validar el correo electrónico del propietario en la creación de organizaciones de plataforma

**MRS:**

> Como administrador del sistema,
quiero que el sistema valide que el correo electrónico del propietario (`orgOwnerEmail`) de una nueva organización de tipo plataforma (`isPlatform: true`) corresponde al del usuario que está realizando la creación. Se debe eliminar la excepción que permitía a la bandera `isPlatform` omitir esta verificación,
a traves de `orgOwnerEmail`,
para la omisión de la validación del propietario para las organizaciones de plataforma representaba una vulnerabilidad de seguridad.
Fuente: PR #26286
