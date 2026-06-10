# Repositories Report — Clasificación por tipo de sistema

## Marco de clasificación

Los repositorios seleccionados para este estudio no se escogen al azar. Cada uno representa un tipo distinto de problema dentro del espectro del desarrollo de software. La clasificación se basa en la naturaleza del sistema software, no en el dominio de negocio, siguiendo la premisa de que el software se divide por tipo de problema a resolver, no por sector.

Las seis categorías cubren las áreas que dominan las taxonomías empíricas en ingeniería de software (construcción, diseño, requisitos, mantenimiento), tal como se recoge en SWEBOK.

---

## Tabla resumen

| # | Tipo | Repositorio | Organización | URL |
|---|---|---|---|---|
| 1 | Transactional systems | Appwrite | appwrite | https://github.com/appwrite/appwrite |
| 2 | Financial / state consistency | Medusa | medusajs | https://github.com/medusajs/medusa |
| 3 | Identity & security | Authentik | goauthentik | https://github.com/goauthentik/authentik |
| 4 | Collaboration | Cal.com | calcom | https://github.com/calcom/cal.com |
| 5 | Data / content | Directus | directus | https://github.com/directus/directus |
| 6 | Integration / service composition | n8n | n8n-io | https://github.com/n8n-io/n8n |

---

## Clasificación detallada

### 1. Transactional systems — Appwrite

**Repositorio:** `appwrite/appwrite`
**Tipo de sistema:** SaaS, CRUD, REST APIs, aplicaciones de negocio.

Appwrite es un backend-as-a-service (BaaS) open source que proporciona una API REST transaccional completa sobre servicios de autenticación, base de datos, almacenamiento de archivos, funciones serverless y mensajería. Los cambios en este repositorio reflejan el patrón CRUD transaccional que subyace a la mayoría de aplicaciones SaaS modernas: creación de endpoints, gestión de esquemas, permisos sobre recursos y flujos de datos. Sus releases referencian PRs de forma exhaustiva, lo que garantiza trazabilidad completa.

### 2. Financial / state consistency systems — Medusa

**Repositorio:** `medusajs/medusa`
**Tipo de sistema:** e-commerce, sistemas de facturación, pedidos, pagos.

Medusa es una plataforma de comercio electrónico headless con arquitectura modular. Sus cambios típicos involucran flujos de pedidos, cálculo de impuestos, aplicación de descuentos, gestión de inventario y procesamiento de pagos. Estos cambios requieren consistencia de estado fuerte: una orden debe reflejar correctamente el estado del pago, el inventario debe decrementarse atómicamente y los descuentos deben aplicarse con reglas condicionales precisas. Sus changelogs incluyen actores explícitos (merchants, customers) y condiciones de negocio.

### 3. Identity & security systems — Authentik

**Repositorio:** `goauthentik/authentik`
**Tipo de sistema:** autenticación, RBAC, sesiones, flujos de autorización.

Authentik es un proveedor de identidad open source compatible con múltiples protocolos (OAuth2, SAML, LDAP, OIDC). Sus cambios giran en torno a flujos de autenticación, políticas de acceso, gestión de sesiones, integración con directorios externos y personalización del flujo de login. Cada release referencia PRs concretas con autoría explícita, lo que permite una trazabilidad completa desde el changelog hasta el diff.

### 4. Collaboration systems — Cal.com

**Repositorio:** `calcom/cal.com`
**Tipo de sistema:** estado multiusuario, manejo de concurrencia, notificaciones, workflows compartidos.

Cal.com es una plataforma de scheduling colaborativo (alternativa open source a Calendly). Sus cambios involucran reserva de slots horarios, gestión de disponibilidad entre múltiples actores, notificaciones, integraciones con calendarios externos y flujos de booking compartidos. La naturaleza colaborativa del sistema introduce complejidad de concurrencia y consistencia eventual entre actores. Sus releases referencian PRs de forma consistente.

### 5. Data / content systems — Directus

**Repositorio:** `directus/directus`
**Tipo de sistema:** CMS, esquemas dinámicos, flujos editoriales, pipelines de contenido.

Directus es un headless CMS que expone dinámicamente cualquier base de datos SQL como una API REST/GraphQL. Sus cambios abarcan la gestión de esquemas dinámicos, personalización de la interfaz de administración, control de acceso a contenido, flujos editoriales y transformaciones de assets. Los cambios en este tipo de sistema se caracterizan por operar sobre estructuras de datos configurables en tiempo de ejecución. Sus releases referencian PRs de forma exhaustiva.

### 6. Integration / service composition systems — n8n

**Repositorio:** `n8n-io/n8n`
**Tipo de sistema:** agregación de APIs, webhooks, sistemas guiados por eventos, orquestación de servicios.

n8n es una plataforma de automatización de workflows mediante composición visual de servicios. Sus cambios involucran conectores a servicios externos, disparadores basados en webhooks, ejecución condicional de nodos, transformación de datos entre servicios y gestión del ciclo de vida de ejecuciones. La naturaleza del sistema es inherentemente de integración: cada cambio compone o modifica la interacción entre múltiples servicios externos. Sus releases referencian PRs de forma consistente.

---

## Justificación del diseño

La selección de exactamente un repositorio por tipo de sistema responde a un diseño de cobertura horizontal: en lugar de profundizar en un único dominio, se muestra cómo el flujo IREB + SpecKit se comporta ante problemas de distinta naturaleza. Esta decisión refuerza la validez externa del estudio al no limitar la evaluación a un único tipo de aplicación.

Cada repositorio aporta cambios característicos de su categoría:

- **Appwrite**: patrones CRUD transaccionales y APIs REST.
- **Medusa**: reglas de negocio con consistencia de estado fuerte.
- **Authentik**: flujos de autorización y políticas de acceso.
- **Cal.com**: sincronización de estado entre múltiples usuarios.
- **Directus**: esquemas dinámicos y transformaciones de contenido.
- **n8n**: composición dirigida por eventos y orquestación de servicios.

La heterogeneidad resultante es una fortaleza del diseño, no una debilidad: si el flujo IREB + SpecKit muestra patrones de comportamiento consistentes a través de tipos de sistema tan dispares, la señal es más robusta que si se hubiera evaluado sobre un único tipo de aplicación.
