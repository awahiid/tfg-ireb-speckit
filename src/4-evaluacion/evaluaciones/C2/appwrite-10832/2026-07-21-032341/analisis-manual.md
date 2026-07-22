# C2 — appwrite-10832 — Evaluación manual SRCI v3

**Ejecución**: C2/appwrite-10832/2026-07-21/032341
**Evaluado**: 2026-07-22
**Coste**: $0.0870 | **Tokens**: 6.825.840

**Requisito**: REQ-APPWRITE-10832 — Caché de listados de documentos con TTL configurable

## Nota global

| Bloque | Puntuación | Peso | Nota |
|--------|:----------:|:----:|:----:|
| **A** | **3/12** | 25% | **2.5** |
| **B** | **4.0/5** | 20% | **8.0** |
| **C** | **2.0/3** | 12% | **6.7** |
| **D** | **2.0/4** | — | — |
| **E** | **3/3=1.00** | 43% | **10** |
| | | **Total** | **7.0/10** |

---

3 source files PHP. `DocumentListCache.php`, `XList.php`, `Databases.php` modificados. Tests presentes. **phpcs**: 14577 issues (similar a C0, peor que C1).
