# FINDINGS: Our Protocols, Decomposed (light pass)

**Spike**: ass-003
**Date**: 2026-07-16
**Approach**: investigation
**Confidence**: directional

---

## Preamble — altitude and evidence base

This is a *vision-resolution* pass, not the exhaustive step-by-step deterministic/LLM
boundary classification (deliberately deferred to a round-2 spike). It reads the four
proven protocols and the coordinator role definition and maps them at the altitude needed
to set direction.

Evidence base (all cited inline below):
- `.claude/protocols/uni/uni-design-protocol.md`
- `.claude/protocols/uni/uni-delivery-protocol.md`
- `.claude/protocols/uni/uni-bugfix-protocol.md`
- `.claude/protocols/uni/uni-research-protocol.md`
- `.claude/protocols/uni/uni-agent-routing.md`
- `.claude/agents/uni/uni-scrum-master.md`
- `CLAUDE.md` (session-type selection rule)

A Unimatrix `context_briefing` was run (breadth includes code); it returned no entries —
the knowledge base has no settled ADR/pattern/convention bearing on this decomposition yet.
So this map is drawn from the protocol prose itself, which is the authoritative artifact.

**The single organizing finding:** every protocol already draws a clean internal line
between a *deterministic spine* (ordering, gates, routing tables, bookkeeping, guards) and
*LLM leaves* (content generation and the judgment verdicts). The scrum-master definition
makes this line explicit in one sentence — "You orchestrate. NEVER generate content."
(`uni-scrum-master.md` L71). Today that spine is **narrated in prose and walked by an LLM
coordinator**; it is not enforced by a harness. That gap is the whole of Q2, and it is what
makes Q3's measurement currently noisy.

---

## Findings

### Q: Across our design / delivery / bugfix / research protocols, what is *already* deterministic (fixed control flow, gates, routing, ordering) vs. LLM-contributed (judgment, content generation, synthesis)?

**Answer**: The protocols are already cleanly two-layered. A deterministic layer decides
*when / whether / which / in-what-order*; an LLM layer decides *what the content is* and
*what the verdict is*. The deterministic layer is large and is expressed as fixed sequences,
guard conditions, and lookup tables — it just happens to be executed by an LLM reading prose.

**Deterministic today (fixed control flow, gates, routing, ordering) — expressed as rules:**

| Category | Where it lives | Mechanic |
|----------|----------------|----------|
| **Session-type selection** | `CLAUDE.md`; `uni-agent-routing.md` L24-28 | Intent -> session type; hard rule: if `IMPLEMENTATION-BRIEF.md` absent -> design regardless of intent |
| **Phase/stage DAG** | each protocol's Execution Model + Message Map | Fixed order: design 1->1b->2a->2a+->2b->2c->2c+->2d; delivery 3a->G3a->3b->G3b->3c->G3c->4; bugfix 1->1b->1c->checkpoint->2->3->G3->4->5 |
| **Gate placement + block semantics** | delivery L167 "MANDATORY BLOCK"; agent-routing L37 "every swarm includes uni-validator at gates. Non-negotiable" | Validator spawned at each gate; no advance without PASS |
| **Gate-verdict -> next action** | delivery L197-203; bugfix L370-384; SM L117-124 | PASS->proceed; REWORKABLE FAIL->re-spawn prior stage; SCOPE FAIL->stop to human |
| **Rework counter** | SM L120-124; delivery L546; bugfix L508 | Max 2 iterations per gate -> auto-escalate to SCOPE FAIL |
| **Agent routing tables** | Dev-Agent Selection (delivery L212-221: `.rs`->rust-dev, `packages/**`->js-dev); Which Researcher Cases 1/2/3 (research L50-101); swarm templates (agent-routing L92-166) | Input characteristics -> agent selection |
| **context_cycle bookkeeping** | SM L96-110; design L58-71/L268; delivery L522-529; bugfix L426-446 | start/phase-end/stop at fixed insertion points, canonical phase names, strict `merge->close->retro` order |
| **Concurrency batching** | SM L168-192; every protocol's Concurrency Rules | "spawn all agents in one message"; "wait for all before next phase" (fan-out/join) |
| **Guards / preconditions** | delivery L53 (brief exists); research L36-46 (SCOPE required-fields present); design L11 | Mechanically checkable file/schema preconditions |
| **Wave dependency ordering** | delivery L223-235 | Topological grouping over a component dependency graph |
| **Campaign execution order** | research L236-248 | Independent spikes parallel; dependents after upstream FINDINGS exist |
| **Documentation trigger** | delivery L426-440 | Feature-change-type -> MANDATORY/SKIP table lookup |
| **Fixed artifact set + paths** | all protocols | Known artifacts written to known paths (`product/features/{id}/...`) |
| **Git choreography** | delivery L59-65/L412-420; bugfix L387-393 | Fixed branch/commit/push/PR command sequences at fixed points |
| **Build/test output discipline** | SM L145-164; delivery L563-584 | Deterministic shell recipes (cargo truncation, hardened test run) |

**LLM-contributed today (judgment, content generation, synthesis):**

| Category | Where | Why it is judgment |
|----------|-------|--------------------|
| **All artifact content** | every specialist output | SCOPE, ARCHITECTURE, ADRs, SPECIFICATION, risk strategy, pseudocode, code, tests, FINDINGS — generative |
| **Gate verdicts themselves** | uni-validator (agent-routing L51 "Reports PASS / REWORKABLE FAIL / SCOPE FAIL") | *Reading* artifacts and *judging* pass/fail is judgment; only the routing *on* the verdict is deterministic |
| **Root-cause diagnosis + fix approach** | bugfix Phase 1/1b | Inference over code |
| **Vision-variance classification** | uni-vision-guardian (design 2b) | Judgment of alignment severity |
| **Synthesis / merge** | uni-synthesizer; dual-track synthesis (research L172-191) | Compression + reconciliation |
| **Input-extraction feeding "deterministic" routing** | wave identification (delivery L228-231 "read the brief for mandatory ordering"); Which Researcher Case match (research L58-86); doc-trigger match (delivery L440 "read Goals... if any matches"); question partitioning (research L137-141) | The *rule* is deterministic, but the *inputs are read from unstructured prose*, so an LLM currently sits at the boundary |
| **Rework content** | rework loops | *What specifically to fix* is judgment; the counter and branch are not |

**The clean split:** the harness owns *when/whether/which/order*; the LLM owns *the content
and the verdict*. The only genuinely blurred zone is the last LLM row above — deterministic
rules whose inputs are today unstructured text. That blur is the seam the round-2 spike must
classify precisely.

**Recommendation**: Treat the protocols as already-two-layered and adopt that framing as the
vision's organizing principle: a fixed harness spine (state machine + routing tables + guards
+ bookkeeping) with LLM specialists as pluggable leaves that emit content and typed verdicts.
Do not model orchestration as "an LLM that happens to follow rules"; model it as "a rule
engine that calls LLMs." The protocols already describe the former as a workaround for not
having the latter.

---

### Q: Where is orchestration currently prose-instructed to a human/LLM scrum master that a deterministic harness could own instead?

**Answer**: Essentially the entire scrum-master job description is the deterministic spine.
`uni-scrum-master.md` states the coordinator "orchestrates, NEVER generates content" (L71) and
its Role-Boundaries table (L73-92) assigns the coordinator *only* deterministic
responsibilities — spawning, gate management, GH comments, component-map routing, rework
loops, git, cycle bookkeeping — while every content row is delegated to a specialist. That is
a harness specification written as prose for an LLM to execute by hand.

The strongest tell that these are ripe: the protocols spend a large fraction of their text
*reminding the LLM to execute deterministic steps correctly* — "Do NOT skip this step"
(delivery L165), "MANDATORY BLOCK" (delivery L167), the `merge->close->retro` strict-order
warning repeated three times (delivery L519/L629/L666, bugfix L423/L599/L613), "never close
the issue yourself" (research L259), rework-counter tracking (SM L124), "KEEP the phase OPEN"
(delivery L516). Each reminder marks a deterministic rule that is *fragile precisely because
an LLM owns it*. Those are the candidates.

**Candidate harness-owned orchestration points (ranked by ripeness):**

1. **Gate-result -> next-action state machine + rework counter.** PASS/REWORKABLE
   FAIL/SCOPE FAIL -> deterministic branch; max-2 -> escalate. Pure state machine; the LLM only
   needs to *produce* the verdict. (SM L117-124; delivery L197-203; bugfix L370-384.) *Highest
   ripeness — fully mechanical, currently hand-tracked.*
2. **Phase/stage sequencing (the DAG).** The transition graph per session type is fixed;
   the LLM walks it by re-reading the protocol. A harness state machine owns transitions and
   emits the next spawn. (Message Maps in all four protocols.)
3. **context_cycle bookkeeping.** start/phase-end/stop with canonical phase names at fixed
   insertion points, strict merge->close->retro order. A harness emits these automatically at
   transitions instead of relying on LLM recall (the triple-repeated warnings prove recall is
   unreliable). (design L58-71; delivery L522-529; bugfix L426-446.)
4. **Guards / preconditions.** `IMPLEMENTATION-BRIEF.md` exists (filesystem check);
   SCOPE required-fields present (schema check); session-type selection. All mechanically
   decidable. (delivery L53; research L23-46; CLAUDE.md.)
5. **Agent routing by mechanical key.** Dev-Agent Selection is pure file-glob dispatch
   (`.rs`->rust-dev, `packages/**`->js-dev, delivery L212-221). Swarm composition per session
   type is a fixed template (agent-routing L92-166). Both are table lookups.
6. **Concurrency fan-out/join.** "spawn all agents in one message; wait for all before next
   phase" is a harness parallel-map primitive, not an instruction an LLM should police. (SM
   L168-192.)
7. **Git + PR choreography.** Fixed branch/commit/push/PR sequences at fixed points. (delivery
   L59-65/L412-420; bugfix L387-393.)
8. **Component-Map / artifact-path bookkeeping.** Collecting file paths from agent returns and
   writing them into the brief's tables is mechanical string plumbing. (delivery L144-165.)
9. **Wave + campaign scheduling.** Topological sort once dependencies are declared. (delivery
   L223-235; research L236-248.)
10. **Documentation-trigger + Phase-3 research validation.** Table lookup / checklist.
    (delivery L426-440; research L195-209.)

**The one caveat (pre-frames round-2):** several of these consume *inputs that are currently
unstructured prose* — wave dependencies live in brief narrative, Which-Researcher Case
selection reads scope characteristics, doc-trigger reads SCOPE Goals. The *decision rule* is
harness-ownable, but full determinism requires the **inputs to be structured** (typed scope
fields, explicit `dependencies:` declarations, machine-readable component graph). Without that,
the harness still needs an LLM classifier at the boundary. So the honest scope of "harness can
own this" splits into: (a) *pure-mechanical now* (rows 1-3, 5-8) and (b) *mechanical once inputs
are typed* (rows 4 partial, 9, 10, and the Q1 blur). This split is the exact boundary the
round-2 spike should classify.

**Recommendation**: Extract the spine in two tiers. Tier-1 (build first): the gate state
machine + rework counter, phase-transition engine, and context_cycle auto-emission — these are
pure-mechanical, are the most-reminded (highest current failure surface), and need no input
restructuring. Tier-2 (needs a typed-input contract first): wave/campaign scheduling, Case
routing, doc-trigger. Do Tier-1 to prove the "rule engine that calls LLMs" model, and let the
Tier-2 dependency on structured inputs be an explicit input to the round-2 boundary spike.

---

### Q: Where do self-improvement / A-B hooks naturally sit within these protocols? (feeds ASS-005)

**Answer**: The protocols already emit the exact events an improvement loop needs — discrete
gate verdicts, a rework counter, a fresh-context evaluator role, a fixed agent-spawn contract,
a cycle telemetry stream, and a retrospective write-back. These are natural attachment points
because they are *seams*: typed boundaries with a stable contract on either side.

**Natural hook locations:**

1. **Gate boundaries — primary measurement point.** Each gate emits a discrete
   PASS/REWORKABLE FAIL/SCOPE FAIL plus a written report at a known path (delivery
   L193/L307/L387; bugfix L365). These are ready-made outcome labels: gate pass-rate,
   first-pass-vs-rework, SCOPE-FAIL rate — all measurable per feature, per stage, per agent.
2. **Rework counter — quality signal.** The max-2 loop (SM L124) is itself a metric: rework
   iterations per stage = an inverse-quality score attributable to the upstream specialist.
3. **Agent spawn/return contract — the A/B swap point.** Every specialist is spawned fresh
   with a defined input (reads named files) and return (paths + summary, not content) — SM
   L172-174, design L404-412. This clean seam is precisely where a variant agent (uni-architect
   v1 vs v2) can be swapped and the *downstream gate outcome* used as the comparison metric.
4. **context_cycle telemetry — the existing measurement spine.** phase-end/stop already carry
   `outcome` strings and write an audit row (ADR-005 referenced delivery L527). This is the
   backbone an ASS-005 metrics store attaches to; much of the event stream already exists.
5. **Fresh-context evaluators as scorers.** uni-validator (three-valued verdict) and
   uni-zero-reviewer (advisory, deliberately context-disconnected — design L129) already act as
   independent judges. They can double as offline scorers for variant comparison without new
   machinery.
6. **Retrospective pipeline — the learning write-back.** `/uni-retro` +
   `context_cycle_review` + `transcript_candidates` (agent-routing L154-164) already extract
   patterns/procedures/lessons into Unimatrix post-merge. This is the self-improvement *write*
   path; A/B outcomes feed the same channel.
7. **Human checkpoints — ground-truth labels.** SCOPE approval (design L124), diagnosis
   approval (bugfix L176), and the merge gate are human accept/reject signals — the highest-value
   labels for calibrating whether automated gate verdicts predict human acceptance.

**The cross-link ASS-005 must hear:** clean A/B requires the orchestration *around* the tested
unit to be fixed, or outcome differences cannot be attributed to the variant. That means Q2's
deterministic spine is a **prerequisite** for Q3's measurement being trustworthy. Today, because
the spine is LLM-executed prose, run-to-run orchestration varies (skipped cycle calls, missed
rework escalation, ordering drift — the very failures the repeated warnings guard against),
which is confounding noise. Fixing the spine (Tier-1 of Q2) is what turns the gate/rework/cycle
signals from noisy into attributable.

**Recommendation**: Anchor ASS-005 on the three signals that already exist and need no new
instrumentation — (a) gate verdict + rework count as the outcome metric, (b) the agent-spawn
contract as the variant-swap seam, (c) context_cycle events + `/uni-retro` as the telemetry and
write-back channel. Sequence it *after* Tier-1 of the spine extraction (gate state machine +
cycle auto-emission), because attribution is only clean once orchestration is deterministic.
Use uni-validator / uni-zero-reviewer as the initial scorers rather than building new ones.

---

## Unanswered Questions

- **Exact per-step deterministic/LLM classification** — deliberately out of scope this round
  (SCOPE Hypothesis: "Full step-by-step classification is out of scope; round-2 spike"). This
  pass sets the framing (two-layer spine/leaves) and the Tier-1/Tier-2 split; the exhaustive
  step-level labeling is the round-2 deliverable.
- **Which unstructured inputs must become typed** to make Tier-2 routing fully deterministic
  (wave dependencies, Case-selection fields, doc-trigger keys) — identified here as a class but
  not enumerated field-by-field. Needs the round-2 boundary spike (or a small input-schema
  spike) to specify.
- **Failure-rate evidence** — the volume of corrective prose *implies* observed LLM-execution
  failures, but this spike did not read git history, issues, or Unimatrix lessons to quantify
  how often the spine is mis-executed. Quantifying it would strengthen the Tier-1 prioritization
  but requires access not in this spike's breadth.

## Out-of-Scope Discoveries

- **Corrective-prose density is itself a signal.** The `merge->close->retro` strict-order warning
  appears three separate times in the delivery protocol and three in bugfix; "Do NOT skip,"
  "MANDATORY BLOCK," "never close the issue yourself," rework-counter reminders recur throughout.
  This concentration is a reliability smell that maps 1:1 to the highest-ripeness harness
  candidates. *Why it matters:* it is a cheap, already-written prioritization heatmap for
  spine extraction — worth mining systematically in round-2.
- **Some tooling is already extracted from prose into deterministic recipes** — cargo output
  truncation, the hardened `setsid/timeout` test runner (SM L145-164), and the infra-001
  integration harness (delivery L632-641). *Why it matters:* these are existence-proofs that the
  spine-extraction hypothesis holds in practice; they are the pattern the orchestration spine
  should follow.
- **Research Phase-3 validation is already a near-deterministic checklist** ("does not require a
  separate agent," research L195-209). *Why it matters:* a low-risk first target for a harness
  guard, useful as an early proof-of-concept for Tier-1.
- **uni-validator's three-valued return is already a typed interface, not free prose**
  (agent-routing L51). *Why it matters:* the verdict boundary is the readiest place to formalize
  a machine-consumable contract between LLM leaf and harness spine — start the typed-verdict
  contract here.

---

## Recommendations Summary

- **Q1 (deterministic vs LLM map):** Adopt the protocols' own implicit two-layer structure as
  the vision's frame — a fixed harness spine (ordering, gates, routing tables, guards,
  bookkeeping) calling LLM specialists as pluggable leaves that emit *content* and *typed
  verdicts*. Model orchestration as "a rule engine that calls LLMs," not "an LLM that follows
  rules." The one blurred zone — deterministic rules fed by unstructured prose inputs — is the
  round-2 boundary target.
- **Q2 (harness-owned orchestration):** The scrum-master role *is* the spine. Extract it in two
  tiers: Tier-1 now (gate state machine + rework counter, phase-transition engine, context_cycle
  auto-emission — pure-mechanical, highest current failure surface); Tier-2 after a typed-input
  contract exists (wave/campaign scheduling, Case routing, doc-trigger). The density of
  corrective prose is a ready-made ripeness heatmap.
- **Q3 (self-improvement / A-B hooks — feeds ASS-005):** Anchor on signals that already exist —
  gate verdict + rework count (outcome metric), the fresh agent-spawn contract (variant-swap
  seam), and context_cycle + `/uni-retro` (telemetry + write-back). Reuse uni-validator /
  uni-zero-reviewer as initial scorers. Sequence ASS-005 *after* Tier-1 spine extraction, because
  attributable A/B requires the orchestration around the tested unit to be deterministic — Q2 is
  a prerequisite for Q3.
