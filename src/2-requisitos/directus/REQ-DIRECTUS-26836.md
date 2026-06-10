### ID

REQ-DIRECTUS-26836

### Nombre

Implementar interfaz de grupo de campos en pestañas (Tabs)

### Tipo

Funcional

### Descripción formal

El sistema deberá proporcionar una nueva interfaz de grupo de campos denominada "Tabs" que permita organizar los campos de un formulario en una disposición de pestañas horizontales. Esta interfaz deberá cumplir con los siguientes criterios:

1.  **Navegación por teclado**: El usuario deberá poder navegar entre las pestañas utilizando las teclas de flecha izquierda y derecha, así como las teclas `Home` y `End` para ir a la primera y última pestaña, respectivamente.
2.  **Indicadores de cambio**: El sistema deberá mostrar un indicador visual (un punto) en la etiqueta de una pestaña si alguno de los campos contenidos en ella tiene cambios sin guardar.
3.  **Manejo de errores de validación**:
    *   Si ocurre un error de validación en un campo, el sistema deberá cambiar automáticamente a la pestaña que contiene dicho campo.
    *   Un indicador de error (icono de advertencia) deberá aparecer en la pestaña correspondiente.
    *   Al pasar el cursor sobre el indicador, un tooltip deberá mostrar todos los mensajes de error de validación para los campos de esa pestaña.
4.  **Ocultar pestañas**: Si un campo que define una pestaña está configurado como oculto (`hidden`), la pestaña correspondiente no deberá mostrarse en la interfaz.
5.  **Opción de ancho completo**: La interfaz deberá ofrecer una opción de configuración `fillWidth` que, al activarse, permita que el grupo de pestañas se expanda para ocupar todo el ancho disponible en el formulario.
6.  **Compatibilidad**: La interfaz deberá ser compatible con la edición colaborativa y el modo de comparación de revisiones (`diff`).

### Fuente

Pull Request #26836 (https://github.com/directus/directus/pull/26836)

### Rationale

La interfaz de grupo "Accordion" existente puede ser ineficiente para formularios con muchos grupos de campos, ya que requiere un desplazamiento vertical considerable. La nueva interfaz "Tabs" se introduce como una alternativa que organiza los campos de forma más compacta y horizontal, mejorando la usabilidad y la navegación en formularios complejos. Se basa en componentes de UI existentes para garantizar la accesibilidad (WAI-ARIA) y la coherencia con el resto del sistema.

### Prioridad

Media

### Verificación

1.  **Navegación**:
    a. Crear un formulario con un grupo de pestañas y varios campos en cada una.
    b. Verificar que se puede cambiar entre pestañas haciendo clic en ellas.
    c. Verificar que se puede navegar entre las pestañas usando las teclas de flecha, `Home` y `End`.

2.  **Indicador de cambios**:
    a. Modificar el valor de un campo dentro de una pestaña.
    b. Cambiar a otra pestaña y verificar que la pestaña con el campo modificado muestra un punto indicador de "editado".

3.  **Errores de validación**:
    a. Introducir un valor inválido en un campo de una pestaña no activa.
    b. Intentar guardar el formulario.
    c. Verificar que el sistema cambia automáticamente a la pestaña que contiene el error, muestra un icono de advertencia en la etiqueta de la pestaña y un tooltip con el mensaje de error al pasar el cursor sobre el icono.

4.  **Opción `fillWidth`**:
    a. Activar la opción `fillWidth` en la configuración de la interfaz.
    b. Verificar que el contenedor de las pestañas se expande para ocupar todo el ancho del formulario.

### Estado

Borrador

### Versión

1.0
