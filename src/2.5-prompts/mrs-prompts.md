# MRS Prompts — Pipeline IREB/SpecKit

**Generado**: 2026-06-26
**Repositorios procesados**: 6
**Instrucciones de derivacion**: [`instrucciones.md`](./instrucciones.md)

---

## APPWRITE

### REQ-APPWRITE-10832 — Caché de listados de documentos con TTL configurable

**MRS:**

> Como usuario del sistema,
quiero que el sistema permita que las consultas de listado de documentos se sirvan desde caché cuando se especifique un TTL de caché en la petición, devolviendo resultados cacheados dentro del periodo de validez y renovando la caché cuando el TTL expire,
para reducir la latencia y la carga sobre la base de datos en consultas de listado repetitivas, especialmente en escenarios de alta concurrencia de lectura.
Fuente: PR #10832

**Notas de derivacion:** No se identifico artefacto tecnico nombrable; se omite clausula de contexto

### REQ-APPWRITE-10986 — Verificación de email obligatoria al vincular OAuth2

**MRS:**

> Como usuario autenticado,
quiero que el sistema rechace la vinculación de un proveedor OAuth2 a una cuenta de usuario cuando la dirección de correo electrónico asociada no haya sido verificada previamente, impidiendo la operación de enlace hasta que el email esté verificado,
para evitar que identidades externas se vinculen a cuentas cuya propiedad no ha sido validada, cerrando un vector de suplantación de identidad mediante proveedores OAuth.
Fuente: PR #10986

**Notas de derivacion:** No se identifico artefacto tecnico nombrable; se omite clausula de contexto

### REQ-APPWRITE-11009 — Duración configurable de tokens JWT

**MRS:**

> Como cliente de la API,
quiero que el sistema permita especificar la duración de expiración de los tokens JWT en el momento de su creación, aceptando un valor de tiempo de vida personalizado que prevalezca sobre la duración por defecto del proyecto,
para permitir a los clientes ajustar la duración de los tokens según sus requisitos de seguridad, reduciendo la ventana de exposición en contextos sensibles o ampliándola para sesiones de larga duración.
Fuente: PR #11009

**Notas de derivacion:** No se identifico artefacto tecnico nombrable; se omite clausula de contexto

### REQ-APPWRITE-11033 — API de gestión de webhooks

**MRS:**

> Como administrador del sistema,
quiero que el sistema exponga endpoints de administración para crear, listar, actualizar y eliminar configuraciones de webhooks, permitiendo a los administradores definir URLs de destino, eventos suscritos y cabeceras personalizadas para cada webhook,
para proporcionar una API de primera clase para la gestión de webhooks, eliminando la dependencia de configuración manual y permitiendo la automatización de integraciones externas.
Fuente: PR #11033

**Notas de derivacion:** No se identifico artefacto tecnico nombrable; se omite clausula de contexto

### REQ-APPWRITE-11135 — Parámetros de cifrado y compresión por archivo

**MRS:**

> Como usuario del modulo de archivos,
quiero que el sistema permita que al subir un archivo se especifiquen parámetros de cifrado y compresión por archivo individual, aplicando las transformaciones configuradas antes de almacenar el archivo en el sistema de almacenamiento,
para ofrecer control granular sobre la seguridad y el uso de espacio de almacenamiento, permitiendo decisiones distintas por archivo en función de su sensibilidad o tamaño.
Fuente: PR #11135

**Notas de derivacion:** No se identifico artefacto tecnico nombrable; se omite clausula de contexto

### REQ-APPWRITE-11174 — Nuevos tipos de atributo string en esquema de base de datos

**MRS:**

> Como equipo de desarrollo,
quiero que el sistema permita la creación de atributos de tipo varchar, text, mediumtext y longtext en las colecciones de base de datos, validando los valores insertados contra el tipo y las restricciones de longitud definidas en el esquema,
para proporcionar tipos de datos string con diferente capacidad de almacenamiento para optimizar el uso de espacio y adaptarse a distintos casos de uso de contenido textual.
Fuente: PR #11174

**Notas de derivacion:** No se identifico artefacto tecnico nombrable; se omite clausula de contexto

### REQ-APPWRITE-11202 — Suscripciones en tiempo real con filtros de consulta

**MRS:**

> Como cliente de la API,
quiero que el sistema permita que los clientes se suscriban a canales de tiempo real aplicando filtros de consulta, de modo que solo reciban notificaciones de eventos cuyos datos satisfagan las condiciones del filtro especificado,
para reducir el tráfico de red y el procesamiento en cliente permitiendo suscripciones selectivas que solo entreguen los eventos relevantes para cada cliente conectado.
Fuente: PR #11202

**Notas de derivacion:** No se identifico artefacto tecnico nombrable; se omite clausula de contexto

### REQ-APPWRITE-11312 — Soporte de MongoDB como motor de base de datos

**MRS:**

> Como cliente de la API,
quiero que el sistema permita que los proyectos de Appwrite utilicen MongoDB como motor de base de datos subyacente, ofreciendo la misma API de documentos que con el motor por defecto, incluyendo operaciones CRUD sobre colecciones y documentos,
para ampliar la flexibilidad de despliegue permitiendo a los usuarios elegir el motor de base de datos que mejor se adapte a sus necesidades de infraestructura y rendimiento.
Fuente: PR #11312

**Notas de derivacion:** No se identifico artefacto tecnico nombrable; se omite clausula de contexto

### REQ-APPWRITE-11465 — Actualización dispersa de documentos

**MRS:**

> Como usuario del sistema,
quiero que el sistema envie únicamente los atributos modificados al actualizar un documento mediante la operación updateDocument, omitiendo del payload los campos cuyo valor no ha cambiado respecto al estado almacenado,
para optimizar el uso de ancho de banda y reducir el riesgo de sobrescritura accidental de atributos no modificados durante actualizaciones parciales de documentos.
Fuente: PR #11465

**Notas de derivacion:** No se identifico artefacto tecnico nombrable; se omite clausula de contexto

### REQ-APPWRITE-11533 — Impersonación de usuarios por administradores

**MRS:**

> Como administrador del sistema,
quiero que el sistema permita que un administrador autenticado asuma la identidad de un usuario del proyecto con fines de depuración y soporte, registrando cada operación de impersonación en el log de auditoría,
para facilitar la resolución de incidencias permitiendo al equipo de soporte reproducir el contexto exacto del usuario afectado sin necesidad de conocer sus credenciales.
Fuente: PR #11533

**Notas de derivacion:** No se identifico artefacto tecnico nombrable; se omite clausula de contexto

<!-- APPWRITE: 10 ok, 0 omitidos -->

---

## AUTHENTIK

### REQ-AUTHENTIK-10110 — Corrección de esquema FIPS en API de sistema

**MRS:**

> Como administrador del sistema,
quiero que el sistema exponga el estado de compatibilidad FIPS mediante el atributo `openssl_fips_enabled` en la API de información de runtime, manteniendo coherencia con el esquema OpenAPI y la interfaz de administración,
a traves de `openssl_fips_enabled`,
para evitar inconsistencias entre backend, esquema OpenAPI y frontend en la representación del estado FIPS, garantizando consistencia del contrato de datos del sistema.
Fuente: PR #10110

### REQ-AUTHENTIK-10124 — Actualización de reputación concurrente

**MRS:**

> Como usuario del sistema,
quiero que el sistema actualice el valor de reputación asociado a una dirección IP y un identificador sumando el incremento especificado de forma segura contra condiciones de carrera mediante transacciones atómicas,
para evitar que actualizaciones concurrentes de reputación sobrescriban valores mediante el uso de locks en base de datos.
Fuente: PR #10124

**Notas de derivacion:** No se identifico artefacto tecnico nombrable; se omite clausula de contexto

### REQ-AUTHENTIK-20513 — Prevención de recursión infinita en conectores de endpoint

**MRS:**

> Como cliente de la API,
quiero que el sistema evalue si el conector de una fase Endpoint (EndpointStage) tiene una implementación de sub-fase (stage) y, si carece de ella, deberá finalizar la fase de forma exitosa si el modo está configurado como `OPTIONAL`, o rechazarla con el error `Invalid stage configuration` si el modo es `REQUIRED`, evitando llamadas recursivas al despachador general,
a traves de `OPTIONAL`,
para evitar bucles infinitos y caída del proceso cuando se intenta ejecutar una fase de validación (EndpointStage) cuyo conector no soporta o no implementa una fase específica, respetando la configuración de modo (Opcional/Requerido) definida por el administrador.
Fuente: PR #20513

### REQ-AUTHENTIK-20692 — Configuración de search_path en PostgreSQL

**MRS:**

> Como equipo de desarrollo,
quiero que el sistema aplique la configuración del esquema de base de datos (`search_path`) mediante la ejecución de la consulta `select pg_catalog.set_config('search_path', $1, false)` después de establecer la conexión (`AfterConnect`), eliminando dicho parámetro de los `RuntimeParams` de inicio para garantizar compatibilidad con multiplexadores como PgBouncer,
a traves de `search_path`,
para evitar que el establecimiento de la conexión falle en arquitecturas con PgBouncer (especialmente en modo transacción), ya que PgBouncer no soporta el pase de parámetros `search_path` durante el startup de la conexión, resolviéndolo mediante su inyección explícita tras establecer el canal.
Fuente: PR #20692

### REQ-AUTHENTIK-20744 — Configuración de requests máximas en Gunicorn

**MRS:**

> Como administrador de sistemas,
quiero que el sistema permita configurar los parámetros de máximo número de peticiones antes de reiniciar un worker y su jitter en Gunicorn mediante las variables de entorno de configuración `AUTHENTIK_WEB__MAX_REQUESTS` y `AUTHENTIK_WEB__MAX_REQUESTS_JITTER`, asumiendo valores por defecto de 1000 y 50 respectivamente si no están presentes,
a traves de `AUTHENTIK_WEB__MAX_REQUESTS`,
para permitir a los administradores de sistemas ajustar o deshabilitar (asignando a 0) el comportamiento de reinicio automático de workers de Gunicorn para adaptarlo a entornos con cargas de trabajo específicas o problemas de fugas de memoria, aumentando la flexibilidad operativa del servidor web.
Fuente: PR #20744

### REQ-AUTHENTIK-21749 — Prevención de auto-configuración de redirect_uri

**MRS:**

> Como usuario autenticado,
quiero que el sistema no guarde ni configurar automáticamente el parámetro `redirect_uri` proporcionado en una solicitud de autorización OAuth2 en la lista de URLs permitidas del proveedor (OAuth2Provider) cuando este tenga su lista `redirect_uris` vacía, debiendo tratarlo siempre de acuerdo a la lógica estricta de validación y fallando si la URL no está previamente...,
a traves de `redirect_uri`,
para evitar que la primera petición de autorización en un proveedor sin configurar modifique de forma transparente y persistente su configuración de seguridad estableciendo la URL recibida como un destino válido (`RedirectURIMatchingMode.
Fuente: PR #21749

### REQ-AUTHENTIK-21803 — Extracción de client_id mediante HTTP Basic Auth en Device Code

**MRS:**

> Como usuario autenticado,
quiero que el sistema permita la autenticación y extracción del parámetro `client_id` tanto desde el cuerpo de la petición POST como desde la cabecera HTTP `Authorization: Basic` (codificado en base64) durante el inicio del flujo Device Code OAuth2, utilizando la función unificada `extract_client_auth` en lugar de leer únicamente del cuerpo de la petición,
a traves de `client_id`,
para homogeneizar el comportamiento de la validación del identificador de cliente con el estándar OAuth2 y otros endpoints del sistema, permitiendo a dispositivos clientes enviar sus credenciales a través de la cabecera estándar de autorización en lugar de incluirlas forzosamente en el payload.
Fuente: PR #21803

### REQ-AUTHENTIK-22413 — Estabilización temporal en tests de certificados mTLS

**MRS:**

> Como equipo de desarrollo,
quiero que el sistema ejecute los tests unitarios de la fase de validación mTLS (`MTLSStageTests`) fijando el contexto temporal de forma estática en "2026-05-10 12:38:46" para evitar fallos de aserción provocados por la caducidad natural de los certificados hardcodeados utilizados en los fixtures de prueba,
a traves de `MTLSStageTests`,
para prevenir el fallo prematuro de los tests continuos debido a la fecha de expiración de los certificados SSL/TLS estáticos utilizados en las pruebas de autenticación mutua, garantizando la reproducibilidad y estabilidad de las validaciones de CI en el futuro.
Fuente: PR #22413

### REQ-AUTHENTIK-22503 — Resolución de versión en estado de Outpost

**MRS:**

> Como administrador de infraestructura,
quiero que el sistema reporte el atributo `version_should` de un Outpost evaluando dinámicamente el valor actual del módulo en tiempo de respuesta del endpoint de salud (`health`), en lugar de almacenar la versión estáticamente en la instancia de la clase `OutpostState` durante su inicialización,
a traves de `version_should`,
para evitar la persistencia de una versión obsoleta en el estado de los outposts si no se reinicia el worker de la API tras una actualización de la aplicación, garantizando que el dashboard siempre muestre y compare contra la versión correcta real (OUR_VERSION) del servidor en ejecución.
Fuente: PR #22503

<!-- AUTHENTIK: 9 ok, 0 omitidos -->

---

## CALCOM

### REQ-CALCOM-24889 — Encolar o cancelar el flujo de recordatorio de pago

**MRS:**

> Como usuario del sistema de reservas,
quiero que el sistema gestione los recordatorios de pago para reservas pendientes de la siguiente manera: 1. **Encolamiento con retraso:** Al crear una reserva que requiere pago, en lugar de enviar inmediatamente un correo de "pago pendiente", el sistema debe encolar una tarea (`sendAwaitingPaymentEmail`) para ser ejecutada después de un retraso configurable. El...,
a traves de `AWAITING_PAYMENT_EMAIL_DELAY_MINUTES`,
para enviar un correo de recordatorio de pago inmediatamente después de la reserva puede ser prematuro y confuso para los usuarios, que pueden estar en medio del proceso de pago.
Fuente: PR #24889

### REQ-CALCOM-25039 — Implementar página de administración de la lista de bloqueo del sistema

**MRS:**

> Como administrador del sistema,
quiero que el sistema proporcione una nueva página de administración en "Settings > Admin > System Blocklist" para gestionar correos electrónicos y dominios bloqueados a nivel de toda la plataforma. Esta página debe incluir dos vistas principales: "Blocked Entries" y "Pending Reports". La vista "Blocked Entries" debe mostrar una tabla de todas las entradas de la...,
para la gestión de abusos y spam a nivel de plataforma es crucial para mantener la integridad del servicio.
Fuente: PR #25039

**Notas de derivacion:** No se identifico artefacto tecnico nombrable; se omite clausula de contexto

### REQ-CALCOM-25640 — Auto-autorización para clientes OAuth de confianza

**MRS:**

> Como usuario autenticado,
quiero que el sistema permita que los clientes OAuth marcados como de confianza (`isTrusted: true`) omitan la pantalla de consentimiento del usuario durante el flujo de autorización OAuth2,
a traves de `isTrusted: true`,
para para las aplicaciones propias (first-party apps) desarrolladas por Cal.
Fuente: PR #25640

### REQ-CALCOM-26286 — Validar el correo electrónico del propietario en la creación de organizaciones de plataforma

**MRS:**

> Como administrador del sistema,
quiero que el sistema valide que el correo electrónico del propietario (`orgOwnerEmail`) de una nueva organización de tipo plataforma (`isPlatform: true`) corresponde al del usuario que está realizando la creación. Se debe eliminar la excepción que permitía a la bandera `isPlatform` omitir esta verificación,
a traves de `orgOwnerEmail`,
para la omisión de la validación del propietario para las organizaciones de plataforma representaba una vulnerabilidad de seguridad.
Fuente: PR #26286

### REQ-CALCOM-26428 — Corregir el `sub` del JWT en el inicio de sesión SAML iniciado por IdP

**MRS:**

> Como cliente de la API,
quiero que el sistema garantice que, durante un flujo de inicio de sesión SAML iniciado por el proveedor de identidad (IdP), el `sub` (subject) del token JWT se establezca con el ID de usuario numérico de la base de datos, en lugar del NameID (correo electrónico) proporcionado por el IdP,
a traves de `sub`,
para el inicio de sesión SAML iniciado por IdP estaba fallando porque el `sub` del token JWT se estaba poblando con el correo electrónico del usuario (NameID), pero la sesión del servidor espera que este campo contenga el ID de usuario numérico.
Fuente: PR #26428

### REQ-CALCOM-26598 — Bloquear vinculación OAuth para cuentas no verificadas

**MRS:**

> Como usuario autenticado,
quiero que el sistema impida que una cuenta de Cal.com cuyo correo electrónico no ha sido verificado (`emailVerified: false`) se vincule a un proveedor de identidad OAuth (Google o SAML),
a traves de `emailVerified: false`,
para permitir que una cuenta no verificada se vincule a un proveedor de OAuth crea una vulnerabilidad de seguridad conocida como "pre-hijacking".
Fuente: PR #26598

### REQ-CALCOM-26737 — Documentación del patrón de importación de API v2 en AGENTS.md

**MRS:**

> Como usuario del modulo de archivos,
quiero que el sistema incluya en el archivo `AGENTS.md` documentación sobre el patrón de importación correcto para la aplicación `apps/api/v2`. Específicamente, debe indicar que las importaciones de `@calcom/features` y `@calcom/trpc` no deben hacerse directamente debido a la falta de mapeos de rutas en el `tsconfig.json` de la API v2,
a traves de `AGENTS.md`,
para la API v2 carece de configuraciones de ruta para ciertos paquetes internos, lo que resulta en errores de "módulo no encontrado" durante la compilación o ejecución si se importan directamente.
Fuente: PR #26737

### REQ-CALCOM-26801 — Añadir configuración de ámbito para funcionalidades opt-in

**MRS:**

> Como usuario del sistema,
quiero que el sistema permita la configuración de un ámbito (`scope`) opcional para cada funcionalidad de "opt-in" (`OptInFeatureConfig`). El ámbito puede incluir los valores `org`, `team` y/o `user`,
a traves de `scope`,
para algunas funcionalidades "opt-in" solo son relevantes para ciertos niveles de la jerarquía del sistema (por ejemplo, solo para administradores de organización o solo para usuarios individuales).
Fuente: PR #26801

### REQ-CALCOM-26812 — Corregir la URL de reserva para organizaciones de plataforma

**MRS:**

> Como administrador del sistema,
quiero que el sistema genere la `bookingUrl` para los tipos de eventos de la API v2 utilizando `cal.com` como base para los usuarios no administrados que pertenecen a una organización de plataforma (`isPlatform: true`). La URL no debe contener el subdominio de la organización de la plataforma,
a traves de `bookingUrl`,
para las organizaciones de plataforma son contenedores internos para desarrolladores de API y no tienen subdominios de cara al público.
Fuente: PR #26812

### REQ-CALCOM-26826 — Devolver URL de reserva vacía para usuarios administrados en API v2

**MRS:**

> Como administrador del sistema,
quiero que el sistema devuelva una cadena vacía (`""`) en el campo `bookingUrl` de la respuesta de tipos de eventos en la API v2 cuando el usuario consultado sea un usuario administrado por la plataforma (`isPlatformManaged: true`),
a traves de `""`,
para los usuarios administrados creados a través de la Platform API no tienen páginas de reserva públicas de Cal.
Fuente: PR #26826

<!-- CALCOM: 10 ok, 0 omitidos -->

---

## DIRECTUS

### REQ-DIRECTUS-26646 — Restricción de tipos MIME en la interfaz de subida de archivos

**MRS:**

> Como usuario del modulo de archivos,
quiero que el sistema restrinja la selección de archivos en la interfaz de subida del sistema basándose en la lista de tipos MIME permitidos configurada en el servidor (a través de la variable de entorno correspondiente, como `FILES_MIME_TYPE_ALLOW_LIST`),
a traves de `FILES_MIME_TYPE_ALLOW_LIST`,
para anteriormente, la restricción de tipos MIME solo se aplicaba y verificaba en el lado del servidor (API).
Fuente: PR #26646

### REQ-DIRECTUS-26668 — Codificación de claves primarias en URL para comparación de elementos

**MRS:**

> Como cliente de la API,
quiero que el sistema codifice correctamente (URL encoding) el identificador del elemento (clave primaria) al construir la URL para realizar peticiones a la API al recuperar la versión principal (`main`) de un elemento durante el proceso de comparación de revisiones. Específicamente, cualquier carácter especial presente en una clave primaria manual debe ser...,
a traves de `main`,
para anteriormente, el sistema concatenaba el identificador del elemento directamente en la URL sin codificarlo.
Fuente: PR #26668

### REQ-DIRECTUS-26669 — Corrección de la lógica de deshabilitación de la interfaz de traducción

**MRS:**

> Como usuario del sistema,
quiero que el sistema asegure que la interfaz de traducción se deshabilita de forma granular, basándose en los permisos del usuario: 1. **Deshabilitación completa de la interfaz**: La interfaz de traducción completa (incluyendo campos de entrada y controles de edición) deberá deshabilitarse únicamente cuando el usuario no tenga permisos para guardar cambios...,
a traves de `!isSaveAllowed`,
para una regresión anterior causaba que toda la interfaz de traducción se deshabilitara si el usuario carecía de permisos para eliminar, incluso si tenía permisos para editar y guardar traducciones.
Fuente: PR #26669

### REQ-DIRECTUS-26676 — Habilitar estado no editable para campos relacionales con permisos personalizados

**MRS:**

> Como usuario del sistema,
quiero que el sistema El sistema deberá, para elementos existentes en colecciones con permisos de acceso parcial (`access: 'partial'`), evaluar los permisos del elemento (`fetchedItemPermissions`) para determinar si el elemento cumple con las reglas personalizadas,
a traves de `access: 'partial'`,
para la regresión anterior hacía que los campos relacionales fueran completamente inaccesibles (inertes) para los usuarios sin permisos de edición en elementos que fallaban las reglas de permisos personalizados.
Fuente: PR #26676

### REQ-DIRECTUS-26772 — Soporte de versiones en edición visual

**MRS:**

> Como administrador del sistema,
quiero que el sistema integre el soporte para versiones de contenido en el Editor Visual (`Visual Editor`), permitiendo la previsualización y edición de versiones en borrador (`draft`) y locales,
a traves de `Visual Editor`,
para antes de esta implementación, el Editor Visual estaba limitado únicamente al contenido de la versión principal (`main`).
Fuente: PR #26772

### REQ-DIRECTUS-26836 — Implementar interfaz de grupo de campos en pestañas (Tabs)

**MRS:**

> Como usuario del sistema,
quiero que el sistema proporcione una nueva interfaz de grupo de campos denominada "Tabs" que permita organizar los campos de un formulario en una disposición de pestañas horizontales. Esta interfaz deberá cumplir con los siguientes criterios: 1. **Navegación por teclado**: El usuario deberá poder navegar entre las pestañas utilizando las teclas de flecha izquierda...,
a traves de `Home`,
para la interfaz de grupo "Accordion" existente puede ser ineficiente para formularios con muchos grupos de campos, ya que requiere un desplazamiento vertical considerable.
Fuente: PR #26836

### REQ-DIRECTUS-26886 — Eliminación en lote de carpetas con opciones de contenido

**MRS:**

> Como usuario del modulo de archivos,
quiero que el sistema permita la selección y eliminación de una o varias carpetas desde la vista de cuadrícula de archivos. Al iniciar la acción de eliminación, el sistema deberá presentar un diálogo con las siguientes dos opciones para gestionar el contenido de las carpetas a eliminar: 1. **Mover contenido un nivel hacia arriba**: Si se elige esta opción, el...,
para anteriormente, la eliminación de carpetas era una acción individual y no ofrecía control sobre qué hacer con su contenido, lo que podía llevar a la pérdida accidental de datos o requerir un tedioso trabajo manual para mover los archivos antes de la eliminación.
Fuente: PR #26886

**Notas de derivacion:** No se identifico artefacto tecnico nombrable; se omite clausula de contexto

### REQ-DIRECTUS-26965 — Reducción del retardo de los tooltips para elementos deshabilitados

**MRS:**

> Como usuario del sistema,
quiero que el sistema reduzca el tiempo de retardo (delay) para mostrar los tooltips al pasar el cursor sobre los elementos de la interfaz deshabilitados a 125 milisegundos, manteniendo el retardo estándar de 500 milisegundos para los elementos habilitados,
a traves de `disabled`,
para los usuarios necesitan una retroalimentación rápida al intentar interactuar con controles que no están disponibles (elementos deshabilitados) para comprender rápidamente por qué no pueden realizar una acción.
Fuente: PR #26965

### REQ-DIRECTUS-26976 — Navegación por teclado en diseño de tarjetas

**MRS:**

> Como usuario del sistema,
quiero que el sistema permita la navegación y activación de elementos en la vista de tarjetas (`cards layout`) utilizando el teclado, de acuerdo a las siguientes reglas: 1. **Enfoque de tarjetas:** Cuando no hay elementos seleccionados, las tarjetas individuales deben ser alcanzables mediante la tecla `Tab` (`tabindex="0"`). 2. **Activación de tarjetas:** Presionar...,
a traves de `cards layout`,
para la interfaz de vista de tarjetas carecía de soporte para navegación por teclado, lo que impedía el acceso a estos elementos para usuarios que no utilizan ratón y rompía las pautas de accesibilidad.
Fuente: PR #26976

<!-- DIRECTUS: 9 ok, 0 omitidos -->

---

## MEDUSA

### REQ-MEDUSA-13930 — Búsqueda de productos por SKU de variante en la API de administración

**MRS:**

> Como administrador del sistema,
quiero que el sistema permita la búsqueda de productos a través del endpoint de administración (`GET /admin/products`) utilizando el identificador de mantenimiento de existencias (SKU) de cualquiera de sus variantes. Al utilizar el parámetro de consulta de búsqueda libre (`q`), el sistema deberá: 1. **Búsqueda transversal**: Extender el alcance de la búsqueda de...,
a traves de `GET /admin/products`,
para en versiones anteriores (v2), la búsqueda de productos en la API de administración no consideraba el SKU de las variantes del producto, una funcionalidad crítica presente en la versión 1.
Fuente: PR #13930

### REQ-MEDUSA-15264 — Prevención de error en creación de sesiones de pago sin account holders

**MRS:**

> Como usuario del sistema de reservas,
quiero que el sistema gestione de manera segura la creación de sesiones de pago (`createPaymentSessionsWorkflow`) para clientes que no tienen registros vinculados en `account_holders`. Durante este flujo, si la consulta para recuperar los datos del cliente devuelve una lista de `account_holders` vacía o no definida (`undefined`), el sistema deberá interpretarla como...,
a traves de `createPaymentSessionsWorkflow`,
para anteriormente, al invocar la API para crear sesiones de pago (`POST /store/payment-collections/:id/payment-sessions`) para un cliente autenticado que no tenía ningún `account_holder` asociado, la consulta remota devolvía `undefined` para ese campo.
Fuente: PR #15264

### REQ-MEDUSA-15386 — Búsqueda indexada por SKU en opciones de valores de promociones y endpoint de productos

**MRS:**

> Como administrador del sistema,
quiero que el sistema optimice la búsqueda de productos en el endpoint de opciones de valores de reglas de promoción (`rule-value-options`) y en los endpoints de listado de productos (`/admin/products` y `/store/products`), utilizando el módulo de indexación (`IndexEngine`) cuando este esté habilitado,
a traves de `rule-value-options`,
para anteriormente, la búsqueda de productos para definir valores de reglas de promoción resultaba muy lenta en catálogos extensos, ya que no aprovechaba el módulo de indexación.

Restriccion: si no existe previamente
Fuente: PR #15386

### REQ-MEDUSA-15396 — Notificación de códigos promocionales omitidos por límites

**MRS:**

> Como administrador de comercio,
quiero que el sistema devuelva un array denominado `skipped_promo_codes` en la respuesta al aplicar o actualizar códigos promocionales en un carrito, detallando los códigos que no pudieron ser aplicados debido a restricciones de límite o presupuesto. Cada elemento de este array deberá contener el código omitido (`code`) y el motivo de su omisión (`reason`). Los...,
a traves de `skipped_promo_codes`,
para anteriormente, el sistema omitía silenciosamente los códigos promocionales que no podían ser aplicados por haber superado sus límites de uso o el presupuesto de su campaña.
Fuente: PR #15396

### REQ-MEDUSA-15441 — Soporte de Multi-Factor Authentication (MFA) en el SDK JS

**MRS:**

> Como cliente de la API,
quiero que el sistema proporcione soporte para el manejo de Autenticación de Múltiples Factores (MFA) a través del SDK de JavaScript (`@medusajs/js-sdk`). El SDK deberá incorporar las siguientes capacidades: 1. **Gestión de factores MFA**: Proporcionar métodos bajo un objeto `mfa` para listar (`list`), iniciar la configuración (`start`), confirmar la configuración...,
a traves de `@medusajs/js-sdk`,
para antes de esta implementación, el SDK de JavaScript no ofrecía utilidades para gestionar la autenticación de múltiples factores (MFA), lo que dificultaba a las aplicaciones cliente soportar configuraciones de seguridad avanzadas.
Fuente: PR #15441

<!-- MEDUSA: 5 ok, 0 omitidos -->

---

## N8N

### REQ-N8N-30375 — Corrección del procesamiento de correos en el disparador IMAP

**MRS:**

> Como usuario del sistema de integracion,
quiero que el sistema mejore la fiabilidad del nodo "Email Trigger (IMAP)" para asegurar un procesamiento de correos correcto, aplicando las siguientes reglas: 1. **Marcar como leído selectivamente**: Cuando la opción de post-procesamiento sea "marcar como leído" (`read`), el sistema deberá aplicar el indicador `\\SEEN` únicamente a los correos que han sido...,
a traves de `read`,
para la implementación anterior presentaba varios errores críticos: marcaba correos como leídos incluso si no activaban el flujo de trabajo (por ejemplo, si ya habían sido procesados), lo que llevaba a la pérdida de activaciones.
Fuente: PR #30375

### REQ-N8N-30528 — Clasificación precisa de consultas SELECT en el nodo PostgreSQL

**MRS:**

> Como usuario del sistema,
quiero que el sistema identifice de forma precisa si una consulta ejecutada en el nodo de PostgreSQL es una operación de lectura (`SELECT`) para determinar el formato de la respuesta. La clasificación debe ser robusta y manejar correctamente los siguientes casos: 1. **Detección de `SELECT`**: Una consulta se considerará de tipo `SELECT` si su comando principal a...,
a traves de `SELECT`,
para la implementación anterior del nodo PostgreSQL (v2) utilizaba una expresión regular simple para detectar si una consulta era de tipo `SELECT`.
Fuente: PR #30528

### REQ-N8N-30809 — Deduplicación específica por tipo de evento en disparador de Salesforce

**MRS:**

> Como usuario del sistema de integracion,
quiero que el sistema diferencie la lógica de deduplicación de registros en el nodo "Salesforce Trigger" basándose en el tipo de evento configurado (`changeType`), para evitar ejecuciones múltiples erróneas: 1. **Eventos de Creación (`Created`)**: Para cualquier variante del disparador configurada para detectar registros creados (ej. Case, Account, Contact, etc.),...,
a traves de `changeType`,
para anteriormente, todos los eventos del disparador de Salesforce utilizaban la clave compuesta (`Id` + `LastModifiedDate`) para la deduplicación.
Fuente: PR #30809

### REQ-N8N-31071 — Soporte para adjuntos de archivo no integrados (non-inline) en envío de emails

**MRS:**

> Como usuario del modulo de archivos,
quiero que el sistema El nodo "Send Email" deberá permitir el envío de adjuntos en dos modalidades distintas, controladas a través de campos de configuración separados:

1.  **Adjuntos Integrados (Inline)**: A través del campo `attachments`, el sistema deberá añadir los archivos binarios especificados al correo electrónico asignándoles un identificador de contenido...,
a traves de `attachments`,
para anteriormente, el nodo "Send Email" asignaba forzosamente un `Content-ID` a todos los archivos adjuntos.
Fuente: PR #31071

### REQ-N8N-31253 — Enriquecer la respuesta de la API de credenciales para flujos de trabajo

**MRS:**

> Como cliente de la API,
quiero que el sistema modifice la respuesta del endpoint `GET /credentials/for-workflow` para que, por cada credencial devuelta, incluya los siguientes campos adicionales, alineando su estructura con el tipo esperado por el frontend (`ICredentialsResponse`): 1. **`createdAt` y `updatedAt`**: Las fechas de creación y última actualización de la entidad de la...,
a traves de `GET /credentials/for-workflow`,
para la respuesta de la API no coincidía con la estructura de datos (`type`) que el frontend esperaba, lo que provocaba errores de `undefined` en tiempo de ejecución al acceder a campos que no estaban presentes.
Fuente: PR #31253

### REQ-N8N-31349 — Control de acceso basado en permisos para endpoints de control de versiones

**MRS:**

> Como administrador del sistema,
quiero que el sistema restrinja el acceso y la exposición de datos en los endpoints de control de versiones (`source control`) basándose en los permisos del usuario autenticado, de la siguiente manera: 1. **Endpoint de Preferencias (`GET /preferences`)**: * **Administradores Globales**: Para usuarios con el permiso global `sourceControl:manage`, el sistema deberá...,
a traves de `source control`,
para la implementación anterior exponía propiedades de configuración del control de versiones, algunas de ellas sensibles, a todos los usuarios, independientemente de sus permisos.
Fuente: PR #31349

### REQ-N8N-31371 — Validar el tipo de valor de la clave de actualización en el nodo MongoDB

**MRS:**

> Como usuario del sistema,
quiero que el sistema valide el tipo de dato del valor proporcionado para la `updateKey` en el nodo de MongoDB para las operaciones `Find And Replace`, `Find And Update` y `Update`,
a traves de `updateKey`,
para anteriormente, el nodo de MongoDB no validaba el tipo de valor de la `updateKey`.
Fuente: PR #31371

### REQ-N8N-31374 — Validación de regiones de AWS soportadas

**MRS:**

> Como usuario del sistema,
quiero que el sistema valide el valor proporcionado como región de AWS en las credenciales (por ejemplo, `AWS (IAM) account`) antes de construir y enviar cualquier petición HTTP a los servicios de AWS (como S3, Textract, Transcribe) o al servicio STS (para asumir un rol). La validación debe garantizar que el valor de la región coincida exactamente de forma sensible...,
a traves de `AWS (IAM) account`,
para anteriormente, el sistema interpolaba el valor de la región directamente en la URL del endpoint (ej: `https://{service}.
Fuente: PR #31374

### REQ-N8N-31507 — Ocultar controles de conexión para credenciales privadas sin permiso de actualización

**MRS:**

> Como usuario del sistema,
quiero que el sistema oculte el botón "Connect" (en la tarjeta de credenciales) y el enlace "Connect" (en la vista de detalles del nodo) para aquellas credenciales privadas (resolvibles) que no estén conectadas, si el usuario actual carece del permiso `credential:update` sobre dicha credencial. El aviso informativo que indica que la credencial no está conectada...,
a traves de `credential:update`,
para anteriormente, los usuarios con permisos de solo lectura (`credential:read`), como los espectadores de un proyecto (`project:viewer`), podían ver y hacer clic en los controles para conectar una credencial privada no conectada.
Fuente: PR #31507

<!-- N8N: 9 ok, 0 omitidos -->


---
**Total procesados**: 52  
**Total omitidos**: 0
