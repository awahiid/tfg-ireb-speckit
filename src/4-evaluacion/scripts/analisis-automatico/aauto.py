#!/usr/bin/env python3
"""analisis-automatico.py — Analiza un resultado con herramientas reales.

Exporta analyze_one(rd) para uso directo desde otros scripts.

Uso CLI:
  python3 scripts/analisis-automatico.py <ruta-al-resultado>
  python3 scripts/analisis-automatico.py resultados/C0/appwrite-10832/2026-07-21/023158

Salida: evaluaciones/<flow>/<repo>-<reqid>/<timestamp>/analisis-automatico.md
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
    md = out_dir / "analisis-automatico.md"

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

    print(f"[OK] {flow} {case_str} — cloc={cloc_total}  semgrep={sg_total}  linters={lint_total}  ${cost:.4f}")
    print(f"     Informe: {md}")
    return {"flow": flow, "caso": case_str, "cloc": cloc_total, "semgrep": sg_total, "eslint": lint_total, "coste": cost}

def main():
    if len(sys.argv) < 2:
        print("Uso: python3 scripts/analisis-automatico.py <ruta-al-resultado>", file=sys.stderr)
        sys.exit(1)
    analyze_one(Path(sys.argv[1]).resolve())

if __name__ == "__main__":
    main()
