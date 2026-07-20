# Fase 3 — Ejecución de pipelines

## Flujos (4 condiciones experimentales)

| Flujo | Script | Entrada | Fuente del prompt |
|---|---|---|---|
| **C3** — Vibe Coding puro | `scripts/pipeline-c3.sh` | MRS desde 2.5-prompts | `../../2.5-prompts/<repo>/REQ-*.md` |
| **C0** — SpecKit baseline | `scripts/pipeline-c0.sh` | Changelog literal | Changelogs reales de cada proyecto |
| **C1** — IREB Kit v1 | `scripts/pipeline-c1.sh` | Requisito IREB | `../2-requisitos/<repo>/REQ-*.md` |
| **C2** — IREB Kit v2 | `scripts/pipeline-c2.sh` | Requisito IREB | `../2-requisitos/<repo>/REQ-*.md` |

**Ningún pipeline inventa prompts.** Todos leen de ficheros generados en fases anteriores.
**C3 ya NO depende de `casos-mrs/`** — extrae el MRS directamente de `2.5-prompts/`.

## Modelo de ejecución: worktrees aislados

Cada flujo ejecuta sobre su **propio worktree Git**, clonado desde un bare repo. Esto permite re-ejecutar pipelines en paralelo sin que se pisen ni contaminen el historial.

```
.bare/appwrite.git/          ← Bare repo (clon único, sin working tree)
repos/
├── appwrite-e3-C0/          ← Worktree para C0 (SpecKit vanilla)
├── appwrite-e3-C1/          ← Worktree para C1 (SpecKit + IREB v1)
├── appwrite-e3-C2/          ← Worktree para C2 (SpecKit + IREB v2)
└── appwrite-e3-C3/          ← Worktree para C3 (vibe coding)
```

Cada worktree arranca desde el commit pre-PR (`8368a28ff5~1` = `a71f3555ae`).
Antes de cada re-ejecución, se limpia con `git checkout . && git clean -fd`.

### Aislamiento de opencode por pipeline

Cada pipeline ejecuta con su propia instancia aislada de opencode mediante `XDG_DATA_HOME`:

```bash
export XDG_DATA_HOME=$(mktemp -d /tmp/opencode-XXXXXX)
```

Esto hace que `opencode session list`, `opencode export` y `opencode stats` solo vean las sesiones de ESE pipeline. **Sin carreras, sin contaminación cruzada de métricas** entre flujos concurrentes.

La DB de sesiones se almacena en `/tmp/opencode-XXXXXX/opencode/opencode.db` y se destruye al reiniciar.

## Estructura

```
├── scripts/
│   ├── lib.sh                ← Helpers compartidos (oc_run, oc_extract_code, etc.)
│   ├── pipeline-c3.sh        ← C3: 1 prompt (sin SpecKit)
│   ├── pipeline-c0.sh        ← C0: 4 pasos (specify→plan→tasks→implement)
│   ├── pipeline-c1.sh        ← C1: 9 pasos (SpecKit + IREB v1)
│   ├── pipeline-c2.sh        ← C2: 10 pasos (SpecKit + IREB v2 + scope contract)
│   ├── preparar-caso.sh      ← Clona repo en commit pre-PR
│   ├── capturar-metricas.sh  ← Extrae tokens/coste de sesiones opencode
│   └── test.sh               ← Test secuencial (1 caso × 4 flujos)
├── ireb-kit-v1/              ← Kit IREB v1 (templates + constitution)
├── ireb-kit-v2/              ← Kit IREB v2 (templates + constitution)
├── repos/                    ← Worktrees Git aislados
└── resultados/
    ├── C0/  C1/  C2/  C3/    ← Resultados por flujo
```

## Uso

### Ejecución correcta (worktrees aislados, paralelo seguro)

```bash
BASE="/home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion"
PRE_PR="a71f3555ae"   # commit pre-PR #10832
CHANGELOG="Cached document lists — Document list queries can be cached with configurable TTL (#10832)."
REQ="../2-requisitos/appwrite/REQ-APPWRITE-10832.md"
MODEL="deepseek/deepseek-v4-flash"

# 1. Limpiar cada worktree a commit pre-PR
for f in C0 C1 C2 C3; do
  git -C "$BASE/repos/appwrite-e3-$f" checkout "$PRE_PR" 2>/dev/null
  git -C "$BASE/repos/appwrite-e3-$f" clean -fd 2>/dev/null
  rm -rf "$BASE/repos/appwrite-e3-$f/.specify" \
         "$BASE/repos/appwrite-e3-$f/.github" \
         "$BASE/repos/appwrite-e3-$f/specs"
done

# 2. Lanzar los 4 pipelines en paralelo
OPENCODE_MODEL="$MODEL" PIPELINE_TIMEOUT=900 \
  bash "$BASE/scripts/pipeline-c0.sh" "$BASE/repos/appwrite-e3-C0" \
    "$CHANGELOG" appwrite-e3 "$BASE/resultados/C0/appwrite-e3" > /tmp/c0.log 2>&1 &

OPENCODE_MODEL="$MODEL" PIPELINE_TIMEOUT=900 \
  bash "$BASE/scripts/pipeline-c1.sh" "$BASE/repos/appwrite-e3-C1" \
    "$REQ" appwrite-e3 "$BASE/resultados/C1/appwrite-e3" > /tmp/c1.log 2>&1 &

OPENCODE_MODEL="$MODEL" PIPELINE_TIMEOUT=900 \
  bash "$BASE/scripts/pipeline-c2.sh" "$BASE/repos/appwrite-e3-C2" \
    "$REQ" appwrite-e3 "$BASE/resultados/C2/appwrite-e3" > /tmp/c2.log 2>&1 &

OPENCODE_MODEL="$MODEL" PIPELINE_TIMEOUT=900 \
  bash "$BASE/scripts/pipeline-c3.sh" "$BASE/repos/appwrite-e3-C3" \
    appwrite-e3 "$BASE/resultados/C3/appwrite-e3" > /tmp/c3.log 2>&1 &

echo "PIDs: C0=$!, C1=$!, C2=$!, C3=$!"

# 3. Monitorizar progreso
tail -f /tmp/c0.log /tmp/c1.log /tmp/c2.log /tmp/c3.log
```

### Re-ejecución de un solo flujo

```bash
# Limpiar y re-lanzar solo C0, por ejemplo:
git -C repos/appwrite-e3-C0 checkout a71f3555ae
git -C repos/appwrite-e3-C0 clean -fd
rm -rf repos/appwrite-e3-C0/.specify repos/appwrite-e3-C0/.github repos/appwrite-e3-C0/specs

OPENCODE_MODEL=deepseek/deepseek-v4-flash PIPELINE_TIMEOUT=900 \
  bash scripts/pipeline-c0.sh repos/appwrite-e3-C0 \
    "Cached document lists — ..." appwrite-e3 resultados/C0/appwrite-e3
```

### Test secuencial (un mismo worktree, solo para pruebas rápidas)

```bash
bash scripts/test.sh   # ⚠️  NO usar para ejecuciones definitivas
```

## Métricas

Cada ejecución produce: `summary.json`, `diff.patch`, `changed-files.txt`, artefactos `0X-*.md`, prompts `0X-prompt.txt`, `session-ids.txt`.

## lib.sh — Helpers compartidos

Todos los pipelines usan `scripts/lib.sh`:
- `oc_run` — ejecuta opencode `--pure`, captura stderr, extrae session IDs
- `oc_extract_code` — extrae bloques de código (stdout limpio: solo el número)
- `oc_capture_diff` — `git add -A && git diff --cached` (incluye archivos nuevos)
- `oc_extract_mrs` — extrae MRS de ficheros `2.5-prompts/*.md`
- `oc_capture_metrics` — tokens/coste desde sesiones opencode
- `oc_summary` — genera `summary.json` + `README.md`
- **Sin `set -e`**: cada paso decide si un fallo es crítico o no.
