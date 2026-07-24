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
# Auto-descubrir todos los repos de resultados
def discover_cases():
    seen = set()
    cases = []
    for flow in FLOWS:
        fd = RES / flow
        if not fd.exists(): continue
        for d in sorted(fd.iterdir()):
            if not d.is_dir(): continue
            parts = d.name.split("-", 1)
            if len(parts) != 2: continue
            key = (parts[0], parts[1])
            if key not in seen:
                seen.add(key)
                cases.append(key)
    return sorted(cases)

CASOS = discover_cases()


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
    all_results = []
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
                f1 = res.get("comparacion_pr", {}).get("f1", 0)
                ireb_art = res.get("cumplimiento_ireb", {}).get("artifact_ratio", 0)
                spec = res.get("cumplimiento_ireb", {}).get("spec_ireb", {}) or {}
                sa = spec.get("atributos_preservados", 0)
                print(f"  [OK] {flow} {repo}-{rid} — F1={f1:.2f} IR_art={ireb_art:.0%} IR_spec={sa}/7")
                all_results.append(res)
            else:
                msg = f"[ERROR] {flow} {repo}-{rid}"
                print(msg)
                errors.append(msg)

    # ── Resumen global ──
    print(f"\n{'='*60}")
    print("  RESUMEN GLOBAL")
    print(f"{'='*60}")
    print(f"  Analizados: {len(all_results)}/{len(FLOWS)*len(CASOS)}")
    if errors:
        print(f"  Errores: {len(errors)}")
        for e in errors:
            print(f"    {e}")

    # ── Guardar JSON global ──
    from datetime import datetime
    global_json = EVAL / "resumen-global.json"
    with open(global_json, "w") as f:
        json.dump({
            "generado": datetime.now().strftime("%Y-%m-%d %H:%M"),
            "total_analizados": len(all_results),
            "total_esperados": len(FLOWS) * len(CASOS),
            "resultados": all_results
        }, f, indent=2, ensure_ascii=False)
    print(f"\n[OK] JSON global: {global_json}")

    # ── Generar markdown resumen ──
    # NOTA: NO se genera score compuesto. Cada dimensión por separado.
    # La evaluación principal es la rúbrica SRCI v3 (evaluar.py).
    summary_md = EVAL / "aauto.md"
    with open(summary_md, "w") as f:
        f.write("# Análisis automático — resumen global\n\n")
        f.write(f"Generado: {datetime.now():%Y-%m-%d %H:%M}\n\n")
        f.write(f"**Ejecuciones analizadas**: {len(all_results)}/{len(FLOWS)*len(CASOS)}\n\n")

        f.write("## Detalle por ejecución\n\n")
        f.write("| Flow | Caso | F1 | IR_art | IR_spec | Src | cloc | Coste | Tokens | sg | lint |\n")
        f.write("|------|------|----|--------|---------|-----|------|-------|--------|----|------|\n")
        for r in sorted(all_results, key=lambda x: (x["flow"], x["caso"])):
            m = r.get("metricas", {})
            cp = r.get("comparacion_pr", {})
            ir = r.get("cumplimiento_ireb", {})
            sp = ir.get("spec_ireb", {}) or {}
            sa = sp.get("atributos_preservados", 0)
            f.write(f"| {r['flow']} | {r['caso']} | {cp.get('f1',0):.2f} | {ir.get('artifact_ratio',0):.0%} | {sa}/7 | {m.get('archivos_fuente',0)} | {m.get('cloc',0):,} | ${m.get('coste_usd',0):.4f} | {m.get('tokens',0):,} | {m.get('semgrep_incidencias',0)} | {m.get('linters_incidencias',0)} |\n")

        f.write("## Promedios por flow\n\n")
        f.write("| Flow | F1 | IR_art | Src | cloc | Coste | Tokens | semgrep | lint |\n")
        f.write("|------|----|--------|-----|------|-------|--------|---------|------|\n")
        for flow in FLOWS:
            fr = [r for r in all_results if r["flow"] == flow]
            if not fr: continue
            n = len(fr)
            f1 = sum(r.get("comparacion_pr",{}).get("f1",0) for r in fr) / n
            ireb_art = sum(r.get("cumplimiento_ireb",{}).get("artifact_ratio",0) for r in fr) / n
            arch = sum(r.get("metricas",{}).get("archivos_fuente",0) for r in fr) / n
            cloc = sum(r.get("metricas",{}).get("cloc",0) for r in fr) / n
            coste = sum(r.get("metricas",{}).get("coste_usd",0) for r in fr) / n
            tokens = sum(r.get("metricas",{}).get("tokens",0) for r in fr) / n
            semg = sum(r.get("metricas",{}).get("semgrep_incidencias",0) for r in fr) / n
            lint = sum(r.get("metricas",{}).get("linters_incidencias",0) for r in fr) / n
            f.write(f"| {flow} | {f1:.2f} | {ireb_art:.0%} | {arch:.0f} | {cloc:,.0f} | ${coste:.4f} | {tokens:,.0f} | {semg:.0f} | {lint:.0f} |\n")

        f.write("\n## Rankings\n\n")
        by_f1 = sorted(all_results, key=lambda x: x.get("comparacion_pr",{}).get("f1",0), reverse=True)
        f.write("### Top 5 por F1 (coincidencia con PR real)\n\n")
        f.write("| # | Flow | Caso | F1 | IR_art | Coste |\n|---|------|------|----|--------|-------|\n")
        for i, r in enumerate(by_f1[:5], 1):
            f1 = r.get("comparacion_pr",{}).get("f1",0)
            ireb_art = r.get("cumplimiento_ireb",{}).get("artifact_ratio",0)
            coste = r.get("metricas",{}).get("coste_usd",0)
            f.write(f"| {i} | {r['flow']} | {r['caso']} | {f1:.2f} | {ireb_art:.0%} | ${coste:.4f} |\n")
        f.write("\n### Bottom 5 por F1\n\n")
        f.write("| # | Flow | Caso | F1 | IR_art | Coste |\n|---|------|------|----|--------|-------|\n")
        for i, r in enumerate(by_f1[-5:], 1):
            f1 = r.get("comparacion_pr",{}).get("f1",0)
            ireb_art = r.get("cumplimiento_ireb",{}).get("artifact_ratio",0)
            coste = r.get("metricas",{}).get("coste_usd",0)
            f.write(f"| {i} | {r['flow']} | {r['caso']} | {f1:.2f} | {ireb_art:.0%} | ${coste:.4f} |\n")

    print(f"[OK] Resumen: {summary_md}")


if __name__ == "__main__":
    main()
