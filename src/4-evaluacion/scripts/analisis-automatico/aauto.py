#!/usr/bin/env python3
"""aauto.py — Analiza un resultado con herramientas reales.

Exporta analyze_one(rd) para uso directo desde otros scripts.

Uso CLI:
  python3 scripts/aauto.py <ruta-al-resultado>

Salida: evaluaciones/<flow>/<repo>-<reqid>/<timestamp>/aauto.md
"""

import json, re, sys, os, subprocess
from pathlib import Path
from datetime import datetime

EVAL = Path(os.environ.get("EVAL_DIR",
              Path(__file__).resolve().parent.parent.parent / "evaluaciones"))

_SCRIPT_DIR = Path(__file__).resolve().parent
_ESLINT = str(_SCRIPT_DIR / "node_modules" / ".bin" / "eslint")
_ESLINT_CFG = str(_SCRIPT_DIR / ".eslintrc.json")

LINTER_CMD = {
    ".js":  [_ESLINT, "--config", _ESLINT_CFG, "--format", "json"],
    ".ts":  [_ESLINT, "--config", _ESLINT_CFG, "--format", "json"],
    ".jsx": [_ESLINT, "--config", _ESLINT_CFG, "--format", "json"],
    ".tsx": [_ESLINT, "--config", _ESLINT_CFG, "--format", "json"],
    ".vue": [_ESLINT, "--config", _ESLINT_CFG, "--format", "json"],
    ".php": ["phpcs", "--standard=Generic", "--report=json", "--runtime-set", "ignore_warnings_on_exit", "1"],
    ".sh":  ["shellcheck", "--format=json"],
    ".bash":["shellcheck", "--format=json"],
    ".py":  ["pyflakes"],  # salida texto: file:line:col: message
}


def parse_diff(path):
    t = path.read_text("utf-8", errors="replace")
    sec, cur, ls = {}, None, []
    for l in t.split("\n"):
        m = re.match(r'^diff --git a/(.*) b/\1$', l)
        if m:
            if cur and ls: sec[cur] = ls
            cur, ls = m.group(1), []
            continue
        if cur is not None: ls.append(l)
    if cur and ls: sec[cur] = ls
    return sec


def run_linter(fp):
    ext = fp.suffix.lower()
    if ext not in LINTER_CMD: return {}, "none"
    try:
        r = subprocess.run(LINTER_CMD[ext] + [str(fp)],
                          capture_output=True, text=True, timeout=30)
        o = r.stdout.strip()
        if "eslint" in LINTER_CMD[ext][0]:
            if not o:
                if r.returncode != 0:
                    return [f"  ERROR (exit {r.returncode}): {r.stderr.strip()[:200]}"], "error"
                return [], "eslint"
            d = json.loads(o) if o else []
            msgs = []
            for f in (d if isinstance(d, list) else []):
                for m in f.get("messages", []):
                    msgs.append(f"  L{m.get('line',0)}:{m.get('column',0)} {m.get('message','')} ({m.get('ruleId','')})")
            return msgs, "eslint"
        if "phpcs" in LINTER_CMD[ext][0]:
            if not o:
                return [], "phpcs"
            try:
                d = json.loads(o)
            except json.JSONDecodeError:
                return [f"  RAW OUTPUT: {o[:200]}"], "phpcs"
            msgs = []
            for fi_name, fi in d.get("files", {}).items():
                for m in fi.get("messages", []) or []:
                    t = "W" if m.get("type") == "WARNING" else "E"
                    msgs.append(f"  {Path(fi_name).name}:L{m.get('line',0)} {t}: {m.get('message','')}")
            return msgs, "phpcs"
        if "shellcheck" in LINTER_CMD[ext][0]:
            if not o:
                return [], "shellcheck"
            d = json.loads(o) if o else []
            msgs = []
            for m in d:
                msgs.append(f"  L{m.get('line',0)}:{m.get('column',0)} {m.get('level','').upper()}: {m.get('message','')} ({m.get('code','')})")
            return msgs, "shellcheck"
        if "pyflakes" in LINTER_CMD[ext][0]:
            if not o:
                return [], "pyflakes"
            lines = o.split("\n")
            msgs = []
            for line in lines:
                m = re.match(r'.+:(\d+):(\d+):\s*(.*)', line)
                if m:
                    msgs.append(f"  L{m.group(1)}:{m.group(2)} {m.group(3)}")
                elif line.strip():
                    msgs.append(f"  {line.strip()}")
            return msgs, "pyflakes"
        if "flake8" in LINTER_CMD[ext][0]:
            if not o:
                return [], "flake8"
            d = json.loads(o) if o else []
            msgs = [f"  L{m.get('line',0)}:{m.get('column',0)} {m.get('message','')} ({m.get('code','')})" for m in d]
            return msgs, "flake8"
        # Si llegamos aqui, herramienta desconocida
        if r.returncode != 0:
            return [f"  ERROR (exit {r.returncode}): {r.stderr.strip()[:200]}"], "error"
        return [], "none"
    except Exception as e:
        return [f"  ERROR: {type(e).__name__}: {e}"], "error"
    return [], "none"


def linter_detallado(gen):
    """Ejecuta linters y devuelve {tool: {comando, archivos: [{path, mensajes}]}}."""
    if not gen.exists():
        return {}
    res = {}
    for fp in sorted(gen.rglob("*")):
        if not fp.is_file():
            continue
        ext = fp.suffix.lower()
        if ext not in LINTER_CMD:
            continue
        cmd_str = " ".join(str(c) for c in LINTER_CMD[ext] + [str(fp)])
        msgs, tool = run_linter(fp)
        rel_path = str(fp.relative_to(fp.parent.parent.parent.parent))
        key = tool if tool not in ("none", "error") else ("error" if tool == "error" else None)
        if key is None:
            continue
        if key not in res:
            res[key] = {"comando": cmd_str, "archivos": []}
        res[key]["archivos"].append({"path": rel_path, "mensajes": msgs})
    return res


def semgrep_analysis(gen):
    """Ejecuta semgrep sobre generated/ y categoriza por severidad."""
    gen = Path(gen) if not isinstance(gen, Path) else gen
    if not gen.exists():
        return {}
    # Buscar semgrep: primero en el venv local, luego en PATH
    sg = str(Path(__file__).resolve().parent / ".venv" / "bin" / "semgrep")
    if not Path(sg).exists():
        import shutil
        sg = shutil.which("semgrep")
    if not sg:
        return {}
    cmd = [sg, "--json", "--quiet", "--no-git-ignore", "--config=auto", str(gen)]
    cmd_str = " ".join(cmd)
    try:
        r = subprocess.run(cmd, capture_output=True, text=True, timeout=120)
        d = json.loads(r.stdout) if r.stdout.strip() else {}
        results = d.get("results", [])
        cats = {"ERROR": [], "WARNING": [], "INFO": []}
        for res in results:
            sev = res.get("extra", {}).get("severity", "INFO")
            check = res.get("check_id", "unknown")
            path = res.get("path", "")
            line = res.get("start", {}).get("line", 0)
            msg = res.get("extra", {}).get("message", "")
            cats.setdefault(sev, []).append(f"  L{line} [{check}] {msg}")
        scanned = d.get("paths", {}).get("scanned", [])
        # Agrupar archivos escaneados por extension
        exts = {}
        for s in scanned:
            ext = s.rsplit(".", 1)[-1] if "." in s else "(none)"
            exts[ext] = exts.get(ext, 0) + 1
        return {"comando": cmd_str, "categorias": cats,
                "total": sum(len(v) for v in cats.values()),
                "scanned": len(scanned),
                "scanned_ext": exts}
    except FileNotFoundError:
        return {}
    except subprocess.TimeoutExpired:
        return {"comando": cmd_str, "categorias": {"ERROR": ["TIMEOUT"]}, "total": 0,
                "scanned": 0, "scanned_ext": {}}
    except (json.JSONDecodeError, Exception) as e:
        return {"comando": cmd_str, "categorias": {"ERROR": [f"Parse error: {e}"]}, "total": 0}


def cloc_por_lenguaje(gen):
    """Devuelve {lenguaje: lineas}."""
    if not gen.exists(): return {}
    try:
        r = subprocess.run(["cloc", str(gen), "--json"],
                          capture_output=True, text=True, timeout=30)
        d = json.loads(r.stdout) if r.stdout.strip() else {}
        return {k: v.get("code",0) for k,v in d.items()
                if k not in ("header","SUM") and isinstance(v,dict)}
    except: return {}


def compare_with_pr(rd):
    """Compara el diff del agente con el diff real del PR.

    rd: Path al directorio del resultado.
    Devuelve dict con métricas de comparación o None si no se puede.

    Métricas:
      - archivos_comunes: archivos modificados en ambos
      - solo_agente: archivos solo en el agente
      - solo_pr: archivos solo en el PR real
      - precision: comunes / total_agente
      - recall: comunes / total_pr
      - f1: media armónica
      - detalle_archivos: lista de archivos con su estado
    """
    rd = Path(rd)
    reqs_file = Path(__file__).resolve().parent.parent.parent / ".." / "3-implementacion" / "reqs.json"
    if not reqs_file.exists():
        reqs_file = Path(__file__).resolve().parent.parent.parent / ".." / "3-implementacion" / "casos.json"
    if not reqs_file.exists():
        return None

    # Obtener repo y reqid desde la ruta
    parts = rd.parts
    try:
        idx = [i for i, p in enumerate(parts) if p.startswith("C0") or p.startswith("C1") or p.startswith("C2") or p.startswith("C3")][0]
        case_str = parts[idx+1]
        repo_name, reqid = case_str.split("-", 1)
    except (IndexError, ValueError):
        return None

    # Mapear nombre de repo a clave en reqs.json
    repo_map = {"calcom": "calcom", "appwrite": "appwrite", "authentik": "authentik",
                "directus": "directus", "medusa": "medusa", "n8n": "n8n"}
    json_key = repo_map.get(repo_name, repo_name)

    try:
        with open(reqs_file) as f:
            data = json.load(f)
        pre_pr = data.get(json_key, {}).get("reqs", {}).get(reqid, {}).get("pre_pr", "")
    except:
        return None

    if not pre_pr or "~1" not in pre_pr:
        return None

    merge_commit = pre_pr.replace("~1", "")
    bare = Path(__file__).resolve().parent.parent.parent / ".." / "3-implementacion" / ".bare" / f"{json_key}.git"
    if not bare.exists():
        return None

    try:
        # Obtener archivos del PR real
        r_real = subprocess.run(
            ["git", "-C", str(bare), "diff", "--name-only", pre_pr, merge_commit],
            capture_output=True, text=True, timeout=30
        )
        real_files = set(f.strip() for f in r_real.stdout.strip().split("\n") if f.strip())

        # Obtener archivos del diff del agente (excluyendo scaffolding y archivos generados)
        agent_diff = rd / "diff.patch"
        if not agent_diff.exists():
            return None
        agent_text = agent_diff.read_text("utf-8", errors="replace")
        agent_files = set(re.findall(r'^diff --git a/(.*?) b/', agent_text, re.M))
    except Exception as e:
        return None

    # Archivos a ignorar en ambos lados (scaffolding, metadatos, documentación)
    # Solo contamos archivos de CÓDIGO para la comparación, no documentación.
    CODE_EXTENSIONS = {
        ".py", ".js", ".ts", ".tsx", ".jsx", ".vue", ".php", ".java",
        ".go", ".rs", ".c", ".h", ".cpp", ".hpp", ".sh", ".bash",
        ".yml", ".yaml", ".json", ".toml", ".ini", ".cfg",
        ".css", ".scss", ".less", ".sql", ".graphql", ".proto",
    }
    IGNORE_PATTERNS = (
        ".specify/", ".github/", ".vscode/", ".turbo/",
        ".changeset/", "node_modules/", "vendor/", "dist/", "build/",
        "specs/",  # specs del pipeline, no código
        "composer.lock", "package-lock.json", "yarn.lock", "pnpm-lock.yaml",
        "go.sum", "Gemfile.lock", "Gemfile",
    )

    def is_code_file(p):
        # Si matchea un patrón de ignorado, no es código
        if any(pat in p for pat in IGNORE_PATTERNS):
            return False
        # Si tiene extensión de código, sí
        ext = Path(p).suffix.lower()
        if ext in CODE_EXTENSIONS:
            return True
        # Archivos sin extensión o con extensión de documentación → no código
        return False

    # Filtrar: solo archivos de código
    real_code = {f for f in real_files if is_code_file(f)}
    agent_code = {f for f in agent_files if is_code_file(f)}

    # Comparar archivos (normalizar paths: quitar './')
    def normalize(p):
        return p[2:] if p.startswith("./") else p

    agent_norm = {normalize(f) for f in agent_code}
    real_norm = {normalize(f) for f in real_code}

    comunes = agent_norm & real_norm
    solo_agente = agent_norm - real_norm
    solo_pr = real_norm - agent_norm

    total_agente = len(agent_norm)
    total_pr = len(real_norm)
    total_comunes = len(comunes)

    precision = total_comunes / total_agente if total_agente > 0 else 0
    recall = total_comunes / total_pr if total_pr > 0 else 0
    f1 = 2 * (precision * recall) / (precision + recall) if (precision + recall) > 0 else 0

    return {
        "total_agente": total_agente,
        "total_pr": total_pr,
        "comunes": total_comunes,
        "solo_agente": total_agente - total_comunes,
        "solo_pr": total_pr - total_comunes,
        "precision": round(precision, 3),
        "recall": round(recall, 3),
        "f1": round(f1, 3),
        "archivos_comunes": sorted(comunes)[:20],
        "archivos_solo_agente": sorted(solo_agente)[:20],
        "archivos_solo_pr": sorted(solo_pr)[:20],
    }


def evaluate_ireb_compliance(sec, flow):
    """Evalúa si el agente siguió el marco IREB/SpecKit.

    El denominador (artefactos_esperados) es FIJO por flow según el diseño
    experimental (Tabla 3.3 de la memoria):
      - C0: solo spec.md — el pipeline vanilla no incluye pasos IREB
      - C1: spec.md + constitution + clarify + analyze
      - C2: spec.md + constitution + clarify + analyze + scope-contract
      - C3: 0 — no usa SpecKit

    La puntuación combina 50% artefactos + 50% contenido del spec.
    """
    # Artefactos IREB esperados por flow (fijo, no dinámico)
    # Esto evita que C0 no sea penalizado por no tener constitution/clarify/analyze
    # (el error anterior: total_esperados solo se incrementaba si el artefacto existía)
    IREB_ARTEFACTOS_POR_FLOW = {
        "C0": ["spec.md"],
        "C1": ["spec.md", "constitution.md", "clarify", "analyze"],
        "C2": ["spec.md", "constitution.md", "clarify", "analyze", "scope-contract"],
        "C3": [],
    }

    spec_files = [k for k in sec.keys() if k.startswith("specs/")]

    # Encontrar feature dir
    feature_dirs = set()
    for f in spec_files:
        parts = f.split("/")
        if len(parts) >= 3:
            feature_dirs.add(f"{parts[0]}/{parts[1]}")
    feature_dir = sorted(feature_dirs)[0] if feature_dirs else None

    esperados = IREB_ARTEFACTOS_POR_FLOW.get(flow, [])
    artefactos = []
    total_ok = 0

    for art_id in esperados:
        if art_id == "spec.md":
            encontrado = any(f.endswith("/spec.md") or f == "spec.md" for f in spec_files)
        elif art_id == "constitution.md":
            encontrado = any(".specify/memory/constitution.md" in k for k in sec.keys())
        elif art_id == "clarify":
            encontrado = any("clarify" in k.lower() for k in spec_files)
        elif art_id == "analyze":
            encontrado = any("analyze" in k.lower() for k in spec_files)
        elif art_id == "scope-contract":
            encontrado = any("scope-contract" in k for k in sec.keys())
        else:
            encontrado = False

        icon = "✅" if encontrado else "❌"
        if encontrado:
            total_ok += 1

        artefactos.append({
            "artefacto": art_id,
            "descripcion": {
                "spec.md": "Especificación del requisito",
                "constitution.md": "Constitución IREB",
                "clarify": "Informe de clarificación",
                "analyze": "Informe de análisis",
                "scope-contract": "Contrato de alcance",
            }.get(art_id, art_id),
            "presente": encontrado,
            "icono": icon,
        })

    artefactos_esperados = len(esperados)
    total_esperados = artefactos_esperados

    # Análisis del spec.md (IREB compliance del contenido)
    spec_content = ""
    for k in sorted(sec.keys()):
        if re.match(r'^specs/\d+-[^/]+/spec\.md$', k):
            lines = sec[k]
            spec_content = "\n".join(
                l[1:] for l in lines if l.startswith("+") and not l.startswith("+++")
            )
            break

    spec_ireb = None
    if spec_content:
        spec_ireb = {
            "tiene_id": bool(re.search(r'REQ-[\w-]+-\d+', spec_content)),
            "tiene_tipo": bool(re.search(r'\*\*Type\*\*.*(?:Functional|Quality|Constraint)', spec_content, re.I)),
            "tiene_fuente": bool(re.search(r'\*\*Source\*\*', spec_content, re.I)),
            "tiene_prioridad": bool(re.search(r'\*\*Priority\*\*.*(?:High|Medium|Low)', spec_content, re.I)),
            "tiene_formato_ireb": bool(re.search(r'El sistema deberá|The system shall', spec_content, re.I)),
            "tiene_verificacion": bool(re.search(r'Verification|verificación|Acceptance Scenarios', spec_content, re.I)),
            "tiene_rationale": bool(re.search(r'\*\*Rationale\*\*', spec_content, re.I)),
            "total_atributos": 7,
        }
        spec_ireb["atributos_preservados"] = sum(1 for v in spec_ireb.values() if isinstance(v, bool) and v)

    # Puntuación: 50% artefactos esperados + 50% contenido del spec
    # (se mantiene como valor orientativo, pero el JSON exporta por separado
    #  artifact_ratio y spec_atributos para que el lector compare sin pesos)
    spec_pct = 0
    if spec_ireb and spec_ireb.get("total_atributos", 0) > 0:
        spec_pct = spec_ireb["atributos_preservados"] / spec_ireb["total_atributos"]
    artifact_pct = total_ok / total_esperados if total_esperados > 0 else 0

    return {
        "artefactos": artefactos,
        "adicionales": [],
        "total_ok": total_ok,
        "total_esperados": total_esperados,
        "artifact_ratio": round(artifact_pct, 3),
        "spec_ireb": spec_ireb,
        "feature_dir": feature_dir,
    }


def analyze_one(rd):
    """Analiza un resultado y genera informe.
    rd: Path o string al directorio del resultado.
    Devuelve dict con resumen o None si falla."""
    rd = Path(rd) if not isinstance(rd, Path) else rd
    if not (rd / "diff.patch").exists():
        return None

    # Extraer flow, repo, reqid, timestamp de la ruta
    parts = rd.parts
    try:
        idx = [i for i, p in enumerate(parts) if p.startswith("C0") or p.startswith("C1") or p.startswith("C2") or p.startswith("C3")][0]
        flow = parts[idx]
        case_str = parts[idx+1]
        repo, reqid = case_str.split("-", 1)
        timestamp = f"{parts[idx+2]}/{parts[idx+3]}"
    except (IndexError, ValueError):
        flow = rd.parent.parent.name
        case_str = rd.parent.name
        timestamp = f"{rd.parent.parent.name}/{rd.name}"
        repo, reqid = case_str.split("-", 1) if "-" in case_str else (case_str, "??")

    gen = rd / "generated"

    # Analisis
    sec = parse_diff(rd / "diff.patch")

    # cloc detallado
    cloc_langs = cloc_por_lenguaje(gen)
    cloc_total = sum(cloc_langs.values())

    # semgrep (analisis estatico multilenguaje)
    sg = semgrep_analysis(gen)
    sg_total = sg.get("total", 0) if sg else 0
    cats = sg.get("categorias", {}) if sg else {}

    # eslint (JS/TS/React — complemento a semgrep)
    lint = linter_detallado(gen)
    lint_total = sum(len(a["mensajes"]) for info in lint.values() for a in info["archivos"]) if lint else 0

    # Coste
    cost = tok = 0
    sm = rd / "summary.json"
    if sm.exists():
        try:
            s = json.loads(sm.read_text())
            cost = s.get("cost_usd", 0)
            tok = s.get("tokens", 0)
        except: pass

    # Archivos fuente (sin .specify/.github)
    src_files = sorted([p for p in sec.keys()
                       if not p.startswith(".specify/") and not p.startswith(".github/")])

    # Generar informe
    out_dir = EVAL / flow / case_str / timestamp.replace("/", "-")
    out_dir.mkdir(parents=True, exist_ok=True)
    md = out_dir / "aauto.md"

    with open(md, "w") as f:
        f.write(f"# {flow} — {case_str}\n\n")
        f.write(f"**Ejecucion**: {flow}/{case_str}/{timestamp}\n")
        f.write(f"**Analizado**: {datetime.now():%Y-%m-%d %H:%M}\n\n")

        f.write("## Resultados de herramientas\n\n")
        f.write("| Herramienta | Resultado |\n|-------------|-----------|\n")
        f.write(f"| Archivos modificados | {len(sec)} |\n")
        f.write(f"| Archivos fuente (sin infraestructura) | {len(src_files)} |\n")
        f.write(f"| Lineas de codigo generadas (cloc) | {cloc_total} |\n")
        if cloc_langs:
            for lang, lines in sorted(cloc_langs.items(), key=lambda x: -x[1]):
                f.write(f"| &nbsp;-- {lang} | {lines} lineas |\n")
        f.write(f"| Coste generacion | ${cost:.4f} |\n")
        f.write(f"| Tokens consumidos | {tok} |\n\n")

        if sg:
            f.write("## Analisis estatico (semgrep)\n\n")
        else:
            f.write("## Analisis estatico (semgrep)\n\n")
            f.write("**semgrep no esta disponible** — instalar con: pip install semgrep\n\n")
            sg = {"comando": "semgrep --json --quiet --no-git-ignore --config=auto <dir>", "categorias": {}, "total": 0, "scanned": 0, "scanned_ext": {}}

        f.write(f"**Total incidencias**: {sg_total}\n\n")
        f.write(f"**Comando**: `{sg['comando']}`\n\n")
        f.write(f"**Archivos escaneados**: {sg.get('scanned', 0)}\n")
        if sg.get("scanned_ext"):
            for ext, n in sorted(sg["scanned_ext"].items(), key=lambda x: -x[1]):
                f.write(f"  - .{ext}: {n} archivos\n")


        if sg_total > 0:
            for sev, msgs in cats.items():
                label = {"ERROR": "🔴 Errores criticos (bugs, seguridad)",
                        "WARNING": "🟡 Warnings (code smells, practicas)",
                        "INFO": "🔵 Informacion/Estilo (formato, naming)"}.get(sev, sev)
                f.write(f"### {label}: {len(msgs)}\n\n")
                if msgs:
                    f.write("```\n")
                    for m in msgs[:50]:
                        f.write(f"{m}\n")
                    if len(msgs) > 50:
                        f.write(f"... y {len(msgs)-50} mas\n")
                    f.write("```\n\n")
        else:
            f.write("*(no se encontraron incidencias)*\n\n")

        f.write("### Linters por lenguaje\n\n")
        if lint:
            for tool, info in lint.items():
                total = sum(len(a["mensajes"]) for a in info["archivos"])
                f.write(f"**{tool}**: {total} incidencias en {len(info['archivos'])} archivos\n\n")
                f.write(f"**Comando**: `{info['comando']}`\n\n")
                if any(a["mensajes"] for a in info["archivos"]):
                    f.write("```\n")
                    for a in info["archivos"]:
                        for m in a["mensajes"][:10]:
                            f.write(f"{m}\n")
                        if len(a["mensajes"]) > 10:
                            f.write(f"  ... y {len(a['mensajes'])-10} mas\n")
                    f.write("```\n\n")
                else:
                    f.write("*(sin incidencias)*\n\n")
        else:
            f.write("*(no se encontraron archivos lintables)*\n\n")

        f.write("## Archivos fuente modificados\n\n")
        for p in src_files:
            f.write(f"- `{p}`\n")

        if len(sec) - len(src_files) > 0:
            f.write(f"\n... y {len(sec) - len(src_files)} archivos de infraestructura (.specify, .github)\n")

        # ── Comparación con PR real ──
        f.write("\n## Comparación con PR real\n\n")
        comp = compare_with_pr(rd)
        if comp is None:
            f.write("*(no se pudo comparar — falta reqs.json o bare repo)*\n")
        else:
            f.write(f"| Métrica | Valor |\n")
            f.write(f"|---------|-------|\n")
            f.write(f"| Archivos en PR real (sin scaffolding) | {comp['total_pr']} |\n")
            f.write(f"| Archivos del agente (sin scaffolding) | {comp['total_agente']} |\n")
            f.write(f"| **Archivos comunes** | **{comp['comunes']}** |\n")
            f.write(f"| Solo en agente | {comp['solo_agente']} |\n")
            f.write(f"| Solo en PR real | {comp['solo_pr']} |\n")
            f.write(f"| **Precision** (acierto) | **{comp['precision']:.1%}** |\n")
            f.write(f"| **Recall** (cobertura) | **{comp['recall']:.1%}** |\n")
            f.write(f"| **F1** | **{comp['f1']:.2f}** |\n\n")

            if comp['archivos_comunes']:
                f.write("### Archivos comunes\n\n")
                for a in comp['archivos_comunes']:
                    f.write(f"- `{a}`\n")
                f.write("\n")

            if comp['archivos_solo_agente']:
                f.write("### Archivos solo en agente\n\n")
                for a in comp['archivos_solo_agente']:
                    f.write(f"- `{a}`\n")
                f.write("\n")

            if comp['archivos_solo_pr']:
                f.write("### Archivos solo en PR real\n\n")
                for a in comp['archivos_solo_pr']:
                    f.write(f"- `{a}`\n")
                f.write("\n")

        # ── Cumplimiento IREB / SpecKit ──
        f.write("\n## Cumplimiento IREB / SpecKit\n\n")
        ireb = evaluate_ireb_compliance(sec, flow)
        if ireb:
            sa = ireb['spec_ireb']['atributos_preservados'] if ireb['spec_ireb'] else 0
            sa_total = ireb['spec_ireb']['total_atributos'] if ireb['spec_ireb'] else 0
            f.write(f"**Artefactos IREB**: {ireb['total_ok']}/{ireb['total_esperados']} ({ireb['artifact_ratio']:.0%})\n\n")
            f.write(f"**Spec IREB (atributos)**: {sa}/{sa_total}\n\n")
            f.write(f"**Directorio de features**: `{ireb['feature_dir']}`\n\n" if ireb['feature_dir'] else "")
            f.write("### Artefactos del pipeline\n\n")
            f.write("| Artefacto | Estado |\n|-----------|--------|\n")
            for a in ireb['artefactos']:
                f.write(f"| `{a['artefacto']}` — {a['descripcion']} | {a['icono']} |\n")
            if ireb['adicionales']:
                f.write("\n| Artefacto adicional | Estado |\n|---------------------|--------|\n")
                for a in ireb['adicionales']:
                    f.write(f"| `{a['artefacto']}` — {a['descripcion']} | {a['icono']} |\n")
            f.write(f"\n**Total**: {ireb['total_ok']}/{ireb['total_esperados']} artefactos\n\n")

            if ireb['spec_ireb']:
                si = ireb['spec_ireb']
                f.write("### Atributos IREB en spec.md\n\n")
                f.write("| Atributo | Presente |\n|----------|----------|\n")
                labels = [
                    ("ID de requisito (REQ-...)", "tiene_id"),
                    ("Tipo (Functional/Quality/Constraint)", "tiene_tipo"),
                    ("Fuente (Source)", "tiene_fuente"),
                    ("Prioridad (High/Medium/Low)", "tiene_prioridad"),
                    ("Formato \"El sistema deberá\"", "tiene_formato_ireb"),
                    ("Criterios de verificación", "tiene_verificacion"),
                    ("Rationale", "tiene_rationale"),
                ]
                for lbl, key in labels:
                    val = si.get(key, False)
                    f.write(f"| {lbl} | {'✅' if val else '❌'} |\n")
                f.write(f"\n**Atributos preservados**: {si['atributos_preservados']}/{si['total_atributos']}\n\n")
            else:
                f.write("*(no se encontró spec.md para analizar)*\n")

    # ── Generar summary.json con métricas valiosas ──
    comp_data = comp if comp else {}
    # Puntuación compuesta (0-10)
    # Diseño intencional: 40% F1 (coincidencia con PR real, métrica que ya
    # integra precision+recall), 30% calidad código (incidencias relativas),
    # 30% eficiencia de coste. No se incluyen precision/recall por separado
    # porque F1 ya es su media armónica — ponderarlos aparte triplicaría
    # la misma señal en el score.
    f1_score = comp_data.get("f1", 0)
    precision = comp_data.get("precision", 0)
    recall = comp_data.get("recall", 0)

    # Calidad código: incidencias por cada 100 líneas (escala más discriminativa
    # que la anterior que usaba 0.1/cloc y casi siempre daba ~1.0)
    incidencias = sg_total + lint_total
    ratio_incidencias = (incidencias / max(cloc_total, 1)) * 100  # por cada 100 líneas
    code_quality = max(0, 1 - min(ratio_incidencias, 2) / 2)  # 2+ por 100L = 0
    code_quality = min(code_quality, 1)

    # Eficiencia de coste: normalizado contra $0.15 (máximo observado en
    # ejecuciones piloto de los 6 casos originales; C2/appwrite-10832 dio
    # ~$0.087, C1/appwrite-10832 ~$0.10, el máximo fue ~$0.15)
    cost_efficiency = max(0, 1 - cost / 0.15)
    cost_efficiency = min(cost_efficiency, 1)

    score = (
        f1_score * 0.40 +
        code_quality * 0.30 +
        cost_efficiency * 0.30
    )
    score_10 = round(score * 10, 1)

    summary_data = {
        "flow": flow,
        "caso": case_str,
        "repo": repo,
        "reqid": reqid,
        "timestamp": timestamp,
        "metricas": {
            "cloc": cloc_total,
            "coste_usd": round(cost, 4),
            "tokens": tok,
            "archivos_diff": len(sec),
            "archivos_fuente": len(src_files),
            "semgrep_incidencias": sg_total,
            "linters_incidencias": lint_total,
            "code_quality_score": round(code_quality, 3),
        },
        "comparacion_pr": {
            "archivos_agente": comp_data.get("total_agente", 0),
            "archivos_pr": comp_data.get("total_pr", 0),
            "comunes": comp_data.get("comunes", 0),
            "solo_agente": comp_data.get("solo_agente", 0),
            "solo_pr": comp_data.get("solo_pr", 0),
            "precision": round(comp_data.get("precision", 0), 3),
            "recall": round(comp_data.get("recall", 0), 3),
            "f1": round(f1_score, 3),
        },
        "eficiencia": {
            "coste_usd": round(cost, 4),
            "cost_efficiency_score": round(cost_efficiency, 3),
            "tokens_por_dolar": round(tok / cost, 0) if cost > 0 else 0,
            "lineas_por_dolar": round(cloc_total / cost, 0) if cost > 0 else 0,
        },
        "cumplimiento_ireb": {
            "artifact_ratio": ireb['artifact_ratio'] if ireb else 0,
            "artefactos_ok": ireb['total_ok'] if ireb else 0,
            "artefactos_esperados": ireb['total_esperados'] if ireb else 0,
            "spec_atributos": ireb['spec_ireb']['atributos_preservados'] if ireb and ireb['spec_ireb'] else 0,
            "spec_atributos_total": ireb['spec_ireb']['total_atributos'] if ireb and ireb['spec_ireb'] else 7,
            "tiene_constitucion": ireb['adicionales'][0]['presente'] if ireb and ireb['adicionales'] else False,
            "tiene_scope_contract": ireb['adicionales'][1]['presente'] if ireb and ireb['adicionales'] and flow == 'C2' and len(ireb['adicionales']) > 1 else False,
        },
    }

    # Guardar JSON junto al informe markdown
    json_path = out_dir / "summary.json"
    with open(json_path, "w") as f:
        json.dump(summary_data, f, indent=2, ensure_ascii=False)

    print(f"[OK] {flow} {case_str} — F1={f1_score:.2f} semgrep={sg_total} linters={lint_total} cloc={cloc_total} ${cost:.4f}")
    print(f"     Informe: {md}")
    print(f"     JSON:    {json_path}")
    return summary_data

def main():
    if len(sys.argv) < 2:
        print("Uso: python3 scripts/aauto.py <ruta-al-resultado>", file=sys.stderr)
        sys.exit(1)
    analyze_one(Path(sys.argv[1]).resolve())

if __name__ == "__main__":
    main()
