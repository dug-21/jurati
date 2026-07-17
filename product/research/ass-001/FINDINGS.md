# FINDINGS: Unimatrix as Substrate

**Spike**: ass-001
**Date**: 2026-07-16
**Approach**: investigation + evaluation
**Confidence**: directional

---

## What was examined (evidence base)

- **Live MCP surface**: exercised the read-only tools against the running server — `context_status`,
  `context_briefing`, plus loaded (not called) the full schema of every `context_*` tool including the
  write family. The tool JSONSchemas are richly self-documenting (supersession semantics, edge modes,
  graph traversal modes, capability gating) and are the primary evidence for the contract below.
- **The backing binary**: `@dug-21/unimatrix` v0.11.3 npm package. The MCP server is a **native Rust
  binary** shipped as a platform optionalDependency (`@dug-21/unimatrix-linux-x64/bin/unimatrix`,
  ~33 MB, bundles `libonnxruntime` for local embeddings). Rust source is NOT in the package — only the
  compiled binary. Recovered tool names, relation types, categories, and event types via `strings`.
- **The JS edge (`lib/hook-client/`)**: the telemetry client that feeds the observation pipeline —
  `cycles.js`, `cycle-decoration.js`, `cycle-validation.js`, `topic-signal.js`, `delta.js`,
  `build-request*.js`, `index.js`, `normalize.js`. This is where the "workflow" and self-improvement
  substrate is actually wired.
- **Shipped skills + protocols**: `skills/uni-*`, `protocols/uni-agent-routing.md`, and `lib/init.js`
  (the binding mechanism).
- **Live KB state**: 0 knowledge entries, but **163 observation records across 7 sessions, 0
  retrospected features, 0 extracted, 0 rejected** — confirming SCOPE's note that the measurement loop
  exists and is running but has produced nothing yet.

---

## Findings

### Q1: What does Unimatrix expose that a harness can build on — the full MCP tool surface, the knowledge/graph/semantic model, and the "workflow" concept? What are the stable integration seams?

**Answer**: Unimatrix exposes a stable, versioned MCP contract with **15 `context_*` tools**, a typed
knowledge graph with semantic + deterministic retrieval, and a first-class **cycle** primitive that IS
the "workflow" concept. A harness binds through four seams: (1) the MCP tool contract, (2) the
`.mcp.json` server entry, (3) a 9-event Claude Code hook set in `.claude/settings.json`, and (4) the
knowledge/observation data model.

**Evidence**:

*The 15-tool MCP surface* (confirmed from the loaded schemas / live registry):

| Tool | Capability | Role |
|------|-----------|------|
| `context_briefing` | read | Ranked orientation index for a task (semantic + goal-cluster + co-access). |
| `context_search` | search | NL semantic search, category/topic/tag filters, `k`. |
| `context_lookup` | read | Deterministic filter by topic/category/tags/status/id. |
| `context_get` | read | Fetch by id; resolves supersessions + surfaces depth-1 typed edges by default. |
| `context_status` | read | KB health: counts, distributions, coherence (lambda), observation pipeline, effectiveness. |
| `context_graph` | read | 7-mode traversal: chain / current / neighbors / subgraph / inverse / filter / path. |
| `context_store` | write | New entry (content, topic, category, tags, edges, source, feature_cycle). |
| `context_correct` | write | Supersede-in-place: deprecates original + creates linked replacement. |
| `context_deprecate` | write | Soft-remove from default retrieval. |
| `context_quarantine` | admin | Exclude from search/lookup but keep `context_get`-able. |
| `context_tag` | write | In-place single-tag add/remove/replace; preserves hash/edges/embedding. |
| `context_edge` | write | Standalone typed-edge add/remove/redirect. |
| `context_enroll` | admin | Enroll/adjust an agent's trust level + capabilities. |
| `context_cycle` | write | Declare a work cycle (start / phase-end / stop) with goal + tags. |
| `context_cycle_review` | read | Retrospective analysis over a cycle's observations (hotspots, baselines, transcript). |

*The knowledge model*: entries carry `category`, `topic`, `title`, `content`, `tags`, `source`,
`confidence`, `status` (Active / Deprecated / Proposed / Quarantined), and typed edges. Categories
recovered from the binary: **decision, pattern, procedure, convention, lesson-learned, capability,
goal, outcome, research**. Relation (edge) types recovered: **Supersedes, Supports, Contradicts,
Informs, Prerequisite, Advances, Motivates, About**. Edges have retrieval semantics — the `uni-capability`
skill documents that `Supports`/`Prerequisite`/`Informs` are **PPR-positive** (they pull the neighbor
into agent retrieval via personalized-PageRank expansion), while `Motivates`/`Advances`/`About` are
**PPR-neutral** (navigable via `context_graph` but inert in retrieval). This is a load-bearing design
lever, not decoration.

*Retrieval is dual-mode*: semantic (`context_search`, `context_briefing` — embeddings via bundled ONNX
runtime, so no external API dependency) AND deterministic (`context_lookup` by exact filters,
`context_graph` by traversal). Supersession is a first-class chain (`context_get` resolves a deprecated
id to its terminal active version by default; `context_graph mode=chain/current` walks it).

*The "workflow" concept = the cycle*. `context_cycle` declares a bounded work unit — `topic` (opaque
id, "software feature, incident, campaign, clinical trial, or any work unit a domain tracks from start
to completion"), an optional `goal` sentence (improves briefing for that cycle), a `phase` progression
(`start` -> `phase-end`(phase, next_phase, outcome) -> `stop`), and opaque run-identity `tags`. The edge
client (`cycles.js`) persists a per-session tracker `{topic, phase, declared_at, updated}` keyed by
root session id, and `cycle-decoration.js` **stamps that cycle onto every telemetry event**. So a cycle
is both a declaration and an attribution key that binds all downstream observations to a unit of work.

*The binding mechanism* (`lib/init.js`): `unimatrix init` (a) writes/merges a `.mcp.json` server entry
(either the Rust binary over stdio, or a token-free `node mcp-bridge <projectHash>` entry for remote
that resolves credentials from an out-of-tree store); (b) merges a **9-event hook set** into
`.claude/settings.json` (`PreToolUse, PostToolUse, SubagentStart, SubagentStop, UserPromptSubmit,
SessionStart, Stop, PreCompact, SessionEnd`), each as `node <clientPath> <EVENT>`, idempotent and
preserving foreign hooks; (c) installs skills; (d) appends a CLAUDE.md knowledge block. This exact
wiring is already present in the Jurati repo's CLAUDE.md "Unimatrix" section.

**Recommendation**: **Bind Jurati to the MCP tool contract and the cycle primitive as the two stable
seams; do NOT bind to the Rust internals or the hook-client wire format.** Treat the 15 `context_*`
tools + the entry/edge/category data model + the cycle lifecycle as the substrate contract (fully
enumerated in the "Substrate Contract" output below). Jurati's coordinators should call `context_cycle`
at session start with a real goal sentence and drive `phase-end` transitions at protocol phase
boundaries — this is the single most valuable seam because it retroactively structures every
observation the hook layer already collects for free.

---

### Q2: How can Unimatrix's graph + semantic search + categorization structure harness *operations* — routing, run state, artifact lineage, gate decisions — not just store knowledge after the fact?

**Answer**: Partially, and unevenly. Categorization + graph + search are strong for **memory,
orientation, and lineage-by-topic**, usable **today**. But for **live run-state and gate decisions**
the engine offers primitives that must be *composed by the harness* — Unimatrix has no notion of "this
run is at gate 3b, blocked." The cycle/phase tracker is the closest thing to run-state, and it is
**telemetry-grade (best-effort, fail-open), not a transactional state machine** the harness can
authoritatively read back.

**Evidence**:

- **Routing / orientation — strong, today.** `context_briefing(task=...)` returns a ranked, PPR-aware
  entry set; the existing protocols already route agents to `/uni-query-patterns` and
  `/uni-knowledge-search` before design/implementation. Categorization (`decision/pattern/procedure/
  convention/lesson-learned`) plus tag filters give deterministic "give me every ADR in this domain"
  routing via `context_lookup`. This directly structures *what an agent knows before it acts*.
- **Artifact lineage — strong-by-topic, today.** Every entry carries `topic`/`feature_cycle`, and
  `context_cycle` attributes all observations to that cycle. The typed graph gives real lineage:
  `Advances` (capability->goal), `Prerequisite` (DAG between capabilities), `Supersedes` (correction
  chains), `Motivates` (research->capability). The `uni-capability` skill already models a goal->capability
  ->feature decomposition as a graph with delivery-status tags — a working template for "what is left to
  build" as a *query*, not a document. Jurati can lay its own artifact lineage (SCOPE->SPEC->BRIEF->PR) onto
  the same edge model.
- **Gate decisions — the graph can *record* them, cannot *make* them.** Nothing in the tool surface
  evaluates a gate. A gate PASS/FAIL is produced by `uni-validator` (an agent) and can be *stored* as an
  `outcome`/`lesson-learned` entry and linked with edges, but there is no server-side predicate,
  trigger, or blocking primitive. `context_status` reports a **coherence** signal (lambda, graph quality,
  contradiction density — all 1.0 on the empty KB) that could *inform* a KB-health gate, but it is a
  corpus metric, not a per-run verdict.
- **Run-state — telemetry-grade only.** The cycle tracker (`cycles.js`) is explicitly *best-effort,
  never-throws, fail-open* (`C-04`): "Failures degrade to the never-throw sentinel so the spawn always
  exits 0." Cycle stamps ride the hook path, which drains per-turn and can drop under server-state-loss
  events. `context_cycle`'s MCP handler even documents that it does NOT read back the `goal`/`tags` it
  accepts — persistence happens on the hook path, not the tool-call path. So a harness cannot treat
  `context_cycle` as a durable, immediately-readable state write.

**Recommendation**: **Use Unimatrix as the memory + lineage + orientation substrate now; keep
authoritative run-state and gate control in Jurati's own layer (GH Issues + files, as the protocols
already do), and mirror them INTO Unimatrix as `outcome`/edge records for lineage and learning.**
Concretely: (1) drive `context_cycle` phases at every protocol phase boundary for attribution, but
never read the cycle back as the source of truth for "where is this run"; (2) model artifact lineage
with typed edges (SCOPE `Prerequisite->` SPEC `Prerequisite->` BRIEF; gate outcomes `Supports/Contradicts`
the entries they judged); (3) store each gate verdict as an `outcome` entry so retrospection can learn
from gate history. Do NOT try to make Unimatrix the run orchestrator — that is a Jurati concern and a
co-evolution item (see Q4 / wishlist).

**Optimization opportunity — cycle tags as a workflow-version stamp** *(surfaced by domain owner,
2026-07-16).* `context_cycle(start)` accepts opaque `tags`, which can carry the **protocol/workflow
version** that executed the cycle (e.g. `design-protocol@v2`). Today Jurati's execution + tracking is
split across **Git + files + Unimatrix**; stamping the workflow version onto each cycle is a concrete
seam to consolidate that. The payoff is not just tracking — a version-stamped cycle makes retrospection
*version-aware*: cross-cycle analysis (gap #7) can then ask "did design-protocol v2 reduce gate failures
vs v1?", turning the workflow itself into a measurable, improvable object. This is the most direct bridge
between the cycle primitive (Q1) and the self-improvement loop (Q3), and a candidate optimization to
reduce Jurati's reliance on Git/files for run bookkeeping. Worth validating in a downstream design
session before committing the convention.

---

### Q3: What do Unimatrix's observation / effectiveness / extraction / retrospection mechanisms actually measure today, and could they be the feedback substrate for a self-improving harness (feeds ASS-005)?

**Answer**: They measure a real, running pipeline: **observations** (hook-captured tool/agent/session
events, cycle-stamped), **extraction** (a background tick that auto-mines candidate knowledge entries
from observations), **effectiveness** (did injected knowledge correlate with session success, with a
confidence-calibration curve), and **retrospection** (`context_cycle_review` -> hotspots + baselines
over a cycle). This is a **genuine, sufficient feedback substrate for a self-improving harness** — but
it is currently *inert* (163 observations, 0 retrospected, 0 extracted), so the loop is validated as
*present* but not yet as *effective*.

**Evidence** (from live `context_status` + `uni-retro` skill + edge client):

- **Observation pipeline**: 163 records, 7 sessions, oldest 1 day. Populated by the hook client:
  `PostToolUse`/`PreToolUse`/`SubagentStart`/`UserPromptSubmit`/`SessionStart`/`Stop`/`PreCompact`
  events, plus `transcript_delta` frames (`delta.js` ships unshipped transcript spans, end-anchored,
  zero transcript bytes at rest). Every frame is cycle-stamped and topic-attributed (`topic-signal.js`
  extracts feature ids from `product/features/{id}/...` paths, `feature/{id}` git checkouts, and
  word-boundary id tokens). This is the raw signal.
- **Extraction**: the background tick (`context_status` -> "Background Tick": last maintenance, next
  scheduled ~15 min cadence; "Entries extracted: 0 / rejected: 0") auto-mines candidate entries from
  observations. It is running but has extracted nothing yet.
- **Effectiveness**: `context_status` reports an **effectiveness taxonomy** — Effective / Settled /
  Unmatched / Ineffective / Noisy — *per knowledge source*, with a **Utility** column, AND a
  **confidence-calibration table** (Injections vs Actual Success vs Expected, bucketed 0.0-1.0). This is
  exactly a self-improvement measurement store: it asks "when we injected knowledge at confidence X, did
  the session actually succeed?" All zeros today because no knowledge exists to inject.
- **Retrospection**: `context_cycle_review(feature_cycle, transcript:{})` returns hotspots
  (`orphaned_calls, sleep_workarounds, cold_restart, coordinator_respawns, post_completion_work,
  lifespan, mutation_spread, file_breadth, reread_rate`), baseline outliers, narratives, and
  recommendations — an agent-owned synthesis over honest telemetry planes (the tool does the retrieval,
  the agent does the causal joins). `uni-retro` already consumes this to extract patterns/procedures/
  lessons back into the KB, closing the loop.
- **Coherence metrics**: lambda, graph quality, embedding consistency, contradiction density (all 1.0 on the
  empty KB) — a corpus-health signal the harness could watch over time.

Together these ARE the measurement loop SCOPE hypothesized: observe -> extract/retrospect -> store ->
inject -> measure effectiveness -> recalibrate confidence. The machinery is complete end-to-end.

**Recommendation (directional, feeds ASS-005)**: **The SCOPE hypothesis holds — self-improvement can
ride Unimatrix's existing effectiveness/observation machinery rather than standing up a separate
measurement store.** But three caveats must anchor ASS-005: (1) the loop is *unexercised* (0
retrospected) — ASS-005 must treat "does effectiveness scoring actually discriminate good from bad
knowledge at Jurati's scale" as an open empirical question, not a given; (2) attribution depends on
Jurati emitting clean cycle topics + `product/features/{id}/` paths — the harness's own conventions are
load-bearing for the feedback signal; (3) the hotspot vocabulary is agent-workflow-centric (orphaned
calls, respawns, sleep workarounds) — it measures *harness execution health* directly, which is a gift
for a self-improving harness, but the taxonomy is fixed by the engine, so new Jurati-specific signals
are a co-evolution item.

---

### Q4: What does Unimatrix NOT provide that Jurati would need — the gap list / co-evolution seam?

**Answer**: Unimatrix is a strong **knowledge + observation + retrospection engine** but a deliberately
thin **orchestration and governance** engine. The gaps cluster into: run/gate state, category-scoped
authorization (identity itself being a Jurati responsibility, not an engine gap — see #2), active (push)
retrieval, extensible measurement vocabulary, and lineage for non-entry artifacts. None contradict the
"companion not fork" constraint — all are additive.

**Evidence + gap list** (detail in the "Gap/Wishlist" output below):

1. **No authoritative run-state / gate state machine.** Cycle tracking is fail-open telemetry, not a
   durable, readable-back run record with gate transitions and blocking. (Q2 evidence.)
2. **Missing piece is agent *identity*, not privilege enforcement — and identity is a Jurati
   responsibility.** *(Corrected per domain owner, 2026-07-16.)* `context_enroll` defines trust levels
   (system/privileged/internal/restricted) and capabilities, and Unimatrix **CAN enforce Read vs Write
   vs Admin**. The reason it does not today is that a context engine has no trustworthy way to
   *identify* an agent: identity was LLM-driven, where a self-declared `agent_id` is not meaningful — so
   `agent_id` is documented **AUDIT-ONLY, never authorization** (`SD-9`). The enforcement *principle* is
   present; it is starved of trustworthy identity. **If Jurati solves agent/sub-agent identity outside
   the LLM context** (a real, attestable identity per sub-agent/connection), Unimatrix's existing
   read/write/admin enforcement activates with **no engine change** for coarse enforcement. The genuine
   *Unimatrix* limitation is finer-grained: **it cannot segment those privileges by data category** —
   e.g., "read-only on `decision`, writable on `outcome`." Per-category privilege segmentation is the
   real engine gap; per-agent identity is Jurati's to solve.
3. **Pull-only retrieval; no push/subscription.** Everything is agent-initiated (`briefing`/`search`).
   There is no "notify the coordinator when a contradicting ADR is stored" or "inject this at gate 3b"
   trigger. A self-improving harness will want event-driven knowledge delivery.
4. **Fixed measurement vocabulary.** Categories, edge types, and hotspot types are engine-defined. The
   `uni-capability` skill already works *around* this by encoding domain status in **opaque tags**
   rather than schema fields — evidence the team already treats extension-via-tags as the pattern. But
   genuinely new signals (e.g., a Jurati-specific gate-failure taxonomy, dual-track research metrics)
   need engine support or a documented convention.
5. **Lineage only covers Unimatrix entries.** Edges can only target entries; `delivered_by`/`proven_by`
   are plain string fields because "GH features, test artifacts are not Unimatrix entries." Jurati's
   real artifacts (SCOPE.md, FINDINGS.md, PRs, GH Issues) can only be referenced as opaque strings, not
   traversed. First-class external-artifact nodes/refs would make lineage queryable end-to-end.
6. **No native multi-track / campaign structure.** The cycle is single-topic/single-phase-chain. Jurati
   runs dual-track research (internal + external) and multi-spike campaigns; there is no built-in "these
   two cycles are two tracks of one question, synthesize them" relation. (Achievable today via topics +
   `Advances`/`Prerequisite` edges, but by convention, not by primitive.)
7. **Retrospection is per-cycle, not cross-cycle/portfolio.** `context_cycle_review` analyzes one
   feature cycle. A self-improving harness wants trend analysis across many cycles (is our design phase
   getting faster? are gate failures declining?). `context_status` gives corpus-level aggregates but not
   longitudinal per-phase harness metrics.

**Recommendation**: **Adopt the co-evolution hypothesis, but prioritize the backlog by leverage, not by
ease — and note that the highest-leverage security item is Jurati's to solve, not Unimatrix's.** The
sequence: (a) **Jurati solves attestable agent/sub-agent identity outside the LLM context** (#2 —
security-critical the moment Jurati runs read-only or untrusted sub-agents against a shared server; this
*unlocks* Unimatrix's already-present read/write/admin enforcement with no engine change); then, into
Unimatrix, (b) **category-scoped privilege segmentation** (#2b — the real engine gap once identity
exists); (c) **a durable, readable-back run/gate state seam** (#1 — the single biggest structural gap
between "memory engine" and "orchestration substrate"); (d) **cross-cycle/portfolio retrospection** (#7
— the payoff seam for ASS-005). Handle #4 and #6 by **convention over engine change first** (opaque tags
+ typed edges, exactly as `uni-capability` already does) and only escalate to engine features when the
convention demonstrably strains. Defer #3 (push retrieval) and #5 (external-artifact nodes) until a
concrete Jurati workflow demands them. Keep Jurati a companion: run-state and gate control live in
Jurati until/unless a proven pattern earns promotion into the engine.

---

## TARGET OUTPUT 1 — Substrate Contract (stable seams a harness can depend on)

**Tier A — Depend on directly (stable, versioned MCP contract):**

- **The 15 `context_*` MCP tools** and their JSONSchemas (enumerated in Q1). Treat schema evolution as
  additive/backward-compatible — the schemas themselves document this discipline (e.g. `context_get`
  `include_edges`/`follow_supersessions` default-on for old callers; `context_cycle` `goal`/`tags` are
  omit-safe for old callers).
- **The knowledge entry model**: `{category, topic, title, content, tags, source, confidence, status,
  edges}`. Categories: decision, pattern, procedure, convention, lesson-learned, capability, goal,
  outcome, research. Status: Active / Deprecated / Proposed / Quarantined.
- **The typed edge model**: Supersedes, Supports, Contradicts, Informs, Prerequisite, Advances,
  Motivates, About — with the PPR-positive vs PPR-neutral retrieval distinction.
- **Retrieval seams**: semantic (`briefing`, `search`, ONNX-local — no external embedding API),
  deterministic (`lookup`, `graph` 7 modes), supersession-resolving `get`.
- **The correction discipline**: `context_correct` (supersede-in-place) is the *only* sanctioned update
  path; `context_tag`/`context_edge` are the non-destructive in-place mutators.
- **The cycle lifecycle**: `context_cycle` start/phase-end/stop with goal + phase + opaque tags.

**Tier B — Depend on with care (present but weaker guarantees):**

- **Cycle/phase run-state** — fail-open telemetry, not transactional; write-then-read-back is NOT
  guaranteed on the tool path. Use for attribution, not authoritative state.
- **`context_status` effectiveness/coherence aggregates** — real but corpus-scoped and currently
  unexercised (all zeros / 1.0 on the empty KB).
- **`context_cycle_review` retrospection** — per-cycle, agent-synthesis-owned; the tool returns honest
  planes, not verdicts.

**Tier C — Do NOT depend on (internal / out of contract):**

- The Rust binary internals, the hook-client wire format, the observation frame shapes, the
  `.mcp.json`/`settings.json` merge internals. These are init-managed plumbing; bind above them.

**Binding recipe**: `unimatrix init` -> `.mcp.json` (stdio Rust binary or token-free JS bridge) +
9-event hook set in `.claude/settings.json` + skills + CLAUDE.md block. Jurati is already wired this way.

---

## TARGET OUTPUT 2 — Primitive -> Use Map (Unimatrix capability -> harness concern)

| Harness concern | Unimatrix primitive(s) | Readiness | How Jurati uses it |
|---|---|---|---|
| **Orientation / routing** | `context_briefing`, `context_search`, `context_lookup`, categories, tags | Ready | Agents pull relevant ADRs/patterns/conventions before acting (protocols already do this). |
| **Memory (settled knowledge)** | entry model + categories + `context_store`/`context_correct` | Ready | ADRs, patterns, procedures, lessons — the durable project brain. Supersession keeps it current. |
| **Artifact / decision lineage** | typed edges (`Prerequisite`, `Advances`, `Supersedes`, `Supports`, `Contradicts`, `Motivates`), `topic`/`feature_cycle`, `context_graph` | Ready (entry-scoped) | Model SCOPE->SPEC->BRIEF->gate-outcome as a traversable graph; correction chains for evolving decisions. |
| **Goal decomposition / "what's left"** | `capability` category + `Advances`/`Prerequisite` edges + delivery-status tags (`uni-capability`) | Ready (template exists) | Turn "what to build next" into a graph query; behavioral-proof gating on `done_when`. |
| **Run-state / workflow tracking** | `context_cycle` (start/phase-end/stop), cycle-stamped observations | Partial (telemetry-grade) | Attribution + phase timing for retrospection; NOT authoritative run-state (keep in GH Issues/files). |
| **Gate decisions** | `outcome`/`lesson-learned` entries + edges; `context_status` coherence signal | Record-only | Store verdicts + link to judged entries; the *decision* stays with `uni-validator`/the harness. |
| **Self-improvement — measure** | observation pipeline + effectiveness taxonomy + confidence calibration (`context_status`) | Present, inert | Measures whether injected knowledge correlated with success; recalibrates confidence. Feeds ASS-005. |
| **Self-improvement — learn** | `context_cycle_review` (hotspots/baselines) + `uni-retro` extraction; background-tick extraction | Present, inert | Mine patterns/procedures/lessons from real sessions back into the KB. Closes the loop. |
| **Harness-execution health** | hotspot taxonomy (orphaned_calls, respawns, sleep_workarounds, cold_restart, post_completion_work, mutation_spread, ...) | Present, inert | Directly measures swarm execution quality — a gift for a self-improving *harness* specifically. |
| **Trust / security** | `context_enroll` (trust levels + capabilities: read/write/admin), quarantine, attribution/source | Ready once Jurati supplies identity | Read/Write/Admin enforcement exists; it is starved of trustworthy agent identity (a Jurati responsibility, not an engine gap). Category-scoped privilege segmentation is the one real engine gap (#2). |

---

## TARGET OUTPUT 3 — Unimatrix Gap / Wishlist (co-evolution backlog)

Ordered by leverage (build into Unimatrix, human controls the repo):

| # | Gap | Why Jurati needs it | Suggested seam | Priority |
|---|---|---|---|---|
| 1 | **Attestable agent identity (Jurati-side) → then category-scoped privileges (Unimatrix-side)** | Unimatrix already enforces Read/Write/Admin but has no trustworthy agent identity (LLM `agent_id` is self-declared, audit-only). **Identity is Jurati's to solve outside the LLM context**; once solved, existing enforcement activates. The remaining *engine* gap is segmenting privileges by data category (e.g. read-only on `decision`, write on `outcome`). | (a) Jurati: attestable per-sub-agent identity supplied to the MCP connection. (b) Unimatrix: per-category capability scoping bound to that identity. | **High (security)** |
| 2 | **Durable, readable-back run/gate state** | The gap between "memory engine" and "orchestration substrate." Cycle tracking is fail-open telemetry. | A transactional run/phase/gate record with read-back + optional blocking, distinct from the telemetry cycle. | **High** |
| 3 | **Cross-cycle / portfolio retrospection** | `cycle_review` is per-cycle; a self-improving harness needs longitudinal trends (phase velocity, gate-failure decline). | Aggregate retrospection across cycles/topics; per-phase harness baselines over time. | **High (ASS-005)** |
| 4 | **Extensible measurement/status vocabulary** | Categories, edge types, hotspot types are engine-fixed; Jurati has its own signals (dual-track, gate taxonomy). | First: convention via opaque tags (as `uni-capability` already does). Escalate to engine only on strain. | Medium |
| 5 | **Multi-track / campaign primitive** | Dual-track research + multi-spike campaigns have no native "these are tracks/spikes of one question." | Convention via topics + `Advances`/`Prerequisite` edges now; a campaign relation later if it strains. | Medium |
| 6 | **First-class external-artifact refs** | Edges only target entries; PRs/Issues/SCOPE.md are opaque strings, not traversable. | External-artifact node/ref type so lineage is end-to-end queryable. | Low |
| 7 | **Push / event-driven retrieval** | Retrieval is pull-only; no "notify on contradicting ADR" or "inject at gate 3b." | Subscription/trigger seam on store/correct events. | Low (defer) |

**Governing principle**: prefer *convention over engine change* (opaque tags + typed edges) until a
pattern proves it strains, then promote it into the engine — matching how `uni-capability` already
extends the domain-agnostic core without new schema fields.

---

## Hypothesis verdicts (SCOPE asked these be challenged)

- **"Unimatrix is extensible on demand (co-evolution over routing-around)"** — **SUPPORTED, with a
  refinement.** The engine is deliberately domain-agnostic and the team already extends it *by
  convention* (opaque tags, typed edges) rather than by schema change (`uni-capability` is the proof).
  So the right default is "extend by convention first, build into the engine second, route around never."
  Pure engine features (per-agent auth, run-state, cross-cycle retro) are the minority that genuinely
  need Rust changes. The hypothesis holds; it just isn't always "add an engine feature."

- **"Self-improvement can ride existing effectiveness/observation machinery (no separate store)"** —
  **SUPPORTED as designed, UNPROVEN in practice.** The full loop exists end-to-end (observe -> extract ->
  retrospect -> store -> inject -> measure effectiveness -> recalibrate). But it is inert (163 obs, 0
  retrospected, 0 extracted). The substrate is sufficient; whether its scoring *discriminates* at
  Jurati's scale is the empirical question ASS-005 must answer. No separate measurement store is
  warranted; a separate *validation* of the existing loop is.

---

## Unanswered Questions

- **Does effectiveness scoring actually discriminate good from bad knowledge?** Cannot be answered from
  a cold KB (0 entries, 0 retrospected). Requires running real cycles and observing whether the
  effectiveness taxonomy + calibration curve produce actionable signal. Deferred to **ASS-005** (this
  spike unblocks it, as intended).
- **Exact background-tick extraction criteria** (what promotes an observation to a candidate entry, and
  the rejection rule). The Rust source is not in the npm package; recoverable only by reading the
  `dug-21/unimatrix` GitHub source or by exercising extraction with real data. Directionally
  irrelevant to the binding decision; flag for ASS-005 if extraction quality becomes load-bearing.
- **Concurrency/consistency guarantees of the graph cache** — schemas note `depth>1` graph/subgraph
  reads may lag committed writes by one tick (~30-60s). The precise staleness envelope under a busy
  swarm is unmeasured. Matters only if Jurati depends on multi-hop reads for live decisions (it should
  not, per Q2).

## Out-of-Scope Discoveries

- **Remote/multi-tenant deployment is a first-class mode.** `init.js` supports a token-free `mcp-bridge`
  that resolves credentials from an out-of-tree store keyed by `projectHash`, with cert pinning
  (`cert-pin.js`) and HTTP transport. Implication: a shared/cloud Unimatrix serving many Jurati
  repos is an anticipated topology — relevant to any future "org brain" vision but outside this scope.
- **The hook client is a sophisticated, zero-dependency, fail-open parity port of a Rust oracle** with
  strict size budgets (<500-line files), byte-exact UTF-8 handling, and end-anchored transcript
  elision. Any Jurati contribution to the edge must honor the same fail-open + parity contract (the
  `uni-js-dev` agent already encodes this). Noted as a contribution-quality bar, not pursued.
- **`uni-capability` is a working reference for "manage a domain in the engine without schema changes"**
  (status-as-tag, behavioral-proof gating). This is likely the reusable architectural lesson for how
  Jurati should model ITS domains on Unimatrix — worth promoting to a pattern after a downstream design
  session validates it through use.

---

## Recommendations Summary

- **Q1 (substrate contract)**: Bind Jurati to the 15-tool MCP contract + entry/edge/category model + the
  cycle lifecycle (Tier A). Do not bind to Rust internals or the hook wire format. Drive `context_cycle`
  with real goal sentences at session start and phase boundaries.
- **Q2 (structuring operations)**: Use Unimatrix now for memory, orientation, and topic/edge lineage;
  keep authoritative run-state and gate control in Jurati (GH Issues + files) and mirror verdicts back as
  `outcome` entries + edges. Do not make Unimatrix the orchestrator.
- **Q3 (feedback substrate)**: The observation -> extraction -> effectiveness -> retrospection loop is
  complete and sufficient to be ASS-005's feedback substrate — no separate store needed — but it is
  inert (0 retrospected), so ASS-005 must empirically validate that it discriminates.
- **Q4 (gaps)**: Security-critical item is split — **agent identity is Jurati's to solve outside the LLM
  context** (Unimatrix already enforces Read/Write/Admin; it just lacks trustworthy identity), and once
  solved the real *engine* gap is **category-scoped privilege segmentation**. Then co-evolve Unimatrix in
  leverage order: durable run/gate state, cross-cycle retrospection. Extend by convention (tags/edges)
  first, engine features second, route-around never — keeping Jurati a companion, not a fork.
- **Optimization**: `context_cycle` tags can stamp the executing **workflow version**, consolidating
  today's Git+files+Unimatrix run tracking and making retrospection version-aware (feeds ASS-005).
- **Hypotheses**: Both SUPPORTED — extensibility holds (often via convention, not engine change);
  self-improvement can ride the existing machinery (design-complete, practice-unproven).
