# ASS-003 — Our Protocols, Decomposed (light pass)

*Founding vision research · Tier 1 (independent) · Internal*

> **Scope discipline:** this is a *vision-resolution* pass, not the full step-by-step
> deterministic/LLM classification. The exhaustive boundary classification is
> deliberately deferred to a round-2 spike once the vision frames it. Stay at the
> altitude needed to set direction.

## Goal

Answerable questions:

1. Across our design / delivery / bugfix / research protocols, what is *already*
   deterministic (fixed control flow, gates, routing, ordering) vs. LLM-contributed
   (judgment, content generation, synthesis)?
2. Where is orchestration currently prose-instructed to a human/LLM scrum master that a
   deterministic harness could own instead?
3. Where do self-improvement / A-B hooks naturally sit within these protocols? (feeds
   ASS-005)

## Breadth

`code-only` — this repository's `.claude/protocols/uni/*` and `.claude/agents/uni/*`.

## Approach

`investigation`.

## Confidence required

`directional`.

## Target outputs

- **First-pass deterministic/LLM map** of our proven protocols, at vision resolution.
- **Candidate harness-owned orchestration points** — the steps most ripe to move from
  prose-instruction into a deterministic spine.
- **Improvement-hook locations** — where measurement and variant-testing would attach.

## Constraints

**Hard:**
- These protocols are proven-in-use in Unimatrix delivery — the map describes what
  exists, it does not redesign it.

**Hypothesis (challengeable):**
- The deterministic spine can be extracted from the prose protocols without losing what
  makes them work.
- Full step-by-step classification is out of scope this round (round-2 spike).

## Dependencies

None (Tier 1). **Feeds** the vision synthesis (and pre-frames the round-2 boundary spike).

## Prior art

- `.claude/protocols/uni/` — design, delivery, bugfix, research, agent-routing.
- `.claude/agents/uni/` — the 19 specialist definitions and the scrum-master role.
