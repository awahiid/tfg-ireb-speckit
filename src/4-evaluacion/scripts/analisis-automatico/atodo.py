#!/usr/bin/env python3
"""atodo.py — Analiza los 24 resultados mas recientes.

Importa analyze_one de aauto.py y lo ejecuta en el mismo proceso.
Uso: python3 atodo.py
"""

import sys, json
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from aauto import analyze_one

BASE = Path(__file__).resolve().parent.parent.parent
RES = BASE.parent / "3-implementacion" / "resultados"
EVAL = BASE / "evaluaciones"
FLOWS = ["C0", "C1", "C2", "C3"]
CASOS = [
    ("appwrite", "10832"),
    ("authentik", "10110"),
    ("calcom", "26812"),
    ("directus", "26646"),
    ("medusa", "13930"),
    ("n8n", "31371"),
]


def find_latest(flow, repo, req_id):
    d = RES / flow / f"{repo}-{req_id}"
    if not d.exists():
        return None
    for f in sorted(d.iterdir(), reverse=True):
        if not f.name.startswith("20"):
            continue
        for r in sorted(f.iterdir(), reverse=True):
            if (r / "diff.patch").exists():
                return r
    return None


def main():
    results = []
    errors = []

    for flow in FLOWS:
        for repo, rid in CASOS:
            rd = find_latest(flow, repo, rid)
            if not rd:
                msg = f"[WARN] {flow} {repo}-{rid}: no results"
                print(msg)
                errors.append(msg)
                continue

            print(f"\n{'='*60}")
            print(f"  {flow} {repo}-{rid}  —  {rd.parent.name}/{rd.name}")
            print(f"{'='*60}")

            res = analyze_one(str(rd))
            if res:
                print(f"  [OK] {flow} {repo}-{rid}")
                results.append((flow, repo, rid, rd))
            else:
                print(f"  [ERROR] {flow} {repo}-{rid}")

    # Resumen global
    print(f"\n{'='*60}")
    print("  RESUMEN GLOBAL")
    print(f"{'='*60}")
    print(f"  Analizados: {len(results)}/{len(FLOWS)*len(CASOS)}")
    if errors:
        print(f"  Errores: {len(errors)}")
        for e in errors:
            print(f"    {e}")

    # Reunir metricas de los informes generados
    import re as _re
    rows = []
    all_data = {}  # {(repo, rid): {flow: {semgrep, linters, cloc, cost, ...}}}
    for flow, repo, rid, rd in results:
        ts_dir = f"{rd.parent.name}-{rd.name}"
        report = EVAL / flow / f"{repo}-{rid}" / ts_dir / "analisis-automatico.md"
        if not report.exists():
            continue
        txt = report.read_text()
        cloc = cost = tok = src_files = semgrep_total = 0
        linters = {}  # tool -> total_issues
        for line in txt.split("\n"):
            if "cloc)" in line:
                m = _re.search(r'\|\s*(\d+)\s*\|', line)
                if m: cloc = int(m.group(1))
            elif "Coste" in line:
                m = _re.search(r'\|\s*\$?([\d.]+)\s*\|', line)
                if m: cost = float(m.group(1))
            elif "Tok" in line:
                m = _re.search(r'\|\s*(\d+)\s*\|', line)
                if m: tok = int(m.group(1))
            elif "fuente" in line:
                m = _re.search(r'\|\s*(\d+)\s*\|', line)
                if m: src_files = int(m.group(1))
            elif "Total incidencias" in line:
                m = _re.search(r':\s*(\d+)', line)
                if m: semgrep_total = int(m.group(1))
            # Extraer datos de linters: **tool**: N incidencias en M archivos
            m = _re.match(r'^\*\*([a-z]+(?:-[a-z]+)?)\*\*:\s*(\d+)\s+incidencias', line)
            if m:
                linters[m.group(1)] = int(m.group(2))
        linters_total = sum(linters.values())
        rows.append(f"| {flow} | {repo}-{rid} | {src_files} | {cloc} | ${cost:.4f} | {tok} | {semgrep_total} | {linters_total} |")
        all_data.setdefault((repo, rid), {})[flow] = {
            "cloc": cloc, "cost": cost, "tokens": tok,
            "src": src_files, "semgrep": semgrep_total, "linters": linters
        }

    # Markdown resumen
    summary = EVAL / "analisis-automatico.md"
    with open(summary, "w") as f:
        from datetime import datetime
        f.write("# Analisis automatico — resumen global\n\n")
        f.write(f"Generado: {datetime.now():%Y-%m-%d %H:%M}\n\n")
        f.write(f"**Ejecuciones analizadas**: {len(results)}/{len(FLOWS)*len(CASOS)}\n\n")

        # --- Tabla detallada por caso ---
        f.write("## Detalle por ejecucion\n\n")
        f.write("| Flow | Caso | Arch. | cloc | Coste | Tokens | semgrep | linters |\n")
        f.write("|------|------|-------|------|-------|--------|---------|--------|\n")
        for r in rows:
            f.write(r + " |\n")

        # --- Tabla comparativa por repositorio (C0 vs C1 vs C2 vs C3) ---
        f.write("\n## Comparativa por repositorio\n\n")
        f.write("| Repositorio | Flow | cloc | Coste | semgrep | eslint | phpcs | shellcheck | pyflakes |\n")
        f.write("|-------------|------|------|-------|---------|--------|-------|-----------|---|\n")
        for (repo, rid) in sorted(all_data.keys()):
            flows_data = all_data[(repo, rid)]
            first = True
            for flow in FLOWS:
                if flow not in flows_data:
                    continue
                d = flows_data[flow]
                ls = d["linters"]
                lbl = f"{repo}-{rid}" if first else ""
                f.write(f"| {lbl} | {flow} | {d['cloc']} | ${d['cost']:.4f} | {d['semgrep']} | {ls.get('eslint','-')} | {ls.get('phpcs','-')} | {ls.get('shellcheck','-')} | {ls.get('pyflakes','-')} |\n")
                first = False
            f.write("|---|----|----|----|---------|--------|-------|-----------|---|\n")

        # --- Promedios por flow ---
        f.write("\n## Promedios por flow\n\n")
        f.write("| Flow | Archivos | Lineas (cloc) | Coste | Tokens |\n")
        f.write("|------|----------|---------------|-------|--------|\n")
        for flow in FLOWS:
            fr = [r for r in rows if r.startswith(f"| {flow} ")]
            if not fr:
                continue
            n = len(fr)
            arch = sum(int(r.split("|")[3].strip()) for r in fr) / n
            lineas = sum(int(r.split("|")[4].strip()) for r in fr) / n
            coste = sum(float(r.split("|")[5].strip().replace("$","")) for r in fr) / n
            tokens = sum(int(r.split("|")[6].strip()) for r in fr) / n
            f.write(f"| {flow} | {arch:.0f} | {lineas:.0f} | ${coste:.4f} | {tokens:.0f} |\n")

    print(f"\n[OK] Resumen: {summary}")


if __name__ == "__main__":
    main()
