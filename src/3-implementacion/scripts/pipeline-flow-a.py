#!/usr/bin/env python3
"""
pipeline-flow-a.py — Pipeline Flow A directo vía API (sin opencode)
Flow A = baseline: changelog crudo, sin IREB. Solo: specify → plan → tasks → implement

Usa la API de DeepSeek directamente (OpenAI-compatible), sin lectura de archivos.
Mucho más rápido que opencode porque no explora el repositorio.

Uso:
  python pipeline-flow-a.py <repo-dir> "<changelog-text>" <case-id> [output-dir]
  OPENAI_API_KEY=sk-... OPENAI_API_BASE=https://api.deepseek.com/v1 \
    python pipeline-flow-a.py repos/n8n-e5 "MongoDB Node: Validate..." n8n-e5
"""
import os, sys, json, subprocess, time
from pathlib import Path
from datetime import datetime, timezone

try:
    from openai import OpenAI
except ImportError:
    print("ERROR: pip install openai")
    sys.exit(1)

# ── Config ───────────────────────────────────────────────────────────
API_KEY = os.environ.get("OPENAI_API_KEY") or os.environ.get("DEEPSEEK_API_KEY") or "sk-489ed17e6c204e9d87ea45e7ff163bde"
API_BASE = os.environ.get("OPENAI_API_BASE", "https://api.deepseek.com/v1")
MODEL_RAW = os.environ.get("OPENCODE_MODEL") or os.environ.get("OPENAI_MODEL", "deepseek-v4-pro")

# Normalizar: opencode usa deepseek/deepseek-chat, API usa deepseek-v4-pro
if MODEL_RAW in ("deepseek-chat", "deepseek/deepseek-chat"):
    MODEL = "deepseek-v4-pro"
elif MODEL_RAW in ("deepseek-reasoner", "deepseek/deepseek-reasoner"):
    MODEL = "deepseek-v4-pro"
elif MODEL_RAW.startswith("deepseek/"):
    MODEL = MODEL_RAW
else:
    MODEL = MODEL_RAW

if not API_KEY:
    print("ERROR: OPENAI_API_KEY or DEEPSEEK_API_KEY required")
    sys.exit(1)

# ── Args ─────────────────────────────────────────────────────────────
if len(sys.argv) < 4:
    print("Uso: pipeline-flow-a.py <repo-dir> <changelog-text> <case-id> [output-dir]")
    sys.exit(1)

REPO_DIR = Path(sys.argv[1]).resolve()
# Si el segundo argumento es un archivo corto que existe, leer su contenido
mrs_arg = sys.argv[2]
if len(mrs_arg) < 200 and Path(mrs_arg).exists():
    CHANGELOG_TEXT = Path(mrs_arg).read_text().strip()
else:
    CHANGELOG_TEXT = mrs_arg
CASE_ID = sys.argv[3]
OUTPUT_DIR = (Path(sys.argv[4]) if len(sys.argv) > 4 else REPO_DIR / ".specify" / "memory" / "flow-a-output").resolve()
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

# ── Client ───────────────────────────────────────────────────────────
client = OpenAI(api_key=API_KEY, base_url=API_BASE)

print(f"""
==============================================
  🚀 PIPELINE FLOW A (BASELINE - API directa)
==============================================

  Caso:        {CASE_ID}
  Changelog:   {CHANGELOG_TEXT}
  Repositorio: {REPO_DIR}
  Modelo:      {MODEL}
  Output:      {OUTPUT_DIR}
""")

# ── Helpers ──────────────────────────────────────────────────────────
def call_llm(system_prompt: str, user_prompt: str, step_id: str) -> str:
    """Call DeepSeek API and return response text."""
    print(f"  [{step_id}] Llamando a {MODEL}...", flush=True)
    t0 = time.time()
    try:
        resp = client.chat.completions.create(
            model=MODEL,
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt},
            ],
            temperature=0.3,
            max_tokens=8192,
        )
        elapsed = time.time() - t0
        text = resp.choices[0].message.content or ""
        lines = text.count("\n") + 1
        print(f"  [{step_id}] OK — {lines} líneas, {elapsed:.0f}s", flush=True)
        return text
    except Exception as e:
        print(f"  [{step_id}] ERROR: {e}", flush=True)
        raise

def save(file_name: str, content: str):
    path = OUTPUT_DIR / file_name
    path.write_text(content)
    return path

def extract_code_blocks(text: str) -> int:
    """Extract ```language path/to/file blocks and write them to the repo."""
    import re
    count = 0
    pattern = re.compile(r'```(\w+)\s+([^\n]+)\n(.*?)```', re.DOTALL)
    for match in pattern.finditer(text):
        file_path = match.group(2).strip()
        code = match.group(3)
        if not file_path or "/" not in file_path:
            continue
        abs_path = REPO_DIR / file_path
        abs_path.parent.mkdir(parents=True, exist_ok=True)
        abs_path.write_text(code)
        print(f"    📄 {file_path}", flush=True)
        count += 1
    return count

SYSTEM_BASE = "Eres un desarrollador senior. Responde en Markdown. Sé específico, concreto y conciso."

# ── STEP 0: Guardar input ────────────────────────────────────────────
save("00-input-changelog.txt", CHANGELOG_TEXT)

# ── STEP 1: Specify ──────────────────────────────────────────────────
print("\n── PASO 1/4: Specify ──", flush=True)
spec = call_llm(SYSTEM_BASE, f"""\
A partir de la siguiente descripción de un cambio en un changelog de software,
genera una especificación técnica para implementarlo:

«{CHANGELOG_TEXT}»

Describe qué hay que construir, qué archivos podrían modificarse, y qué
comportamiento debe tener el sistema. NO uses ninguna plantilla IREB ni
estándar de requisitos. Simplemente describe el cambio como lo haría un
desarrollador senior.""", "01-specify")
save("01-specify.md", spec)

# ── STEP 2: Plan ─────────────────────────────────────────────────────
print("\n── PASO 2/4: Plan ──", flush=True)
plan = call_llm(SYSTEM_BASE, f"""\
Especificación:
{spec}

Genera un plan de implementación técnico para la especificación anterior.

Incluye:
1. Enfoque técnico
2. Archivos a modificar o crear
3. Orden de implementación
4. Estrategia de verificación (tests)

Sé concreto y directo. No uses gates ni plantillas formales.""", "02-plan")
save("02-plan.md", plan)

# ── STEP 3: Tasks ────────────────────────────────────────────────────
print("\n── PASO 3/4: Tasks ──", flush=True)
tasks = call_llm(SYSTEM_BASE, f"""\
Plan:
{plan}

Descompón el plan anterior en tareas ejecutables y ordenadas.

Para cada tarea indica:
- Título descriptivo
- Archivos afectados
- Dependencias entre tareas (si las hay)

Marca tareas independientes como [P] (paralelizables).""", "03-tasks")
save("03-tasks.md", tasks)

# ── STEP 4: Implement ────────────────────────────────────────────────
print("\n── PASO 4/4: Implement ──", flush=True)
implement = call_llm(SYSTEM_BASE, f"""\
Especificación:
{spec}

Plan:
{plan}

Tareas:
{tasks}

IMPLEMENTA el código necesario. Genera el código completo para cada archivo
usando bloques de código con la sintaxis: ```lenguaje ruta/al/archivo

Por ejemplo:
```typescript packages/editor/src/Component.ts
// CASO: {CASE_ID}
export class Component {{ ... }}
```

Reglas:
1. Implementa tests y código fuente
2. NO preguntes — genera TODO el código ahora
3. Usa el formato ```lenguaje ruta/al/archivo para cada archivo
4. Cada archivo DEBE tener un comentario con el CASE_ID: {CASE_ID}
5. NO uses placeholders ni comentarios TODO — código completo y funcional""", "04-implement")
save("04-implement.md", implement)

# ── Extraer bloques de código ────────────────────────────────────────
print("\n── Extrayendo archivos de código ──", flush=True)
files_created = extract_code_blocks(implement)
print(f"  Archivos creados: {files_created}", flush=True)

# ── Generar diff ─────────────────────────────────────────────────────
print("\n── Generando diff ──", flush=True)
os.chdir(str(REPO_DIR))
# Incluir archivos nuevos (untracked) en el diff
subprocess.run(["git", "add", "-A"], capture_output=True)
result = subprocess.run(["git", "diff", "--cached", "--quiet"], capture_output=True)
if result.returncode == 0:
    print("  ⚠️  No hay cambios en el repositorio (diff vacío)", flush=True)
else:
    diff = subprocess.run(["git", "diff", "--cached"], capture_output=True, text=True).stdout
    (OUTPUT_DIR / "diff.patch").write_text(diff)
    print(f"  diff.patch: {len(diff.splitlines())} líneas", flush=True)
    stat = subprocess.run(["git", "diff", "--cached", "--stat"], capture_output=True, text=True).stdout
    (OUTPUT_DIR / "changed-files.txt").write_text(stat)
    print(f"  changed-files.txt: {len(stat.splitlines())} archivos", flush=True)
# Revertir git add para no ensuciar el repo
subprocess.run(["git", "reset", "HEAD"], capture_output=True)

# ── Generar README ───────────────────────────────────────────────────
artifacts = []
for f in sorted(OUTPUT_DIR.glob("*.md")):
    lines = f.read_text().count("\n") + 1
    artifacts.append(f"- {f.name}: {lines} líneas")

diff_info = ""
diff_file = OUTPUT_DIR / "diff.patch"
if diff_file.exists():
    diff_lines = diff_file.read_text().count("\n") + 1
    diff_info = f"- `diff.patch`: {diff_lines} líneas\n- `changed-files.txt`: disponible"
else:
    diff_info = "- No se detectaron cambios"

readme = f"""# Pipeline Flow A (Baseline) — Resumen de ejecución

**Caso**: {CASE_ID}
**Modelo**: {MODEL}
**Fecha**: {datetime.now(timezone.utc).isoformat()}

## Input
```
{CHANGELOG_TEXT}
```

## Artefactos generados
{chr(10).join(artifacts)}

## Cambios en el código
{diff_info}
"""
save("README.md", readme)

print(f"""
==============================================
  ✅ PIPELINE FLOW A COMPLETADO
==============================================
  Resultados en: {OUTPUT_DIR}
""")
