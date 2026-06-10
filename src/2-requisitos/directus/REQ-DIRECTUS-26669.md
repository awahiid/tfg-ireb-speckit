### ID

REQ-DIRECTUS-26669

### Nombre

Corrección de la lógica de deshabilitación de la interfaz de traducción

### Tipo

Funcional

### Descripción formal

El sistema deberá asegurar que la interfaz de traducción se deshabilita de forma granular, basándose en los permisos del usuario:

1.  **Deshabilitación completa de la interfaz**: La interfaz de traducción completa (incluyendo campos de entrada y controles de edición) deberá deshabilitarse únicamente cuando el usuario no tenga permisos para guardar cambios (`!isSaveAllowed`) en la colección de traducciones.
2.  **Deshabilitación del botón de eliminar**: El botón específico para eliminar traducciones dentro de la interfaz deberá deshabilitarse de forma independiente cuando el usuario no tenga permisos para eliminar (`!deleteAllowed`) en la colección de traducciones.

### Fuente

Pull Request #26669 (https://github.com/directus/directus/pull/26669), Issue CMS-1818

### Rationale

Una regresión anterior causaba que toda la interfaz de traducción se deshabilitara si el usuario carecía de permisos para eliminar, incluso si tenía permisos para editar y guardar traducciones. Esto impedía a los usuarios realizar su trabajo de traducción. Esta corrección restablece el comportamiento esperado, permitiendo a los usuarios con permisos de edición modificar traducciones, incluso si no pueden eliminarlas, lo que mejora la usabilidad y respeta la granularidad de los permisos.

### Prioridad

Alta

### Verificación

1.  **Usuario sin permiso de guardar**:
    a. Configurar un usuario sin permisos para guardar cambios en la colección de traducciones.
    b. Acceder a la interfaz de traducción.
    c. Verificar que toda la interfaz de traducción (campos de texto, botones de añadir/editar) está deshabilitada y no permite la interacción.

2.  **Usuario con permiso de guardar, pero sin permiso de eliminar**:
    a. Configurar un usuario con permisos para guardar cambios en la colección de traducciones, pero sin permisos para eliminar traducciones.
    b. Acceder a la interfaz de traducción.
    c. Verificar que la interfaz de traducción está habilitada para la edición y permite modificar y guardar traducciones.
    d. Verificar que el botón de eliminar traducciones está deshabilitado y no permite la acción.

3.  **Usuario con permiso de guardar y eliminar**:
    a. Configurar un usuario con permisos para guardar y eliminar traducciones.
    b. Acceder a la interfaz de traducción.
    c. Verificar que toda la interfaz de traducción está habilitada, incluyendo el botón de eliminar.

### Estado

Borrador

### Versión

1.0
