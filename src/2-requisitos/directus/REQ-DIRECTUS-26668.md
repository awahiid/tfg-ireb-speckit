### ID

REQ-DIRECTUS-26668

### Nombre

Codificación de claves primarias en URL para comparación de elementos

### Tipo

Funcional

### Descripción formal

El sistema deberá codificar correctamente (URL encoding) el identificador del elemento (clave primaria) al construir la URL para realizar peticiones a la API al recuperar la versión principal (`main`) de un elemento durante el proceso de comparación de revisiones. Específicamente, cualquier carácter especial presente en una clave primaria manual debe ser procesado mediante la función estándar de codificación de componentes URI antes de adjuntarse a la ruta del endpoint (`/items/{coleccion}/{id}`).

### Fuente

Pull Request #26668 (https://github.com/directus/directus/pull/26668), Issue CMS-1828 (https://linear.app/directus/issue/CMS-1828/issue-retrieving-revisions-with-custom-id-with-special-characters)

### Rationale

Anteriormente, el sistema concatenaba el identificador del elemento directamente en la URL sin codificarlo. Esto provocaba fallos cuando la clave primaria (configurada manualmente) contenía caracteres especiales con significado semántico en URLs (como `#`, `?`, `/`, `&`). Por ejemplo, un identificador como `item#123` truncaría la petición en el símbolo `#`. Al codificar el componente URI, se asegura que el identificador completo y literal se transmita al servidor, permitiendo recuperar y comparar correctamente elementos con claves primarias arbitrarias.

### Prioridad

Media

### Verificación

1.  **Clave primaria con caracteres especiales**:
    a. Crear una colección en la que la clave primaria se pueda introducir manualmente (tipo string).
    b. Crear un elemento cuya clave primaria contenga caracteres especiales, por ejemplo, `test/key#123` o `item?id=456`.
    c. Realizar modificaciones en el elemento para generar revisiones.
    d. Acceder a la vista de revisiones y abrir la comparación de elementos (`Revisions Sidebar -> Compare`).
    e. Comprobar que la vista de comparación se carga correctamente y muestra las diferencias sin arrojar errores de red o de aplicación.

### Estado

Borrador

### Versión

1.0
