### ID

REQ-DIRECTUS-26676

### Nombre

Habilitar estado no editable para campos relacionales con permisos personalizados

### Tipo

Funcional

### Descripción formal

El sistema deberá, para elementos existentes en colecciones con permisos de acceso parcial (`access: 'partial'`), evaluar los permisos del elemento (`fetchedItemPermissions`) para determinar si el elemento cumple con las reglas personalizadas. Si un elemento existente no cumple con las reglas de permisos personalizadas, el sistema deberá marcar todos sus campos como de solo lectura (`readonly: true`) y no editables (`non_editable: true`). Esto permitirá que las interfaces de campos relacionales (Many-to-One, One-to-Many, Many-to-Many) abran el cajón de edición en modo de solo lectura, en lugar de estar completamente inoperativas.

### Fuente

Pull Request #26676 (https://github.com/directus/directus/pull/26676), Issue #26670

### Rationale

La regresión anterior hacía que los campos relacionales fueran completamente inaccesibles (inertes) para los usuarios sin permisos de edición en elementos que fallaban las reglas de permisos personalizados. Esto impedía la visualización de datos relacionados. Al cambiar el estado a "no editable" en lugar de "deshabilitado", se permite a los usuarios ver el contenido relacionado en modo de solo lectura, mejorando la usabilidad sin comprometer la seguridad.

### Prioridad

Alta

### Verificación

1.  **Configuración de permisos**:
    a. Crear una colección con un campo relacional (ej. Many-to-One).
    b. Configurar un rol de usuario con permisos de acceso parcial (`access: 'partial'`) en esta colección, con una regla personalizada que restrinja el acceso a ciertos elementos (ej. `status = 'draft'`).
    c. Asegurarse de que el rol no tenga permisos de actualización (`update`) en la colección.
2.  **Elemento que falla la regla**:
    a. Crear un elemento en la colección que *no* cumpla con la regla personalizada (ej. `status = 'published'`).
    b. Iniciar sesión con el usuario configurado en el paso 1.
    c. Intentar abrir el elemento.
    d. Verificar que todos los campos del elemento se muestran como no editables (no se pueden modificar).
    e. Intentar abrir el campo relacional (ej. haciendo clic en el botón "Edit" o "View" del campo M2O).
    f. Verificar que el cajón del elemento relacionado se abre en modo de solo lectura, permitiendo ver el contenido pero no modificarlo.
3.  **Elemento que pasa la regla**:
    a. Crear un elemento en la colección que *sí* cumpla con la regla personalizada (ej. `status = 'draft'`).
    b. Iniciar sesión con el mismo usuario.
    c. Intentar abrir el elemento.
    d. Verificar que los campos se muestran editables según los permisos de campo del rol.

### Estado

Borrador

### Versión

1.0
