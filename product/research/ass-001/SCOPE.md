# ASS-001 — Unimatrix as Substrate

*Founding vision research · Tier 1 (independent) · Internal*

## Goal

Answerable questions:

1. What does Unimatrix expose that a harness can build on — the full MCP tool
   surface, the knowledge/graph/semantic model, and the "workflow" concept it
   already understands? What are the stable integration seams a harness would bind to?
2. How can Unimatrix's graph + semantic search + categorization be used to *structure
   harness operations* — routing, run state, artifact lineage, gate decisions — not
   just to store knowledge after the fact?
3. What do Unimatrix's observation / effectiveness / extraction / retrospection
   mechanisms actually measure today, and could they serve as the feedback substrate
   for a self-improving harness (feeds ASS-005)?
4. What does Unimatrix **not** provide that Jurati would need — the gap list — that we
   could add to Unimatrix, given the human controls that repo (the co-evolution seam)?

## Breadth

`code+ecosystem` — read the `github.com/dug-21/unimatrix` codebase and exercise the
live MCP surface / knowledge state.

## Approach

`investigation` + `evaluation`.

## Confidence required

`directional` — a recommendation on how Jurati binds to Unimatrix; no PoC required.

## Target outputs

- **Substrate contract**: the stable integration seams (tools, schemas, state) a harness
  can depend on.
- **Primitive→use map**: which Unimatrix capabilities (graph, semantic search,
  categorization, workflow concept, effectiveness tracking) map to which harness
  concerns (orchestration, memory, lineage, self-improvement).
- **Unimatrix gap/wishlist**: what Jurati will need that Unimatrix lacks — the
  co-evolution backlog.

## Constraints

**Hard:**
- Unimatrix is the backing memory/context engine (an MCP server). Jurati is a
  *companion* to it, not a fork.

**Hypothesis (challengeable):**
- Unimatrix is extensible on demand — if Jurati needs a capability it lacks, we build it
  into Unimatrix (co-evolution) rather than routing around it.
- Self-improvement can ride Unimatrix's existing effectiveness/observation machinery
  rather than requiring a separate measurement store.

## Dependencies

None (Tier 1). **Unblocks** ASS-005 (self-improvement) and the vision synthesis.

## Prior art

- `github.com/dug-21/unimatrix` repository.
- CLAUDE.md "Unimatrix" section (this repo).
- The `context_*` MCP tool family (search, lookup, get, graph, store, correct, status…).
- `context_status` already reports observation records, effectiveness
  (effective / ineffective / noisy), extraction, and retrospection counts — evidence a
  measurement loop exists but is unused (0 retrospected).
