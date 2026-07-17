# ASS-006 — What Jurati Wants To Be (and Not Be)

*Founding vision research · divergent-ideation spike · feeds the vision synthesis*

**Spike**: ass-006
**Assigned agent**: `uni-hypothesizer` (divergent generator — the funnel's wide mouth)
**Status**: scope drafted — awaiting human detailed review

---

## Goal

Answerable questions:

1. Given the five founding findings (ASS-001…005), the current north-star statement, and Jurati's
   real process/substrate surface, what is the **widest set of plausible, mechanism-grounded identities**
   Jurati could take — each phrased *"Jurati could be **&lt;kind of thing&gt;** for **&lt;whom&gt;**,
   delivering **&lt;outcome&gt;**, powered by **&lt;bet/mechanism&gt;**"* — spanning obvious, adjacent,
   and non-obvious/whitespace? Every identity must cite the **specific lever** (from the findings or the
   surface) that makes it real.
2. For each identity: **whom** it serves, the **outcome** it delivers, the **load-bearing bet** it rests
   on, and the **cheapest test** that would confirm or kill it as a direction.
3. **The anti-vision.** What should Jurati explicitly **NOT** be — the inversions and tempting adjacent
   identities that would dilute, contradict, or over-extend the direction — and *why* each is a trap?
4. **The tension map.** Where do the generated identities cluster or conflict — the trade-offs a human
   triage must resolve (e.g. personal-tool vs. platform; SDLC-only vs. general structured-work;
   OSS-first vs. enterprise-pull; queen-over-an-ecosystem vs. single-harness)?

## Breadth

`internal-synthesis` — read the five ASS FINDINGS in full and Jurati's current surface (agents, skills,
protocols, Unimatrix substrate). No new external investigation; this spike *recombines* prior research
into an option space. *(New breadth value — approved as a spike-scope variance; see "Approved protocol
variance" below.)*

## Approach

`divergent-generation` — the wide mouth of the ideation funnel, executed by `uni-hypothesizer`.
Range-seeking, mechanism-grounded conjecture. NOT investigation/evaluation/measurement/PoC/literature.
*(New approach value — approved as a spike-scope variance; see below.)*

## Confidence required

`directional` — everything produced is **conjecture** by design. The firewall holds: every identity is
`claimed` at most; the generator never grades or ranks. Triage (park/probe/build) is the human's, not
this spike's.

## Target outputs

- **`hypotheses.md`** — the ambition/identity set. Per identity: statement · mechanism (the cited lever) ·
  serves/outcome · class (`obvious`/`adjacent`/`non-obvious`) · level-up-vs-linear · cheapest test · key
  assumption + biggest risk.
- **The anti-vision set** — explicit "Jurati should NOT be X, because Y" inversions.
- **The tension map** — the clusters and conflicts a human triage must resolve.
- Explicitly **NOT** a decision, ranking, or recommended vision. That is the j-queen + human convergent
  step that consumes this file.

## Constraints

**Hard** (fixed — the spike must respect these):
- Output is **conjecture only**. The generator never grades (`proven`/`partial`), never ranks a winner,
  never decides what to pursue. Triage is **j-queen + human** (the funnel's neck).
- Produces **no Unimatrix knowledge entries** (research-spike rule).
- **Mechanism-grounded**: every identity names a specific lever from the findings or surface. No
  ungrounded ambition ("be an enterprise AI platform" with no cited lever = a vibe = out).
- Reasons only from the handed inputs (the five FINDINGS + the real surface); does not invent a surface.

**Hypothesis** (challengeable — the point of the spike is to test its edges):
- The current north-star — *"a world-class, deterministic harness driving structured SDLC + research
  workflows and other domain agentic workflows, Unimatrix as its co-evolving memory/verification engine, controlled and increasingly
  autonomous; personal/OSS-first, architected to extend to enterprise; Jurati as queen over the
  ecosystem"* - This could be in the form of a Jurati component layered in each repostory providing local discipline, OR as a true overseer cross project — is the **present position, not a fixed constraint**. The generator must **pressure-test
  it**, including conceiving identities that stretch or contradict it, so the human can see where the real
  boundary is. Do not merely ratify the north-star.  Use of internal knowledge, previous research, or even new external research is approved.  

## Dependencies

**Depends on:** ASS-001, ASS-002, ASS-003, ASS-004, ASS-005 — all FINDINGS.md complete (they are). Those
five files plus the current surface are the sole evidence base; do not re-investigate them.
**Feeds:** the j-queen + human ambition triage → `PRODUCT-VISION.md` (ambition envelope + what-Jurati-is-
not) + the first strategic goals + the initial capability map.

## Prior art

- The five founding FINDINGS: `product/research/ass-00{1..5}/FINDINGS.md`.
- The north-star statement in `product/research/VISION-RESEARCH-CAMPAIGN.md`.
- Jurati's current surface: `.claude/agents/uni/*`, `.claude/skills/*`, `.claude/protocols/uni/*`, and the
  Unimatrix `context_*` substrate.
- The founding issues #1 (deterministic harness) and #2 (capability-map machinery).
- The **garage funnel** design ASS-002 flagged as an out-of-scope discovery (scout → hypothesizer →
  goal-owner triage) — this spike is Jurati's first use of that intake pattern, at identity altitude.

---

## Approved protocol variance (human-approved · 2026-07-16)

This is a **divergent-ideation** spike, unlike the five investigative spikes. It uses two field values
outside the research protocol's current vocabulary — Approach `divergent-generation` and Breadth
`internal-synthesis` — and routes to the new `uni-hypothesizer` agent rather than the three
investigative-researcher cases in `uni-research-protocol.md`.

**The human has approved this variance for ASS-006 specifically.** It is captured here, in scope, on
purpose: *how* to fold it into the research protocol (a fourth routing case / a divergent-ideation mode)
and the `uni-agent-routing.md` roster is a **deferred decision** — to be made later, not as a side effect
of running this spike. Until that decision, this scope IS the authority for how ASS-006 routes.
