# Appwrite — informe de selección de evidencia

## Objetivo

Este informe documenta la selección de entradas de changelog/release suficientemente buenas para una futura derivación de requisitos. El JSON asociado contiene únicamente evidencia literal y trazable; no contiene requisitos redactados.

## Criterio de selección

Se incluyen entradas que:
1. aparecen en releases o changelogs oficiales;
2. tienen trazabilidad mínima suficiente, preferiblemente mediante referencia a PR;
3. contienen al menos una señal útil para una futura derivación, como método/path, condición explícita, actor explícito, superficie pública o término relevante de dominio.

No se exige perfección ni completitud total. La decisión se basa en suficiencia defendible, no en excelencia absoluta.

## Fuentes

- Releases: https://github.com/appwrite/appwrite/releases
- Repositorio: https://github.com/appwrite/appwrite

## Tabla resumen

| ID | Release | Entry text | PR | Link exacto | Valoración breve |
|---|---|---|---|---|---|
| appwrite-11312 | 1.9.0 | `MongoDB support (#11312).` | #11312 | https://github.com/appwrite/appwrite/releases/tag/1.9.0 | soporte de base de datos + adapter |
| appwrite-11174 | 1.9.0 | `String types — New varchar, text, mediumtext, and longtext attribute types (#11174).` | #11174 | https://github.com/appwrite/appwrite/releases/tag/1.9.0 | schema + tipos concretos |
| appwrite-10832 | 1.9.0 | `Cached document lists — Document list queries can be cached with configurable TTL (#10832).` | #10832 | https://github.com/appwrite/appwrite/releases/tag/1.9.0 | condición explícita + API + TTL |
| appwrite-11033 | 1.9.0 | `Webhooks API — First-class webhooks management endpoints for creating, listing, and managing webhook configurations (#11033, #11566).` | #11033 | https://github.com/appwrite/appwrite/releases/tag/1.9.0 | API nueva + CRUD + actor admin |
| appwrite-11533 | 1.9.0 | `User impersonation — Admins can now impersonate users for debugging and support (#11533).` | #11533 | https://github.com/appwrite/appwrite/releases/tag/1.9.0 | actor doble + condición |
| appwrite-11202 | 1.9.0 | `Query subscriptions — Subscribe to realtime channels with query filters for targeted updates (#11202, #11237).` | #11202 | https://github.com/appwrite/appwrite/releases/tag/1.9.0 | realtime + filtros + condición |
| appwrite-11009 | 1.9.0 | `Custom JWT duration — Configure JWT expiration time when creating tokens (#11009).` | #11009 | https://github.com/appwrite/appwrite/releases/tag/1.9.0 | auth + parámetro concreto |
| appwrite-10986 | 1.9.0 | `OAuth email verification — Enforce email verification when linking OAuth2 providers (#10986).` | #10986 | https://github.com/appwrite/appwrite/releases/tag/1.9.0 | condición clara + seguridad |
| appwrite-11135 | 1.9.0 | `File encryption/compression parameters — Configure per-file encryption and compression (#11135).` | #11135 | https://github.com/appwrite/appwrite/releases/tag/1.9.0 | storage + seguridad + per-file |
| appwrite-11465 | 1.9.0 | `Sparse document updates — updateDocument() sends only changed attributes (#11465).` | #11465 | https://github.com/appwrite/appwrite/releases/tag/1.9.0 | rendimiento + API + condición |

## Valoración por candidato

### appwrite-11312
**Release:** 1.9.0  
**Texto literal:**  
`MongoDB support (#11312).`  
**PR:** #11312  
**Link exacto:** https://github.com/appwrite/appwrite/releases/tag/1.9.0

**Valoración.** Esta entrada se selecciona porque representa una capacidad funcional mayor: añadir soporte para un nuevo motor de base de datos. Aunque el texto es breve, la PR asociada (#11312) contiene la implementación completa del adapter MongoDB, con cambios en la capa de abstracción de base de datos. Su principal limitación es que el texto del changelog no detalla el alcance exacto del soporte ni sus restricciones. Aun así, entra con claridad porque la capacidad es muy identificable y verificable mediante tests de integración contra MongoDB.

### appwrite-11174
**Release:** 1.9.0  
**Texto literal:**  
`String types — New varchar, text, mediumtext, and longtext attribute types (#11174).`  
**PR:** #11174  
**Link exacto:** https://github.com/appwrite/appwrite/releases/tag/1.9.0

**Valoración.** Esta entrada se selecciona porque nombra artefactos técnicos muy concretos (cuatro tipos de string) que amplían el esquema de base de datos del sistema. La PR asociada contiene cambios en validación de atributos, migraciones y API. Su principal limitación es que no detalla restricciones de tamaño para cada tipo ni cómo interactúan con las queries existentes. Aun así, es excelente para derivación porque los tipos son enumerables y verificables.

### appwrite-10832
**Release:** 1.9.0  
**Texto literal:**  
`Cached document lists — Document list queries can be cached with configurable TTL (#10832).`  
**PR:** #10832  
**Link exacto:** https://github.com/appwrite/appwrite/releases/tag/1.9.0

**Valoración.** Esta entrada se selecciona porque combina una superficie API clara (list queries de documentos), un mecanismo concreto (caché con TTL configurable) y un comportamiento observable (consultas cacheadas vs no cacheadas). Su principal limitación es que no especifica la granularidad del TTL ni su interacción con invalidaciones. Entra muy bien porque el cambio es acotado y verificable: se puede comprobar que dos listados idénticos en el intervalo TTL devuelven el mismo resultado cacheado.

### appwrite-11033
**Release:** 1.9.0  
**Texto literal:**  
`Webhooks API — First-class webhooks management endpoints for creating, listing, and managing webhook configurations (#11033, #11566).`  
**PR:** #11033  
**Link exacto:** https://github.com/appwrite/appwrite/releases/tag/1.9.0

**Valoración.** Esta entrada se selecciona porque describe una API nueva completa con operaciones CRUD sobre configuraciones de webhook. La referencia a dos PRs sugiere que el cambio tiene entidad suficiente. Menciona un actor implícito (admin) y una superficie pública bien definida (endpoints de gestión). Su principal limitación es que el changelog no enumera los endpoints concretos ni los eventos disparables. Entra con fuerza porque es un subsistema nuevo y autocontenido, ideal para derivación y verificación.

### appwrite-11533
**Release:** 1.9.0  
**Texto literal:**  
`User impersonation — Admins can now impersonate users for debugging and support (#11533).`  
**PR:** #11533  
**Link exacto:** https://github.com/appwrite/appwrite/releases/tag/1.9.0

**Valoración.** Esta entrada se selecciona porque involucra dos actores explícitos (admins y users) y una condición de uso clara (debugging y soporte). La acción es muy concreta: impersonar a un usuario. Su principal limitación es que no detalla cómo se audita la impersonación ni qué permisos se requieren. Aun así, es excelente para derivación porque la funcionalidad es acotada, observable y tiene implicaciones de seguridad claras.

### appwrite-11202
**Release:** 1.9.0  
**Texto literal:**  
`Query subscriptions — Subscribe to realtime channels with query filters for targeted updates (#11202, #11237).`  
**PR:** #11202  
**Link exacto:** https://github.com/appwrite/appwrite/releases/tag/1.9.0

**Valoración.** Esta entrada se selecciona porque introduce un mecanismo de filtrado sobre suscripciones en tiempo real, combinando dos conceptos técnicos (realtime channels + query filters). La condición es explícita: solo recibe actualizaciones que coinciden con el filtro. Su principal limitación es que no especifica la sintaxis de los filtros ni su expresividad. Entra bien porque el comportamiento esperado es claramente contrastable: suscripciones sin filtro reciben todo; con filtro, solo el subconjunto.

### appwrite-11009
**Release:** 1.9.0  
**Texto literal:**  
`Custom JWT duration — Configure JWT expiration time when creating tokens (#11009).`  
**PR:** #11009  
**Link exacto:** https://github.com/appwrite/appwrite/releases/tag/1.9.0

**Valoración.** Esta entrada se selecciona porque describe un parámetro de seguridad concreto (duración del JWT) sobre una operación existente (creación de tokens). El cambio es perfectamente acotable: antes la duración era fija; ahora es configurable. Su principal limitación es que no especifica los límites mínimo y máximo permitidos ni el valor por defecto. Entra con claridad porque el observable es directo: crear un token con duración N y verificar que expira en N.

### appwrite-10986
**Release:** 1.9.0  
**Texto literal:**  
`OAuth email verification — Enforce email verification when linking OAuth2 providers (#10986).`  
**PR:** #10986  
**Link exacto:** https://github.com/appwrite/appwrite/releases/tag/1.9.0

**Valoración.** Esta entrada se selecciona porque combina un actor (usuario que vincula OAuth), una condición explícita (email no verificado) y un resultado observable (la vinculación es rechazada). Es un cambio de seguridad con comportamiento binario: permitir o denegar. Su principal limitación es que no detalla el mensaje de error ni el código HTTP de rechazo. Entra muy bien porque es un guard clause clásico, fácil de formalizar y verificar.

### appwrite-11135
**Release:** 1.9.0  
**Texto literal:**  
`File encryption/compression parameters — Configure per-file encryption and compression (#11135).`  
**PR:** #11135  
**Link exacto:** https://github.com/appwrite/appwrite/releases/tag/1.9.0

**Valoración.** Esta entrada se selecciona porque introduce parámetros de storage configurables por archivo (encryption y compression). La granularidad per-file es una señal estructural fuerte. Su principal limitación es que no especifica los algoritmos soportados ni cómo se reflejan los parámetros en la respuesta de la API. Entra bien porque el cambio es acotado a la operación de subida de archivos y el observable es verificable: un archivo subido con encryption=true debe almacenarse cifrado.

### appwrite-11465
**Release:** 1.9.0  
**Texto literal:**  
`Sparse document updates — updateDocument() sends only changed attributes (#11465).`  
**PR:** #11465  
**Link exacto:** https://github.com/appwrite/appwrite/releases/tag/1.9.0

**Valoración.** Esta entrada se selecciona porque describe una optimización de API con condición explícita (solo atributos modificados). El cambio es técnicamente concreto: la función updateDocument() cambia su comportamiento de envío. Su principal limitación es que no detalla el caso de atributos anidados ni la interacción con validaciones parciales. Entra bien porque el observable es claro: un PATCH que modifica un solo campo debe enviar solo ese campo al backend, no el documento completo.

## Observaciones finales

- **Trazabilidad**: el 100% de las entradas referencian PRs concretas con diff localizable. Esto contrasta fuertemente con PocketBase (~50%) y valida la elección de Appwrite como repositorio de sistemas transaccionales.
- **Cobertura de dominio**: las 10 entradas cubren database (e1, e2, e3, e10), admin APIs (e4, e5), realtime (e6), auth (e7, e8) y storage (e9), reflejando la naturaleza multifacética de un BaaS transaccional.
- **Limitaciones**: el changelog de Appwrite, aunque excelente en trazabilidad, presenta algunas entradas breves (e1) que no detallan el alcance completo del cambio. En estos casos la PR asociada proporciona el contexto necesario para la fase de derivación.
- **Suficiencia**: todas las entradas superan ampliamente el umbral de la rúbrica IR-QM v3 (puntuaciones estimadas entre 7 y 9 sobre 10), lo que las hace directamente utilizables para la fase 2 de formalización de requisitos.
