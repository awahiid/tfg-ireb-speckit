#!/usr/bin/env python3
"""amanual.py — Evalúa un resultado del pipeline usando LLM (opencode + DeepSeek V4 Flash).

Uso:
    python3 amanual.py <ruta-al-resultado>

La ruta puede ser:
  - Un directorio en src/3-implementacion/resultados/<flow>/<caso>/<timestamp>/
  - Un directorio en src/4-evaluacion/evaluaciones/<flow>/<caso>/<timestamp>/

El script lee los artefactos, lanza opencode con la rúbrica SRCI v3,
y guarda la evaluación JSON en src/4-evaluacion/evaluaciones/<flow>/<caso>/<timestamp>/amanual.json
"""

import sys
import json
import re
import os
import subprocess
from pathlib import Path
from datetime import datetime

# ── Raíz del proyecto ──
BASE = Path(__file__).resolve().parent.parent.parent.parent.parent  # tfg/
RESULTADOS = BASE / "src" / "3-implementacion" / "resultados"
EVALUACIONES = BASE / "src" / "4-evaluacion" / "evaluaciones"
REQUISITOS = BASE / "src" / "2-requisitos"
RUBRICA_PATH = BASE / "src" / "4-evaluacion" / "scripts" / "rubrica-resultados.md"

# ── OpenCode ──
OPENCODE_BIN = "/home/awahiid/.npm-global/bin/opencode"


def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)


def find_artifacts(result_dir: Path) -> dict:
    """Escanea el directorio de resultado y devuelve un dict con las rutas relevantes."""
    artifacts = {"dir": result_dir}

    # summary.json (en evaluaciones o en resultados)
    for p in [result_dir / "summary.json", result_dir.parent / "summary.json"]:
        if p.exists():
            artifacts["summary"] = p
            break

    # aauto.md (en evaluaciones)
    auto_md = result_dir / "aauto.md"
    if auto_md.exists():
        artifacts["auto_md"] = auto_md

    # diff.patch
    diff = result_dir / "diff.patch"
    if diff.exists():
        artifacts["diff"] = diff

    # generated/ (artefactos del pipeline) — leer TODO recursivamente
    gen = result_dir / "generated"
    if gen.exists():
        artifacts["generated"] = gen
        gen_files = []
        for f in sorted(gen.rglob("*")):
            if f.is_file():
                rel = f.relative_to(gen)
                gen_files.append((str(rel), f))
        artifacts["generated_files"] = gen_files
        eprint(f"[amanual] generated/: {len(gen_files)} archivos")

    # input (changelog)
    input_txt = result_dir / "00-input-changelog.txt"
    if input_txt.exists():
        artifacts["input"] = input_txt

    return artifacts


def read_artifact(path: Path | None, max_lines=200) -> str | None:
    """Lee un artefacto, truncando si es muy grande."""
    if not path or not path.exists():
        return None
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    if len(lines) > max_lines:
        return "\n".join(lines[:max_lines]) + f"\n\n[... {len(lines)-max_lines} líneas omitidas -- fin del archivo]"
    return "\n".join(lines)


def find_req_file(repo: str, reqid: str) -> Path | None:
    """Busca el REQ-*.md de entrada en src/2-requisitos/<repo>/."""
    repo_dir = REQUISITOS / repo
    if not repo_dir.exists():
        return None
    for f in repo_dir.rglob(f"*{reqid}*"):
        if f.suffix == ".md":
            return f
    return None


def build_prompt(artifacts: dict) -> str:
    """Construye el prompt completo con rúbrica + artefactos + plantilla JSON."""
    rubric_text = read_artifact(RUBRICA_PATH, max_lines=500) or "(rúbrica no encontrada)"

    prompt_parts = [
        "# Instrucciones\n",
        "Eres un evaluador experto en ingeniería de requisitos (IREB CPRE, ISO 29148).",
        "Evalúa el siguiente resultado de un pipeline de generación de código según la rúbrica SRCI v3.",
        "",
        "⚠️ IMPORTANTE: SOLO LECTURA. No edites, no escribas, no crees nada.",
        "⚠️ RESTRICCIÓN: No puedes leer archivos del sistema. Todos los artefactos necesarios YA están incluidos en este prompt.",
        f"⚠️ El directorio de trabajo es: `{artifacts['dir']}`",
        "⚠️ Si un artefacto no aparece en este prompt, asume que no fue generado (puntuación 0).",
        "⚠️ Para C3 (Vibe Coding) no hay spec.md, plan.md, tasks.md, checklist.md. Evalúa solo diff.patch y summary.json.",
        "",
        "## Rúbrica de evaluación",
        "",
        rubric_text,
        "",
        "---",
        "## Artefactos del resultado",
        "",
    ]

    # Añadir artefactos relevantes
    if "summary" in artifacts:
        prompt_parts.append("### summary.json")
        prompt_parts.append(read_artifact(artifacts["summary"]) or "(vacío)")
        prompt_parts.append("")

    if "auto_md" in artifacts:
        prompt_parts.append("### aauto.md")
        prompt_parts.append(read_artifact(artifacts["auto_md"], max_lines=300) or "(vacío)")
        prompt_parts.append("")

    # ── TODO generated/ (inyectado completo, el agente NO puede leer archivos) ──
    if "generated_files" in artifacts:
        prompt_parts.append("### generated/ (artefactos completos del pipeline)")
        prompt_parts.append("")
        for rel, fpath in artifacts["generated_files"]:
            content = read_artifact(fpath, max_lines=300) or "(vacío)"
            prompt_parts.append(f"#### {rel}")
            prompt_parts.append(content)
            prompt_parts.append("")

    if "input" in artifacts:
        prompt_parts.append("### Input original (changelog)")
        prompt_parts.append(read_artifact(artifacts["input"]) or "(vacío)")
        prompt_parts.append("")

    if "req_file" in artifacts:
        prompt_parts.append("### REQ de entrada (formalizado)")
        prompt_parts.append(read_artifact(artifacts["req_file"]) or "(vacío)")
        prompt_parts.append("")

    if "diff" in artifacts:
        diff_text = read_artifact(artifacts["diff"], max_lines=150)
        if diff_text:
            prompt_parts.append("### diff.patch (inicio)")
            prompt_parts.append(diff_text)
            prompt_parts.append("")

    # Plantilla JSON
    prompt_parts.extend([
        "---",
        "## Formato de respuesta",
        "",
        "Devuelve ÚNICAMENTE un bloque JSON válido (sin markdown, sin explicación adicional).",
        "Usa esta plantilla exacta:",
        "",
        """```json
{
  "bloque_A": {
    "puntuacion": 0,
    "maximo": 12,
    "justificacion": "texto breve",
    "criterios": {
      "A1": 1, "A2": 1, "A3": 1, "A4": 1, "A4b": 1, "A4c": 1,
      "A5": 1, "A6": 1, "A7": 1, "A8": 1, "A9": 1,
      "A10": 1, "A11": 1, "A12": 1
    }
  },
  "bloque_B": {
    "puntuacion": 0,
    "maximo": 5,
    "justificacion": "texto breve",
    "criterios": {
      "B1": 1, "B2": 1, "B3": 1, "B4": 1, "B5": 1
    }
  },
  "bloque_C": {
    "puntuacion": 0,
    "maximo": 3,
    "justificacion": "texto breve",
    "criterios": {
      "C1": 1, "C2": 1, "C3": 1
    }
  },
  "bloque_D": {
    "puntuacion": 0,
    "maximo": 4,
    "justificacion": "texto breve",
    "criterios": {
      "D1": 1, "D2": 1, "D3": 1, "D4": 1
    }
  },
  "bloque_E": {
    "puntuacion": 0,
    "maximo": 0,
    "justificacion": "texto breve",
    "tsr": 0.0,
    "total_requisitos": 0,
    "satisfechos": 0,
    "parciales": 0,
    "no_satisfechos": 0
  },
  "total": 0.0,
  "categoria": "Conforme|Parcialmente conforme|Conformidad baja|No conforme",
  "diagnostico": "Fortaleza principal. Debilidad principal."
}
```""",
    ])

    return "\n".join(prompt_parts)


def call_opencode(prompt: str, result_dir: Path, eval_dir: Path) -> str:
    """Llama a opencode pasando el prompt por stdin (evita 'Argument list too long')."""
    model = "deepseek/deepseek-v4-flash"
    cmd = [
        OPENCODE_BIN, "run",
        "--model", model,
        "--agent", "srci-v3-evaluator",
    ]
    env = {**os.environ, "OPENCODE_MODEL": model}

    eprint(f"[amanual] Lanzando opencode (DeepSeek V4 Flash)...")
    eprint(f"[amanual] Prompt: {len(prompt)} chars | Resultado: {result_dir}")
    eprint(f"[amanual] COMANDO: opencode run --model {model} --agent srci-v3-evaluator < stdin")
    eprint(f"[amanual] ENV: OPENCODE_MODEL={model}")
    sep = "- " * 40
    eprint(f"[amanual] Conversación a continuación (espera...)\n{sep}")

    proc = subprocess.run(
        cmd,
        input=prompt,
        capture_output=True,
        text=True,
        cwd=BASE,
        env=env,
    )
    output = proc.stdout
    if proc.stderr:
        output += proc.stderr
    print(output, end="", flush=True)

    print(f"\n{sep}")
    eprint(f"[amanual] opencode exit: {proc.returncode}")

    return output


def get_last_session_cost(caso: str) -> dict | None:
    """Obtiene coste real de la última sesión de opencode vía export.

    Busca la sesión más reciente cuyo título contenga el nombre del caso.
    Devuelve dict con tokens y coste, o None si no encuentra.
    """
    try:
        result = subprocess.run(
            [OPENCODE_BIN, "session", "list"],
            capture_output=True, text=True, timeout=30,
        )
        lines = result.stdout.strip().split("\n")
        # Buscar la línea que contenga el nombre del caso
        session_id = None
        for line in lines:
            if caso in line and line.strip():
                # Extraer session ID (primera palabra antes del espacio)
                parts = line.strip().split()
                if parts and parts[0].startswith("ses_"):
                    session_id = parts[0]
                    break
        if not session_id:
            eprint(f"[amanual] No se encontró sesión para {caso}")
            return None

        import tempfile
        tmp = tempfile.NamedTemporaryFile(mode="w", suffix=".json", delete=False)
        tmp_path = tmp.name
        tmp.close()
        r = subprocess.run(
            [OPENCODE_BIN, "export", session_id],
            capture_output=True, text=True, timeout=30,
        )
        if r.returncode != 0:
            Path(tmp_path).unlink(missing_ok=True)
            eprint(f"[amanual] export falló (código {r.returncode}): {r.stderr[:200]}")
            return None
        Path(tmp_path).write_text(r.stdout)
        with open(tmp_path) as f:
            data = json.load(f)
        Path(tmp_path).unlink(missing_ok=True)
        msgs = data.get("messages", [])
        total_in = 0
        total_out = 0
        total_cost = 0.0
        for m in msgs:
            info = m.get("info", {})
            tok = info.get("tokens", {}) or {}
            total_in += tok.get("input", 0)
            total_out += tok.get("output", 0)
            total_cost += info.get("cost", 0.0)
        return {
            "session_id": session_id,
            "input_tokens": total_in,
            "output_tokens": total_out,
            "total_tokens": total_in + total_out,
            "cost_total_usd": round(total_cost, 6),
        }
    except Exception as e:
        eprint(f"[amanual] No se pudo obtener coste real: {e}")
        return None


def extract_json(text: str) -> dict | None:
    """Extrae el primer bloque JSON válido de la respuesta."""
    # Intentar ```json ... ```
    m = re.search(r"```(?:json)?\s*\n?(.*?)```", text, re.DOTALL)
    if m:
        candidate = m.group(1).strip()
        try:
            return json.loads(candidate)
        except json.JSONDecodeError:
            pass

    # Intentar { ... } directamente
    m = re.search(r"(\{.*\})", text, re.DOTALL)
    if m:
        candidate = m.group(1).strip()
        try:
            return json.loads(candidate)
        except json.JSONDecodeError:
            pass

    return None


def estimate_cost(prompt: str, response: str) -> dict:
    """Estima tokens y coste según tarifas DeepSeek V4 Flash.

    Tarifas aproximadas (públicas):
      - Input:  $0.15 / 1M tokens
      - Output: $0.60 / 1M tokens
    """
    input_tokens = len(prompt) // 3
    output_tokens = len(response) // 3
    cost_input = input_tokens * 0.15 / 1_000_000
    cost_output = output_tokens * 0.60 / 1_000_000
    return {
        "input_tokens_est": input_tokens,
        "output_tokens_est": output_tokens,
        "total_tokens_est": input_tokens + output_tokens,
        "cost_input_est": round(cost_input, 6),
        "cost_output_est": round(cost_output, 6),
        "cost_total_est": round(cost_input + cost_output, 6),
        "modelo": "deepseek/deepseek-v4-flash",
        "tarifa_input": "$0.15/1M tokens",
        "tarifa_output": "$0.60/1M tokens",
        "nota": "Estimación basada en chars/3. Ver coste real en dashboard DeepSeek.",
    }


def save_evaluation(result_dir: Path, eval_data: dict, cost_info: dict | None = None) -> Path | None:
    """Guarda la evaluación en evaluaciones/. Devuelve el Path o None."""
    parts = result_dir.resolve().parts
    try:
        idx = None
        for i, p in enumerate(parts):
            if p in ("C0", "C1", "C2", "C3"):
                idx = i
                break
        if idx is None:
            eprint("[amanual] ERROR: No se pudo identificar el flow en la ruta")
            return False

        flow = parts[idx]
        caso = parts[idx + 1] if idx + 1 < len(parts) else "unknown"
        ts_raw = "/".join(parts[idx + 2:]) if idx + 2 < len(parts) else "unknown"
        timestamp = ts_raw.replace("/", "-")
    except (IndexError, ValueError):
        eprint(f"[amanual] ERROR: Ruta inesperada: {result_dir}")
        return False

    out_dir = EVALUACIONES / flow / caso / timestamp
    out_dir.mkdir(parents=True, exist_ok=True)
    out_file = out_dir / "amanual.json"

    eval_data["_metadata"] = {
        "flow": flow,
        "caso": caso,
        "timestamp": timestamp,
        "eval_date": datetime.now().strftime("%Y-%m-%d %H:%M"),
        "modelo": "deepseek/deepseek-v4-flash",
        "herramienta": "amanual.py",
        "rubrica": "SRCI v3",
    }
    if cost_info:
        eval_data["_metadata"]["coste_estimado"] = cost_info

    out_file.write_text(json.dumps(eval_data, indent=2, ensure_ascii=False), encoding="utf-8")
    eprint(f"[amanual] ✅ Evaluación guardada: {out_file}")
    return out_file


def main():
    if len(sys.argv) < 2:
        print(__doc__, file=sys.stderr)
        sys.exit(1)

    result_path = Path(sys.argv[1])

    if not result_path.exists():
        eprint(f"[amanual] ERROR: La ruta no existe: {result_path}")
        for base in [RESULTADOS, EVALUACIONES]:
            candidate = base / result_path
            if candidate.exists():
                result_path = candidate
                break
        else:
            sys.exit(1)

    eprint(f"[amanual] Evaluando: {result_path}")

    artifacts = find_artifacts(result_path)

    if "summary" not in artifacts:
        eprint(f"[amanual] ERROR: No se encontró summary.json en {result_path}")
        sys.exit(1)

    summary = json.loads(artifacts["summary"].read_text())
    flow_raw = summary.get("flow", "")
    flow = flow_raw.split(" - ")[0] if " - " in flow_raw else flow_raw
    repo = summary.get("repo", "")
    reqid = summary.get("reqid", "")

    eprint(f"[amanual] Flow: {flow} | Repo: {repo} | Req: {reqid}")

    caso_id = f"{repo}-{reqid}" if repo and reqid else ""

    req_file = find_req_file(repo, reqid)
    if req_file:
        artifacts["req_file"] = req_file
        eprint(f"[amanual] REQ entrada: {req_file}")

    prompt = build_prompt(artifacts)

    # Determinar directorio de salida en evaluaciones/ (solo lectura en resultados/)
    parts = result_path.resolve().parts
    try:
        idx = next(i for i, p in enumerate(parts) if p in ("C0", "C1", "C2", "C3"))
        flow_dir = parts[idx]
        caso_dir = parts[idx + 1]
        ts_raw = "/".join(parts[idx + 2:])
        timestamp = ts_raw.replace("/", "-")
        eval_dir = EVALUACIONES / flow_dir / caso_dir / timestamp
        eval_dir.mkdir(parents=True, exist_ok=True)
    except (StopIteration, IndexError):
        eprint(f"[amanual] ERROR: No se pudo determinar ruta de evaluaciones")
        sys.exit(1)

    response = call_opencode(prompt, result_path, eval_dir)

    # Guardar respuesta cruda en evaluaciones/ (NUNCA en resultados/)
    raw_log = eval_dir / "amanual_raw.txt"
    try:
        raw_log.write_text(response, encoding="utf-8")
        eprint(f"[amanual] Log crudo: {raw_log}")
    except OSError as e:
        eprint(f"[amanual] No se pudo guardar log: {e}")

    eval_data = extract_json(response)
    if not eval_data:
        eprint(f"[amanual] ERROR: No se pudo extraer JSON de la respuesta")
        eprint(f"[amanual] Respuesta (primeros 1000 chars): {response[:1000]}")
        sys.exit(1)

    eprint(f"[amanual] JSON extraído correctamente")

    # Obtener coste real de opencode
    real_cost = get_last_session_cost(caso_id)
    if real_cost:
        eprint(f"[amanual] Coste real: ${real_cost['cost_total_usd']:.6f} "
               f"({real_cost['input_tokens']:,} in / {real_cost['output_tokens']:,} out tokens)")
        cost_info = real_cost
    else:
        eprint(f"[amanual] No se encontró sesión para coste real, usando estimación")
        cost_info = estimate_cost(prompt, response)

    out_path = save_evaluation(result_path, eval_data, cost_info)
    if out_path:
        eprint(f"[amanual] ✅ Evaluación completada")
    else:
        eprint(f"[amanual] ERROR: No se pudo guardar la evaluación")
        sys.exit(1)


if __name__ == "__main__":
    main()
