### REQ-APPWRITE-11465 — Actualización dispersa de documentos

**MRS:**

> Como usuario del sistema,
quiero que el sistema envie únicamente los atributos modificados al actualizar un documento mediante la operación updateDocument, omitiendo del payload los campos cuyo valor no ha cambiado respecto al estado almacenado,
para optimizar el uso de ancho de banda y reducir el riesgo de sobrescritura accidental de atributos no modificados durante actualizaciones parciales de documentos.
Fuente: PR #11465

**Notas de derivacion:** No se identifico artefacto tecnico nombrable; se omite clausula de contexto
