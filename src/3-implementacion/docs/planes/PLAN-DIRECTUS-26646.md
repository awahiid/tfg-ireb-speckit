# Implementation Plan — REQ-DIRECTUS-26646

> **Branch**: `feat/mime-restriction-system-upload` | **Date**: 2026-07-03
> **Spec**: `docs/requisitos/REQ-DIRECTUS-26646.md`
> **Baseline commit (pre-PR)**: `127db21081b656167ebe57c04ec4e6803b4bff68`

---

## Phase 0: Pre-Implementation Gates (IREB)

### Verifiability Gate (Article I)
- [x] Every requirement has a verification criterion with observable behavior
- [x] Verification criteria include concrete steps (config → open dialog → check filter)
- [x] No verification criterion is circular

### Anti-Ambiguity Gate (Article V)
- [x] No subjective terms detected
- [x] All criteria use concrete values (`FILES_MIME_TYPE_ALLOW_LIST`, `accept`, `*/*`)
- [x] Remaining ambiguities: none

### Traceability Gate (Articles III, VII)
- [x] Source field present: PR #26646 + Issue CMS-1679 (Linear)
- [x] Rationale: evitar que el usuario seleccione archivos no permitidos antes del envío al servidor
- [x] Dependencies: `FILES_MIME_TYPE_ALLOW_LIST`, API endpoint `GET /server/info`, Pinia store, VUpload component

### Classification Gate (Article IV)
- [x] Type: Functional — expone configuración del servidor al cliente y la aplica en el navegador

### Minimality Gate (Article II)
- [x] Plan covers ONLY files needed to expose MIME config to client and apply it
- [x] No architectural changes, refactors, or dependency additions
- [x] No feature additions beyond the requirement scope
- [x] Each planned file maps to exactly one REQ-ID
- [x] No "while we're here" improvements

### ⚠️ Singularity Gate (Article VI)
| Issue | Description |
|-------|-------------|
| ⚠️ | La especificación contiene **dos obligaciones**: (1) exponer la lista MIME del servidor al cliente, (2) aplicar el atributo `accept`. Son causalmente dependientes — no se puede aplicar sin exponer. Se mantienen como sub-tareas de un mismo REQ-ID. |

### ⚠️ Anti-Hallucination Gate (Article 0)
| Issue | Resolution |
|-------|------------|
| ~~Plan anterior listaba interfaces `file.vue`, `files.vue`, `file-image.vue`~~ | **Corregido**: el PR real solo modifica `add-new.vue` (dialogo de subida del sistema). Las interfaces son cambios de PRs posteriores (#26647, #26821, #26831). Este plan sigue exclusivamente el alcance de PR #26646. |
| ~~Plan anterior usaba `uploads.mimeTypeAllowList`~~ | **Corregido**: el PR real usa `info.files.mimeTypeAllowList` (top-level `files`, no anidado en `uploads`). |
| ~~Plan anterior mencionaba `constants.ts`~~ | **Corregido**: el PR real lee `env['FILES_MIME_TYPE_ALLOW_LIST']` directamente, sin constante intermedia. |

### Gate Decision
| Result | Action |
|--------|--------|
| ALL gates pass (2 exceptions documented) | Proceed to Phase 1 |

---

## Phase 1: Technical Design

### 1.1 Technology Stack

| Component | Technology | Justification |
|-----------|-----------|---------------|
| Framework (API) | Express.js + TypeScript | Existente en Directus |
| Framework (App) | Vue 3 + Pinia + TypeScript | Existente en Directus |
| Test framework | Vitest | Existente en Directus |

### 1.2 Architecture Overview

**Problema**: `FILES_MIME_TYPE_ALLOW_LIST` solo se valida en backend (`controllers/files.ts:82-86`). El cliente nunca recibe esta configuración, por lo que el `<input type="file">` no puede aplicar el atributo `accept` con los tipos permitidos.

**Solución** (dos cambios atómicos, 4 archivos):

1. **API** (`api/src/services/server.ts`): Añadir `info['files'] = { mimeTypeAllowList: env['FILES_MIME_TYPE_ALLOW_LIST'] }` en `serverInfo()`, dentro del bloque `if (this.accountability?.user)`.

2. **Store** (`app/src/stores/server.ts`):
   - Añadir tipo `files?: { mimeTypeAllowList: string }` a `Info`
   - Inicializar `info.files = undefined` en el estado reactivo
   - Hidratar `info.files = serverInfoResponse.data.data?.files` en `hydrate()`

3. **Component** (`app/src/modules/files/routes/add-new.vue`):
   - Importar `computed` de `vue` y `useServerStore` de `@/stores/server`
   - Crear `allowedMimeTypes` computado que retorna `undefined` si no hay allow list o es `*/*`
   - Pasar `:accept="allowedMimeTypes"` a `<VUpload>`

4. **Changeset** (`.changeset/shy-carrots-think.md`): Documentar el cambio para release notes.

### 1.3 API Contracts

| Endpoint | Method | Cambio | Implementa |
|----------|--------|--------|------------|
| `GET /server/info` | GET | Añadir `files.mimeTypeAllowList` con valor raw de `FILES_MIME_TYPE_ALLOW_LIST` | REQ-DIRECTUS-26646 (sub-obligación 1) |

Response addition (bloque `if (this.accountability?.user)` en `serverInfo()`):
```json
{
  "data": {
    "project": { ... },
    "files": {
      "mimeTypeAllowList": "image/*,audio/*"
    },
    "uploads": {
      "maxConcurrency": 25
    }
  }
}
```

Nota: `files` es un top-level key, independiente de `uploads`.

### 1.4 Files to Modify

| # | File | Líneas | Change | Implements |
|---|------|--------|--------|------------|
| 1 | `api/src/services/server.ts` | +4 | Añadir `info['files']` block tras `info['ai_enabled']` | REQ-DIRECTUS-26646 |
| 2 | `app/src/stores/server.ts` | +5 | Añadir `files?` a tipo `Info`, inicializar, hidratar | REQ-DIRECTUS-26646 |
| 3 | `app/src/modules/files/routes/add-new.vue` | +15/-1 | Computar `allowedMimeTypes` desde store, pasar `:accept` | REQ-DIRECTUS-26646 |
| 4 | `.changeset/shy-carrots-think.md` | +6 | Changeset patch para `@directus/api` y `@directus/app` | REQ-DIRECTUS-26646 |

---

## Phase 2: Implementation Strategy

### 2.1 File Creation Order (Test-First)

```
1. Test API:     api/src/services/__tests__/server.test.ts  (nuevo)
2. Source API:   api/src/services/server.ts                 (+4 líneas)
3. Test Store:   app/src/stores/__tests__/server.test.ts    (nuevo)
4. Source Store: app/src/stores/server.ts                    (+5 líneas)
5. Test Vue:     app/src/modules/files/routes/__tests__/add-new.test.ts (nuevo)
6. Source Vue:   app/src/modules/files/routes/add-new.vue   (+15/-1 líneas)
7. Changeset:    .changeset/shy-carrots-think.md            (+6 líneas)
```

### 2.2 Implementation Tasks by Sub-obligation

| REQ-ID | Sub | Tasks | Archivos |
|--------|-----|-------|----------|
| REQ-DIRECTUS-26646 | 1 (exponer server → client) | 1a. Test: `GET /server/info` incluye `files.mimeTypeAllowList` 1b. Añadir `info['files']` en `ServerService.serverInfo()` 1c. Test: store hidrata `info.files` correctamente 1d. Añadir `files?` a tipo `Info` + inicializar + hidratar | `server.test.ts` (API), `server.ts` (API), `server.test.ts` (store), `server.ts` (store) |
| REQ-DIRECTUS-26646 | 2 (aplicar `accept`) | 2a. Test: `add-new.vue` pasa `accept` a VUpload con MIME configurado 2b. Crear `allowedMimeTypes` computado 2c. Pasar `:accept` a `<VUpload>` | `add-new.test.ts`, `add-new.vue` |

---

## Phase 3: Verification Strategy

### 3.1 Verification by Requirement

| REQ-ID | Verification Method | Expected Result | Test File |
|--------|--------------------|----------------|-----------|
| REQ-DIRECTUS-26646 sub-1 | Vitest (unit API) | `serverInfo()` devuelve `{ files: { mimeTypeAllowList: "image/*" } }` cuando env tiene el valor | `api/src/services/__tests__/server.test.ts` |
| REQ-DIRECTUS-26646 sub-1 | Vitest (unit store) | `useServerStore().info.files.mimeTypeAllowList` se hidrata desde API response | `app/src/stores/__tests__/server.test.ts` |
| REQ-DIRECTUS-26646 sub-1 | Vitest (unit store) | `info.files` es `undefined` cuando API no devuelve `files` | `app/src/stores/__tests__/server.test.ts` |
| REQ-DIRECTUS-26646 sub-2 | Vitest + Vue Test Utils | `<VUpload>` recibe `:accept="allowedMimeTypes"` con valor correcto | `app/src/modules/files/routes/__tests__/add-new.test.ts` |
| REQ-DIRECTUS-26646 sub-2 | Vitest + Vue Test Utils | `allowedMimeTypes` es `undefined` cuando `FILES_MIME_TYPE_ALLOW_LIST` es `*/*` o no está definida | `app/src/modules/files/routes/__tests__/add-new.test.ts` |

### 3.2 Verification Environment Setup

```typescript
// API test: mock env
vi.mock('@directus/env', () => ({
  useEnv: () => ({ 'FILES_MIME_TYPE_ALLOW_LIST': 'image/*,audio/*' }),
}));

// Store test: mock API response
vi.mocked(api.get).mockResolvedValue({
  data: { data: { files: { mimeTypeAllowList: 'image/*' } } },
});

// Vue test: mock store
vi.mock('@/stores/server', () => ({
  useServerStore: () => ({ info: { files: { mimeTypeAllowList: 'image/*' } } }),
}));
```

### 3.3 Regression Gate

- [x] All existing tests still pass (`pnpm --filter @directus/api test` + `pnpm --filter @directus/app test`)
- [x] All new tests pass
- [x] No changes to controller `files.ts` — server-side MIME validation untouched
- [x] No changes to `v-upload.vue` — `validFiles()` ya filtra por `accept` prop
- [x] No changes to interfaces (file, files, file-image) — fuera del scope de PR #26646

### 3.4 Scope Restriction (Article II)

- **NO** modificar la validación MIME en `files.ts` controller — ya funciona en backend
- **NO** cambiar `validFiles()` en `v-upload.vue` — ya filtra correctamente cuando recibe `accept`
- **NO** modificar interfaces file/files/file-image — son cambios de PR #26647 y #26821
- **NO** tocar interfaces de editor (rich-text-html, rich-text-md, block-editor)
- **NO** refactorizar ni añadir constantes intermedias

---

## Complexity Tracking

| Decision | Violation | Justification | Approved |
|----------|-----------|---------------|----------|
| Mantener 2 obligaciones en 1 REQ-ID | Artículo VI | Causalmente dependientes: exponer sin aplicar no tiene efecto, aplicar sin exponer es imposible | Sí |
| Incluir `*/*` check en el computado | Artículo II | El PR real incluye esta optimización (evitar `accept` cuando todo está permitido) — es parte del spec original | Sí |
| No crear constantes en `constants.ts` | Ninguna | El PR real lee env directamente en `server.ts`; añadir constantes sería un cambio fuera de scope | Sí |
| Usar `info.files` top-level (no `uploads`) | Ninguna | El PR real usa estructura plana `files.mimeTypeAllowList`, no anidada bajo `uploads` | Sí |

---

## Post-Implementation Verification

- [ ] Analyze confirma spec ↔ plan ↔ tasks ↔ code consistency
- [ ] All verification tests pass
- [ ] Traceability chain: REQ-DIRECTUS-26646 → spec → plan → test → code
- [ ] No alucinaciones de contexto en el código generado
- [ ] El atributo `accept` solo se modifica en `add-new.vue` (dialogo del sistema de archivos)
