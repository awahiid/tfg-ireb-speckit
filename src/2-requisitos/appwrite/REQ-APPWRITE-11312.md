### ID

REQ-APPWRITE-11312

### Nombre

Soporte de MongoDB como motor de base de datos

### Tipo

Funcional

### Descripción formal

El sistema deberá permitir que los proyectos de Appwrite utilicen MongoDB como motor de base de datos subyacente, ofreciendo la misma API de documentos que con el motor por defecto, incluyendo operaciones CRUD sobre colecciones y documentos.

### Fuente

Release 1.9.0 (https://github.com/appwrite/appwrite/releases/tag/1.9.0), PR #11312 (https://github.com/appwrite/appwrite/pull/11312), entrada: "MongoDB support".

### Rationale

Ampliar la flexibilidad de despliegue permitiendo a los usuarios elegir el motor de base de datos que mejor se adapte a sus necesidades de infraestructura y rendimiento.

### Prioridad

Media

### Verificación

Crear un proyecto configurado con MongoDB, realizar operaciones CRUD sobre documentos a través de la API estándar de Appwrite y verificar que las operaciones se reflejan correctamente en la base de datos MongoDB subyacente.

### Estado

Borrador

### Versión

1.0
