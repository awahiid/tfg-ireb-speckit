# Tasks Template — IREB Edition

> **Replaces**: Default SpecKit `tasks-template.md`
> **Based on**: IREB CPRE §Requirements Management, ISO 29148 §6.3.1

Cada tarea debe ser **trazable a exactamente un REQ-ID**.
Tareas sin trazabilidad no deben existir. Tareas independientes se marcan [P].

---

## Formato de tarea

```
[REQ-ID] Título descriptivo | Prioridad | Archivos afectados | Dependencias
```

---

## Reglas IREB

1. **Trazabilidad obligatoria**: cada tarea referencia un `REQ-ID`.
   Si una tarea no traza a ningún REQ-ID → es huérfana y debe eliminarse.
2. **Atomicidad**: cada tarea hace UNA sola cosa verificable.
3. **Orden por dependencias**: las tareas con dependencias van después.
4. **Paralelizables [P]**: tareas sin dependencias entre sí.
5. **Test-first**: las tareas de test preceden a las de implementación.
6. **Sin ambigüedad**: verbos concretos (crear, modificar, añadir, eliminar).
   Nada de "mejorar", "optimizar", "revisar".

---

## Secciones

### 1. Setup y preparación
Tareas de configuración previa (instalar dependencias, configurar entorno).

### 2. Tests (primero)
Tests que verifican el comportamiento esperado ANTES de implementar.

### 3. Implementación
Código fuente que satisface los criterios de verificación del requisito.

### 4. Integración y limpieza
Conexión con el resto del sistema, documentación, changelog.

---

## Ejemplo

```markdown
## Tasks

### 2. Tests
- [ ] [T1] [REQ-APP-001] Test unitario de validación MIME | Alta | `tests/upload_test.go` | Ninguna [P]
- [ ] [T2] [REQ-APP-001] Test de integración endpoint upload | Alta | `tests/integration/upload_test.go` | T1

### 3. Implementación
- [ ] [T3] [REQ-APP-001] Añadir constante MIME_TYPES_ALLOWED | Alta | `config/constants.go` | Ninguna [P]
- [ ] [T4] [REQ-APP-001] Validación MIME en controlador upload | Alta | `handlers/upload.go` | T3
- [ ] [T5] [REQ-APP-001] Mensaje de error en i18n | Media | `locales/es.json` | T4

### 4. Integración
- [ ] [T6] [REQ-APP-001] Actualizar changelog | Baja | `CHANGELOG.md` | T5
```

---

## Verificación pre-implementación

- [ ] Todos los REQ-ID del spec tienen al menos una tarea
- [ ] No hay tareas sin REQ-ID (huérfanas)
- [ ] Las tareas [P] no tienen dependencias
- [ ] Los tests preceden a la implementación
