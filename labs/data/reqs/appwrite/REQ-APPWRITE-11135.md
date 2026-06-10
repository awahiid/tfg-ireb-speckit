### ID

REQ-APPWRITE-11135

### Nombre

Parámetros de cifrado y compresión por archivo

### Tipo

Funcional

### Descripción formal

El sistema deberá permitir que al subir un archivo se especifiquen parámetros de cifrado y compresión por archivo individual, aplicando las transformaciones configuradas antes de almacenar el archivo en el sistema de almacenamiento.

### Fuente

Release 1.9.0 (https://github.com/appwrite/appwrite/releases/tag/1.9.0), PR #11135 (https://github.com/appwrite/appwrite/pull/11135), entrada: "File encryption/compression parameters — Configure per-file encryption and compression".

### Rationale

Ofrecer control granular sobre la seguridad y el uso de espacio de almacenamiento, permitiendo decisiones distintas por archivo en función de su sensibilidad o tamaño.

### Prioridad

Media

### Verificación

Subir un archivo con el parámetro de cifrado activado, recuperar el archivo directamente del almacenamiento subyacente y verificar que los datos están cifrados. Subir otro archivo con el parámetro de compresión activado y verificar que el tamaño almacenado es menor que el original.

### Estado

Borrador

### Versión

1.0
