# FINDINGS (INTERNAL track): Self-Improving Deterministic Workflows

**Spike**: ass-005
**Track**: INTERNAL (Case 3 dual-track — external eval/flywheel literature handled in parallel)
**Date**: 2026-07-16
**Approach**: investigation (code+ecosystem — Jurati's own protocols/agents/skills + live Unimatrix READ)
**Confidence**: directional

**Assigned questions**: Q2 (feedback loop + deterministic/LLM split, our-harness-owned), Q3 (what to reuse from ASS-001/ASS-002), Q5 internal angle (honest MVP line), plus the INTERNAL grounding for the determinism-vs-improvement reconciliation (SCOPE Q1 / "Determinism resolution").

---

## Evidence base (what I actually read/ran)

- **Live Unimatrix READ** (`context_status`, `context_search`, agent_id `researcher-ass-005`): **0 knowledge entries** (Active/Deprecated/Proposed/Quarantined all 0); **315 observation records across 11 sessions, oldest 1 day; 0 retrospected features; 0 extracted / 0 rejected; effectiveness taxonomy and confidence-calibration table all zeros; coherence 1.0** on the empty KB. This is ASS-001's picture, grown (163→315 obs) and still inert. The measurement machinery is running and collecting; it has produced nothing yet.
- **Jurati control flow**: `.claude/agents/uni/uni-scrum-master.md` (coordinator — reads protocol, spawns, gates, `context_cycle` attribution, max-2 rework cap), `.claude/agents/uni/uni-validator.md` (three-gate decision table PASS/REWORKABLE-FAIL/SCOPE-FAIL), `.claude/protocols/uni/uni-research-protocol.md` (phase sequence + table-driven routing).
- **The learn step**: `.claude/skills/uni-retro/SKILL.md` (post-merge extraction wired to `context_cycle_review`; NG-5 "retro synthesis is AGENT-owned, the tool returns honest planes only").
- **How process definitions are authored**: `.claude/agents/uni/AGENT-CREATION-GUIDE.md` (the stability boundary — principles stable, implementation specifics change), CLAUDE.md routing block.
- **Feed-through** (read as given, not re-investigated): ASS-001 FINDINGS (substrate contract, cycle primitive, effectiveness machinery, gap list) and ASS-002 FINDINGS (arch-research versioned-workflow-as-artifact, git-tag-derived `wf-v` stamp, retro→edit→bump loop proven / autonomous A/B never run).
- **Git history as evidence of the loop already running manually**: commit `738083d` — *"Validate research flow end-to-end; fix routing + write-prohibition wording"* — is a process-definition edit driven by a validation run. That is one turn of the improvement loop, on the process definitions, already happening by hand.

---

## Findings

### Q2: What is the concrete feedback loop as OUR harness would own it — and within it, what is deterministic (harness-owned) vs. LLM-driven?

**Answer.** The loop is **run → measure → propose variant → adopt (human-gated) → re-run**, and Jurati already owns roughly 70% of it in shipped protocol/agent/skill machinery. Mapped to our actual components:

| Loop stage | Who owns it in Jurati today | Determinism |
|---|---|---|
| **Run** | `uni-scrum-master` reads the protocol and executes it — spawns specialists, drives fixed phase sequence, manages gates, calls `context_cycle(start/phase-end/stop)`. "Reads the protocol and executes it — not improvise." | **Deterministic** control flow; **LLM** slot content (each spawned specialist's output) |
| **Measure** | 9-event hook pipeline auto-captures observations (315 live), cycle-stamped. At close, `context_cycle_review` returns hotspots, `baseline_comparison` (per-metric current-vs-rolling-mean with `is_outlier` — real regression detection), `gate_outcome_text` per phase, and `transcript_candidates`. `context_status` gives the effectiveness taxonomy + confidence-calibration curve. | **Deterministic recording** (hooks, cycle stamps, git-derived version stamp); **LLM interpretation** (what a hotspot means) |
| **Propose variant** | `uni-retro`'s architect (retrospective mode) reads the retro planes and proposes edits — today to *knowledge entries*; the natural extension is a proposed diff to a **process-definition file** (`.claude/protocols/*.md`, `.claude/agents/*.md`, `.claude/skills/*/SKILL.md`). | **LLM-driven** (judgment — writing the diff) |
| **Adopt** | Commit the edited definition + bump a git-tag-derived version stamp. Because definitions are **read at runtime**, the next run executes the new process with **no deploy step** (same property arch-research relies on). | **Deterministic** mechanics (files read at runtime, version stamp derived not typed); **human-gated** adopt decision |
| **A/B / did-it-help** | Slice `context_cycle_review` / `context_status` telemetry by the workflow-version tag: did gate-failure rate / rework / hotspots improve v_n+1 vs v_n? | **Deterministic** data slice; **LLM** verdict "is it better" |

**The deterministic vs LLM split, grounded and sharpened:**

*Deterministic (harness-owned control flow, gates, routing, measurement recording):*
- **Phase sequencing** — fixed per protocol; SM does not improvise (`uni-scrum-master.md`: "read the protocol and execute it").
- **Gate consequence mapping** — `uni-validator` Step 4 is a literal decision table: all-PASS→proceed, REWORKABLE-FAIL→re-spawn prior stage, SCOPE-FAIL→stop-and-escalate; **max 2 rework iterations**, tracked by SM. The *consequence* of a verdict is deterministic control flow.
- **Routing** — table-driven (research protocol "Which Researcher?" Cases 1/2/3, "evaluate in order, stop at first match"; SM's owner/not-you responsibility table).
- **Measurement recording** — the 9-event hooks, `context_cycle` stamps, and (proposed) git-tag-derived version stamp. Emission is mechanical.

*LLM-driven (judgment, variant proposal, synthesis):*
- **The gate verdict itself** — the validator *evaluating* the check-set against artifacts is judgment (the deterministic part is only what happens next).
- **All slot content** — architecture, spec, pseudocode, code, tests, findings.
- **Retro synthesis** — explicitly agent-owned (retro NG-5: "the tool returns honest planes only … all synthesis is YOUR work over those planes, not a tool capability").
- **Variant proposal** — writing the process-definition diff.
- **The "is v_n+1 better" call** — interpretation over telemetry.

**Recommendation.** Adopt the loop exactly as tabled above, with the **adopt decision human-gated in v1** (ASS-002: the autonomous telemetry-proven A/B half has never run once in the source system; do not inherit it as a foundation). Keep the deterministic/LLM boundary where the code already draws it: **the harness owns the rails and the consequence tables; the LLM owns every slot including the gate verdict, and the gate's deterministic *consequence* — not a deterministic *judgment* — is what makes the loop safe.** The single missing mechanical piece is the version stamp (Q3/Q5).

---

### Q3: What can Jurati concretely REUSE from ASS-001 (Unimatrix) and ASS-002 (arch-research) rather than invent?

**Answer.** Nearly the entire loop already exists as reusable mechanism across the three sources — Jurati should **wire, not invent**. Each mechanism mapped to its role in the self-improvement loop:

**From ASS-001 (Unimatrix substrate — the measurement machine):**

| Mechanism | Role in the improvement loop | State |
|---|---|---|
| `context_cycle` start/phase-end/stop | **Run instrumentation / attribution key** — binds every observation to a run; already called by `uni-scrum-master`. | Ready, in use |
| 9-event hook observation pipeline (315 obs live) | **Measure — raw signal.** Automatic, deterministic, fail-open. | Ready, running |
| `context_cycle_review` (hotspots, `baseline_comparison`/`is_outlier`, `gate_outcome_text`, `transcript_candidates`) | **Measure → learn — per-cycle regression detection + candidate harvest.** | Ready (present, unexercised) |
| `context_status` effectiveness taxonomy (Effective/Settled/Unmatched/Ineffective/Noisy + Utility) + confidence-calibration table | **The knowledge-A/B** — "when we injected knowledge at confidence X, did the session succeed?" | Present, inert (all zeros) |
| `context_cycle` opaque `tags` | **The version-stamp seam** — carry the workflow version (ASS-001's flagged optimization). | Ready, unused |
| typed edges + categories + `context_correct` | **Knowledge model + correction discipline** for anything the loop learns. | Ready |

**From ASS-002 (arch-research — the improvement design, proven human-gated):**

| Mechanism | Role in the improvement loop | Transfer note |
|---|---|---|
| **Versioned-workflow-as-artifact** (skills/protocols read at runtime; change = commit, no deploy) | **The adopt mechanism.** Jurati already has this — protocols/agents/skills ARE runtime-read files. | Already true; make it explicit |
| **Git-tag-derived `wf-v<semver>` stamp** (`git describe --match 'wf-*'`, never hand-typed — they observed 24 commits drift when hand-copied) | **The version stamp on `context_cycle` tags.** | Reuse **directly**; stamp the literal git-tag string (ASS-002 correction #2) |
| **retro → edit → bump loop** (the *proven, human-gated* half) | **The improvement cadence.** | Adopt wholesale |
| **The firewall** ("status moves only on real artifact evidence") | **Safety invariant for adopting a variant** — "v_n+1 is better" is `claimed` until telemetry proves it. | Name it as a protocol rule; `uni-capability` already embodies it |
| **Advisory vs blocking gates; PASS/REWORKABLE/SCOPE-FAIL; max-2 rework** | **The gate model.** | Already present in `uni-validator` |
| **A process observations log** (`observations.md` — OBS-1..12 drove 14 versions) | **The cheapest improvement input** — needs no working telemetry. | Adopt; highest value-per-effort |

**From Jurati itself (already built — the back half of the loop):**

| Mechanism | Role |
|---|---|
| `uni-retro` skill (wired to `context_cycle_review`, extracts patterns/procedures/lessons) | **The learn step, already built** — extend its target from knowledge-only to include process-definition files. |
| `uni-validator` (gate reports, `gate_outcome_text`, rework signals) | **Produces the friction signal** that retro consumes. |
| `uni-scrum-master` `context_cycle` attribution | **The run instrumentation**, already emitting. |
| gate reports + `fix(gate):` rework commits + post-gate rework window | **Measurement of process friction**, already produced and already mined by `uni-retro` Phase 1. |

**Recommendation.** Treat self-improvement as an **integration job, not an invention job.** The measurement substrate (ASS-001), the improvement design (ASS-002), and the learn step (`uni-retro`) all already exist. Jurati's build reduces to three small connectors: (1) stamp the git-tag-derived workflow version onto `context_cycle` tags; (2) extend `uni-retro` to also propose edits to process-definition files (not only knowledge entries); (3) name the firewall as an explicit "workflow change is `claimed` until next-run evidence" protocol rule. Everything else is reuse.

---

### Q5 (internal angle): Given what our substrate ALREADY provides, what is the honest MVP line — already have / small lift / defer?

**Answer.** The honest line is: **v1 = retro-driven, human-gated, version-stamped process improvement layered on the deterministic execution + observation/retrospection substrate we already run.** Almost all of it exists; the net-new is one mechanism (the version stamp) plus one extension (retro targets process files). Framed as requested:

**ALREADY HAVE (live today, zero build):**
- Deterministic execution: SM control flow + `uni-validator` three-gate decision table + max-2 rework cap.
- `context_cycle` attribution + 9-event observation pipeline (315 obs, running).
- `context_cycle_review` retrospection *with regression detection* (`baseline_comparison`/`is_outlier`) and `gate_outcome_text`.
- `uni-retro` extraction of lessons/patterns/procedures.
- **Process definitions as runtime-read files** — so "edit the process, next run uses it, no deploy" already works (proven by commit `738083d` editing routing/wording after a validation run).
- Effectiveness taxonomy + confidence-calibration machinery (present, inert).

**SMALL LIFT to reach (the actual v1 build):**
- **Git-tag-derived workflow-version stamp on `context_cycle` tags** — small, deterministic, highest-leverage: it makes every downstream retrospection *version-aware* (ASS-001's flagged optimization; ASS-002's proven mechanism). Stamp the literal `git describe` string. **This is the one piece worth building first.**
- **Extend `uni-retro` to process definitions** — add an explicit "does this cycle warrant a protocol/agent/skill edit?" step that emits a proposed `.md` diff + version bump. The ad-hoc version already happens (commit `738083d`); formalize the trigger.
- **A process-improvement observations log** (arch-research `observations.md` analog) — cheap, needs no telemetry, delivers value on day one.
- **Name the firewall for process changes** — "a workflow edit is `claimed` until next-run/telemetry evidence; human gates adoption."

**DEFER (not v1 — unproven or premature):**
- **Autonomous, telemetry-proven A/B of workflow versions** — ASS-002: never ran once upstream; and our own effectiveness loop is inert (0 retrospected), so we have zero evidence it *discriminates*. Keep human-gated.
- **Cross-cycle / portfolio retrospection** (ASS-001 gap #7) — not engine-native; needs convention-side reconstruction and enough cycles to trend. Defer until cycle count justifies it.
- **Knowledge-effectiveness-driven auto-adoption** — depends on effectiveness scoring discriminating, which is empirically unproven at our scale (ASS-001 open question).
- **Sealed process-plane category** (ASS-002 avoid #4) — premature isolation; add only if self-improvement tracking pollutes delivery retrieval.

**Recommendation (internal-grounded input to the settled-in-synthesis MVP).** Draw the v1 line at **"version-stamped, retro-driven, human-gated process improvement over the existing substrate."** It is ~80% wiring of shipped mechanism + one small new stamp. Ship the version stamp, extend retro to process files, keep an observations log, and name the firewall. Defer every autonomous/quantitative capability until the currently-inert measurement loop is *observed* to discriminate on real Jurati cycles — do not build on a signal that has produced zero outputs in 315 observations.

---

### Determinism resolution — INTERNAL grounding (SCOPE Q1 / hypothesis test)

**SCOPE hypothesis under test:** *"execution is deterministic; the process definitions (protocols, prompts, LLM-slots) are what evolve, measured against outcomes in Unimatrix."*

**Verdict: SUPPORTED, but the word "deterministic" must be corrected, and the "two-part" framing is really three layers.** Our architecture supports the split — with one sharp challenge and one caveat.

**Where the hypothesis is right (strongly supported by our code):**
- Process definitions **are files read at runtime** — `.claude/protocols/*.md`, `.claude/agents/*.md`, `.claude/skills/*/SKILL.md`, CLAUDE.md. Editing them changes future behavior with **no deploy**. That is precisely "the process definitions are what evolve." Confirmed by AGENT-CREATION-GUIDE's stability boundary and by commit `738083d` (a live process-definition edit after a validation run).
- The **LLM-slots evolve as prompts, not weights** — Jurati does not fine-tune. "The prompts evolve" = editing agent/skill `.md` text. This *strengthens* the hypothesis: the evolving object is fully file-based and git-versioned.
- Evolution is **measured in Unimatrix** — observations, `context_cycle_review`, effectiveness. The Hard constraint holds.

**The challenge (load-bearing correction):** *Execution is NOT deterministic in the reproducible-output sense.* It is deterministic only in the **control-flow / structure** sense. Two distinct claims are being conflated:
- The **rails** (harness control flow) are deterministic: same protocol version → same phase sequence, same gate consequence table, same routing, same cycle stamps (SM "does not improvise").
- The **content** at each rail step is **stochastic** — every specialist output (ADR, code, gate verdict, findings) is LLM-generated and not byte-reproducible. ASS-001 further notes the substrate itself is fail-open telemetry (cycle tracker never-throws, best-effort; graph cache can lag a tick) — so even the recording layer is not transactionally deterministic.

**Therefore the precise internal framing is a THREE-layer model, not two:**

1. **Rails / control flow** — deterministic, harness-owned (SM + gate consequence tables + routing + cycle stamps). Fixed *within a version*.
2. **Slot content** — LLM-driven, stochastic, per-run. Never reproducible; made safe not by determinism but by the **firewall** (status/adoption moves only on real evidence) and the gate/rework cap.
3. **Process definitions** — the versioned artifact that *is* both the rails and the slot-prompts. This is the layer that evolves between versions.

"**Deterministic yet improving**" resolves cleanly once the two properties are seen to live on different layers:
- **Determinism** is a property of the **rails within a pinned version** (layer 1, fixed by a version of layer 3).
- **Improvement** is a property of **moving between versions of layer 3**.
- Layer 2 is stochastic in both regimes and is bounded by gates/firewall, not by determinism.

So the contradiction is only apparent: nothing is asked to be simultaneously fixed and changing — the *rails* are fixed per version, the *definitions* change across versions, and the *content* was never deterministic at all.

**The caveat (honest, mirrors ASS-002):** "measured against outcomes in Unimatrix" is **architecturally sound but operationally unexercised** — 0 retrospected features, effectiveness all zeros across 315 observations. The measurement layer *supports* the split by design; it has not yet *demonstrated* it discriminates good process changes from bad. This is the exact analog of ASS-002's "improvement design is thorough; the autonomous quantitative half has never run." The split is real in the architecture and unproven in practice.

**Recommendation.** Adopt the hypothesis with the corrected wording: **"the control flow is deterministic and version-pinned; slot content is stochastic and bounded by gates/firewall, not by determinism; the process definitions are the versioned object that evolves, measured against Unimatrix outcomes."** Carry the caveat forward — treat "Unimatrix outcome measurement discriminates" as a `claimed` property to validate on real cycles, not a settled foundation.

---

## Unanswered Questions

- **Does the Unimatrix measurement loop actually discriminate a better process version from a worse one at Jurati's scale?** Cannot be answered from an inert loop (0 retrospected, effectiveness all zeros across 315 obs). Requires running real versioned cycles and observing whether `cycle_review` regression detection + effectiveness scoring produce an actionable delta. Inherited open question from ASS-001; this spike does not resolve it — it defines the MVP so as *not to depend on* it (Q5 defer list). Requires empirical data not yet available.
- **The external half of the reconciliation** — eval-driven / flywheel patterns and their failure modes (overfitting-to-a-metric, reward-hacking, drift, loss of reproducibility) — is assigned to the EXTERNAL track (SCOPE Q4). Not answered here by design.
- **Exact retro-trigger for process edits** (what threshold of hotspot/rework warrants a protocol edit vs. a knowledge entry) — a design-session question, not a research question. Flagged for the downstream design of the extended `uni-retro`.

## Out-of-Scope Discoveries

- **The improvement loop is already turning by hand on the process definitions.** Commit `738083d` ("fix routing + write-prohibition wording" after validating the research flow end-to-end) is a complete retro→edit→commit turn on `.claude/` definition files, done manually. Implication: v1 is not building a loop from scratch — it is *instrumenting and versioning a loop that already runs informally.* Strengthens the Q5 MVP case; worth surfacing to synthesis.
- **The gate's determinism is in the consequence, not the judgment** — a reusable framing beyond this spike. Any Jurati "deterministic" claim should specify *deterministic control flow around stochastic slots*, never *reproducible outputs*. Candidate lesson for how Jurati describes itself publicly. Not pursued here.
- **`context_cycle_review` is richer than the loop currently uses** (ASS-002 reconciliation: `baseline_comparison`/`is_outlier` regression detection + per-phase `gate_outcome_text` already present). The measurement gap is specifically *knowledge-yield accounting*, not the telemetry surface. Relevant if a downstream design wants version-over-version process trending before cross-cycle retrospection is built. Flagged, not pursued.

---

## Recommendations Summary

- **Q2 (loop + split):** Adopt run→measure→propose→adopt(human-gated)→re-run as tabled; Jurati already owns ~70%. Harness owns deterministic rails + gate *consequence* tables + routing + cycle stamps; LLM owns every slot including the gate *verdict* and the variant proposal. Safety comes from the firewall/gate-cap, not from determinism.
- **Q3 (reuse):** Wire, don't invent. Reuse `context_cycle`+hooks+`context_cycle_review`+effectiveness (ASS-001), versioned-workflow-as-artifact + git-tag-derived `wf-v` stamp + retro→edit→bump + firewall (ASS-002), and `uni-retro`+`uni-validator` (Jurati). Net-new is three connectors.
- **Q5 (MVP line):** v1 = version-stamped, retro-driven, human-gated process improvement over the existing substrate. Small lift: git-tag-derived version stamp on cycle tags (build first), extend `uni-retro` to process-definition files, a process observations log, name the firewall. Defer: autonomous telemetry-proven A/B, cross-cycle retrospection, effectiveness-driven auto-adoption — all unproven while the measurement loop is inert.
- **Determinism resolution (internal grounding):** Hypothesis SUPPORTED with a required correction — three layers: deterministic version-pinned rails (1), stochastic gate/firewall-bounded slot content (2), versioned evolving definitions (3). "Deterministic yet improving" resolves because determinism lives in the rails-within-a-version and improvement lives in moving between versions. Caveat: the Unimatrix measurement layer supports the split by design but is operationally unexercised (0 retrospected / 315 obs) — treat "measurement discriminates" as `claimed`, not settled.
