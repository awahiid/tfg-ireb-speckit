#!/usr/bin/env python3
"""Split mrs-prompts.md into individual files per repo."""

import re
import os
from pathlib import Path

BASE = Path(__file__).parent
SRC = BASE / "mrs-prompts.md"

text = SRC.read_text()

# Split into blocks: each block starts with "### REQ-"
# The header line gives us the repo and ID
blocks = re.split(r"\n(?=### REQ-)", text)

repo_map = {
    "APPWRITE": "appwrite",
    "AUTHENTIK": "authentik",
    "CALCOM": "calcom",
    "DIRECTUS": "directus",
    "MEDUSA": "medusa",
    "N8N": "n8n",
}

count = 0
for block in blocks:
    # Only process blocks that start with ### REQ-
    m = re.match(r"### (REQ-(\w+)-(\d+))", block)
    if not m:
        continue

    req_id = m.group(1)   # e.g. REQ-APPWRITE-10832
    repo_code = m.group(2)  # e.g. APPWRITE
    repo = repo_map.get(repo_code)
    if not repo:
        print(f"WARNING: unknown repo {repo_code} for {req_id}")
        continue

    out_dir = BASE / repo
    out_dir.mkdir(exist_ok=True)
    out_file = out_dir / f"{req_id}.md"

    # Clean up the block: remove leading newlines and trailing separators
    content = block.strip()
    # Remove trailing HTML comment lines like <!-- APPWRITE: ... -->
    content = re.sub(r"\n<!--.*?-->\s*$", "", content)
    # Remove trailing --- separators
    content = re.sub(r"\n---\s*$", "", content)

    out_file.write_text(content + "\n")
    count += 1
    print(f"  {req_id}.md -> {repo}/")

print(f"\nDone. {count} files created.")
