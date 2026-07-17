# FINDINGS: Self-Improving Deterministic Workflows

**Spike**: ass-005
**Date**: 2026-07-16
**Approach**: investigation + literature (dual-track Case 3 — internal `code+ecosystem` + external eval/flywheel literature, synthesized)
**Confidence**: directional

*Synthesis of FINDINGS-INTERNAL.md (Q2, Q3, Q5-internal, internal grounding of Q1) and FINDINGS-EXTERNAL.md (Q1-external, Q4, external input to Q5). No re-investigation — both track files are the sole evidence base.*

---

## Findings

### Q1: How can a deterministic-execution harness continuously improve its process definitions? Reconcile "the run is deterministic" vs. "the system gets better over time."

**Answer.** The contradiction is only apparent, and **both tracks independently reached the same resolution**: separate the fixed execution machinery from the versioned definitions, and put *all* improvement into the definition layer under version control. Nothing is asked to be simultaneously fixed and changing — determinism and improvement live on different layers, and are additionally separated in time (a definition is fixed *within* a version; improvement is the act of *moving between* versions).

The unified position — internal three-layer model, external config-as-data framing, reconciled:

- **Layer 1 — Rails / control flow (deterministic, version-pinned, harness-owned).** The scrum master reads the protocol and executes it without improvising: fixed phase sequence, fixed gate-consequence table, table-driven routing, cycle stamps. Fixed *within* a definition version. This is the external "fixed interpreter / fixed code" and the DSPy "declarative program with fixed control flow."
- **Layer 2 — Slot content (stochastic, per-run, LLM-driven).** Every specialist output (ADR, spec, pseudocode, code, tests, findings, and the gate *verdict* itself) is LLM-generated and **not byte-reproducible**. Made safe not by determinism but by the firewall (status/adoption moves only on real evidence) and the gate/rework cap.
- **Layer 3 — Process definitions (the versioned artifact that evolves).** `.claude/protocols/*.md`, `.claude/agents/*.md`, `.claude/skills/*/SKILL.md`, CLAUDE.md — files read at runtime, so editing them changes future behavior with **no deploy step**. This layer *is* both the rails and the slot-prompts; it is the object that evolves between versions. The external track's four artifact classes (code / data / config / environment) and "prompts, policies, routing, few-shot exemplars, eval suites are data that evolve" map onto exactly this layer.

**Evidence.** *Internal:* process definitions confirmed as runtime-read files (AGENT-CREATION-GUIDE stability boundary); LLM-slots evolve as prompt text, not weights (Jurati does not fine-tune) — so the evolving object is fully file-based and git-versioned; commit `738083d` is a live process-definition edit made after a validation run. *External:* MLOps config-as-data ("without versioning, any retraining will end up being non-deterministic"; layers "evolve independently while maintaining reproducibility through proper versioning"); DSPy compiles a fixed program against a metric into a "deterministic artifact tied to a specific model, dataset, and optimizer configuration" — improvement at *compile time*, not run time; OPRO (fixed meta-loop, evolving prompt) and Constitutional AI (fixed procedure, evolving human-editable constitution) show the same split at optimization and training layers.

**The load-bearing correction — both tracks converge, state it crisply.** "Execution is deterministic" is only true in the **control-flow / structure** sense, and must never be stated unqualified. The internal challenge ("execution is NOT deterministic in the reproducible-output sense — the rails are deterministic, the content is stochastic; even the fail-open telemetry is not transactionally deterministic") and the external honesty flag ("LLM token generation is generally not bit-reproducible even at temperature 0 — floating-point/batching non-determinism, provider model updates") are the **same point from two directions**. Unified phrasing to adopt everywhere Jurati describes itself:

> **"Deterministic control flow + versioned definition-set + pinned model — NOT deterministic token output."**

An unqualified "execution is deterministic" will be rejected by anyone who knows LLM internals. The honest caveat is that execution is deterministic in the control-flow sense only; slot content was never reproducible.

**Recommendation.** Accept the SCOPE hypothesis with the corrected wording above. Architect Jurati on the config-as-data / DSPy-compilation pattern the ecosystem already validates: protocols, agent prompts, routing, and eval rubrics are **versioned data artifacts**; the harness is fixed code; each improvement is a discrete, reviewable, revertible version bump whose justifying outcome-measurement lives in Unimatrix. "Deterministic yet improving" dissolves via layer + time separation: determinism is a property of the rails within a pinned version; improvement is a property of moving between versions of the definitions; the stochastic slots are bounded by gates and the firewall in both regimes.

---

### Q2: What is the concrete feedback loop (run → measure → propose variant → A/B → adopt), and within it what is deterministic (harness-owned) vs. LLM-driven?

**Answer.** The loop is **run → measure → propose variant → adopt (human-gated) → re-run**, and Jurati already owns roughly **70%** of it in shipped protocol/agent/skill machinery. The external literature confirms the *same* loop shape as a named, production-proven pattern (EDD / MAPE), which strengthens confidence that Jurati's loop is on the industry path, not a bespoke invention.

**The loop, mapped to Jurati's actual components (internal):**

| Loop stage | Who owns it in Jurati today | Determinism |
|---|---|---|
| **Run** | `uni-scrum-master` reads the protocol and executes it — spawns specialists, drives fixed phase sequence, manages gates, calls `context_cycle(start/phase-end/stop)`. | **Deterministic** control flow; **LLM** slot content |
| **Measure** | 9-event hook pipeline auto-captures observations (315 live), cycle-stamped. `context_cycle_review` returns hotspots, `baseline_comparison`/`is_outlier` (real regression detection), per-phase `gate_outcome_text`, `transcript_candidates`. `context_status` gives effectiveness taxonomy + confidence-calibration curve. | **Deterministic recording**; **LLM interpretation** |
| **Propose variant** | `uni-retro`'s architect reads the retro planes and proposes edits — today to knowledge entries; the natural extension is a proposed diff to a process-definition file. | **LLM-driven** (judgment) |
| **Adopt** | Commit the edited definition + bump a git-tag-derived version stamp. Definitions are read at runtime → next run executes the new process with **no deploy**. | **Deterministic** mechanics; **human-gated** decision |
| **A/B / did-it-help** | Slice `context_cycle_review` / `context_status` telemetry by the workflow-version tag: did gate-failure / rework / hotspots improve v_n+1 vs v_n? | **Deterministic** data slice; **LLM** verdict |

**The industry framing of the same loop (external):** run → collect traces → error-analysis/measure → propose variant → **offline eval (regression) → gate** → canary/online eval → adopt (version bump) → repeat. This is the classic autonomic-computing **MAPE** control loop (Monitor→Analyze→Plan→Execute) with a human in the loop, and the **EDD** lifecycle with an explicit offline (pre-deploy) vs. online (runtime) split. Across sources the pattern is consistent: **run/collect and offline-eval are fully automatable; the *propose* step is automatable (OPRO/DSPy/LLM proposer); the *adopt/promote* step is almost always human- or regression-gated.** Full autonomy on adoption is the frontier, not practice — "88% of academic evaluations are fully automated" while shipped systems keep a human gate.

**The deterministic vs. LLM split, grounded:**

*Deterministic (harness-owned):* phase sequencing (SM does not improvise); gate *consequence* mapping (`uni-validator` Step 4 literal decision table — all-PASS→proceed, REWORKABLE-FAIL→re-spawn prior stage, SCOPE-FAIL→stop-and-escalate; max-2 rework, SM-tracked); routing (table-driven, "stop at first match"); measurement recording (9-event hooks, `context_cycle` stamps, git-tag-derived version stamp — emission is mechanical).

*LLM-driven:* the gate *verdict* itself (evaluating the check-set against artifacts is judgment; only the *consequence* is deterministic); all slot content; retro synthesis (explicitly agent-owned — "the tool returns honest planes only"); the variant proposal (writing the process-definition diff); the "is v_n+1 better" call.

**Recommendation.** Adopt the loop exactly as tabled, with the **adopt decision human-gated in v1**, and recognize it as the industry-standard EDD/MAPE loop. Keep the deterministic/LLM boundary where the code already draws it: **the harness owns the rails and the consequence tables; the LLM owns every slot including the gate verdict; the gate's deterministic *consequence* — not a deterministic *judgment* — is what makes the loop safe.** The single missing mechanical piece is the version stamp (Q3/Q5).

---

### Q3: What can Jurati reuse from Unimatrix (ASS-001) and arch-research (ASS-002) rather than invent?

**Answer.** Nearly the entire loop already exists as reusable mechanism across three sources. Self-improvement is an **integration job, not an invention job** — Jurati should **wire, not invent**.

**From ASS-001 (Unimatrix substrate — the measurement machine):**

| Mechanism | Role in the improvement loop | State |
|---|---|---|
| `context_cycle` start/phase-end/stop | Run instrumentation / attribution key | Ready, in use |
| 9-event hook observation pipeline (315 obs live) | Measure — raw signal; automatic, deterministic, fail-open | Ready, running |
| `context_cycle_review` (hotspots, `baseline_comparison`/`is_outlier`, `gate_outcome_text`, `transcript_candidates`) | Measure→learn — per-cycle regression detection + candidate harvest | Ready (present, unexercised) |
| `context_status` effectiveness taxonomy + confidence-calibration table | The knowledge-A/B — did injected knowledge correlate with session success | Present, inert (all zeros) |
| `context_cycle` opaque `tags` | The version-stamp seam — carry the workflow version | Ready, unused |
| typed edges + categories + `context_correct` | Knowledge model + correction discipline | Ready |

**From ASS-002 (arch-research — the improvement design, proven human-gated):**

| Mechanism | Role | Transfer note |
|---|---|---|
| Versioned-workflow-as-artifact (skills/protocols read at runtime; change = commit, no deploy) | The adopt mechanism | Already true in Jurati; make it explicit |
| Git-tag-derived `wf-v<semver>` stamp (`git describe --match 'wf-*'`, never hand-typed — 24 commits drift observed when hand-copied) | The version stamp on `context_cycle` tags | Reuse directly; stamp the literal `git describe` string |
| retro → edit → bump loop (the proven, human-gated half) | The improvement cadence | Adopt wholesale |
| The firewall ("status moves only on real artifact evidence") | Safety invariant for adopting a variant — "v_n+1 is better" is `claimed` until telemetry proves it | Name it as a protocol rule; `uni-capability` already embodies it |
| Advisory vs. blocking gates; PASS/REWORKABLE/SCOPE-FAIL; max-2 rework | The gate model | Already present in `uni-validator` |
| A process observations log (`observations.md` — OBS-1..12 drove 14 versions) | The cheapest improvement input — needs no working telemetry | Adopt; highest value-per-effort |

**From Jurati itself (already built — the back half of the loop):** `uni-retro` (the learn step, extend from knowledge-only to process-definition files); `uni-validator` (produces the friction signal retro consumes); `uni-scrum-master` `context_cycle` attribution (run instrumentation, already emitting); gate reports + `fix(gate):` rework commits (process-friction measurement, already mined by `uni-retro` Phase 1).

**External note reinforcing "reuse, don't invent":** the loop Jurati already has *is* the named literature pattern — MAPE (arxiv 2510.27051, a decades-old control-systems framing) and EDD (arxiv 2411.13768). Adopting the existing internal mechanism is also adopting the industry-validated architecture.

**Recommendation.** Treat self-improvement as integration. The measurement substrate (ASS-001), the improvement design (ASS-002), and the learn step (`uni-retro`) all already exist. Jurati's build reduces to **three small connectors**: (1) stamp the git-tag-derived workflow version onto `context_cycle` tags; (2) extend `uni-retro` to also propose edits to process-definition files (not only knowledge entries); (3) name the firewall as an explicit "workflow change is `claimed` until next-run evidence" protocol rule. Everything else is reuse.

---

### Q4: What external eval-driven / flywheel patterns apply, and what are the risks — overfitting, reward-hacking, drift, loss of reproducibility?

**Answer.** The applicable pattern is **Evaluation-Driven Development (EDD) wrapped in a MAPE control loop, with an LLM-driven proposer and a human-/regression-gated adopter.** Two production papers ground it: Agent-in-the-Loop (EMNLP-2025, arxiv 2510.06674 — 6-step cycle, LLM virtual judge automates filtering while humans gate annotations and "missing knowledge"; update cycles 3 months→weeks, +11.7% recall, +38.1% citation accuracy) and Adaptive Data Flywheel / MAPE (arxiv 2510.27051 — routing model swapped 70B→fine-tuned 8B at 96% accuracy, 10× smaller). EDD (arxiv 2411.13768) documents the offline-vs-online split and the key gap: fully-autonomous self-improvement is largely an *academic* artifact; shipped systems keep a human gate.

**Named patterns to reuse:** EDD (write eval cases before shipping a change, gate on them — TDD's mirror); LLM-as-a-judge (automated grading offline+online — *caveat: judges are definitions that drift and can be gamed*); offline vs. online eval; canary/shadow eval (50–200 case canary sets, "test→canary→monitor→rollback"); prompt optimization (DSPy/OPRO as automated *proposer*, not *adopter*); RLHF/RLAIF/Constitutional AI as analogy (human-authored constitution/protocols + AI critique — full RL not needed v1).

**Risks + mitigations (external evidence base):**

| Risk | Mitigation |
|---|---|
| **Goodhart / metric overfitting** | One north-star + guardrail metrics (never a single scalar); stacked metrics; frozen evals; trace review |
| **Reward hacking / spec-gaming** | Reward shaping; adversarial red-teaming (failures become next-round negatives); ensemble/uncertainty reward models; keep a *gold* eval the optimizer never sees |
| **Drift** (data/behavior/judge) | Online drift monitoring + escalation on confidence-threshold breach feeding new cases back offline; periodically re-validate the judge against human labels; treat the eval suite as living/versioned |
| **Loss of reproducibility** | Version all four artifact classes + pin model id; per-execution isolation; store each run's definition-set hash with its outcome |
| **Eval contamination / leakage** (~45% measured on public benchmarks) | Held-out/frozen eval sets the optimizer never trains on; "contamination canary" sets (structurally identical, modified content); flag unnatural spikes |
| **Regression on unmeasured qualities** | Guardrail KPIs + frozen regression suite + human trace review; canary+monitor+rollback on a broad signal set |
| **Judge fragility** (length/position/self-preference bias) | Validate judges vs. human labels; ensemble judges; humans in loop for high-stakes/novel cases |

**Recommendation.** Use the EDD/MAPE loop with an LLM proposer and a human-/regression-gated adopter. **Hard-require three defenses from day one:** (1) a **frozen held-out regression suite** no optimizer may train on (kills contamination + Goodhart together); (2) **north-star + guardrail metrics**, never a single score; (3) **full definition-set versioning + model pinning** (revertible improvements, reproducible past runs). Reward-hacking and drift are *contained* via human-gated adoption + rollback, not fully prevented — accept that honestly.

---

### Q5: What is the minimum self-improvement capability worth building into v1 vs. deferring? Where is the honest MVP line?

**Answer (settled — both tracks converge on the same line, from opposite starting points).** **v1 = the measurement + version-stamped, retro-driven, human-gated definition-improvement loop over the existing substrate. Defer the autonomous optimizer entirely.** The internal track reaches this by asking "what does our substrate already provide?" (answer: ~80% of it); the external track reaches it by asking "what did every credible production source ship first?" (answer: a trustworthy versioned human-gated eval hub, automation added spoke-by-spoke). They agree.

**A strengthening fact both tracks surfaced: the loop is ALREADY turning by hand.** Commit `738083d` ("Validate research flow end-to-end; fix routing + write-prohibition wording") is a complete retro→edit→commit turn on `.claude/` definition files, done manually after a validation run. v1 is therefore **not building a loop from scratch — it is instrumenting and versioning a loop that already runs informally.**

**ALREADY HAVE (live today, zero build):**
- Deterministic execution: SM control flow + `uni-validator` three-gate decision table + max-2 rework cap.
- `context_cycle` attribution + 9-event observation pipeline (315 obs, running).
- `context_cycle_review` retrospection *with* regression detection (`baseline_comparison`/`is_outlier`) and `gate_outcome_text`.
- `uni-retro` extraction of lessons/patterns/procedures.
- Process definitions as runtime-read files — "edit the process, next run uses it, no deploy" already works (proven by `738083d`).
- Effectiveness taxonomy + confidence-calibration machinery (present, inert).

**SMALL LIFT — the actual v1 build (internal mechanism + external discipline merged):**
- **Git-tag-derived workflow-version stamp on `context_cycle` tags** — small, deterministic, highest-leverage; makes every downstream retrospection version-aware. **Build this first.** (This is the external "version every definition change with its outcome evidence" and "full artifact versioning + model pinning.")
- **Extend `uni-retro` to process definitions** — add an explicit "does this cycle warrant a protocol/agent/skill edit?" step emitting a proposed `.md` diff + version bump. Formalizes the trigger the `738083d` edit already exercised ad hoc. Keep the proposer **human-initiated** in v1.
- **A process-improvement observations log** (arch-research `observations.md` analog) — cheap, needs no telemetry, value on day one. Complements the external "review 20–50 outputs / error-analysis before infrastructure" (Husain & Shankar: writing elaborate eval criteria before looking at data is the #1 documented mistake).
- **A small held-out regression set that grows from real failures** (external hard-require; canary size 50–200) + **name the firewall** — "a workflow edit is `claimed` until next-run/telemetry evidence; human gates adoption."
- **One human decision-maker** at the adopt gate (external "benevolent dictator" — not a committee, not an autonomous judge).

**DEFER (not v1 — unproven or premature):**
- **Autonomous, telemetry-proven A/B of workflow versions** — ASS-002: never ran once upstream; EDD's 88%-automated is academic; and Jurati's own effectiveness loop is inert (0 retrospected across 315 obs), so we have zero evidence it *discriminates*. Keep human-gated.
- **Automated prompt optimizers (DSPy / OPRO) as proposer** — until the metric is trusted.
- **Online / canary / shadow infra** — heavier; add after the offline loop is trusted.
- **RL / RLAIF / fine-tuning flywheels** — reached only after a mature annotation pipeline.
- **Cross-cycle / portfolio retrospection** (ASS-001 gap #7) — defer until cycle count justifies trending.
- **Knowledge-effectiveness-driven auto-adoption** and a **sealed process-plane category** (ASS-002 avoid #4) — premature.

**Recommendation.** Draw the v1 line at **"version-stamped, retro-driven, human-gated process improvement over the existing substrate"** — ~80% wiring of shipped mechanism plus one small new stamp, governed by the external track's three hard-required defenses (frozen held-out suite, north-star + guardrails, full versioning + model pinning). Ship the version stamp first, extend retro to process files, keep an observations log, grow a small held-out regression set, and name the firewall. **Defer every autonomous/quantitative capability until the currently-inert measurement loop is observed to discriminate on real Jurati cycles** — do not build on a signal that has produced zero outputs in 315 observations. This is exactly what every credible production source shipped first.

---

## Target Outputs (SCOPE-required deliverables)

**(a) Self-improvement model — recommended shape of Jurati's improvement loop.**
The industry-standard **EDD / MAPE loop**, most of which Jurati already owns: **run → measure → propose variant → adopt (human-gated) → re-run**, with outcomes recorded in Unimatrix and each adopted change carrying a git-tag-derived version stamp. Harness owns the deterministic rails, gate-consequence tables, routing, and measurement recording; the LLM owns every slot (including the gate verdict) and the variant proposal; a human owns the adopt decision. It is an integration of ASS-001 substrate + ASS-002 improvement design + Jurati's `uni-retro`, not a new invention.

**(b) Determinism resolution — the explicit answer to "deterministic yet improving."**
Adopt: **"deterministic control flow + versioned definition-set + pinned model — NOT deterministic token output."** Three layers: (1) rails, deterministic and fixed *within* a version; (2) slot content, stochastic per run, bounded by gates + firewall not by determinism; (3) process definitions, the versioned object that evolves *between* versions. Determinism is a property of layer 1 within a pinned version; improvement is a property of moving between versions of layer 3. The honest caveat both tracks insist on: execution is deterministic in the **control-flow sense only** — LLM token output is never bit-reproducible (temperature-0 floating-point/batching non-determinism, provider model updates, fail-open telemetry). The paradox dissolves via layer + time separation; nothing is asked to be both fixed and changing.

**(c) Deterministic / LLM split within the loop.**
*Deterministic (harness):* phase sequencing, gate-consequence table (PASS→proceed / REWORKABLE-FAIL→re-spawn / SCOPE-FAIL→escalate, max-2 rework), table-driven routing, measurement recording (hooks, cycle stamps, git-tag version stamp). *LLM:* the gate verdict itself, all slot content, retro synthesis, the variant-proposal diff, the "is v_n+1 better" call. The gate is safe because its *consequence* is deterministic, not because its *judgment* is.

**(d) v1-vs-later scope line.**
v1 = version-stamped, retro-driven, human-gated process improvement over the existing substrate (~80% wiring + one new stamp), with three hard-required defenses (frozen held-out suite; north-star + guardrails; full versioning + model pinning). Build first: the git-tag-derived version stamp on `context_cycle` tags. Later/defer: autonomous telemetry-proven A/B, automated DSPy/OPRO proposers, online/canary/shadow infra, RL/RLAIF/fine-tuning, cross-cycle retrospection, effectiveness-driven auto-adoption, sealed process-plane category.

**(e) Risks + mitigations.**
Goodhart → north-star + guardrails, never a single scalar. Reward-hacking → gold eval the optimizer never sees + adversarial red-teaming. Drift → living/versioned eval suite + periodic judge re-validation + online monitoring. Reproducibility loss → version all artifact classes + pin model id + store each run's definition-set hash with its outcome. Contamination → frozen held-out sets + "contamination canary" mirrors. Unmeasured-quality regression → guardrail KPIs + human trace review + rollback. Judge fragility → validate judges vs. human labels + ensemble + humans-in-loop for high-stakes cases. Reward-hacking and drift are *contained* (human-gated adoption + rollback), not fully prevented. **Jurati-specific risk overriding all of the above:** the measurement loop is architecturally sound but operationally unexercised (0 retrospected / 315 obs) — treat "Unimatrix outcome measurement discriminates good process changes from bad" as `claimed`, not settled, and keep the whole loop human-gated until it is observed to discriminate on real cycles.

---

## Unanswered Questions

- **Does the Unimatrix measurement loop actually discriminate a better process version from a worse one at Jurati's scale?** Cannot be answered from an inert loop (0 retrospected, effectiveness all zeros across 315 obs). Requires running real versioned cycles and observing whether `cycle_review` regression detection + effectiveness scoring produce an actionable delta. Inherited from ASS-001; this spike does not resolve it — it defines the MVP so as *not to depend on* it. Requires empirical data not yet available. (Both tracks flag this: the literature confirms *what* must be measured — outcome + guardrails + held-out eval — but not whether Jurati's existing substrate captures it.)
- **Right cadence for Jurati's low-volume, high-stakes SDLC runs.** Production sources report "months→weeks" at customer-support *volume*; the small-N regime (few runs per unit time → weak A/B statistical power) is poorly covered by the literature. Real open risk; likely a follow-on empirical spike once instrumented.
- **Eval of multi-step agentic *trajectories* (not just final outputs).** Acknowledged hard and immature; low confidence any turnkey pattern exists. Treat as a research frontier.
- **Exact retro-trigger for process edits** (what threshold of hotspot/rework warrants a protocol edit vs. a knowledge entry). A design-session question, not a research question — flagged for the downstream design of the extended `uni-retro`.

---

## Out-of-Scope Discoveries

- **The improvement loop is already turning by hand on the process definitions.** Commit `738083d` is a complete retro→edit→commit turn on `.claude/` definition files, done manually. v1 is instrumenting and versioning a loop that already runs informally — strengthens the Q5 MVP case.
- **The gate's determinism is in the consequence, not the judgment.** Any Jurati "deterministic" claim should specify *deterministic control flow around stochastic slots*, never *reproducible outputs*. Candidate lesson for how Jurati describes itself publicly.
- **`context_cycle_review` is richer than the loop currently uses** — `baseline_comparison`/`is_outlier` regression detection + per-phase `gate_outcome_text` already present. The real measurement gap is *knowledge-yield accounting*, not the telemetry surface. Relevant if a downstream design wants version-over-version process trending before cross-cycle retrospection is built.
- **MAPE (Monitor-Analyze-Plan-Execute)** (arxiv 2510.27051) — a clean, decades-old control-systems framing for the whole flywheel; candidate *organizing metaphor* for Jurati's improvement engine (named, literature-backed architecture instead of bespoke).
- **DSPy as an implementation substrate** (not just a framing) — closest off-the-shelf realization of "deterministic runtime, evolving definitions"; a future evaluation spike if Jurati ever wants *automated* protocol/prompt optimization.
- **"Contamination canary" sets** — structurally-identical-but-modified eval mirrors; cheap, high-leverage, generalizes beyond ML benchmarks to any self-improving eval loop; reusable regardless of v1 scope.

---

## Recommendations Summary

- **Q1 (determinism reconciliation):** Accept the SCOPE hypothesis, restated precisely as **"deterministic control flow + versioned definition-set + pinned model — NOT deterministic token output."** Three layers: version-pinned deterministic rails (1), stochastic gate/firewall-bounded slot content (2), versioned evolving definitions (3). "Deterministic yet improving" dissolves via layer + time separation — determinism is the rails within a version, improvement is moving between versions. Honest caveat: execution is deterministic in the control-flow sense only; token output is never bit-reproducible. Architect on config-as-data / DSPy-compilation.
- **Q2 (loop + split):** Adopt run→measure→propose→adopt(human-gated)→re-run — Jurati already owns ~70%, and it *is* the industry EDD/MAPE loop. Harness owns deterministic rails + gate *consequence* tables + routing + cycle stamps; LLM owns every slot including the gate *verdict* and the variant proposal. Safety comes from the firewall/gate-cap, not from determinism.
- **Q3 (reuse):** Wire, don't invent. Reuse `context_cycle`+hooks+`context_cycle_review`+effectiveness (ASS-001), versioned-workflow-as-artifact + git-tag-derived `wf-v` stamp + retro→edit→bump + firewall (ASS-002), and `uni-retro`+`uni-validator` (Jurati). Net-new is three connectors: version stamp on cycle tags, retro-targets-process-files, named firewall rule.
- **Q4 (external patterns + risks):** Use **EDD/MAPE** with an **LLM proposer + human-/regression-gated adopter**. Hard-require **frozen held-out regression suite**, **north-star + guardrail metrics**, **full artifact versioning + model pinning** — these counter Goodhart, reward-hacking, contamination, drift, and reproducibility loss; unmeasured-quality regression is contained via guardrails + trace review + rollback, not eliminated.
- **Q5 (MVP line — settled):** v1 = **version-stamped, retro-driven, human-gated process improvement over the existing substrate** — ~80% wiring + one new stamp. Build first: git-tag-derived version stamp on `context_cycle` tags. Also: extend `uni-retro` to process-definition files, keep a process observations log, grow a small held-out regression set (50–200), one human at the adopt gate, name the firewall. Defer: autonomous telemetry-proven A/B, automated DSPy/OPRO proposers, online/canary infra, RL/RLAIF/fine-tuning, cross-cycle retrospection, effectiveness-driven auto-adoption. Strengthening fact: the loop is already turning by hand (commit `738083d`) — v1 instruments a loop that already runs. Overriding caveat: the measurement layer is architecturally sound but operationally unexercised (0 retrospected / 315 obs) — treat "measurement discriminates" as `claimed`, keep human-gated until proven on real cycles.
