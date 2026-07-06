# REQ-AUTHENTIK-10110

| Atributo        | Valor                                                                                             |
| --------------- | ------------------------------------------------------------------------------------------------- |
| **ID**          | REQ-AUTHENTIK-10110                                                                               |
| **Name**        | Corrección de esquema FIPS en API de sistema                                                      |
| **Type**        | Constraint                                                                                     |
| **Description** | El sistema deberá exponer el estado de compatibilidad FIPS mediante el atributo `openssl_fips_enabled` en la API de información de runtime, y deberá eliminar el atributo `openssl_fips_mode` de la respuesta de dicha API, de modo que el esquema OpenAPI y la interfaz de administración reflejen exclusivamente `openssl_fips_enabled`. |
| **Source**      | Pull Request #10110 (https://github.com/goauthentik/authentik/pull/10110). Issue derivado implícitamente de cambios de esquema de sistema — sin issue explícito asociado en los datos proporcionados. |
| **Rationale**   | Evitar inconsistencias entre backend, esquema OpenAPI y frontend en la representación del estado FIPS, garantizando consistencia del contrato de datos del sistema. |
| **Priority**    | Media                                                                                             |
| **Verification**| 1. Consultar el endpoint de información de runtime y verificar que la respuesta incluye `openssl_fips_enabled` y no incluye `openssl_fips_mode`. 2. Inspeccionar el esquema OpenAPI generado y comprobar que solo contiene `openssl_fips_enabled` como atributo de estado FIPS. 3. Acceder a la interfaz de administración y confirmar que el estado FIPS se muestra correctamente sin referencias a `openssl_fips_mode`. |
| **Status**      | Draft                                                                                             |
| **Version**     | 1.0                                                                                               |
| **Dependencies**| API de runtime (`GET /admin/system/`) existente; TypedDict `RuntimeDict` en `authentik/admin/api/system.py` |
| **Module**      | System API / Runtime Information                                                                  |

---

## Metadatos IREB

- **Artículo I (Verificabilidad)**: ✅ — tres escenarios observables (consulta API, inspección de esquema, comprobación de UI).
- **Artículo II (Minimalidad funcional)**: ✅ — solo corrige el atributo expuesto; no añade funcionalidad especulativa.
- **Artículo III (Trazabilidad completa)**: ✅ — origen en PR #10110 con URL.
- **Artículo IV (Clasificación)**: **Constraint** — describe un cambio estructural en el contrato de datos de la API (renombrar `openssl_fips_mode` → `openssl_fips_enabled`), no un nuevo comportamiento funcional del sistema. Limita el espacio de solución del esquema de respuesta.
- **Artículo V (Sin ambigüedad)**: ✅ — términos concretos: `openssl_fips_enabled`, `openssl_fips_mode`, endpoint de runtime, esquema OpenAPI.
- **Artículo VI (Obligación única)**: ✅ — una sola obligación: corregir el esquema FIPS eliminando `openssl_fips_mode` y exponiendo `openssl_fips_enabled`.
- **Artículo VII (Fuente documentada)**: ✅ — URL del PR #10110.
- **Artículo VIII (Rationale)**: ✅ — consistencia del contrato de datos del sistema.
- **Artículo IX (QA continuo)**: ✅ — verificable en cada despliegue mediante los escenarios descritos.
