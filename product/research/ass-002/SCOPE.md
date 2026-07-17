# ASS-002 — The arch-research Factory

*Founding vision research · Tier 1 (independent) · Internal*

## Goal

Answerable questions:

1. How is the `arch-research` workflow factory structured — what runs deterministically
   vs. what is LLM-driven, and what generalizes into a reusable harness?
2. How did arch-research design **workflow-improvement in from the start** — what is the
   concrete mechanism, and what has it actually learned in practice? (feeds ASS-005)
3. How does arch-research **use Unimatrix today** — which primitives, what integration
   pattern, what works and what is awkward?
4. What from arch-research should Jurati adopt directly, and what should it avoid?

## Breadth

`code+ecosystem` — read the `github.com/dug-21/arch-research` repository and its
workflow/protocol definitions.

## Approach

`investigation`.

## Confidence required

`directional` — design input for Jurati; no PoC required.

## Target outputs

- **Generalizable patterns**: the deterministic-vs-LLM split and workflow structure
  worth carrying into Jurati.
- **Improvement mechanism**: how arch-research bakes in continuous workflow improvement,
  described concretely enough to reuse.
- **Unimatrix usage pattern**: how a real workflow factory consumes Unimatrix today.
- **Adopt / avoid list**: what to reuse, what to leave behind.

## Constraints

**Hard:**
- arch-research is an existing repository; this spike is read-only against it.

**Hypothesis (challengeable):**
- Its improvement design generalizes from research workflows to SDLC workflows.

## Dependencies

None (Tier 1). **Unblocks** ASS-005 (self-improvement) and the vision synthesis.

## Prior art

- `github.com/dug-21/arch-research` repository.
- Human note: the factory was designed with workflow improvement in mind from day one,
  and it uses Unimatrix today.
