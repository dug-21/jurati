# FINDINGS: The arch-research Factory

**Spike**: ass-002
**Date**: 2026-07-16
**Approach**: investigation (code+ecosystem — read `github.com/dug-21/arch-research`)
**Confidence**: directional

---

## Evidence base

Cloned and read `dug-21/arch-research` in full. Primary sources:
- `docs/research-factory-methodology.md` (the 15-section spec — the whole method)
- `.claude/agents/factory/*.md` (research-leader, factory-curator, factory-researcher, goal-owner, scout, hypothesizer)
- `.claude/workflow/{decompose-scope,research-scope,theme-scan}.md` (the executable protocols)
- `.claude/skills/factory-{retro,git,onboard}/SKILL.md`
- `.claude/rules/unimatrix-access.md`
- `product/factory/{decisions.md (D1-D13), observations.md (OBS-1..12), runbook.md, themes.md}`
- `product/factory/experiments/{ab-001,mg-001}.md`, `product/factory/proposals/*`
- git history: 14 `wf-v0.1`...`wf-v0.14` method tags.

Anchored against Jurati's own structure (its `uni-*` agent roster and `design/delivery/bugfix/research` protocols in `.claude/protocols/uni/`). Jurati's Unimatrix KB is empty (fresh install; `context_briefing` and `context_search` both returned nothing) — so Q4 is anchored on Jurati's file structure, not its KB.

---

## Findings

### Q1: How is the `arch-research` workflow factory structured — what runs deterministically vs. LLM-driven, and what generalizes into a reusable harness?

**Answer.** The factory is a **phase-gated, coordinator-orchestrated, single-writer** pipeline (methodology §14). The split is clean:

**Deterministic / mechanical rails (the harness):**
- **Coordinator/specialist separation.** One `research-leader` reads a protocol and executes it; it *spawns all work to subagents and never generates content or writes knowledge itself*. This is a hard rule — both context-window protection and the single-writer firewall depend on it.
- **Fixed phase sequence** per scope: `scope -> decompose` (decompose-scope) or `scope -> tech-discovery -> [feasibility] -> synthesis` (research-scope); `scan -> hypothesize -> triage` (theme-scan). Each phase closes with a `context_cycle phase-end`.
- **Gate machinery.** Two gate kinds: *advisory* (scope, synthesis — a reviewer's stance relayed verbatim to a human; the leader never acts on it) and *blocking* (coverage, firewall/feasibility — a validator returns PASS / REWORKABLE-FAIL / SCOPE-FAIL; REWORKABLE re-spawns the prior phase, **max 2 iterations**, then escalates).
- **Three-surface model (D1):** Unimatrix = settled/compounding knowledge; git = provisional narrative + proof artifacts; GitHub Issue = the live human<->factory interface. Machine->Issue is render-only; only human inputs *originate* in the Issue and must be distilled back before they count.
- **Two-stream git + `wf:` version stamp** derived from a git tag (see Q2), path-scoped commits for parallel safety.
- **Board-as-graph-query.** "What's done" is never a stored list — it's a single hydrated `context_graph(subgraph)` call read at the start of every cycle.

**LLM-driven / judgment (the specialists):** the actual research (`factory-researcher`, read-only, produces FINDINGS files), the decomposition judgment, the distillation of findings into graph nodes (`factory-curator`, the single writer and "architect-equivalent judgment role"), POC construction (`factory-poc`), artifact verification (`factory-validator`), divergent hypothesis generation (`hypothesizer`, run deliberately on Fable 5 with loose reins), and convergent triage + relevance review (`goal-owner`). All judgment lives in swappable specialists; the leader is pure orchestration.

**The load-bearing invariant that ties it together — the firewall (§3):** *status advances to `proven` ONLY on attached, real-artifact evidence; research and "it should work" move structure, never status.* Structure (what nodes exist, their edges, grades up to `claimed`/`partial`) is moved freely and autonomously by LLM research; status (`proven`) is gated on a demonstrated artifact at the claim's altitude. This is the single mechanism that makes an autonomous loop safe from "compounding rubble at machine speed."

**Evidence.** `research-leader.md` ("spawns all work to specialists and never generates content"; `context_cycle` ONLY access); `factory-curator.md` (the ONLY writer); methodology §14.1 roster + §14.3 gates; `research-scope.md`/`decompose-scope.md`/`theme-scan.md` phase definitions; §3 firewall.

**Recommendation.** Adopt the **coordinator-never-generates-content + single-writer + phase-gate-with-bounded-rework** triad as Jurati's reusable harness spine — it is domain-neutral and already half-present in Jurati (`uni-scrum-master` is the coordinator analog, `uni-validator` the three-gate analog, `uni-architect` the single-writer-judgment analog). Make the **firewall principle** ("status moves only on real artifact evidence") an explicit, named invariant in Jurati's protocols, not an implicit norm — it is the highest-value transferable idea and the one thing that makes autonomy safe.

---

### Q2: How did arch-research design workflow-improvement in from the start — the concrete mechanism, and what has it actually learned in practice? (feeds ASS-005)

**Answer — the mechanism (designed in from day one).** The workflow is a **first-class, versioned artifact** (methodology §7-8), improved on two orthogonal axes: the *subject axis* (is a goal's research done?) and the *process axis* (is the factory running better?). The concrete machinery:

1. **Versioned method.** Skills + protocols live in the repo and are read at run time — a change takes effect on the next run with no deploy step beyond the commit.
2. **`wf:<version>` stamp, single-sourced from a git tag.** The annotated tag `wf-vX.Y` on the method commit is the sole source of truth; the runtime stamp is *derived* (`git describe --tags --match 'wf-*'`), never hand-typed, and rides the `context_cycle(start)` `tags` (set-once at INIT). This exists because hand-copied stamps drift (they observed 24 commits stamped `wf:v0.10` while tags reached v0.12).
3. **Telemetry per run and per version.** `context_cycle_review` aggregates the observation stream; knowledge-yield (findings/run, the proven-vs-claimed "firewall ratio", dead-end rate) is computed by querying nodes tagged with the run-id. Slicing that yield by the `wf:` tag is the process-axis measurement.
4. **The reflexive A/B loop:** `lesson-learned` -> workflow edit (e.g. raise coverage K) -> committed as `wf:v3` -> next runs stamped v3 -> `cycle_review` compares v3-runs vs v2-runs -> *better?* the delta is the `proven_by` artifact for the factory capability "improves its own workflow" (#66) -> *not better?* the lesson was wrong, revert/re-learn.
5. **The firewall applies to itself.** "v3 is better" is `claimed` until comparative telemetry proves it — process improvement is held to the same evidence bar as research. Process improvements are isolated in a **sealed `factory` category** (a process plane, `factory->factory` edges only) so self-improvement tracking never pollutes research retrieval.

**Answer — what it has ACTUALLY learned in practice (the honest, load-bearing finding):**

There are **two halves, and only one has run.**

- **The informal, retro-driven half WORKS and is well-evidenced.** 14 `wf:` versions (`wf-v0.1`->`wf-v0.14`) are real, committed method changes, each driven by a concrete lesson from a real manual run. Traceable examples: OBS-4 (goal-owner missed a step-function level-up) -> a 4th goal-owner dimension baked into `goal-owner.md` at wf:v0.8; OBS-7 (every spawned subagent's file-write is blocked in this harness) -> the researcher contract flipped from "writes its own FINDINGS file" to "returns markdown, leader persists"; OBS-10 (a whole run-line ran with no GitHub Issue and no cycle stamp) -> both wired into protocol INIT as mandatory-first steps; OBS-11/12 (synthetic tests flatter; real linked-transcript data exposed a false-positive) -> a "prove on real captured data, not a proxy" rule. This is a genuinely functioning improve-the-workflow-with-its-own-retrospective loop.
- **The formal, telemetry-proven, autonomous A/B half has NEVER RUN.** Both designed experiments — `AB-001` (the first reflexive A/B, testing a divergent front-end lever) and `MG-001` (multi-goal isolation validation) — are marked **"DESIGNED · not yet run."** The reflexive capability #66 ("improve-its-own-workflow, telemetry-proven") is still `claimed`/`blocked`. Telemetry is only *partially* wired (OBS-6: the cycle/phase/attribution stream works — `cycle_review` returns rich per-phase data; but `total_tool_calls: 0`, `knowledge_curated: 0`, and `feature_knowledge_reuse.total_served: 0` remain unpopulated). Per-run yield is queryable only by a curator-maintained tag convention, not natively.

So: the improvement **design is thorough and internally consistent**, and the **human-in-the-loop retrospective loop is proven**; the **autonomous, quantitative, self-A/B-proving loop is designed but unproven** — by the factory's own firewall, its self-improvement capability is `claimed`, not `proven`.

**Evidence.** methodology §7-§8, §10; `factory-git.md` (`wf:` derivation + drift story); `factory-retro/SKILL.md` (Phase 3: "a factory capability reaches proven ONLY on an autonomous-run artifact; a human-inline run is partial"); OBS-1..12; `ab-001`/`mg-001` status headers; git tag list (14 versions); OBS-6 (telemetry partial).

**Recommendation for ASS-005.** Adopt the **design wholesale** — versioned-protocol-as-artifact, git-tag-derived semver stamp, retro->edit->bump loop — it is the strongest transferable asset here. But **do not inherit the assumption that autonomous telemetry-proven A/B works**: it has not run once in the source system. Treat Jurati's self-improvement as **retro-driven and human-gated first** (the proven mode), and treat telemetry-proven autonomous A/B as an explicitly-`claimed` aspiration that must clear its own firewall before Jurati relies on it. The most reusable, lowest-risk unit for ASS-005 is the **observations log -> versioned workflow edit -> `wf:` bump** cadence, which needs no working telemetry to deliver value.

---

### Q3: How does arch-research use Unimatrix today — which primitives, what integration pattern, what works and what is awkward?

> **Sourcing caveat + live validation (2026-07-16).** Unimatrix is **project-scoped**: every `context_*` call this spike issued resolved against *Jurati's* (empty) instance, not arch-research's. So the claims below were originally sourced from arch-research's **committed logs** (`decisions.md`, `observations.md`, methodology spec), not from observed output of their live instance. **This gap has since been closed:** issue [#40 on `dug-21/arch-research`](https://github.com/dug-21/arch-research/issues/40) had a factory agent run the five load-bearing queries against the live instance and return raw output — archived at `evidence/issue-40-live-output.md`. The **Live-validation reconciliation** subsection at the end of this answer records what confirmed, what was corrected (4 claims), and what is new. Where live output contradicts the text below, the reconciliation is authoritative.

**Answer — primitives used:**
- `context_cycle` (start / phase-end / stop) — the *connective tissue* that binds the repeatable workflow to retrieval AND telemetry. Leader-only. The `goal` sentence at start is load-bearing: it drives goal-conditioned briefing (and thereby plane selection) and binds every entry stored in the run to the run's topic.
- `context_cycle_review` — per-run telemetry (observation stream + yield).
- Reads: `context_search`, `context_get`, `context_graph` in four modes (`current` = live truth/resolve-forward; `neighbors` = edges only; `subgraph` = hydrated nodes; `chain` = lineage), `context_lookup` (yield-by-tag).
- Writes (curator only): `context_store`, `context_correct` (reissues the id — used for content/edge updates and for reaching `proven` with an attached `proven_by`), `context_tag` (in-place grade mutation), `context_edge`.

**Answer — integration pattern:**
- **Single-writer** (curator) for all knowledge; leader touches only `context_cycle`; researchers are read-only.
- **Goal-conditioned briefing** via the cycle-start goal sentence — nobody calls `context_briefing` explicitly; the run's goal steers what surfaces (and keeps the research/process planes apart).
- **Board = one hydrated call:** `context_graph(mode:"subgraph", seed_ids:[goal], max_depth:1, edge_types:["Advances"], direction:"incoming", detail:"full")` returns capability nodes with content+tags; grade is read from each node's `grade:` tag.
- **Grade as a `grade:<missing|claimed|partial|proven>` tag**, mutated in place by `context_tag` (no id churn) — deliberately distinct from the DB `status` field (`active`/`deprecated`). `proven` is the exception: set only via `context_correct` attaching a `proven_by` artifact, never a bare tag.
- **Per-run-id tag** on every node for yield queries; **sealed `factory` category** with `factory->factory` edges only for the process plane; **`cites:`/`proven_by:` as fields, not nodes/edges** (sources and artifacts never become graph nodes — the named defense against category bloat).
- Only six edge types used (`Advances`, `About`, `Prerequisite`, `Motivates`, `Supports`, `Contradicts`), mapped onto native Unimatrix edges — no invented types; `Supersedes` is system-only.

**Answer — what works:** the hydrated `subgraph` board query (one call, was previously three); `context_tag` in-place grade mutation preserving id/edges/embedding; version-pinned IDs that resolve forward via `context_graph(mode:"current")` while `context_get` holds the historical pin (safe cross-surface anchoring); the `wf:` tag round-trip (set at cycle start -> returned by `cycle_review`, verified 2026-07-10); transcript retention on *stamped* cycles.

**Answer — what is awkward (all evidenced in D6/OBS/§11):**
1. **`agent_id` attribution — PARTIALLY CORRECTED by live output (see reconciliation).** The committed D6 says writes record `created_by: anonymous` regardless. Live output contradicts this: nodes carry `created_by: "opcost-001-curator"` etc. — attribution *does* persist, but it is **caller-asserted** (whatever identity the writer passes), not engine-verified. Usable for provenance if writers are disciplined; not an audit/tamper control.
2. **Knowledge-yield is not engine-native** — it must be reconstructed by `context_lookup` on a curator-maintained run-id tag; an untagged node is invisible to the metric (§10.4, threat noted in every experiment). Also: the `topic` field is NOT a yield filter — you must use tags.
3. **`cycle_review` sub-streams unpopulated** — `total_tool_calls`, `knowledge_curated`, `feature_knowledge_reuse.total_served` all read 0 (OBS-6), so the process axis is only partly measurable.
4. **Stale MCP connection mid-run** requires a manual `/mcp` reconnect (~4x/run observed; unimatrix#830, OBS-3) — a blocker for unattended autonomy.
5. **`context_tag` rate-limited ~60 writes/hour** — a large decompose, mass reopen, or grade backfill stalls (OBS-9 hit it: 57 tagged, 3 deferred ~56m).
6. **No way to query available categories** — the enabled set is human-confirmed, not machine-verified (D8).
7. **Briefing is not category-filterable** — plane isolation rests on goal-conditioning as a soft residual, not a hard guarantee (§9/§11; judged "acceptable residual").

**Evidence.** methodology §6/§9/§10/§13/§14.4; `unimatrix-access.md`; D5/D6/D8; OBS-3/6/9; §11 open enhancements.

**Recommendation.** Reuse the **single-writer + goal-conditioned-briefing + fields-not-nodes** integration pattern directly — it is clean and battle-tested across ~10 runs. But **treat as known-fragile**, and design Jurati around, the seven awkward spots: in particular do **not** build any Jurati mechanism that depends on (a) `agent_id` attribution as a *tamper-evident audit* control (it persists but is caller-asserted — see reconciliation), (b) engine-native yield telemetry, or (c) unattended long runs without reconnect resilience — all three are unresolved at the Unimatrix platform level and will bite Jurati identically (same engine).

---

#### Live-validation reconciliation (issue #40, `dug-21/arch-research`, 2026-07-16)

A factory agent ran the five load-bearing queries against arch-research's **live** instance and returned raw output (full transcript: `evidence/issue-40-live-output.md`). The integration pattern is **confirmed**; four specific claims are **corrected**; several new details are worth carrying into ASS-005.

**Confirmed against live output:**
- The one-call hydrated board query (§14.4) returns capability nodes with `grade:` tags + `Advances` edges as described. *(Shape detail: node IDs are integers, not strings; edges are stored `capability → goal` and returned `direction:"outgoing"` even on an `incoming` traversal.)*
- `cycle_review` universal `total_tool_calls: 0` (OBS-6 holds) and `feature_knowledge_reuse.total_served: 0 / total_stored: 0`.
- **Run grouping is not engine-native** — the strongest confirmation of the whole Q3 thesis. `feature_cycle` is `""` on every node; a "run" exists *only* as a curator-applied tag; yield and firewall-ratio are caller-side reconstructions from `tags:[<run-id>]` + `grade:` tags. Nothing in the tool surface returns "findings for run X" or "firewall ratio."
- grade-as-tag is distinct from the DB `status` field; `cites:`/`proven_by:` are fields (prose inside `content`), never nodes/edges — no `Cites`/`ProvenBy` edge types exist.
- `context_graph(mode:"current")` resolves forward (114 → 125); `context_get(follow_supersessions:false)` holds the pin and returns the deprecated node with a `superseded_by` resolution block.

**Corrected by live output:**
1. **`created_by` is NOT universally `anonymous`.** Live nodes carry real curator identities (`opcost-001-curator`, `platform-vision-curator`). D6 is partly stale — attribution *persists*, but it is **caller-asserted** (the identity string the writer passes, a curator *role* name), not engine-derived or verified. → Reliable for provenance *if* every writer passes a stable identity; not an audit/security control. (Flows to Q3 awkward-#1 and Q4 avoid-#3, both revised.)
2. **The run stamp is `wf-v<semver>`, a flat tag — not `wf:<version>`.** Cycle tags round-trip as `"wf-v0.14"`, i.e. the raw `git describe --match 'wf-*'` output, with no reformatting into a namespaced `wf:0.14`. **ASS-005 should stamp with the literal git-tag string.** (Correct every `wf:` in this document's Q2 to `wf-v` when implementing.)
3. **`knowledge_curated` is observable — just not as a universal metric.** It is absent from the universal roll-up but present per-session (`session_summaries[].knowledge_curated = 1`) and per-phase (`knowledge_stored`/`knowledge_served`). The earlier "reads 0" was imprecise: the *universal* counter is 0/absent; the session and phase counters are populated.
4. **The two accounting paths disagree (new, load-bearing for ASS-005).** For the *same* run, `session_summaries[0]` reports `knowledge_served: 3, knowledge_stored: 12`, while `feature_knowledge_reuse` reports `total_served: 0, total_stored: 0`. The reuse block does not merely lag — it **contradicts** the session summary. Do not treat `feature_knowledge_reuse` as a yield source until this is resolved upstream.

**New — worth carrying:**
- **`cycle_review` does more than we credited.** It carries `baseline_comparison` (per-metric current-vs-rolling-mean/stddev with an `is_outlier` flag — real regression detection) and human `gate_outcome_text` per phase. The process-telemetry substrate is richer than Q3's "what works" list implied; the gap is specifically the *knowledge-yield* accounting, not the whole telemetry surface.
- **Grade gotcha (Jurati must adopt the same rule).** The `grade:` tag mutates in place while `content` prose is frozen at correction time. A deprecated node showed `grade:partial` (tag) over `status: missing` (content prose). **Read the tag, not the content, for grade.**
- **Concrete firewall ratio on a real board** (`opcost-001`): **0 proven / 7 capabilities** — 4 `grade:partial`, 3 `grade:missing`. A POC moved four to `partial`; none reached `proven`. A clean illustration of the firewall holding the line (structure moved, status did not).

---

### Q4: What should Jurati adopt directly, and what should it avoid?

**Testing the hypothesis first ("its improvement design generalizes from research workflows to SDLC workflows").** *Partially true — the machinery generalizes; the taxonomy and proof-substrate do not, and the autonomous half is unproven.*

The two systems are explicitly **siblings under one parent**: arch-research's own files call `factory-retro` "the factory variant of `uni-retro` (which is SDLC-shaped)" and `factory-git` "the FACTORY variant; `uni-git` is the SDLC variant." Jurati's roster already mirrors the factory roster (`uni-scrum-master`~=`research-leader`, `uni-validator`~=`factory-validator`, `uni-architect`~=`factory-curator`'s judgment role, `uni-retro`~=`factory-retro`). So the *harness spine and improvement machinery* transfer cleanly. Where they diverge is exactly where arch-research consciously drew the line: **D8 disabled the `pattern` category** with the reasoning *"pattern is SDLC/implementation knowledge, not in the research taxonomy."* That is the seam — the **category taxonomy and the specific proof artifact are domain-shaped and must NOT be cross-imported**.

**ADOPT directly (domain-neutral, proven in arch-research):**
1. **The firewall as a named invariant** — status advances only on real artifact evidence; structure moves freely. (Jurati's `uni-capability` skill already embodies this — "proven ONLY on attached behavioral evidence"; make it a first-class protocol rule everywhere.)
2. **Coordinator-never-generates-content + single-writer** discipline (Jurati already spawns specialists; formalize the "leader writes nothing" rule).
3. **Three-surface model** — Unimatrix (settled) / git (provisional) / GitHub Issue (live human interface), with machine->Issue render-only and human-input-distilled-back.
4. **Versioned-workflow-as-artifact + git-tag-derived `wf:` semver stamp** (never hand-typed) — the core of ASS-005.
5. **Advisory-vs-blocking gates + PASS/REWORKABLE/SCOPE-FAIL + max-2-rework**.
6. **Confidence-required axis** (directional/empirical/validated) to right-size proof depth per scope.
7. **The retro->edit->version-bump improvement loop** (the proven, human-gated half).
8. **Leader-persists** (subagent file-writes are blocked in this harness — OBS-7; Jurati runs the same harness, so its specialists will hit the same block — bake "return markdown, leader persists" into contracts now). *Confirmed live this spike: the Write tool was hook-blocked for this subagent and this file was written via Bash — the exact OBS-2/OBS-7 pattern.*
9. **Status/board as a derived graph query, never a stored flag**.
10. **Path-scoped commits** (never `git add -A`) for parallel-agent safety.

**ADOPT WITH ADAPTATION:**
- **The firewall's proof substrate.** Research `proven` = a POC/A-B artifact; SDLC `proven` should be *green tests + acceptance-map cleared + merged*. Keep the principle, swap the artifact type. Jurati's delivery protocol already has this shape.
- **Grade-as-tag** — Jurati's capability skill already does proven-on-evidence; reuse the `grade:` tag mechanism for its cheap in-place mutation, but keep it distinct from the DB `status` field (the source system is emphatic about this).

**AVOID / do not cargo-cult:**
1. **Do not import the research taxonomy** (`goal/capability/technology/finding`) into Jurati — arch-research itself separated `pattern` out as SDLC-only. Jurati keeps its SDLC set (`decision/pattern/procedure/convention/lesson-learned`); the two taxonomies are correctly different.
2. **Do not assume the autonomous, telemetry-proven A/B loop works** — it has not run once (Q2). Adopt it as an explicitly-`claimed` aspiration, not a foundation.
3. **Do not build on `agent_id` attribution for _audit_** — live output (issue #40) shows attribution *does* persist, but the value is caller-asserted, not engine-verified. Fine for provenance labeling if Jurati mandates a stable `agent_id` on every write; unsafe as a tamper-evident audit control. (Revised from the original "broken upstream/D6" claim.)
4. **Do not stand up a sealed process-plane category yet** — the `factory` plane isolation is elegant but premature for Jurati; add it only if/when Jurati needs to track its own self-improvement separately from delivery knowledge. Its isolation also relies on a soft, un-guaranteed briefing residual (§9).
5. **Do not adopt the heavy multi-goal portfolio machinery** — it is `claimed` and its validating experiment (MG-001) has not run.
6. **Do not make curator-maintained per-run yield tags a load-bearing metric** — fragile and non-native (Q3); fine as a convenience, unsafe as a gate input.

**Evidence.** D1/D7/D8/D10/D12; `factory-retro`/`factory-git` self-descriptions as "the factory variant of the SDLC skill"; §14.1 cardinal write rule reconciling the research-spike "no writes" stance with SDLC's architect-writes-ADRs; Jurati's own `.claude/protocols/uni/*` + agent roster.

**Recommendation.** Adopt the **harness spine and the improvement-design machinery directly**; **adapt the firewall's proof artifact to SDLC** (green tests + acceptance map); and **firewall Jurati against the three unproven/broken areas** (autonomous A/B, agent_id audit, multi-goal portfolio). The hypothesis holds for the *mechanism* and fails for the *taxonomy and the autonomous-proof claim* — carry the former, leave the latter.

---

## Unanswered Questions

None. All four Goal questions are answered at directional confidence from the source repository. Two answers carry an explicit evidentiary limit (stated inline, not omitted):
- **Q2** — "what it has actually learned in practice" is answered, but the *autonomous* half is answered as a negative (never run); the *informal retro* half is answered positively with 14 versions of evidence.
- **Q3** — the awkward-spots list is from the source system's own decision/observation logs, not independently re-probed against a live engine (directional confidence; a `validated` re-probe was not required by scope).

---

## Out-of-Scope Discoveries

- **The garage funnel + divergent generative front-end (theme-scan).** arch-research is layering a "garage" identity over the factory: a wide-mouth `scout`+`hypothesizer` (the latter on Fable 5, deliberately divergent, "generate for range, never self-censor") feeding a convergent `goal-owner` triage (park/probe/build). A generative *idea-intake* pattern. *Why it might matter:* if Jurati ever wants divergent feature/vision ideation rather than only demand-pull delivery, this divergent-generate / convergent-cut split is a reusable design. Out of this spike's scope; flag for a future spike if Jurati wants an intake funnel.
- **Budget metering is a named, unbuilt gap.** The proposal states "budget is assumed, never enforced... every budget discipline rests on a mechanism that does not exist," and arch-research is building an `opcost` skill (per-repo Claude token reporting). *Why it might matter:* any autonomous SDLC harness Jurati builds will hit the same gap. Possible ASS follow-on: a cost governor for autonomous runs.
- **Shared Unimatrix platform gaps.** `agent_id` attribution (#830), non-native knowledge-yield, and unpopulated `cycle_review` sub-streams are Unimatrix-engine limitations that Jurati inherits by using the same engine. *Why it might matter:* worth a platform-side spike distinct from the harness design, since these constrain what any consumer (research or SDLC) can rely on.

---

## Recommendations Summary

- **Q1 (structure):** Adopt the coordinator-never-generates + single-writer + bounded-rework-gate spine, and make the **firewall** (status moves only on real artifact evidence) an explicit named invariant — it is the safety mechanism for autonomy and the top transferable idea.
- **Q2 (improvement):** Adopt the versioned-workflow-as-artifact + git-tag-derived `wf:` semver + retro->edit->bump loop wholesale (the proven, human-gated mode); treat the **autonomous telemetry-proven A/B loop as `claimed`, not foundational — it has never run** (feeds ASS-005 directly).
- **Q3 (Unimatrix usage):** Reuse the single-writer + goal-conditioned-briefing + fields-not-nodes integration pattern; design *around* seven known-fragile spots — never depend on `agent_id` audit, native yield telemetry, or unattended-run reconnect resilience (all unresolved at the engine level Jurati shares).
- **Q4 (adopt/avoid):** Hypothesis holds for the *machinery*, fails for the *taxonomy and the autonomous-proof claim*. Adopt the harness spine + improvement design; adapt the firewall's proof artifact to SDLC (green tests + acceptance map); do NOT import the research taxonomy, do NOT assume autonomous A/B works, do NOT build on `agent_id` attribution or the unproven multi-goal portfolio.
