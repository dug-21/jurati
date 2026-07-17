# ASS-005 — Self-Improving Deterministic Workflows

*Founding vision research · Tier 2 (depends on ASS-001, ASS-002) · Mixed (internal + external)*

## Goal

Answerable questions:

1. How can a **deterministic-execution** harness **continuously improve** its process
   definitions? Reconcile the apparent contradiction — "the run is deterministic" vs.
   "the system gets better over time."
2. What is the concrete feedback loop: run → measure → propose variant → A/B → adopt?
   Within that loop, what is deterministic (harness-owned) and what is LLM-driven?
3. What can Jurati reuse from how **Unimatrix** (ASS-001) and **arch-research** (ASS-002)
   already do improvement — rather than inventing from scratch?
4. What external **eval-driven / flywheel** patterns apply, and what are the risks —
   overfitting to a metric, reward-hacking, drift, loss of reproducibility?
5. What is the **minimum self-improvement capability worth building into v1** vs.
   deferring? Where is the honest MVP line?

## Breadth

`code+ecosystem` + `industry` — dual-track: internal (Unimatrix effectiveness data +
arch-research's mechanism, via the ASS-001/ASS-002 findings) and external (eval/flywheel
literature).

## Approach

`investigation` + `literature`.

## Confidence required

`directional`.

## Target outputs

- **Self-improvement model**: the recommended shape of Jurati's improvement loop.
- **Determinism resolution**: the explicit answer to "deterministic yet improving" —
  candidate hypothesis to test: *execution is deterministic; the process definitions
  (protocols, prompts, LLM-slots) are what evolve, measured against outcomes in Unimatrix.*
- **Deterministic/LLM split** within the loop itself.
- **v1-vs-later scope line** for self-improvement.
- **Risks + mitigations** (overfitting, reward-hacking, drift, reproducibility).

## Constraints

**Hard:**
- Unimatrix is the measurement/feedback substrate.

**Hypothesis (challengeable):**
- Self-improvement is a *founding* property of Jurati, not a bolt-on.
- The determinism/improvement split above holds — challenge it if the evidence points
  elsewhere.

## Dependencies

**Depends on:** ASS-001 (Unimatrix substrate — the measurement machinery) and ASS-002
(arch-research's improvement design). Both FINDINGS.md are prior-art inputs; do not
re-investigate them. **Feeds** the vision synthesis.

## Prior art

- ASS-001 and ASS-002 FINDINGS.md (feed-through — read as context).
- Unimatrix `context_status` effectiveness / observation / retrospection data.
- External eval-driven-improvement and agent-flywheel literature.
