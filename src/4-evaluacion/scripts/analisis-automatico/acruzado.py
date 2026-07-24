#!/usr/bin/env python3
"""acruzado.py — Genera informe cruzado con medias, rankings y conclusiones.

Lee todos los summary.json de evaluaciones/ + amanual.json de 5-resultados/ y produce:
  - cross.md  → informe legible
  - cross.json → datos estructurados para gráficas

Uso: python3 scripts/acruzado.py
"""

import json, statistics
from pathlib import Path
from datetime import datetime

BASE = Path(__file__).resolve().parent.parent.parent.parent.parent  # raíz tfg/
EVAL = BASE / "src" / "4-evaluacion" / "evaluaciones"
FLOWS = ["C0", "C1", "C2", "C3"]
LABELS = {"C0": "SpecKit vanilla", "C1": "IREB v1", "C2": "IREB v2", "C3": "Vibe Coding"}

# ── Cargar datos ──
results = []
for js in sorted(EVAL.rglob("summary.json")):
    results.append(json.loads(js.read_text()))

# Cargar evaluaciones LLM (amanual.json)
llm_evals = []
for js in sorted(EVAL.rglob("amanual.json")):
    llm_evals.append(json.loads(js.read_text()))

print(f"📊 {len(results)} evaluaciones automáticas cargadas")
print(f"🤖 {len(llm_evals)} evaluaciones LLM cargadas")

# ── Agrupar por flow ──
by_flow = {f: [] for f in FLOWS}
by_caso = {}
for r in results:
    f = r["flow"]
    if f in by_flow:
        by_flow[f].append(r)
    key = r["caso"]
    by_caso.setdefault(key, {})[f] = r

# ── Métricas helper ──
def avg(vals): return statistics.mean(vals) if vals else 0
def median(vals): return statistics.median(vals) if vals else 0
def best(vals): return max(vals) if vals else 0

# ── Generar informe ──
md = EVAL / "cross.md"
with open(md, "w") as f:
    f.write("# Análisis cruzado — 24 requisitos × 4 flujos\n\n")
    f.write(f"**Generado**: {datetime.now():%Y-%m-%d %H:%M}\n")
    f.write(f"**Total evaluaciones**: {len(results)} ({len(results)//4} casos × 4 flujos)\n\n")

    # ════════════════════════════════════════
    # DESCRIPCIÓN DE MÉTRICAS
    # ════════════════════════════════════════
    f.write("## Descripción de métricas\n\n")
    f.write("- **F1 vs PR real**: Similaridad F1 entre archivos generados y el PR real del repositorio.\n")
    f.write("- **Precisión vs PR real**: Fracción del código generado que aparece en el PR real.\n")
    f.write("- **Recall vs PR real**: Fracción del PR real cubierta por el código generado.\n")
    f.write("- **Artefactos (encontrados/esperados)**: Ratio de artefactos IREB generados vs esperados según el diseño del flujo (C0: spec.md; C1: +constitution, clarify, analyze; C2: +scope-contract; C3: ninguno).\n")
    f.write("- **Coste medio ($)**: Coste en USD de la ejecución del pipeline (API calls).\n")
    f.write("- **Tokens medios**: Tokens totales consumidos (entrada + salida).\n")
    f.write("- **Líneas de código (cloc)**: Líneas de código fuente generadas (excluye docs/.md).\n")
    f.write("- **Archivos fuente**: Archivos de código generados (solo extensiones de código).\n")
    f.write("- **Incidencias semgrep**: Vulnerabilidades/defectos detectados por semgrep.\n")
    f.write("- **Incidencias linters**: Problemas de estilo/calidad (ESLint, etc.).\n\n")

    # ════════════════════════════════════════
    # 1. TABLA COMPARATIVA GLOBAL
    # ════════════════════════════════════════
    f.write("## 1. Comparativa global por flujo\n\n")
    f.write("| Métrica | " + " | ".join(f"{LABELS[f]}" for f in FLOWS) + " |\n")
    f.write("|--------|" + "|".join("--------" for _ in FLOWS) + "|\n")

    metrics_table = [
        ("F1 vs PR real", ("comparacion_pr", "f1"), "{:.2f}", True),
        ("Precisión vs PR real", ("comparacion_pr", "precision"), "{:.1%}", True),
        ("Recall vs PR real", ("comparacion_pr", "recall"), "{:.1%}", True),
        ("Artefactos (encontrados/esperados)", ("cumplimiento_ireb", "artifact_ratio"), "{:.0%}", True),
        ("Coste medio ($)", ("metricas", "coste_usd"), "${:.4f}", True),
        ("Tokens medios", ("metricas", "tokens"), "{:,.0f}", True),
        ("Líneas de código (cloc)", ("metricas", "cloc"), "{:.0f}", True),
        ("Archivos fuente", ("metricas", "archivos_fuente"), "{:.0f}", True),
        ("Incidencias semgrep", ("metricas", "semgrep_incidencias"), "{:.0f}", False),
        ("Incidencias linters", ("metricas", "linters_incidencias"), "{:.0f}", False),
    ]

    for label, *path_and_fmt in metrics_table:
        f.write(f"| **{label}**")
        for flow in FLOWS:
            vals = by_flow[flow]
            if not vals:
                f.write(" | —")
                continue
            try:
                key = path_and_fmt[0]
                fmt = path_and_fmt[1]
                if isinstance(key, tuple):
                    nums = [float(r.get(key[0], {}).get(key[1], 0) or 0) for r in vals]
                else:
                    nums = [float(r.get(key, 0) or 0) for r in vals]
                mean = avg(nums)
                f.write(f" | {fmt.format(mean)}")
            except Exception as e:
                f.write(f" | (error: {e})")
        f.write(" |\n")

    # ════════════════════════════════════════
    # 2. DONDE BRILLA CADA FLUJO
    # ════════════════════════════════════════
    f.write("## 2. Métricas por flujo\n\n")

    for flow in FLOWS:
        vals = by_flow[flow]
        if not vals:
            continue
        i_avg = avg([r.get("cumplimiento_ireb", {}).get("artifact_ratio", 0) for r in vals])
        f1_avg = avg([r.get("comparacion_pr", {}).get("f1", 0) for r in vals])
        coste_avg = avg([r.get("metricas", {}).get("coste_usd", 0) for r in vals])
        semgrep_avg = avg([r.get("metricas", {}).get("semgrep_incidencias", 0) for r in vals])
        lint_avg = avg([r.get("metricas", {}).get("linters_incidencias", 0) for r in vals])
        src_avg = avg([r.get("metricas", {}).get("archivos_fuente", 0) for r in vals])
        cloc_avg = avg([r.get("metricas", {}).get("cloc", 0) for r in vals])

        f.write(f"### {flow} — {LABELS[flow]}\n\n")
        f.write(f"- **Artefactos (flow)**: {i_avg:.1f}/10\n")
        f.write(f"- **F1 vs PR real**: {f1_avg:.2f}\n")
        f.write(f"- **Calidad código**: {semgrep_avg:.0f} semgrep, {lint_avg:.0f} linters\n")
        f.write(f"- **Tamaño**: {src_avg:.0f} archivos, {cloc_avg:.0f} líneas\n")
        f.write(f"- **Coste**: ${coste_avg:.4f}\n\n")



    # ════════════════════════════════════════
    # 3. MEJOR POR MÉTRICA
    # ════════════════════════════════════════
    f.write("## 3. Mejor flujo por métrica\n\n")
    f.write("| Métrica | Líder | Valor |\n")
    f.write("|---------|---------|-------|\n")

    winners = [
        ("F1 vs PR real", ("comparacion_pr", "f1"), "{:.2f}", True),
        ("Artefactos (encontrados/esperados)", ("cumplimiento_ireb", "artifact_ratio"), "{:.0%}", True),
        ("Precisión", ("comparacion_pr", "precision"), "{:.1%}", True),
        ("Recall", ("comparacion_pr", "recall"), "{:.1%}", True),
        ("Menor coste", ("metricas", "coste_usd"), "${:.4f}", False),
        ("Menos semgrep", ("metricas", "semgrep_incidencias"), "{:.0f}", False),
        ("Menos linters", ("metricas", "linters_incidencias"), "{:.0f}", False),
    ]

    for label, path, fmt, higher_is_better in winners:
        best_flow = None
        best_val = -1 if higher_is_better else float("inf")
        for flow in FLOWS:
            vals = by_flow[flow]
            if not vals:
                continue
            try:
                if isinstance(path, tuple):
                    nums = [float(r.get(path[0], {}).get(path[1], 0) or 0) for r in vals]
                elif path == "score":
                    nums = [float(r.get("score", 0) or 0) for r in vals]
                else:
                    m = {"coste_usd": ("metricas", "coste_usd"),
                         "semgrep_incidencias": ("calidad_codigo", "semgrep_incidencias"),
                         "linters_incidencias": ("calidad_codigo", "linters_incidencias")}
                    k1, k2 = m.get(path, (None, None))
                    if k1:
                        nums = [float(r.get(k1, {}).get(k2, 0) or 0) for r in vals]
                    else:
                        nums = [float(r.get(path, 0) or 0) for r in vals]
                mean = avg(nums)
            except:
                mean = 0 if higher_is_better else float("inf")
            if higher_is_better:
                if mean > best_val:
                    best_val = mean
                    best_flow = flow
            else:
                if mean < best_val:
                    best_val = mean
                    best_flow = flow
        if best_flow:
            f.write(f"| {label} | **{best_flow}** ({LABELS[best_flow]}) | {fmt.format(best_val)} |\n")

    # ════════════════════════════════════════
    # 4. MEJOR Y PEOR CASO POR FLUJO
    # ════════════════════════════════════════
    f.write("\n## 4. Mejor y peor caso por flujo\n\n")
    f.write("| Flow | Mejor caso (F1) | F1 | Peor caso (F1) | F1 |\n")
    f.write("|------|-----------------|----|----------------|----|\n")
    for flow in FLOWS:
        vals = by_flow[flow]
        if not vals:
            continue
        best_c = max(vals, key=lambda x: x.get("comparacion_pr",{}).get("f1",0))
        worst_c = min(vals, key=lambda x: x.get("comparacion_pr",{}).get("f1",0))
        b_f1 = best_c.get("comparacion_pr",{}).get("f1",0)
        w_f1 = worst_c.get("comparacion_pr",{}).get("f1",0)
        f.write(f"| {flow} | {best_c['caso']} | {b_f1:.2f} | {worst_c['caso']} | {w_f1:.2f} |\n")

    # ════════════════════════════════════════
    # 5. RANKING GLOBAL (todos los casos)
    # ════════════════════════════════════════
    f.write("\n## 5. Ranking global (top 10 por F1)\n\n")
    f.write("| # | Flow | Caso | F1 | Artf | Coste |\n")
    f.write("|---|------|------|----|------|-------|\n")
    sorted_all = sorted(results, key=lambda x: x.get("comparacion_pr",{}).get("f1",0), reverse=True)
    for i, r in enumerate(sorted_all[:10], 1):
        f1 = r.get("comparacion_pr", {}).get("f1", 0)
        ireb = r.get("cumplimiento_ireb", {}).get("artifact_ratio", 0)
        coste = r.get("metricas", {}).get("coste_usd", 0)
        f.write(f"| {i} | {r['flow']} | {r['caso']} | {f1:.2f} | {ireb:.0%} | ${coste:.4f} |\n")

    # ════════════════════════════════════════
    # 5b. EVALUACIÓN LLM (amanual.json)
    # ════════════════════════════════════════
    if llm_evals:
        f.write("\n## 5b. Evaluación LLM — medias por sección\n\n")
        BLOQUES = ["bloque_A", "bloque_B", "bloque_C", "bloque_D", "bloque_E"]
        BLOQUE_LABELS = {
            "bloque_A": "Trazabilidad y evidencia",
            "bloque_B": "Completitud y estructura",
            "bloque_C": "Corrección técnica",
            "bloque_D": "Calidad de implementación",
            "bloque_E": "Alineación SpecKit-IREB",
        }

        # Agrupar por flow
        llm_by_flow = {f: [] for f in FLOWS}
        for e in llm_evals:
            case = e.get("_metadata", {}).get("caso", "")
            flow = e.get("_metadata", {}).get("flow", "")
            if flow in llm_by_flow:
                llm_by_flow[flow].append(e)

        # Tabla: medias por sección por flujo
        f.write("| Sección | " + " | ".join(f"{LABELS[f]}" for f in FLOWS) + " |\n")
        f.write("|---------|" + "|".join("--------" for _ in FLOWS) + "|\n")

        for blk in BLOQUES:
            f.write(f"| **{BLOQUE_LABELS[blk]}**")
            for flow in FLOWS:
                vals = llm_by_flow[flow]
                if not vals:
                    f.write(" | —")
                    continue
                scores = [e.get(blk, {}).get("puntuacion", 0) for e in vals if blk in e]
                mean = avg(scores) if scores else 0
                f.write(f" | {mean:.1f}")
            f.write(" |\n")

        # Total medio
        f.write("| **Total (media)**")
        for flow in FLOWS:
            vals = llm_by_flow[flow]
            if not vals:
                f.write(" | —")
                continue
            scores = [e.get("total", 0) for e in vals if "total" in e]
            mean = avg(scores) if scores else 0
            f.write(f" | **{mean:.1f}**")
        f.write(" |\n")

        # Mejor puntuación global
        f.write("\n### Mejor puntuación global (LLM)\n\n")
        f.write("| # | Flow | Caso | Total | Categoría |\n")
        f.write("|---|------|------|-------|----------|\n")
        sorted_llm = sorted(llm_evals, key=lambda x: x.get("total", 0), reverse=True)
        for i, e in enumerate(sorted_llm[:10], 1):
            case = e.get("_metadata", {}).get("caso", "?")
            flow = e.get("_metadata", {}).get("flow", "?")
            f.write(f"| {i} | {flow} | {case} | {e.get('total', 0):.1f} | {e.get('categoria', '?')} |\n")

        # Mejor por flujo
        f.write("\n### Mejor puntuación por flujo (LLM)\n\n")
        f.write("| Flow | Mejor caso | Total | Categoría |\n")
        f.write("|------|-----------|-------|----------|\n")
        for flow in FLOWS:
            vals = llm_by_flow[flow]
            if not vals:
                continue
            best_e = max(vals, key=lambda x: x.get("total", 0))
            case = best_e.get("_metadata", {}).get("caso", "?")
            f.write(f"| {flow} | {case} | {best_e.get('total', 0):.1f} | {best_e.get('categoria', '?')} |\n")

    # ════════════════════════════════════════
    # 6. CONCLUSIONES
    # ════════════════════════════════════════
    f.write("\n## 6. Comparativa frente a C2 (IREB v2)\n\n")
    f.write("C2 es el flujo con mejor F1 medio (0.62). La siguiente tabla compara C2 con cada\n")
    f.write("alternativa en las métricas principales:\n\n")
    f.write("| vs | F1 | Precisión | Recall | Artefactos | Coste | Linters |\n")
    f.write("|----|----|-----------|--------|-----------------|-------|---------|\n")

    c2_f1 = avg([r.get("comparacion_pr", {}).get("f1", 0) for r in by_flow["C2"]])
    c2_prec = avg([r.get("comparacion_pr", {}).get("precision", 0) for r in by_flow["C2"]])
    c2_rec = avg([r.get("comparacion_pr", {}).get("recall", 0) for r in by_flow["C2"]])
    c2_ireb = avg([r.get("cumplimiento_ireb", {}).get("artifact_ratio", 0) for r in by_flow["C2"]])
    c2_cost = avg([r.get("metricas", {}).get("coste_usd", 0) for r in by_flow["C2"]])
    c2_lint = avg([r.get("metricas", {}).get("linters_incidencias", 0) for r in by_flow["C2"]])

    f.write(f"| **C2** | **{c2_f1:.2f}** | **{c2_prec:.1%}** | **{c2_rec:.1%}** | {c2_ireb:.0%} | ${c2_cost:.4f} | {c2_lint:.0f} |\n")

    for flow in ["C0", "C1", "C3"]:
        vals = by_flow[flow]
        if not vals:
            continue
        f1 = avg([r.get("comparacion_pr", {}).get("f1", 0) for r in vals])
        prec = avg([r.get("comparacion_pr", {}).get("precision", 0) for r in vals])
        rec = avg([r.get("comparacion_pr", {}).get("recall", 0) for r in vals])
        ireb = avg([r.get("cumplimiento_ireb", {}).get("artifact_ratio", 0) for r in vals])
        cost = avg([r.get("metricas", {}).get("coste_usd", 0) for r in vals])
        lint = avg([r.get("metricas", {}).get("linters_incidencias", 0) for r in vals])
        f.write(f"| {flow} | {f1:.2f} | {prec:.1%} | {rec:.1%} | {ireb:.0%} | ${cost:.4f} | {lint:.0f} |\n")

print(f"[OK] Informe: {md}")
