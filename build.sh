#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUT_DIR="$ROOT_DIR/.generated"
TEX_FILE="$ROOT_DIR/apuntes-cpre.tex"
TEX_BASENAME="apuntes-cpre"

mkdir -p "$OUT_DIR"

pdflatex -interaction=nonstopmode -output-directory="$OUT_DIR" "$TEX_FILE"
(
  cd "$OUT_DIR"
  BIBINPUTS=.:"$ROOT_DIR" bibtex "$TEX_BASENAME"
)
pdflatex -interaction=nonstopmode -output-directory="$OUT_DIR" "$TEX_FILE"
pdflatex -interaction=nonstopmode -output-directory="$OUT_DIR" "$TEX_FILE"

echo "Build completo: $OUT_DIR/$TEX_BASENAME.pdf"
