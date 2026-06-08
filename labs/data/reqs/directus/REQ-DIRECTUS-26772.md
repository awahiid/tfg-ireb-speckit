### ID

REQ-DIRECTUS-26772

### Nombre

Soporte de versiones en edición visual

### Tipo

Funcional

### Descripción formal

El sistema deberá integrar el soporte para versiones de contenido en el Editor Visual (`Visual Editor`), permitiendo la previsualización y edición de versiones en borrador (`draft`) y locales. El sistema deberá:

1.  **Selección de versión**: Permitir seleccionar la versión de contenido activa (incluyendo la versión "Draft" global) en la interfaz del Editor Visual, siempre que la colección tenga habilitado el versionado, existan plantillas de URL de previsualización que soporten el parámetro de versión (`{{$version}}`), y el usuario tenga permisos de lectura sobre la colección `directus_versions`.
2.  **Inyección de URL**: Resolver y actualizar la URL de previsualización dinámica inyectando la clave de la versión seleccionada (o `main` si no hay versión) en los marcadores de posición correspondientes (ej. `{{$version}}`).
3.  **Restricciones de edición por versión y permisos**: Restringir las acciones de edición de campos dentro de la capa de edición (`EditingLayer`) basándose en los permisos del usuario y el estado de la versión:
    *   Si se previsualiza una versión específica (no `main`), solo se habilitarán los elementos editables si el usuario tiene permisos de edición de versiones (`update` o `create` en `directus_versions`), o si es administrador.
    *   Las comprobaciones de acceso a los campos (`checkFieldAccess`) deberán respetar estos permisos de versión y los permisos de actualización (`update`) del usuario sobre campos específicos de la colección en la versión seleccionada.
4.  **Colaboración y versiones**: Soportar la edición colaborativa sobre las versiones, asegurándose de que la versión global de borrador (`draft`) que aún no ha sido guardada en la base de datos (con ID interno `+`) no active conexiones de websockets colaborativas prematuras, impidiendo errores de sincronización.
5.  **Flujo de versiones reservadas**: Deshabilitar las acciones de "Promocionar" y "Descartar/Eliminar" cuando la versión actualmente creada o previsualizada sea una versión nueva no guardada (con ID `+`). Así mismo, se deberá deshabilitar la creación o el renombrado de versiones locales si se intenta utilizar una clave reservada de versión global (como `draft`).

### Fuente

Pull Request #26772 (https://github.com/directus/directus/pull/26772), Issue CMS-1873 (https://linear.app/directus/issue/CMS-1873/merge-featversions-for-visual-editor-to-main-with-regression-audit)

### Rationale

Antes de esta implementación, el Editor Visual estaba limitado únicamente al contenido de la versión principal (`main`). Los usuarios no podían previsualizar ni editar los cambios que estaban preparando en versiones de borrador o en otras ramas de revisión antes de publicarlos. Esta integración extiende el flujo de trabajo de versionado de Directus a la experiencia de edición visual, permitiendo a los creadores de contenido ver exactamente cómo se verán sus cambios en el contexto del sitio final antes de promoverlos, al tiempo que refuerza la seguridad y la consistencia validando los permisos y previniendo conflictos de edición en versiones no inicializadas.

### Prioridad

Alta

### Verificación

1.  **Previsualización de versión `draft`**:
    a. Habilitar el versionado en una colección y configurar una URL de previsualización para el Editor Visual que incluya el parámetro de versión (ej. `https://example.com/preview?version={{$version}}`).
    b. Abrir un elemento existente en el Editor Visual.
    c. Seleccionar la versión "Draft" desde el menú selector de versiones en la interfaz del Editor Visual.
    d. Verificar que el iFrame carga la URL correcta con el parámetro `?version=draft` y que el contenido reflejado corresponde al estado de ese borrador.

2.  **Edición restringida por permisos de versión**:
    a. Acceder con un usuario que tenga permisos de lectura (`read`) pero no de creación/edición (`create`/`update`) en la colección `directus_versions`.
    b. Abrir el Editor Visual en una versión distinta a la principal.
    c. Verificar que los elementos dentro del iFrame no son interactivos/editables (se filtran los elementos activos debido a la falta de permisos).

3.  **Prevención de uso de clave reservada**:
    a. Como usuario con permisos, en un elemento, intentar crear una nueva versión de contenido (o renombrar una existente) utilizando la clave `draft`.
    b. Verificar que el botón de guardado se deshabilita y se muestra un tooltip indicando que la clave está reservada.

4.  **Comportamiento de websockets para nueva versión**:
    a. Seleccionar una nueva versión "Draft" que aún no ha sido guardada explícitamente.
    b. Verificar en la consola de red/herramientas de desarrollador que no se establecen intentos fallidos de conexión websocket colaborativa usando el ID provisional `+`.

### Estado

Borrador

### Versión

1.0
