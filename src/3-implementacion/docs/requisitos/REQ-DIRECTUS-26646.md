# REQ-DIRECTUS-26646

| Atributo       | Valor                                                                                             |
| -------------- | ------------------------------------------------------------------------------------------------- |
| **ID**         | REQ-DIRECTUS-26646                                                                                |
| **Name**       | Restricción de tipos MIME en la interfaz de subida de archivos                                   |
| **Type**       | Functional                                                                                        |
| **Description**| El sistema deberá restringir la selección de archivos en la interfaz de subida del sistema basándose en la lista de tipos MIME permitidos configurada en el servidor (a través de la variable de entorno correspondiente, como `FILES_MIME_TYPE_ALLOW_LIST`). El sistema deberá exponer esta configuración a la aplicación cliente y aplicarla directamente en el control de subida de archivos del navegador (como atributo `accept`). Esto asegurará que, al abrir la ventana de diálogo para seleccionar archivos, el sistema operativo del usuario solo permita elegir archivos que coincidan con los tipos MIME especificados. Si la lista de tipos permitidos no está definida o está configurada como `*/*`, el control de subida permitirá seleccionar cualquier tipo de archivo. |
| **Source**     | Pull Request #26646 (https://github.com/directus/directus/pull/26646, commit pending fijar tras revisión), Issue CMS-1679 (https://linear.app/directus/issue/CMS-1679/add-mime-type-restriction-to-system-upload-interface) |
| **Rationale**  | Anteriormente, la restricción de tipos MIME solo se aplicaba y verificaba en el lado del servidor (API). Como resultado, la interfaz de usuario permitía al usuario seleccionar y enviar cualquier tipo de archivo, y solo recibía un error una vez que el archivo llegaba al backend y era rechazado. Obtener la lista de tipos permitidos desde el servidor y aplicarla en el cliente mejora significativamente la experiencia del usuario, al evitar que seleccione proactivamente archivos no permitidos y fallos innecesarios durante el proceso de carga. |
| **Priority**   | Media                                                                                             |
| **Verification**| 1. **Restricción activa**: a. Configurar el servidor con una lista restrictiva de tipos MIME (por ejemplo, `FILES_MIME_TYPE_ALLOW_LIST=audio/*,image/*`). b. Iniciar sesión en la aplicación cliente y abrir el diálogo para subir un nuevo archivo al sistema. c. Verificar que, en la ventana de selección de archivos del sistema operativo, solo los archivos de audio y las imágenes están habilitados y pueden ser seleccionados; los demás tipos de archivo deben aparecer deshabilitados o no seleccionables. 2. **Sin restricción (todos permitidos)**: a. Configurar el servidor para permitir cualquier tipo de archivo (por ejemplo, sin la variable de entorno, o con `FILES_MIME_TYPE_ALLOW_LIST=*/*`). b. Iniciar sesión en la aplicación cliente y abrir el diálogo para subir un archivo. c. Verificar que el selector de archivos del sistema operativo permite seleccionar cualquier tipo de archivo. |
| **Status**     | Draft                                                                                             |
| **Version**    | 1.0                                                                                               |
| **Dependencies**| Servidor: variable de entorno `FILES_MIME_TYPE_ALLOW_LIST`; API: endpoint que exponga la configuración al cliente; Cliente: componente de subida de archivos que aplique el atributo `accept`. |
| **Module**     | System Upload Interface                                                                           |

---

## Metadatos IREB

- **Artículo I (Verificabilidad)**: ✅ — dos escenarios con pasos observables.
- **Artículo II (Minimalidad funcional)**: ✅ — solo expone y aplica lo configurado; no añade lógica especulativa.
- **Artículo III (Trazabilidad completa)**: ✅ — origen en PR #26646 e Issue CMS-1679.
- **Artículo IV (Clasificación)**: **Functional** — describe un comportamiento del sistema (restringir selección de archivos) que produce un resultado observable.
- **Artículo V (Sin ambigüedad)**: ✅ — términos medibles: `accept`, `FILES_MIME_TYPE_ALLOW_LIST`, `*/*`, comportamientos definidos por caso.
- **Artículo VI (Obligación única)**: ⚠️ — violación documentada: la descripción contiene dos obligaciones (exponer configuración + aplicar `accept`), pero son causalmente dependientes. Se mantienen como sub-obligaciones de un mismo REQ-ID. Ver `TRACEABILITY-MATRIX.md` §3 Brecha 2 y `PLAN-DIRECTUS-26646.md` Complexity Tracking.
- **Artículo VII (Fuente documentada)**: ✅ — URL y referencia del PR e Issue.
- **Artículo VIII (Rationale)**: ✅ — mejora de UX al evitar rechazos en backend.
- **Artículo IX (QA continuo)**: ✅ — verificable en cada despliegue mediante los escenarios descritos.
