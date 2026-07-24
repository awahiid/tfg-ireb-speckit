# Tasks Template — IREB Edition

> **Replaces**: Default SpecKit `tasks-template.md`
> **Governed by**: constitution Article 0 (Proportionality First)

Each task must be **traceable to exactly one REQ-ID**.
No orphan tasks. Tasks with no dependencies are marked [P].

---

## Task Format

```
[T#] [REQ-ID] Descriptive title | Priority | Files | Dependencies
```

---

## Rules

1. **Mandatory traceability**: every task references a `REQ-ID`. No REQ-ID → orphan → remove.
2. **Atomicity**: each task does ONE verifiable thing.
3. **Order by dependencies**: dependent tasks come after.
4. **Parallelizable [P]**: tasks with no cross-dependencies.
5. **Test-first for Medium+**: tests before implementation. Trivial/Small: flexible.
6. **Concrete verbs**: create, modify, add, delete, update, test, validate. No "improve" or "optimize".

---

## Sections

### 1. Tests (skip for trivial)

Tests verifying the expected behavior.

### 2. Implementation

Source code changes. One task per file unless a file needs multiple related changes.

### 3. Integration

Changelog, docs (if needed).

---

## Pre-Implementation Verification

- [ ] Every REQ-ID from spec has ≥1 task
- [ ] No orphan tasks (without REQ-ID)
- [ ] [P] tasks have no dependencies
- [ ] Task count is proportional to tier (trivial: 1-2, small: 2-4, medium: 4-8)
