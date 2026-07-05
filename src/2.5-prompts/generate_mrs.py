#!/usr/bin/env python3
"""
Genera mrs-prompts.md a partir de los REQ-*.md formalizados.
Aplica las reglas de derivacion definidas en instrucciones.md.
Version mejorada con conjugacion verbal espanola.
"""
import os
import re
from datetime import date

BASE_DIR = "/home/awahiid/cloud/mega/proyectos/tfg/src"
REQ_DIR = os.path.join(BASE_DIR, "2-requisitos")
OUTPUT_DIR = os.path.join(BASE_DIR, "2.5-prompts")
REPOS = ["appwrite", "authentik", "cal", "directus", "medusa", "n8n"]

# Mapa de verbos: infinitivo -> subjuntivo presente (3a singular)
CONJUGACION = {
    "aceptar": "acepte", "actualizar": "actualice", "aplicar": "aplique",
    "asegurar": "asegure", "asumir": "asuma", "autenticar": "autentique",
    "bloquear": "bloquee", "cancelar": "cancele", "completar": "complete",
    "comprobar": "compruebe", "configurar": "configure", "confirmar": "confirme",
    "crear": "cree", "deshabilitar": "deshabilite", "descartar": "descarte",
    "diferenciar": "diferencie", "ejecutar": "ejecute", "eliminar": "elimine",
    "enviar": "envie", "especificar": "especifique", "establecer": "establezca",
    "evitar": "evite", "exponer": "exponga", "facilitar": "facilite",
    "garantizar": "garantice", "gestionar": "gestione", "guardar": "guarde",
    "habilitar": "habilite", "impedir": "impida", "incluir": "incluya",
    "inicializar": "inicialice", "inyectar": "inyecte", "listar": "liste",
    "mostrar": "muestre", "notificar": "notifique", "ocultar": "oculte",
    "ofrecer": "ofrezca", "optimizar": "optimice", "permitir": "permita",
    "prevenir": "prevenga", "proporcionar": "proporcione", "rechazar": "rechace",
    "recibir": "reciba", "registrar": "registre", "reportar": "reporte",
    "resolver": "resuelva", "restringir": "restrinja", "retornar": "retorne",
    "soportar": "soporte", "suscribir": "suscriba", "utilizar": "utilice",
    "validar": "valide", "verificar": "verifique", "vincular": "vincule",
    "devolver": "devuelva", "encolar": "encole", "extraer": "extraiga",
    "omitir": "omita", "reducir": "reduzca", "responder": "responda",
    "servir": "sirva", "ampliar": "amplie", "reescribir": "reescriba",
    "reutilizar": "reutilice", "definir": "defina", "dirigir": "dirija",
    "ser": "sea", "ir": "vaya", "tener": "tenga", "hacer": "haga",
    "decir": "diga", "poner": "ponga", "salir": "salga", "venir": "venga",
    "traer": "traiga", "producir": "produzca", "conocer": "conozca",
    "aparecer": "aparezca", "desaparecer": "desaparezca", "ofrecer": "ofrezca",
    "pertenecer": "pertenezca", "construir": "construya", "destruir": "destruya",
    "concluir": "concluya", "excluir": "excluya", "pedir": "pida",
    "seguir": "siga", "conseguir": "consiga", "elegir": "elija",
    "corregir": "corrija", "sentir": "sienta", "dormir": "duerma",
    "preferir": "prefiera", "comenzar": "comience", "empezar": "empiece",
}


def conjugar(verbo):
    """Conjuga un verbo al subjuntivo presente (3a singular)."""
    v = verbo.lower()
    if v in CONJUGACION:
        return CONJUGACION[v]
    if v.endswith("ar"):
        return v[:-2] + "e"
    elif v.endswith("er") or v.endswith("ir"):
        return v[:-2] + "a"
    return verbo


def parse_req_file(filepath):
    """Extrae los campos del REQ como diccionario."""
    with open(filepath, "r") as f:
        content = f.read()
    fields = {}
    current_field = None
    current_value = []
    for line in content.split("\n"):
        m = re.match(r"^### (.+)$", line)
        if m:
            if current_field:
                fields[current_field] = "\n".join(current_value).strip()
            current_field = m.group(1).strip()
            current_value = []
        elif current_field:
            current_value.append(line)
    if current_field:
        fields[current_field] = "\n".join(current_value).strip()
    return fields


def infer_actor(descripcion, modulo, tipo, nombre):
    """Infiere el actor mas especifico posible."""
    txt = (descripcion + " " + nombre + " " + (modulo or "")).lower()
    if "admin" in txt or "administrador" in txt or "administracion" in txt:
        return "administrador del sistema"
    if "oauth" in txt and "admin" in txt:
        return "administrador de Auth"
    if "oauth" in txt:
        return "usuario autenticado"
    if "webhook" in txt:
        return "administrador del sistema"
    if "worker" in txt or "gunicorn" in txt:
        return "administrador de sistemas"
    if "outpost" in txt:
        return "administrador de infraestructura"
    if "pago" in txt or "payment" in txt or "reserva" in txt or "booking" in txt:
        return "usuario del sistema de reservas"
    if "bloqueo" in txt or "blocklist" in txt or "spam" in txt:
        return "administrador del sistema"
    if "salesforce" in txt:
        return "usuario del sistema de integracion"
    if "subida" in txt or "archivo" in txt or "file" in txt or "upload" in txt:
        return "usuario del modulo de archivos"
    if "promocion" in txt or "producto" in txt or "sku" in txt:
        return "administrador de comercio"
    if "token" in txt or "jwt" in txt:
        return "cliente de la API"
    if "reputacion" in txt:
        return "sistema"
    if "certificado" in txt or "mtls" in txt or "test unitario" in txt:
        return "equipo de desarrollo"
    if "device" in txt or "dispositivo" in txt:
        return "dispositivo cliente"
    if "imperson" in txt:
        return "administrador del sistema"
    if "cliente" in txt or "suscrip" in txt:
        return "cliente de la API"
    if "esquema" in txt or "schema" in txt or "openapi" in txt:
        return "equipo de desarrollo"
    if "endpoint" in txt or "api" in txt:
        return "cliente de la API"
    if "conector" in txt or "stage" in txt:
        return "administrador de Authentik"
    if "disparador" in txt or "trigger" in txt:
        return "usuario del sistema de integracion"
    if "busqueda" in txt or "search" in txt:
        return "usuario del sistema"
    return "usuario del sistema"


def extract_observable_behavior(descripcion):
    """Extrae el comportamiento observable en voz activa y conjuga el verbo."""
    # Detectar si es negacion
    is_negation = bool(re.match(r"^El sistema no\s+deber", descripcion.strip(), re.IGNORECASE))
    # Eliminar prefijos "El sistema deberá/debe/debería/no deberá"
    behavior = re.sub(r"^El sistema (no\s+)?(deber[aá]|debe|deber[ií]a)\s+", "", descripcion.strip(), flags=re.IGNORECASE)
    # Tomar primera oracion significativa
    sentences = re.split(r"[.;]\s*(?=El sistema|Para|Esto|Si|Cuando|En)", behavior)
    behavior = sentences[0].strip()
    # Eliminar punto final si existe (lo anade la plantilla)
    behavior = re.sub(r"\.$", "", behavior)
    # Conjugar el primer verbo al subjuntivo
    words = behavior.split()
    if words:
        first = words[0]
        # Si es negacion, el "no" ya fue eliminado; anadirlo de vuelta
        if is_negation and first.lower() != "no":
            conj = conjugar(first)
            words[0] = "no " + (conj if conj != first else first)
            behavior = " ".join(words)
        elif first.lower() != "no":
            conj = conjugar(first)
            if conj != first:
                words[0] = conj
                behavior = " ".join(words)
    # Limitar longitud pero manteniendo sentido
    if len(behavior) > 350:
        cut = behavior[:347].rfind(" ")
        if cut > 100:
            behavior = behavior[:cut] + "..."
    return behavior


def extract_contexto_tecnico(descripcion, modulo):
    """Extrae el contexto tecnico: artefacto concreto."""
    backtick = re.findall(r"`([^`]+)`", descripcion)
    if backtick:
        env_vars = [b for b in backtick if "_" in b and b.isupper() and len(b) > 3]
        if env_vars:
            return env_vars[0]
        return backtick[0]
    endpoint = re.search(r"(/[a-z_]+(?:/[a-z_{}]+)+)", descripcion)
    if endpoint:
        return endpoint.group(1)
    if modulo and "/" in modulo:
        return modulo.strip()
    return None


def extract_motivacion(rationale, descripcion):
    """Extrae la motivacion como estado indeseable actual."""
    if rationale and rationale.strip() not in ("", "[vacio]", "[vacío]", "Rationale:"):
        primera = rationale.strip().split(".")[0].strip()
        if primera:
            # Limitar a 300 chars sin cortar palabra
            if len(primera) > 300:
                cut = primera[:297].rfind(" ")
                if cut > 50:
                    primera = primera[:cut] + "..."
            primera = primera[0].lower() + primera[1:]
            return primera, False
    behavior = re.sub(r"^El sistema (deber[aá]|debe)\s+", "", descripcion.strip(), flags=re.IGNORECASE)
    behavior = behavior.split(".")[0].strip()[:120]
    inferred = f"evitar que el sistema no {behavior}"
    return inferred, True


def extract_restriccion(descripcion):
    """Extrae restricciones condicionales."""
    m = re.search(r"(?:Si|si)\s[^.]*?(?:no\s(?:esta|estuviera|existe|haya|sea|tiene)[^.]*?)(?:\.|$)",
                  descripcion, re.IGNORECASE)
    if m:
        return m.group(0).strip().rstrip(".")
    m = re.search(r"(?:salvo que|excepto cuando|a menos que)\s[^.]*(?:\.|$)",
                  descripcion, re.IGNORECASE)
    if m:
        return m.group(0).strip().rstrip(".")
    return None


def extract_fuente(fuente):
    """Extrae la referencia mas corta y trazable."""
    if not fuente:
        return None
    # Buscar PR #NNNNN (tanto "PR #" como "Pull Request #")
    pr = re.search(r"(?:PR|Pull Request)\s*#(\d+)", fuente, re.IGNORECASE)
    if pr:
        return f"PR #{pr.group(1)}"
    issue = re.search(r"(?:Issue|issue)\s*#(\d+)", fuente)
    if issue:
        return f"Issue #{issue.group(1)}"
    url = re.search(r"https?://[^\s)]+", fuente)
    if url:
        return url.group(0)
    return fuente[:80]


def derive_mrs(fields, req_id):
    """Deriva el MRS de un REQ."""
    # Buscar campos tanto con tilde como sin tilde
    desc = fields.get("Descripción formal", fields.get("Descripcion formal", ""))
    tipo = fields.get("Tipo", "Funcional")
    modulo = fields.get("Módulo", fields.get("Modulo", ""))
    nombre = fields.get("Nombre", "")
    rationale = fields.get("Rationale", "")
    fuente = fields.get("Fuente", "")
    if not desc:
        return None, "Falta campo Descripción formal"
    actor = infer_actor(desc, modulo, tipo, nombre)
    comportamiento = extract_observable_behavior(desc)
    contexto = extract_contexto_tecnico(desc, modulo)
    motivacion, inferida = extract_motivacion(rationale, desc)
    restriccion = extract_restriccion(desc)
    fuente_corta = extract_fuente(fuente)
    lines = [f"Como {actor},", f"quiero que el sistema {comportamiento},"]
    if contexto:
        lines.append(f"a traves de `{contexto}`,")
    motivacion_text = motivacion
    if inferida:
        motivacion_text += " [inferido]"
    lines.append(f"para {motivacion_text}.")
    if restriccion:
        lines.append(f"\nRestriccion: {restriccion}")
    if fuente_corta:
        lines.append(f"Fuente: {fuente_corta}")
    notas = []
    if inferida:
        notas.append("Rationale inferido por negacion del comportamiento requerido")
    if not contexto and not restriccion:
        notas.append("No se identifico artefacto tecnico nombrable; se omite clausula de contexto")
    return "\n".join(lines), notas


def main():
    today = date.today().isoformat()
    total_ok, total_bad = 0, 0
    omitidos = []
    output = ["# MRS Prompts — Pipeline IREB/SpecKit\n",
              f"**Generado**: {today}",
              f"**Repositorios procesados**: {len(REPOS)}",
              f"**Instrucciones de derivacion**: [`instrucciones.md`](./instrucciones.md)\n"]
    for repo in REPOS:
        repo_dir = os.path.join(REQ_DIR, repo)
        if not os.path.isdir(repo_dir):
            continue
        req_files = sorted([f for f in os.listdir(repo_dir)
                            if f.startswith("REQ-") and f.endswith(".md")])
        if not req_files:
            continue
        label = {"cal": "CALCOM", "n8n": "N8N"}.get(repo, repo.upper())
        output.append("---\n")
        output.append(f"## {label}\n")
        repo_ok, repo_bad = 0, 0
        for rf in req_files:
            fp = os.path.join(repo_dir, rf)
            try:
                fld = parse_req_file(fp)
                rid = fld.get("ID", rf.replace(".md", ""))
                nom = fld.get("Nombre", "")
                mrs, notas = derive_mrs(fld, rid)
                if mrs is None:
                    omitidos.append((rid, notas))
                    repo_bad += 1
                    continue
                output.append(f"### {rid} — {nom}\n")
                output.append("**MRS:**\n")
                output.append(f"> {mrs}\n")
                if notas:
                    output.append(f"**Notas de derivacion:** {'; '.join(notas)}\n")
                repo_ok += 1
                total_ok += 1
            except Exception as e:
                omitidos.append((rf, f"Error: {e}"))
                repo_bad += 1
        total_bad += repo_bad
        output.append(f"<!-- {label}: {repo_ok} ok, {repo_bad} omitidos -->\n")
    if omitidos:
        output.append("---\n## Requisitos omitidos\n")
        output.append("| ID | Razon |\n|---|---|")
        for rid, razon in omitidos:
            output.append(f"| {rid} | {razon} |")
    output.append(f"\n---\n**Total procesados**: {total_ok}  \n**Total omitidos**: {total_bad}\n")
    outpath = os.path.join(OUTPUT_DIR, "mrs-prompts.md")
    with open(outpath, "w") as f:
        f.write("\n".join(output))
    print(f"Generado: {outpath}")
    print(f"  Procesados: {total_ok}")
    print(f"  Omitidos: {total_bad}")


if __name__ == "__main__":
    main()
