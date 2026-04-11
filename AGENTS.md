# AGENTS.md

## Scope

This repository contains a TFG about comparing IREB with SpecKit and documenting the analysis in LaTeX and Markdown.

## Working Rules

- Keep changes focused and minimal.
- Prefer direct, concrete writing over long explanations.
- Do not commit generated files, build artifacts, or PDFs.
- LaTeX outputs should stay in `docs/cpre/.generated/`.
- Use the existing style of the files you edit.

## Commit Style

- Use short, descriptive conventional-style commit messages.
- Preferred format: `type: brief summary`
- Good examples:
  - `docs: formalize speckit analysis`
  - `chore: add project guidance`
  - `docs: update cpre notes`

## Repository Hygiene

- Check `git status` before committing.
- Stage only source files that belong in the repository.
- Exclude PDFs, `.aux`, `.log`, `.bbl`, `.blg`, `.out`, `.toc`, `.synctex.gz`, and other generated LaTeX artifacts.
