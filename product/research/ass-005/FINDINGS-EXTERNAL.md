# FINDINGS (EXTERNAL track): Self-Improving Deterministic Workflows

**Spike**: ass-005 · **Date**: 2026-07-16 · **Approach**: literature (external eval-driven + flywheel) · **Confidence**: directional · **Track**: EXTERNAL (dual-track Case 3)

**Sourcing note**: Web search (dated July 2026) surfaced several arxiv IDs in the `2601.x`–`2606.x` range I could not independently verify. I built **no load-bearing claim** on those and flag them where relevant. All recommendations rest on verifiable primary sources (DSPy, OPRO, Constitutional AI, Anthropic; papers I fetched directly at arxiv 2411.13768 and 2510.06674; Husain/Shankar's evals writing).

---

## Q1 — Reconciling "deterministic execution" vs. "gets better over time"

**Answer**: The contradiction is only apparent. The field resolves it by **separating fixed execution machinery from versioned definitions, and moving all improvement into the definition layer under version control.** The runtime is a fixed interpreter; the *prompts, policies, configs, routing, few-shot exemplars, and eval suites* are data that evolve. Improvement is a sequence of discrete, versioned, individually-reproducible definition changes — not a continuously-mutating runtime.

Four convergent framings in the literature:

1. **Separation of code and configuration (MLOps / config-as-data)** — the dominant framing. Reproducibility is defined as versioning **four artifact classes: code, data, config, environment**; "without versioning, any retraining will end up being non-deterministic." Layers "evolve independently… while maintaining reproducibility through proper versioning." This *is* the SCOPE hypothesis, stated by the ecosystem. (MLOps Coding Course; AIOps Community; LaunchDarkly)

2. **Compilation to a deterministic artifact (DSPy)** — the sharpest realization. A declarative program (fixed control flow/signatures) is compiled by an optimizer ("teleprompter") against a metric+trainset into an optimized prompt config. "Each compilation produces a **deterministic artifact** tied to a specific model, dataset, and optimizer configuration." Improvement happens at *compile time* (offline, gated), not run time. Separated in **time** (compile vs. run) and **layer** (program vs. prompt-artifact). Gains 25–65% over hand-prompting. (Khattab et al.; advancinganalytics; dbreunig)

3. **Fixed meta-loop over an evolving artifact (OPRO, arxiv 2309.03409)** — the optimization *loop structure* is fixed; the *prompt* being improved evolves. Beats human prompts up to 8% (GSM8K), 50% (Big-Bench Hard).

4. **Two-phase self-critique with a fixed procedure (Constitutional AI / RLAIF, arxiv 2212.08073)** — fixed procedure (generate→critique-against-constitution→revise→SFT→RLAIF); the human-editable *constitution* is the evolving definition. Same split at the training layer.

**Honesty flag on "deterministic":** The literature supports reproducible *orchestration + pinned definition-set + versioned model* — but **LLM token generation is generally not bit-reproducible** even at temperature 0 (floating-point/batching non-determinism, provider model updates). The defensible claim is: *"deterministic control flow + versioned definition-set + pinned model, not deterministic token output."* Adopt that phrasing; an unqualified "execution is deterministic" will be rejected by anyone who knows LLM internals.

**Recommendation**: Accept the SCOPE hypothesis, restated precisely as above. Architect Jurati on the config-as-data / DSPy-compilation pattern: protocols, agent prompts, routing, eval rubrics are **versioned data artifacts**; the harness is fixed code; each improvement is a discrete, reviewable, revertible version bump whose justifying outcome-measurement lives in Unimatrix. The paradox dissolves via layer + time separation.

---

## Q4 — Eval-driven / flywheel patterns and risks

### 4a. Core loop; automated vs. human-gated

Canonical loop, consistent across sources: **run → collect traces → error-analysis/measure → propose variant → offline eval (regression) → gate → canary/online eval → adopt (version bump) → repeat.** The flywheel "compounds — each cycle improves both the system and the ability to evaluate it." (Vercel; freeCodeCamp; Pragmatic Engineer)

Two production papers (fetched directly):

- **Agent-in-the-Loop (AITL), EMNLP-2025 Industry (arxiv 2510.06674)** — 6-step cycle with four annotation types (pairwise preference, adoption rationale, knowledge relevance, missing-knowledge). **Automated**: LLM "virtual judge" filters annotations, batch inference, periodic LoRA/QLoRA retraining. **Human-gated**: the annotations themselves, expert review, and — notably — *"missing knowledge" is explicitly preserved for human judgment.* Update cycles cut **3 months → weeks**; +11.7% recall@75, +14.8% precision@8, +8.4% helpfulness, +38.1% citation accuracy; annotation agreement 43.6%→92.3%.

- **Adaptive Data Flywheel / MAPE (arxiv 2510.27051)** — frames the loop as the classic autonomic-computing **Monitor→Analyze→Plan→Execute** control loop with human-in-the-loop. Routing model swapped 70B→fine-tuned 8B at 96% accuracy, 10× smaller, 70% lower latency. Value: the loop is a *named control-systems pattern*, not an invention.

- **EDD process model (arxiv 2411.13768)** — 4-step lifecycle with explicit **offline (pre-deploy) vs. online (runtime)** split and two-branch improvement (4a: adjust prompts/retrieval/tools without redeploy; 4b: redevelop architecture/model/tests). Key gap it documents: **"88% of academic evaluations are fully automated" while "industry integrates hybrid human-AI approaches"** — fully-autonomous self-improvement is largely an *academic* artifact; shipped systems keep a human gate.

**Automated vs. human-gated (synthesis):** run/collect and offline-eval are fully automatable; the *propose* step is automatable (OPRO/DSPy/LLM proposer); the **adopt/promote step is almost always human- or hard-gated by a regression suite.** Full autonomy on adoption is the frontier, not practice.

### 4b. Named patterns to reuse
- **Evaluation-Driven Development (EDD)** — TDD's mirror; write eval cases before shipping a prompt/protocol change, gate on them.
- **LLM-as-a-judge** — automated grading offline+online; same rubric as regression grader and live monitor (Evidently AI; DeepEval). *Caveat: judges are definitions that drift/can be gamed.*
- **Offline vs. online eval** — offline regression gates deploy; online scores a live slice (Deepchecks).
- **Canary / shadow eval** — route/shadow 5–10% of traffic, LLM-judge live sessions vs. control; "test→canary→monitor→rollback." Canary sets of **50–200 cases** run on every change.
- **Prompt optimization (DSPy, OPRO)** — automated *proposer*, not *adopter*.
- **RLHF/RLAIF/Constitutional AI flywheels** — analogy for Jurati (human-authored "constitution"/protocols + AI critique); full RL heavyweight, not needed v1.
- **Data flywheel / MAPE / Agent-in-the-loop** — operational wrapper turning production feedback into signal.

### 4c. Risks + mitigations

| Risk | Mitigation (from literature) |
|---|---|
| **Goodhart / metric overfitting** — proxy peaks then diverges from true objective under pressure | **One north-star + guardrail metrics** ("pair north-star with guardrails → fewer regressions"); stacked metrics, frozen evals, trace review. Never optimize a single scalar. |
| **Reward hacking / spec-gaming** — optimizer exploits metric flaws (e.g. verbosity) | Reward shaping (arxiv 2502.18770); **adversarial red-teaming** where failures become next-round negatives; ensemble/uncertainty reward models; keep a *gold* eval the optimizer never sees. |
| **Drift** (data/behavior/judge) | Online drift monitoring + escalation on confidence-threshold breach feeding new cases back offline (EDD); periodically re-validate the judge against human labels; treat eval suite as living/versioned. |
| **Loss of reproducibility** | **Version all four artifact classes + pin model id**; per-execution isolation; store each run's definition-set hash with its outcome. |
| **Eval contamination / leakage** — measured up to ~45% on public benchmarks; MMLU ~29%, scores drop up to 13pts on clean mirrors | **Held-out/frozen eval sets** the optimizer never trains on; **"contamination canary" sets** (structurally identical, modified content); flag unnatural spikes. (Search-Time Data Contamination 2508.13180; LessLeak-Bench 2502.06215) |
| **Regression on unmeasured qualities** | Guardrail KPIs + frozen regression suite + human trace review; canary+monitor+rollback on a *broad* signal set; "excessive modifications risk destabilizing performance" (EDD). |
| **Judge fragility** (LLM-as-judge bias: length/position/self-preference) | Validate judges vs. human labels; ensemble judges; humans in loop for high-stakes/novel cases. |

**Recommendation**: Use the **EDD / MAPE** loop with an **LLM-driven proposer and a human-/regression-gated adopter**. Hard-require three defenses from day one: (1) **frozen held-out regression suite** no optimizer may train on (kills contamination + Goodhart together); (2) **north-star + guardrail metrics**, never a single score; (3) **full definition-set versioning + model pinning** (revertible improvements, reproducible past runs). Reward-hacking and drift are *contained* via human-gated adoption + rollback, not fully prevented — accept that.

---

## Q5 — External input to the v1-vs-later line (final MVP settled in synthesis)

The literature is unusually consistent, and it is the *opposite* of the "autonomous optimizer" vision.

**Ship first (honest MVP):**
1. **Error analysis before infrastructure** — Husain & Shankar (*LLM Evals FAQ*): "review 20–50 outputs manually whenever you make significant changes." Writing elaborate eval criteria before looking at data is the #1 documented mistake.
2. **One human decision-maker** ("benevolent dictator" / single domain expert) — not a committee, not an autonomous judge.
3. **A cheap trace-review harness** (notebook or light annotation UI) to read/label/cluster failures.
4. **A small held-out regression set that grows from real failures** — "start small, let data guide you." Canary size 50–200 cases.
5. **A human-gated adopt step** — measure a proposed change against the frozen suite + a human eyeball, then version-bump.

**Defer:** autonomous adoption (EDD's 88%-automated is academic); automated prompt optimizers (DSPy/OPRO) as *proposer* until you trust the metric; RL/RLAIF/fine-tuning flywheels (AITL/MAPE reach these only after a mature annotation pipeline); online/canary/shadow infra (heavier — after the offline loop is trusted).

**External directional recommendation**: Jurati v1 self-improvement = **the measurement + human-gated definition-versioning loop, not the autonomous optimizer.** Instrument runs so outcomes land in Unimatrix (internal track owns substrate sufficiency); support *human-initiated* variant proposal; gate adoption on frozen-regression + human sign-off; version every definition change with its outcome evidence. Defer automated proposal, autonomous adoption, and RL/fine-tuning. This matches what every credible production source shipped first: **a trustworthy versioned human-gated eval hub is the flywheel's core; automation is added spoke-by-spoke.**

---

## Unanswered Questions
- **Is Unimatrix's `context_status`/observation data a sufficient measurement substrate?** — internal track's question by design. Literature confirms *what* must be measured (outcome + guardrails + held-out eval), not whether the existing substrate captures it.
- **Right cadence for Jurati's low-volume, high-stakes SDLC runs?** — production sources report "months→weeks" at customer-support *volume*. Small-N regime (few runs per unit time → weak A/B power) is poorly covered by the literature. Real open risk; likely a follow-on empirical spike once instrumented.
- **Eval of multi-step agentic *trajectories* (not just final outputs)** — acknowledged hard and immature; low confidence any turnkey pattern exists. Treat as research frontier.

## Out-of-Scope Discoveries
- **MAPE (Monitor-Analyze-Plan-Execute)** (arxiv 2510.27051) — a clean, decades-old control-systems framing for the whole flywheel; candidate *organizing metaphor* for Jurati's improvement engine (gives a named, literature-backed architecture instead of bespoke).
- **DSPy as an implementation substrate** (not just a framing) — closest off-the-shelf realization of "deterministic runtime, evolving definitions"; future evaluation spike if Jurati ever wants *automated* protocol/prompt optimization.
- **"Contamination canary" sets** — structurally-identical-but-modified eval mirrors; cheap, high-leverage, generalizes beyond ML benchmarks to any self-improving eval loop; a reusable pattern regardless of v1 scope.

---

## Recommendations Summary
- **Q1**: Adopt the SCOPE hypothesis, restated as **"deterministic control flow + versioned definition-set + pinned model, not deterministic token output."** Architect on config-as-data / DSPy-compilation; improvement = discrete revertible version bumps measured in Unimatrix. Paradox dissolves via layer+time separation.
- **Q4**: Use **EDD/MAPE** (run→measure→propose→offline-eval→gate→canary→adopt) with **LLM proposer + human-/regression-gated adopter**. Hard-require **frozen held-out regression suite**, **north-star + guardrail metrics**, **full artifact versioning + model pinning** — these counter Goodhart, reward-hacking, contamination, drift, reproducibility loss; unmeasured-quality regression contained via guardrails + trace review + rollback.
- **Q5 (external)**: Ship the **measurement + human-gated definition-versioning loop** first (error-analysis on traces, one expert, small growing held-out suite, human-gated version bumps). Defer automated proposal (DSPy/OPRO), autonomous adoption, RL/RLAIF/fine-tuning, online/canary infra. *(Final MVP line settled in synthesis with internal-track substrate findings.)*

**Key sources**: DSPy (Khattab et al.; advancinganalytics; dbreunig); OPRO (arxiv 2309.03409); Constitutional AI/RLAIF (arxiv 2212.08073; anthropic.com); EDD process model (arxiv 2411.13768); Agent-in-the-Loop EMNLP-2025 (arxiv 2510.06674); Adaptive Data Flywheel/MAPE (arxiv 2510.27051); Husain & Shankar LLM Evals FAQ (hamel.dev); Vercel/freeCodeCamp/Pragmatic Engineer eval-flywheel; Deepchecks (offline vs online); Evidently AI / DeepEval (LLM-as-judge); Goodhart/reward-hacking (explainx; arxiv 2502.18770); contamination (arxiv 2508.13180, 2502.06215); MLOps reproducibility (mlops-coding-course.fmind.dev; aiopscommunity.com; launchdarkly.com). *Unverified 2026-dated arxiv IDs (2601.x–2606.x) excluded from all core claims.*
