# ASS-007 — Does Anyone But the Human Want This? (demand validation)

*Founding vision research · external demand spike · resolves tensions T1 / T8 for the vision synthesis*

**Spike**: ass-007
**Assigned agent**: `uni-external-researcher` (Case 1 — external only; no protocol variance)
**Status**: scope drafted — awaiting human detailed review

---

## The question behind the spike

ASS-006 generated 23 mechanism-grounded identities and flagged its own honest ceiling: **all five
founding FINDINGS establish *feasibility*; none establish *demand*.** The identities split on one axis:

- **Personal-compounding** (H1, H2, H5, H12, H13, H14) — compound *because one human runs the loop*;
  need no external demand and are out of scope here.
- **Audience-dependent** (H3, H4, H6, H7, H8, H11, H17, H21, H22) — every one rests on the assumption
  *"others want this too."* **That assumption is what this spike tests.**

This spike de-risks that assumption with **proxy/expressed** demand evidence and designs the **primary**
test the human runs next. It does not — and cannot — perform primary validation itself (see Constraints).

## Goal

Answerable questions:

1. For each **demand cluster** below, what **expressed/proxy demand evidence** exists in public sources
   (voiced pain in Claude Code / agentic-dev communities, adjacent-tool adoption and traction, competitor
   existence, stated willingness-to-pay/adopt), and **how strong is it** (strong / moderate / weak /
   none), with sources?
   - **Cluster A — OSS Claude Code developers** wanting installable, proven SDLC discipline (H8 registry,
     H7 spine-as-software, H3 per-repo component). *The north-star's stated OSS-first audience; likely the
     nearest and cheapest to reach — weight discovery here.*
   - **Cluster B — the agentic-engineering field** wanting a portable method/standard (H17 methodology).
   - **Cluster C — accountable / regulated / enterprise-curious teams** wanting audit-grade agentic
     delivery (H11, bridging to H21 enterprise-pull).
   - **Cluster D — non-software knowledge workers** wanting structured-work harnesses for other domain
     agentic workflows (H6, H22) — now first-class per the human's expanded north-star.
2. **Who specifically** is the ideal customer profile (ICP) for the strongest-signal cluster — role,
   context, the pain **in their own words**, and where they congregate?
3. **Competitive / adjacent landscape** — who already serves each cluster's demand (e.g. claude-flow /
   ruflo, SPARC, metaharness, BMAD, LangGraph-based delivery tools, Devin-class agents), what real
   traction do they have (weight contributor count / issue activity / actual usage over raw stars —
   ASS-004), and what is the **unmet gap** Jurati would fill?
4. **The cheapest PRIMARY test** the human should run next, per viable cluster — a discovery-conversation
   script + exactly who to talk to and where to find them; or a signal test (landing page / Show HN / OSS
   release-and-watch) — since proxy evidence cannot replace primary validation.
5. **LLM-agnostic demand (cross-cutting dimension).** Unimatrix holds *LLM-agnostic* as a founding goal
   alongside domain-agnostic — the harness should work across the major coding agents (**Claude Code,
   OpenAI Codex, Google Gemini CLI** at minimum), not lock to one vendor. Test that goal against demand,
   not just feasibility:
   - a. What **expressed/proxy demand** exists for a **coding-agent-agnostic / vendor-portable** SDLC or
     agentic-delivery harness — voiced pain about lock-in to a single agent CLI, requests for
     multi-agent/BYO-model support, teams standardizing a method across Claude Code *and* Codex *and*
     Gemini? Rate strength (strong / moderate / weak / none) with sources, and note **which clusters
     (A–D) the signal concentrates in** — it may be strong for one audience and absent for another.
   - b. **Competitive positioning on this axis** — of the harnesses/tools mapped in Q3, which are
     **single-agent-locked** (Claude-only) vs. **agent-agnostic**, and is agnosticism a stated selling
     point buyers respond to, or a feature nobody asks for? Identify the **unmet gap** (if any) an
     LLM-agnostic Jurati would fill, and the **counter-signal** — evidence that users prefer a
     deeply-integrated single-agent tool over a portable-but-shallower one.

## Breadth

`industry` / `external` — Claude Code + agentic-dev communities (GitHub, HN, Reddit, Discord/forum
archives, X), competitor repos and their traction, and any relevant market/practice literature. No
Unimatrix access; no codebase reading.

## Approach

`investigation` + `evaluation` — survey demand signals broadly across the four clusters, then go **deep**
on the one or two clusters with the strongest proxy signal. Evaluate signal strength honestly; rank the
clusters by evidence.

## Confidence required

`directional` — proxy/expressed demand is directional evidence. `validated`/`empirical` demand is
**out of reach for an agent spike** (it requires primary user contact) and is explicitly deferred to the
human's follow-on primary test, which this spike *designs* but does not *run*.

## Target outputs

- **Demand-evidence map** — per cluster: strength (strong / moderate / weak / none) + the concrete
  sources behind the rating.
- **ICP profile** for the strongest-signal cluster — role, context, pain in their words, where they are.
- **Competitive / adjacent landscape** — who serves each cluster, their real traction, and the unmet gap.
- **LLM-agnostic demand read** — strength rating (with sources) for vendor-portable / coding-agent-agnostic
  demand, which clusters it concentrates in, the competitive lock-in-vs-agnostic split, the unmet gap, and
  the honest counter-signal (users may prefer deep single-agent integration). A weak/none result here is a
  valid finding — it would point toward a Claude-Code-first, integration-deep identity.
- **Cheapest primary-test design** per viable cluster — the exact next move the human runs to get real
  demand data (discovery-call script + target list, or a signal test).
- Explicitly **NOT** a decision on Jurati's identity. That is the j-queen + human triage (resolving T1 /
  T8) that consumes this file.

## Constraints

**Hard** (fixed — the spike must respect these):
- **Proxy / public evidence only.** The spike does **not** and **cannot** conduct primary user research —
  no interviews, no surveys, no direct user contact. Every demand signal must be **labelled by strength
  and cited to a source**.
- **GitHub stars are a weak signal** (ASS-004). Weight contributor count, issue/PR activity, response
  time, and evidence of actual usage far higher; treat vendor/community traction claims skeptically and
  flag them as such.
- Produces **no Unimatrix knowledge entries** (research-spike rule).
- Does **not** decide Jurati's identity or recommend a vision — it supplies demand evidence to the human
  triage.

**Hypothesis** (challengeable — the point of the spike is to test it):
- The working assumption *"others want this too"* is **exactly what is under test.** The researcher must
  be willing — and is expected — to return *"proxy signal is weak or absent for cluster X."* A weak/none
  result is a **valid, valuable finding** (it points toward the personal-instrument identity, T1's left
  pole). **Do not manufacture demand** to fill the table.

## Dependencies

**Depends on:** ASS-006 `hypotheses.md` (the identity clusters + the demand flag) and ASS-004 FINDINGS
(the competitive/harness landscape is already partly mapped there — start from it, do not re-derive it).
**Feeds:** the j-queen + human triage resolving tensions **T1** (personal instrument vs. product-with-
users) and **T8** (OSS-first vs. enterprise-pull) → the `PRODUCT-VISION.md` ambition envelope + the
audience decision that gates every audience-dependent identity.

## Prior art

- `product/research/ass-006/hypotheses.md` — the identities, clusters, anti-vision, tension map, and the
  demand flag this spike answers.
- `product/research/ass-004/FINDINGS.md` — the harness/agentic landscape (claude-flow/ruflo, metaharness,
  LangGraph, AutoGen, CrewAI, Temporal) with traction caveats.
- The north-star statement in `product/research/VISION-RESEARCH-CAMPAIGN.md` (as expanded by the human:
  SDLC + research **+ other domain agentic workflows**; per-repo component **or** cross-project overseer).
- **Unimatrix founding goal — LLM-agnostic + domain-agnostic**: the harness is intended to run across the
  major coding agents (Claude Code, OpenAI Codex, Google Gemini CLI at minimum), not lock to one vendor.
  Q5 tests this goal against *demand* (feasibility is a separate matter).
- Founding issues #1 (deterministic harness) and #2 (capability-map machinery).
