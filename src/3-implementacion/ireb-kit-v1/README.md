# IREB Kit v1 — Unstable version (no AGENTS.md or scope contract)

> ⚠️ **WARNING**: This is the Kit version that caused verbosity and hallucinations.
> It is kept as experimental condition C1 for comparison with Kit v2.

## What is missing compared to Kit v2

| Component | Kit v1 | Kit v2 |
|---|---|---|
| AGENTS.md (universal rules R0-R4) | ❌ Missing | ✅ 5 rules |
| constitution.md (Art. 0 anti-hallucination) | ✅ | ✅ |
| spec/clarify/checklist/plan/tasks/analyze | ✅ | ✅ |
| Scope contract (step 07.5) | ❌ Missing | ✅ |
| pipeline.sh with scope contract | ❌ | ✅ |

## Observed effects

- **Without AGENTS.md**: the agent does not receive universal rules. Each `/speckit.*` command may behave inconsistently.
- **Without scope contract**: the `implement` step modifies files without restrictions, causing scope creep (up to 4238 lines in n8n-e5).
- **Result**: 3 out of 6 cases did not complete the pipeline. Average SRCI score: 3.4/10.
