### ID

REQ-DIRECTUS-26886

### Nombre

Eliminación en lote de carpetas con opciones de contenido

### Tipo

Funcional

### Descripción formal

El sistema deberá permitir la selección y eliminación de una o varias carpetas desde la vista de cuadrícula de archivos. Al iniciar la acción de eliminación, el sistema deberá presentar un diálogo con las siguientes dos opciones para gestionar el contenido de las carpetas a eliminar:

1.  **Mover contenido un nivel hacia arriba**: Si se elige esta opción, el sistema deberá mover todos los archivos y subcarpetas contenidos directamente dentro de las carpetas seleccionadas a la carpeta padre de estas, antes de eliminar las carpetas seleccionadas.
2.  **Eliminar todo el contenido**: Si se elige esta opción, el sistema deberá eliminar recursivamente todas las subcarpetas y archivos contenidos en las carpetas seleccionadas, en todos los niveles de anidamiento, y finalmente eliminar las carpetas seleccionadas.

El sistema también deberá permitir la selección mixta de archivos y carpetas. Si en la selección hay al menos una carpeta, se deberá mostrar el diálogo con las dos opciones de eliminación. Si solo se seleccionan archivos, se deberá mostrar un diálogo de confirmación simple.

### Fuente

Pull Request #26886 (https://github.com/directus/directus/pull/26886)

### Rationale

Anteriormente, la eliminación de carpetas era una acción individual y no ofrecía control sobre qué hacer con su contenido, lo que podía llevar a la pérdida accidental de datos o requerir un tedioso trabajo manual para mover los archivos antes de la eliminación. Esta funcionalidad introduce una capacidad de gestión en lote muy necesaria y proporciona a los usuarios un control explícito y seguro sobre el destino del contenido de las carpetas, mejorando significativamente la eficiencia y la seguridad en la gestión de archivos.

### Prioridad

Alta

### Verificación

1.  **Eliminación con "Mover contenido"**:
    a. Crear una carpeta con archivos y subcarpetas.
    b. Seleccionar la carpeta y elegir la opción de eliminar.
    c. En el diálogo, seleccionar "Mover contenido un nivel hacia arriba" y confirmar.
    d. Verificar que la carpeta ha sido eliminada y que su contenido (archivos y subcarpetas) ahora se encuentra en el nivel superior (la carpeta padre de la carpeta eliminada).

2.  **Eliminación con "Eliminar todo el contenido"**:
    a. Crear una carpeta con archivos y subcarpetas anidadas.
    b. Seleccionar la carpeta y elegir la opción de eliminar.
    c. En el diálogo, seleccionar "Eliminar todo el contenido" y confirmar.
    d. Verificar que tanto la carpeta seleccionada como todo su contenido (archivos y subcarpetas en todos los niveles) han sido eliminados permanentemente.

3.  **Eliminación en lote**:
    a. Seleccionar múltiples carpetas a la vez.
    b. Repetir las pruebas 1 y 2 y verificar que la acción se aplica correctamente a todas las carpetas seleccionadas y su respectivo contenido.

4.  **Selección mixta (archivos y carpetas)**:
    a. Seleccionar una combinación de archivos y al menos una carpeta.
    b. Iniciar la eliminación y verificar que se muestra el diálogo con las dos opciones de contenido.
    c. Confirmar la acción y verificar que tanto los archivos seleccionados como las carpetas (y su contenido, según la opción elegida) son eliminados.

### Estado

Borrador

### Versión

1.0
