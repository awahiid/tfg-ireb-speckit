### ID

REQ-APPWRITE-11174

### Nombre

Nuevos tipos de atributo string en esquema de base de datos

### Tipo

Funcional

### Descripción formal

El sistema deberá permitir la creación de atributos de tipo varchar, text, mediumtext y longtext en las colecciones de base de datos, validando los valores insertados contra el tipo y las restricciones de longitud definidas en el esquema.

### Fuente

Release 1.9.0 (https://github.com/appwrite/appwrite/releases/tag/1.9.0), PR #11174 (https://github.com/appwrite/appwrite/pull/11174), entrada: "String types — New varchar, text, mediumtext, and longtext attribute types".

### Rationale

Proporcionar tipos de datos string con diferente capacidad de almacenamiento para optimizar el uso de espacio y adaptarse a distintos casos de uso de contenido textual.

### Prioridad

Media

### Verificación

Crear una colección con atributos de cada uno de los cuatro tipos string, insertar documentos con valores de distinta longitud, verificar que valores que exceden la capacidad del tipo son rechazados y que valores válidos se almacenan correctamente.

### Estado

Borrador

### Versión

1.0
