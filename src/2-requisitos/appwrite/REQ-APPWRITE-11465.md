### ID

REQ-APPWRITE-11465

### Nombre

Actualización dispersa de documentos

### Tipo

Funcional

### Descripción formal

El sistema deberá enviar únicamente los atributos modificados al actualizar un documento mediante la operación updateDocument, omitiendo del payload los campos cuyo valor no ha cambiado respecto al estado almacenado.

### Fuente

Release 1.9.0 (https://github.com/appwrite/appwrite/releases/tag/1.9.0), PR #11465 (https://github.com/appwrite/appwrite/pull/11465), entrada: "Sparse document updates — updateDocument() sends only changed attributes".

### Rationale

Optimizar el uso de ancho de banda y reducir el riesgo de sobrescritura accidental de atributos no modificados durante actualizaciones parciales de documentos.

### Prioridad

Media

### Verificación

Crear un documento con múltiples atributos, modificar un único atributo mediante updateDocument, inspeccionar el payload de red y verificar que solo contiene el atributo modificado. Verificar también que los atributos no modificados conservan su valor original.

### Estado

Borrador

### Versión

1.0
