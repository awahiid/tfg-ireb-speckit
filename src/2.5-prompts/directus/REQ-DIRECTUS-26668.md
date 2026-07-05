### REQ-DIRECTUS-26668 — Codificación de claves primarias en URL para comparación de elementos

**MRS:**

> Como cliente de la API,
quiero que el sistema codifice correctamente (URL encoding) el identificador del elemento (clave primaria) al construir la URL para realizar peticiones a la API al recuperar la versión principal (`main`) de un elemento durante el proceso de comparación de revisiones. Específicamente, cualquier carácter especial presente en una clave primaria manual debe ser...,
a traves de `main`,
para anteriormente, el sistema concatenaba el identificador del elemento directamente en la URL sin codificarlo.
Fuente: PR #26668
