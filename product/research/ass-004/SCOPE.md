# ASS-004 — Agentic-Harness Landscape

*Founding vision research · Tier 1 (independent) · External*

## Goal

Answerable questions:

1. What do the leading agentic / SDLC / workflow harnesses actually do — and explicitly,
   what *should* a harness do vs. **not** do? (patterns and anti-patterns)
2. How do they split **deterministic orchestration** vs. **model-driven** behavior?
3. What patterns exist for **one harness driving multiple projects** (multi-project /
   multi-tenant orchestration) vs. per-project deployment — benefits, costs, failure
   modes? *(This is the big topology question for this round.)*
4. What patterns exist for **controlled autonomy** — guardrails, human gates, escalation,
   blast-radius limits?
5. What **self-improving / eval-driven** agent-system patterns exist — A/B of
   prompts/process, eval flywheels, offline vs. online improvement? (feeds ASS-005)
6. What **early architectural / security seams** let an OSS core extend to enterprise
   without a rewrite — multi-tenancy, authz, secrets, audit, isolation — and which are
   worth laying *now* vs. later?
7. For a harness bound to a custom backend, what would **heavy-customizing an existing
   base** (e.g. metaharness, claude-flow, LangGraph, Temporal) cost vs. a clean build?

## Breadth

`industry` — ecosystem evaluation, library/framework landscape, literature. No internal
source required.

## Approach

`literature` + `evaluation`.

## Confidence required

`directional`.

## Target outputs

- **Do / don't-do list** for harnesses, ranked, with evidence.
- **Topology options** (single-orchestrator-multi-project vs. per-project) with
  trade-offs and failure modes.
- **Controlled-autonomy patterns** worth adopting.
- **Self-improvement patterns** from the ecosystem.
- **Early-seam recommendations** for OSS→enterprise extensibility.
- **Build-vs-heavy-customize read** against the named candidate bases.

## Constraints

**Hard:**
- None — this is an external survey.

**Hypothesis (challengeable — the researcher must test these, not assume them):**
- Jurati leans **build** (or heavy-customize a base), because nothing works
  out-of-the-box against a custom Unimatrix backend.
- **Aggregated, one-harness-across-projects** is preferred over per-project deployment.
- **Some security seams are worth laying now** to enable later enterprise extension.

## Dependencies

None (Tier 1). **Unblocks** ASS-005 (self-improvement) and the vision synthesis.

## Prior art

- `github.com/ruvnet/metaharness` — the human's known point of alignment; use as an
  anchor and extend well beyond it.
- Candidate bases to survey: LangGraph, CrewAI, AutoGen, OpenAI Agents SDK / Swarm,
  Temporal (durable execution), claude-flow, and comparable orchestration frameworks.
- Human framing: deterministic spine + LLM-contributed judgment; personal/OSS-first,
  enterprise-extensible.
