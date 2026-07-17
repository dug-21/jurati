# Jurati — Product Vision

*The best solution for agentic delivery. This document carries the vision, its principles, and
its strategic goals. It does not carry feature status, timelines, or implementation specs —
those live in the Unimatrix capability map and in GitHub Issues.*

---

## North-star — two crowns, co-evolving

**Unimatrix** is the best **memory platform for agentic delivery.**
**Jurati** takes that memory platform and is the best **delivery solution** built on it —
**secure, self-improving, spend-minimized, and reliable.**

They are a co-evolving pair, each best-in-class at its own layer: Unimatrix crowns *memory*,
Jurati crowns *delivery*. Jurati is Unimatrix's flagship consumer and drives what its memory
becomes — as a partner, not a subordinate.

## What Jurati is

> Jurati is the best solution for agentic delivery. It **leverages** Unimatrix and the
> best-available execution and specialist components, **configures** them — including the
> coding-agent CLI's deterministic control surfaces and spawn mechanisms — and **builds the
> deterministic structure** (phases, gates, routing, firewall) around them to ship the most
> reliable outcome a swarm of agents can produce.

Concretely, Jurati is five things: the **spine** (protocols, routing, gates), the **roster**
(specialist agents that generate content and verdicts), the **memory** (Unimatrix knowledge
and the goal → capability → feature map as a live graph), the **firewall** (the safety
invariant below), and the **self-improvement loop** (versioned definitions, retro-driven,
human-gated).

**Who it is for:** one developer running their own work — first and load-bearing — built in
the open so any developer can install the same discipline.

## Principles

- **Leverage → Configure → Structure.** Jurati does not rebuild memory, execution, or
  judgment. It takes the best available (Unimatrix, the coding-agent CLI and its deterministic
  surfaces, specialist agents, ecosystem patterns), configures them, and builds the one thing
  nobody else provides — the deterministic structure that makes them deliver reliably together.
  That structure *is* the product.

- **The firewall.** Nothing counts as "done" without real, attached evidence. Research and
  "it should work" move *structure*, never *status*. The firewall governs delivery,
  self-improvement, and the product's own claims alike — including the claim to be "best."

- **Deterministic control flow + versioned definitions + pinned model — NOT deterministic
  output.** Execution is deterministic in the control-flow sense only; LLM token output is
  never bit-reproducible. Never state it unqualified.

- **Determinism governs *how*, not *which*.** A workflow executes deterministically — the rails
  do not improvise within a pinned version — but Jurati ships no static, unmodifiable
  workflows. It provides **recommended, versioned workflow definitions per domain** as starting
  points; each project adopts, pins, and evolves its own. Workflows are versioned data, not
  baked-in code — deterministic to run, adaptable by design.

- **Reliable is the north-star; secure, spend-minimized, and self-improving are the
  guardrails.** "Best" is not a vibe — it is proven on real cycles against these axes, behind
  the firewall. You cannot buy reliability by leaking credentials, burning budget, or freezing
  the process.

- **Vision commits to outcomes and feasibility; mechanisms are resolved downstream.** Each goal
  is drawn at outcome altitude — the property *works / is enforced*, not "the mechanism exists."
  Which mechanism delivers it is chosen by evaluating options against the goals and the
  capability decomposition.

- **OSS by posture.** A personal instrument, built in the open. Others can install it, adopt
  the method, or learn from it — but users are not a load-bearing constituency until demand is
  proven. External resonance is a byproduct of building well and openly, not an obligation
  taken on.

- **Prove the core, seam the rest.** Claim only what is proven on real cycles. Lay every
  extension — portability across coding agents, new domains, more autonomy, an external
  audience — as a cheap seam now, and promote it from seam to plan only on evidence.

- **Human-sovereign now; autonomy earned spoke-by-spoke.** Every proven mode today is
  human-gated. Autonomy is a gated trajectory: each step must clear the firewall on real
  cycles before it is claimed.

## What Jurati is not

- **Not an agent framework.** It ships repositories that deliver, not primitives to assemble
  agents.
- **Not a single shared runtime across projects.** Shared method and control plane; isolated
  per-project memory, credentials, and audit.
- **Not autonomously self-modifying.** A human gates every process change.
- **Not a "deterministic output" promise.** Deterministic control flow over stochastic slots —
  never reproducible tokens.

## Strategic goals

Goals are the levers that produce the north-star outcome. They decompose into behaviorally-
proven capabilities in Unimatrix (proven only on attached evidence) and into features in GitHub.

| # | Goal | Intent | Outcome (what "best" looks like) |
|---|------|--------|----------------------------------|
| 1 | **Deterministic delivery spine** | The reliability engine — gate-quality SDLC cycles (feature / bugfix / design / research as modes) executed by specialist agents on deterministic rails. | Repeatable, gated cycles that outperform freehand agent use on rework, captured decisions, and reliability. |
| 2 | **Compounding memory & capability map** | Unimatrix-backed memory that compounds every cycle; "what's left" and "what's proven" as a live graph, not a decaying document. | Delivery truth and roadmap truth cannot silently diverge; the next thing to build is a query. |
| 3 | **Self-improving workflow** | Versioned, retro-driven, human-gated improvement of the process definitions themselves. | Each cycle makes the next better; defect classes get retired, not repeated — with every change revertible and evidence-gated. |
| 4 | **Secure by construction — close Unimatrix's identity gap** ★ *primary* | Unimatrix enforces read/write/admin but lacks trustworthy agent identity; supplying attestable identity outside the LLM context is Jurati's responsibility, and it is feasible by more than one mechanism (chosen during capability decomposition and design). | Least-privilege on the memory platform and the firewall enforced *mechanically*, not by honor system; every action auditable. |
| 5 | **Spend-minimized delivery** | Deliver the reliable outcome for the least spend — cost governance, blast-radius limits, and cheapest-model-that-clears-the-bar routing. | Autonomy and scale stay affordable and bounded; cost per delivered outcome trends down. |

*All five `Advances` the north-star. Capabilities fall out of these goals next.*
