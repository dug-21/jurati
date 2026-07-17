# FINDINGS: Agentic-Harness Landscape

**Spike**: ass-004
**Date**: 2026-07-16
**Approach**: literature + evaluation
**Breadth**: industry (external survey)
**Confidence**: directional

> Scope note: This is a Tier 1 external survey. Findings are directional, not validated —
> no PoC was built, and several ecosystem claims below are vendor/community assertions
> (flagged inline). The three SCOPE Hypothesis constraints were treated as *challengeable*
> and are tested explicitly in the "Hypothesis Verdicts" section. ruvnet/metaharness is
> used as the anchor and extended well beyond.

---

## Orientation: what "harness" means here, and where Jurati sits

The ecosystem has converged on a distinction that maps directly onto Jurati's stated
framing ("deterministic spine + LLM-contributed judgment"):

- **Framework** = a library you use to *build* an agent (LangGraph, CrewAI, AutoGen,
  OpenAI Agents SDK). It ships primitives; you assemble the product.
- **Harness / scaffold** = the control loop, tool definitions, state management, context
  strategy, gates, and memory that *surround* the model and turn it into a working system
  for a specific domain. Recent literature is blunt that "the scaffolding code that
  surrounds the language model ... increasingly determines how the agent behaves, what
  mistakes it makes, and where it spends its token budget" (arXiv 2604.03515, *Inside the
  Scaffold*). The model is increasingly the commodity; the harness is the differentiator.

metaharness states this as a slogan — **"The model is replaceable. The harness is the
product"** and **"Frameworks help developers build agents. metaharness helps repositories
ship agents"** (github.com/ruvnet/metaharness README). Jurati is on the harness side of
this line, not the framework side. That single fact drives most of the recommendations
below.

**The metaharness anchor maps almost 1:1 onto Jurati's existing pieces** — this is why the
human flagged it as a point of alignment:

| metaharness component | Jurati equivalent |
|---|---|
| Scoped memory namespace | Unimatrix (knowledge engine, MCP server) |
| Governance policy: default-deny, audit trails | (partially present via protocol gates; not yet a hardened permission layer) |
| Darwin Mode self-evolution (config mutates, sandbox-tested, keep only measurable wins) | *Not yet present* — this is exactly what ASS-005 explores |
| Domain agents / multi-agent pods with system prompts | `.claude/agents/uni/*` specialists |
| Skills + slash commands | `.claude/skills/*`, `/uni-*`, `/j-queen` |
| Deterministic static analysis vs. model-driven execution | protocols/gates (deterministic) vs. specialist agents (model-driven) |
| Witness-signed releases (Ed25519, SLSA) | *Not yet present* — a candidate enterprise seam |

The practical read: Jurati is already a metaharness-shaped system built by hand. The
question is not "adopt metaharness or not" but "which of the patterns metaharness (and the
broader ecosystem) has codified are worth importing, and in what order."

---

## Findings

### Q1: What do leading harnesses do — and what *should* a harness do vs. NOT do?

**Answer**: The consensus "job of a harness" has stabilized into ~6 responsibilities:
(1) a **control loop / orchestration spine**, (2) **tool + capability definitions with
scoping**, (3) **state/memory management** (in-context and externalized), (4) **context
engineering** (what the model sees, when), (5) **gates/guardrails** (human + automated),
and (6) **observability/eval** (traces, judged outcomes). The strongest anti-patterns are
about *over-delegating judgment the harness should own* and *fanning out work that needs
shared context*.

**Evidence**:
- Anthropic's *Building Effective Agents* taxonomy (widely adopted as the reference frame)
  separates **workflows** (LLM steps on deterministic rails) from **agents** (LLM directs
  its own control flow), and counsels using the *simplest* thing that works — most
  production value is in workflows, not open-ended agents.
- Anthropic's multi-agent research write-up: "Architecture follows task structure";
  externalize state early ("the lead researcher saves its plan to memory before context
  fills"); use artifact/filesystem handoffs rather than piping everything through one
  agent; build systems that "resume from where the agent was when the errors occurred."
  (anthropic.com/engineering/multi-agent-research-system)
- Cognition's *Don't Build Multi-Agents*: the anti-pattern is parallel subagents that
  can't see each other's full traces — "Actions carry implicit decisions, and conflicting
  decisions carry bad results." (cognition.com/blog/dont-build-multi-agents)
- The Berkeley *Multi-Agent System Failures* taxonomy (referenced across sources) clusters
  14 failure modes into **specification failures, inter-agent coordination failures, and
  execution failures** — a useful checklist of what a harness must actively prevent.
- metaharness codifies the "don't" side into defaults: **default-deny** tools ("no
  network, no shell, no file-write, approve-dangerous"), 30s timeouts, 8-calls-per-turn
  caps, mandatory audit logging, and it *never executes* inferred build commands
  (`trust: inferred - execution: disabled`).

**Recommendation**: Adopt the **workflow-first** posture. Jurati's protocols are already
workflows (deterministic phase/gate rails with model-driven steps inside) — keep it that
way and resist "let an agent figure out the SDLC." Codify a **do/don't list** (see Target
Output 1) and treat the Berkeley 14-failure taxonomy as an explicit checklist the harness
design must answer. Own judgment at the seams (routing, gating, decomposition); delegate
judgment only inside a well-scoped step.

---

### Q2: How do they split deterministic orchestration vs. model-driven behavior?

**Answer**: The winning production pattern is a **deterministic spine with model-driven
leaves**: fixed control flow, state transitions, retries, and gates are code; the model
supplies judgment *inside* bounded steps. Frameworks differ mainly in *how much* control
flow they force you to make explicit. There is a clear "reasoning layer vs. durability
layer" split emerging at the top of the stack.

**Evidence**:
- Framework axis (2026 comparisons, gurusup.com / openagents.org / callsphere.ai):
  **LangGraph** = explicit directed graph, conditional edges, checkpointed state — most
  deterministic control. **OpenAI Agents SDK** = explicit handoffs (a handoff is literally
  a `transfer_to_X` tool call) + input/output **guardrails** with tripwires. **CrewAI** =
  role-based crews, sequential task outputs — convenient, less explicit control.
  **AutoGen** = conversational GroupChat (least deterministic); Microsoft has moved AutoGen
  to **maintenance mode** in favor of the Microsoft Agent Framework — a maintenance-risk
  flag for anyone considering it as a base.
- Durable-execution layer: **Temporal** supplies event-history-backed durability, replay,
  exactly-once, and Saga compensation. The repeatedly-recommended pattern is *not* either/or
  but **"LangGraph for reasoning + Temporal for orchestration — LangGraph decides what to
  do; Temporal ensures it actually gets done"** (langchain.com, cordum.io, medium DSC).
  A March 2026 OpenAI Agents SDK <-> Temporal integration exists.
- A critical, load-bearing limitation: **LangGraph checkpointers only save state *between*
  nodes, not inside a node** — long work inside one node is lost on failure. This is why
  durable-execution engines exist as a separate layer.
- Coding-agent research (arXiv 2604.03515) found a *fixed pipeline* of
  localize->repair->re-rank "can match or exceed agentic approaches on SWE-bench" — direct
  evidence that determinism often beats autonomy on structured tasks.
- metaharness draws the line explicitly: repo scoring, genome analysis, and MCP
  threat-modeling are "deterministic static-analysis only"; only reasoning/codegen is
  model-driven, routed to "the cheapest model predicted to clear your quality bar."

**Recommendation**: Keep the **spine deterministic and inspectable** (Jurati protocols +
gates = the spine). Push model judgment to the leaves and *bound each leaf* (scope, tool
allowlist, turn/call caps). Treat **durable execution as a named future seam**, not a day-1
dependency: the *concepts* (checkpoint after each phase, resume-not-restart, idempotent
steps, compensation on gate failure) are worth designing for now even if the *engine*
(Temporal-class) comes later. Jurati's per-phase artifacts (SCOPE.md, FINDINGS.md, gates)
are already a poor-man's checkpoint log — lean into that.

---

### Q3: One harness driving multiple projects vs. per-project deployment (THE topology question)

**Answer**: The ecosystem is bifurcating. The *harness definition* is increasingly
**shared/aggregated** (one codebase, one control loop, one set of patterns), while the
*runtime execution context* is increasingly **per-project isolated** (scoped memory,
scoped credentials, scoped audit). The dominant emerging pattern is **"shared control
plane, isolated data/execution plane"** — you do not have to choose one axis for
everything. Fully-aggregated single-runtime-across-projects is a known scaling and
blast-radius liability; fully-per-project-fork is a known maintenance liability.

**Evidence**:
- metaharness is explicitly **aggregated-definition / isolated-runtime**: one generator,
  but each harness gets a **"scoped memory namespace ... preventing cross-project context
  bleed"**, and vertical wrappers are "byte-identical to the equivalent metaharness
  invocation" (shared definition, reproducible per project).
- Multi-tenant agent-architecture literature (scalekit, blaxel, omnithium, fast.io, AWS
  Bedrock tenant-isolation blog) converges on the same seams regardless of vendor:
  **tenant is the organizing principle for config, credentials, data access, and audit**;
  you need a **tenant-aware router, a credential vault, per-tenant retrieval isolation,
  and per-tenant audit pipelines**. Tenant-ID as a *mandatory filter* on every store/query.
- Failure mode of over-aggregation: "as deployment scales, the governance gap ... grows with
  it, and so does the blast radius when something goes wrong in production." A shared
  *runtime* means one poisoned memory/one over-broad credential leaks across projects.
- Failure mode of per-project forks: drift. Each fork accumulates local patches; the
  learning loop (Q5) can't pool signal; security fixes must be re-applied N times. This is
  the classic "wrapping the wrapper" tax (augmentcode.com on ruflo).

**Recommendation** (this is the round's headline, and it *refines* Hypothesis #2 rather
than simply endorsing it):

> **Aggregate the harness *definition and control plane*; isolate the *memory, credentials,
> and audit* per project.** One Jurati codebase/protocol set (shared, versioned, one place
> to improve). Unimatrix knowledge, secrets, and audit trails scoped per project/tenant
> from the start — even if today there is only one project. The cheap thing to get wrong
> now and expensive to retrofit is *runtime isolation*, not *definition sharing*.

See Target Output 2 for the full topology comparison table and failure modes.

---

### Q4: Controlled-autonomy patterns — guardrails, gates, escalation, blast-radius limits

**Answer**: The ecosystem has converged on a small, reusable vocabulary of controlled-
autonomy primitives: **(a) typed guardrails with tripwires**, **(b) rule-based vs.
risk-based guardrails**, **(c) exception-based human escalation** (humans see exceptions,
not every action), **(d) blast-radius limits via allowlists + least-privilege identity**,
and **(e) structured approvals that feed the improvement loop**. These are mature and
worth adopting largely as-is.

**Evidence**:
- **Typed guardrails / tripwires**: OpenAI Agents SDK ships input guardrails and output
  guardrails; a failing check "trips a tripwire to halt the run" via a raised exception
  (openai.github.io/openai-agents-python/guardrails). This is a clean, copyable primitive.
- **Rule-based vs. risk-based** (elementum, strata.io): rule-based = deterministic,
  "fires the same way every time"; risk-based = an agent scores blast radius when you
  "cannot reduce it to a clean rule." Use rules for the common case, risk-scoring for the
  long tail.
- **Exception-based escalation** ("hybrid autonomy," the stated 2025+ default): "automate
  routine work, enforce policies and guardrails, and route high-impact decisions to trained
  humans with the authority to override" — keeps human attention on exceptions.
- **Blast-radius limits**: "explicit allowlists for databases, APIs, and tools"; "agents
  should inherit user permissions ... instead of running with broad service-level access."
  metaharness's default-deny + per-tool caps + timeouts is the concrete instantiation.
- **Approvals as feedback** (this connects Q4->Q5): "Replace 'Approve?' with a checklist:
  intent, data lineage, permissions chain, expected blast radius, rollback plan," and
  capture "reason codes, missing context, policy concerns" so "captured reviewer decisions
  iteratively improve upstream prompts [and] routing rules." Approvals should be
  *structured data*, not a click.

**Recommendation**: Jurati already has human gates in its protocols — **formalize them into
the ecosystem vocabulary**: (1) make each gate emit a *structured* decision record (intent,
blast radius, rollback, reason codes) rather than a pass/fail, (2) distinguish rule-based
gates (always fire: e.g., "no delivery without IMPLEMENTATION-BRIEF") from risk-based gates
(escalate on blast-radius spikes), (3) enforce **default-deny tool scoping per agent** as a
first-class harness property. The structured-approval record is the *cheapest* thing to add
now that pays off hugely for Q5, because it *is* the labeled-failure feedstock for the
flywheel.

---

### Q5: Self-improving / eval-driven patterns (feeds ASS-005 — made deliberately usable as prior art)

**Answer**: There is now a well-formed, named body of prior art. The dominant production
pattern is the **eval-driven data flywheel** (online failure -> human label -> offline golden
set -> regression gate), and the dominant *automated* self-improvement pattern is
**reflective prompt/config evolution** (GEPA/DSPy-style), **with the model weights frozen**.
The strong, repeated lesson: improve the *harness* (prompts, routing, config, evals), not
the *model*. This aligns exactly with metaharness's "the model stays frozen; the harness
evolves."

**Evidence** — organized as prior-art buckets for ASS-005:

1. **The eval-driven flywheel (offline vs. online split)** — the backbone pattern:
   - "Offline tells you whether a change is *safe to ship*; online tells you whether what
     you shipped is *still working*" (qaskills.sh, datadog).
   - The loop (langchain.com/resources/llm-evals; LangSmith flywheel): *online eval flags
     failures -> humans label -> new cases enter the offline golden set -> offline eval gets
     more comprehensive -> regressions caught earlier -> fewer production failures.*
   - "Problematic traces ... turned into regression tests" — **production failures become
     tomorrow's regression tests**. This is the single most portable idea for Jurati:
     every gate rejection / bugfix is a candidate golden-set entry.

2. **LLM-as-judge, calibrated** — how you score without humans in the hot loop:
   - Anthropic's rubric: factual accuracy, citation accuracy, completeness, source quality,
     tool efficiency; "scores from 0.0-1.0 and a pass-fail grade was the most consistent and
     aligned with human judgements."
   - Calibrate the judge against human corrections; keep humans for edge cases ("people
     testing agents find edge cases that evals miss").
   - Start tiny: Anthropic began with **~20 representative queries**, not a big dataset —
     "effect sizes are initially large enough to spot improvements with minimal test cases."

3. **Reflective prompt/config evolution (offline, automated)** — GEPA + DSPy:
   - **GEPA** (github.com/gepa-ai/gepa; ICLR Oral): "combine reflection with evolution" —
     uses *natural-language feedback from execution traces* to iteratively revise prompts,
     **weights frozen**. Shipped inside Google Cloud's Gemini Enterprise "Quality Flywheel."
   - **DSPy** provides the programmatic optimize/eval harness; GEPA plugs in as the
     optimizer. "Define your eval as usual, then call GEPA ... in a couple of lines."
   - Caution (arXiv 2606.23664, *MAS-PromptBench*): prompt optimization does **not** reliably
     improve *multi-agent* systems — gains are uneven. Do not assume single-agent optimizer
     wins transfer to a swarm. Optimize per-agent against per-agent evals.

4. **Self-evolving harness config (the metaharness "Darwin Mode" pattern)** — the closest
   named prior art to what Jurati would build:
   - "mutate its own config, tests each change in a sandbox, and keeps only what measurably
     improves"; **gradient-free, local, model frozen**. This is a *guarded, eval-gated
     config search* — mutation is cheap, the eval gate is the safety mechanism.
   - Survey framing (arXiv 2507.21046, *A Survey of Self-Evolving Agents*: what/when/how/
     where to evolve) is a good literature spine for ASS-005.

5. **Offline vs. online improvement — the safety boundary**:
   - **Offline** (safe, gated, reproducible): prompt/config evolution against a frozen
     golden set; ship only if offline regression passes. This is where automated
     self-improvement belongs.
   - **Online** (observational, *not* auto-applied): production traces feed labeling and
     monitoring; you do **not** let the system silently self-modify in production. Every
     credible source keeps a human/label + offline-gate step between "we saw a failure" and
     "we changed behavior."

**Recommendation** for Jurati / ASS-005: Build the flywheel in this order —
**(1) capture** (structured gate/retro records + traces -> this is Unimatrix's job and it is
already partly there via `/uni-retro`, `/uni-store-lesson`), **(2) golden set** (curate a
small eval set from real gate rejections and bugs), **(3) LLM-as-judge** (rubric-scored,
human-calibrated, start at ~20 cases), **(4) offline optimizer** (GEPA/DSPy-style reflective
evolution of agent prompts/protocols, weights frozen, gated by the golden set),
**(5) guarded rollout** (Darwin-style: mutate config -> sandbox -> keep only measured wins ->
human sign-off). Keep the **model frozen; evolve the harness.** Do *not* wire online
production signal directly to behavior change — always route through the offline gate. Treat
MAS-PromptBench's warning as a design constraint: optimize agents individually, not the swarm
as a monolith.

---

### Q6: Early architectural / security seams for OSS->enterprise without a rewrite

**Answer**: Five seams recur across every serious multi-tenant/agent-security source, and
they cleanly split into "lay the *seam* now (cheap), defer the *heavy implementation*
later." The three that are genuinely expensive to retrofit — and therefore worth stubbing
now — are **tenant/namespace scoping, identity+authz on tool calls, and audit trail**. The
two that can safely wait for real enterprise demand are **hardened secret management** and
**strong runtime isolation (sandboxing)**.

**Evidence** (scalekit, blaxel, omnithium, fast.io, AWS Bedrock, OpenBao, external-secrets):
- **Tenant/namespace scoping** — "Tenant is the organizing principle for everything:
  configuration, credentials, data access, audit trails." Retrofitting a tenant dimension
  onto a store that assumed one tenant is the classic painful migration. metaharness bakes
  in the scoped memory namespace from the start for exactly this reason.
- **Identity + authz at the tool boundary** — "Tool calls are HTTP requests that cross
  network boundaries ... allowing you to firewall, rate-limit, and audit every tool
  invocation." Least-privilege, inherit-user-permissions. If tools are wired as ambient
  capability now, adding authz later means re-plumbing every call site.
- **Audit trail** — "capture every action, prompt, tool call, and cross-system access with
  tenant metadata (correlation trace ID, tenant-scoped identifier, agent instance ID,
  action type)." Audit is near-impossible to reconstruct after the fact; the schema must
  exist from the first action or you lose history forever.
- **Secrets** — OpenBao/Vault namespaces give per-tenant isolation; External Secrets
  Operator patterns exist. This is a *swap-in* later: if you route secret access through a
  single indirection (a "get_secret(scope, key)" seam) now, the backend can be env-vars
  today and Vault/OpenBao later with no call-site changes.
- **Runtime isolation** — Docker/microVM/hardware sandbox (metaharness's RVM host,
  OpenHands' Docker sandbox). Real but heavy; safe to defer *provided* the tool layer is
  already default-deny and scoped.

**Recommendation** (refines Hypothesis #3 — the answer is "yes, but only three of five"):
Lay these three seams *now*, as thin interfaces even if single-tenant behind them:
1. **A tenant/scope parameter threaded through every Unimatrix read/write and every
   artifact path.** (Cheap now; a migration nightmare later.)
2. **A single tool-invocation choke point** with default-deny + allowlist + a place to
   later attach authz and rate limits. metaharness's default-deny model is the template.
3. **A structured audit event schema** emitted from that choke point and from every gate
   (ties to Q4's structured approvals and Q5's flywheel — same event stream serves all
   three).
Defer, behind a thin indirection only: hardened secrets backend and strong sandbox
isolation. Do **not** build full RBAC, SSO, or microVM isolation now — that is
speculative enterprise weight with no current tenant to justify it.

See Target Output 5 for the seam-by-seam now/later table.

---

### Q7: Heavy-customize an existing base vs. clean build (against the named candidates)

**Answer**: For a harness *bound to a custom backend (Unimatrix) whose entire value
proposition is the deterministic SDLC spine + knowledge engine*, **heavy-customizing a
general-purpose agent framework is a poor fit; the honest options are (a) clean build of
the spine while (b) borrowing patterns and possibly thin libraries from the ecosystem.**
None of the named bases are "adopt wholesale." The realistic framing is *build the spine,
selectively vendor the leaves*.

**Evidence — candidate-by-candidate read** (directional):

| Base | What it gives | Fit for Jurati | Verdict |
|---|---|---|---|
| **metaharness** (ruvnet) | The *conceptual template* — memory namespace, default-deny governance, Darwin self-evolution, host adapters, witness-signed releases. Generator, not a runtime library. | Highest *conceptual* fit (it's the same shape as Jurati). But it *generates* a harness scaffold; it is not a spine you embed a custom backend into. Also carries fast-moving-solo-maintainer risk (rebrands: metaharness->ruflo lineage). | **Mine for patterns; do not depend on as a runtime.** Anchor, not base. |
| **claude-flow / ruflo** (ruvnet) | Multi-agent swarm orchestration for Claude Code, SPARC methodology, hive-mind, MCP. Community claims 31k+ stars, 84.8% SWE-bench, Rust/WASM rewrite (all *vendor/community claims — treat skeptically*). | Overlaps Jurati's swarm/protocol space, but it is opinionated, heavy, fast-churning (multiple renames/rewrites in <12 months = integration + stability risk), and not built around a custom knowledge backend. | **Study SPARC + swarm patterns; do not build on. Churn/maintenance risk is high.** |
| **LangGraph** | Best-in-class *deterministic graph orchestration* + checkpointing + LangSmith eval/flywheel. Most production-battle-tested. | Good fit *as an orchestration library* for the spine's internals **if** Jurati wants graph execution — but Jurati's spine is currently protocol/markdown-driven and Claude-Code-native, and LangGraph is Python-centric. Adopting it reframes the whole runtime. Checkpoint-inside-node limitation noted. | **Strongest "borrow the library" candidate** *if* a code-level orchestration engine is ever wanted. Otherwise borrow the *patterns* (graph, checkpoints, reducers). |
| **OpenAI Agents SDK / Swarm** | Clean handoff + typed guardrail/tripwire primitives; Temporal integration. | Model-locked (OpenAI); Jurati is Claude-Code-native. Guardrail/handoff *primitives* are excellent references. | **Copy the guardrail/handoff design; don't adopt (model lock-in).** |
| **AutoGen** | Conversational GroupChat multi-agent. | **In maintenance mode** (superseded by Microsoft Agent Framework). Conversational topology is the exact anti-pattern Cognition warns against for structured work. | **Avoid.** Maintenance + topology risk. |
| **CrewAI** | Fast role-based crews. | Low-ceiling: "medium production readiness, limited checkpointing." Good for prototypes, not a durable spine. | **Not a base.** Maybe a prototyping reference. |
| **Temporal** | Durable execution: replay, exactly-once, Saga, audit. Not agent-specific. | Excellent *durability layer* — but it is infrastructure, not a harness. Heavy dependency for a personal/OSS-first tool today. | **Named future seam** (Q2). Design for its concepts; adopt the engine only when long-running/multi-service durability is real. |

The recurring cost of "heavy-customize a general base": you inherit the base's opinions
(topology, execution model, language, model-provider assumptions) and then fight them to
bolt on your custom backend — the "wrapping the wrapper" tax. Jurati's differentiator (the
Unimatrix-backed deterministic SDLC spine) is precisely the part no base provides, so the
base would only be supplying the *leaves*, which are the cheap, replaceable part.

**Recommendation** (refines Hypothesis #1): **Build the spine; vendor patterns, not
platforms.** Concretely: keep Jurati's protocol/gate/Unimatrix spine hand-built and
Claude-Code-native; import *designs* from LangGraph (graph + checkpoint semantics), OpenAI
Agents SDK (typed guardrails/tripwires, handoffs-as-tool-calls), Anthropic (orchestrator-
worker, externalized memory, small-eval-first), and metaharness (default-deny governance,
scoped memory, Darwin self-evolution, witness-signed releases). Keep a **thin seam** where
a durable-execution engine (Temporal-class) or a graph library (LangGraph) *could* slot in
later, so the choice stays reversible. A full clean-build of *everything* including the
orchestration primitives is unnecessary — the ecosystem's *patterns* are free; only the
*platform lock-in* is the thing to avoid.

---

## Target Output 1 — Do / Don't-Do list for harnesses (ranked, with evidence)

**DO (ranked by evidence strength / payoff):**
1. **Keep a deterministic, inspectable spine; put model judgment in bounded leaves.**
   (Anthropic workflows-vs-agents; arXiv fixed-pipeline>=agentic on SWE-bench.)
2. **Externalize state early — checkpoint after each phase; resume, don't restart.**
   (Anthropic multi-agent lessons; LangGraph/Temporal durability literature.)
3. **Default-deny tool scoping per agent** (allowlist, timeouts, per-turn call caps).
   (metaharness governance; blast-radius literature.)
4. **Structured gates/approvals as data** (intent, blast radius, rollback, reason codes) —
   they double as the self-improvement feedstock. (HITL governance sources; Q5 flywheel.)
5. **Eval-driven from tiny (~20 cases); LLM-as-judge, human-calibrated.** (Anthropic.)
6. **Scope memory/credentials/audit per project from day one** even at single-tenant.
   (Multi-tenant seam literature.)
7. **Give subagents their own context windows + artifact/filesystem handoffs** when you
   *do* parallelize. (Anthropic.)

**DON'T (ranked by damage):**
1. **Don't fan out parallel agents on work that needs shared context** (esp. codegen) —
   "conflicting decisions carry bad results." (Cognition.)
2. **Don't let an agent own control flow the harness should own** (the SDLC itself).
   (Workflows-first consensus.)
3. **Don't wire online/production signal directly to behavior change** — always gate through
   an offline golden set. (offline-vs-online literature.)
4. **Don't adopt conversational/free-for-all topologies for structured tasks** (AutoGen
   GroupChat style). (Cognition; AutoGen maintenance mode.)
5. **Don't build on fast-churning solo-maintainer platforms** without an exit seam
   (claude-flow/ruflo rebrand+rewrite churn).
6. **Don't retrofit tenancy/authz/audit later** — thread the seams now.
7. **Don't assume single-agent prompt-optimization wins transfer to a swarm.**
   (MAS-PromptBench.)

---

## Target Output 2 — Topology options (trade-offs + failure modes)

| Dimension | (A) Fully aggregated: one runtime across all projects | (B) Fully per-project: fork/deploy per project | (C) **Recommended: shared definition + control plane, isolated memory/creds/audit** |
|---|---|---|---|
| Definition maintenance | One place (good) | N forks drift (bad) | One place (good) |
| Learning-loop signal pooling | Pooled (but risky) | Fragmented (bad) | Pooled at definition level, isolated at data level (good) |
| Blast radius | Largest (bad): one poisoned memory/over-broad cred leaks across all | Smallest (good) | Small (good): data plane isolated |
| Security-fix propagation | Instant (good) | N re-applies (bad) | Instant (good) |
| Isolation / compliance | Weakest (bad) | Strongest (good) | Strong (good): per-tenant scope |
| Cost/ops complexity | Low infra, high risk | High ops (bad) | Moderate — the winning trade |
| **Primary failure mode** | Cross-project context bleed; single point of catastrophic failure; governance gap grows with scale | Drift, duplicated fixes, un-poolable learning | Requires disciplined tenant-scoping from day one (the one thing you must not skip) |

Failure-mode notes: (A)'s canonical failure is **cross-tenant memory bleed** and a
**blast radius that scales with adoption**; (B)'s is **drift + the "wrapping the wrapper"
maintenance tax**; (C)'s only real risk is **forgetting to thread the scope early** — which
is precisely why Q6's seams are the enabling move for the recommended topology.

---

## Target Output 3 — Controlled-autonomy patterns worth adopting

1. **Typed input/output guardrails with tripwires** (OpenAI Agents SDK model) — a guardrail
   returns structured output; a triggered tripwire halts the run via a raised exception.
2. **Rule-based vs. risk-based guardrails** — deterministic rules for the common case;
   agent-scored blast-radius for the long tail.
3. **Exception-based human escalation ("hybrid autonomy")** — humans review exceptions and
   high-consequence actions, not every step. Jurati's gates already do this; formalize it.
4. **Blast-radius limits** — explicit allowlists per tool/DB/API; least-privilege,
   inherit-user-permissions rather than ambient service creds.
5. **Structured approvals as feedback** — capture intent/lineage/permissions/blast-radius/
   rollback + reason codes; feed them to the flywheel.
6. **Default-deny + caps** (metaharness) — no network/shell/file-write by default,
   per-turn call caps, per-tool timeouts, mandatory audit.
7. **Pre-flight static scan** (metaharness `mcp-scan` model) — flag shell/network grants,
   wildcard permissions, missing audit/timeouts, unguarded secrets *before* a tool ships.

---

## Target Output 4 — Self-improvement patterns from the ecosystem (prior art for ASS-005)

1. **Eval-driven data flywheel**: online failure -> human label -> offline golden set ->
   regression gate. Production failures become regression tests. (LangSmith/DeepEval/Datadog.)
2. **Offline vs. online boundary**: offline = "safe to ship?" (gated, automated OK); online
   = "still working?" (observational, never auto-applied to behavior).
3. **LLM-as-judge, calibrated**: rubric-scored 0-1 + pass/fail; calibrate against human
   corrections; start at ~20 cases. (Anthropic.)
4. **Reflective prompt/config evolution (weights frozen)**: GEPA (reflection+evolution over
   traces) + DSPy as the optimize/eval harness. Caveat: gains don't reliably transfer to
   multi-agent — optimize per-agent (MAS-PromptBench).
5. **Guarded self-evolving config (Darwin Mode)**: mutate config -> sandbox-test -> keep only
   measured wins -> human sign-off. Gradient-free, local, model frozen.
6. **"Model frozen, harness evolves"** as the governing principle across all of the above.
7. **Cost-aware routing learned from eval logs** (metaharness router; also LoRA-tuning a
   cheap tier from resolved archives — a heavier, later-stage option).

---

## Target Output 5 — Early-seam recommendations (OSS->enterprise)

| Seam | Lay the *seam* now? | Build heavy impl now? | Why |
|---|---|---|---|
| **Tenant/scope threading** (every store read/write + artifact path carries a scope) | **YES** | No (single-tenant behind it) | Retrofitting a tenant dimension is the classic painful migration. |
| **Tool-invocation choke point** (default-deny + allowlist; hook for authz/rate-limit) | **YES** | Partial (default-deny yes; RBAC no) | Adding authz to ambient tool calls later = re-plumb every call site. |
| **Structured audit event schema** (from choke point + every gate) | **YES** | No (log locally now) | Audit history can't be reconstructed after the fact; schema must precede first action. |
| **Secrets access indirection** (`get_secret(scope,key)` seam) | Thin seam only | No (env vars behind it; Vault/OpenBao later) | Swap-in later with no call-site changes. |
| **Runtime isolation** (Docker/microVM sandbox) | No (rely on default-deny) | No | Heavy; safe to defer *if* tool layer is already scoped. |
| **Witness-signed releases** (Ed25519/SLSA, metaharness pattern) | Optional/cheap | Optional | Cheap provenance win; nice-to-have, not blocking. |
| **RBAC / SSO / full multi-tenant identity** | No | No | Speculative enterprise weight; no current tenant to justify. |

Guiding rule: **lay seams that are cheap-now / expensive-later (scope, tool choke point,
audit schema); defer everything whose cost is dominated by real enterprise demand.**

---

## Target Output 6 — Build-vs-heavy-customize read (summary)

**Verdict: build the spine, vendor patterns not platforms.** See the Q7 table for the
candidate-by-candidate rationale. One-line reads:
- **metaharness** -> anchor/pattern source, not a runtime dependency.
- **LangGraph** -> best "borrow the library/patterns" option if a code-level orchestration
  engine is ever wanted; otherwise borrow graph+checkpoint semantics.
- **OpenAI Agents SDK** -> copy guardrail/handoff *primitives*; don't adopt (model lock-in).
- **Temporal** -> named future durability seam; concepts now, engine later.
- **claude-flow/ruflo** -> study SPARC/swarm patterns; high churn/maintenance risk as a base.
- **AutoGen** -> avoid (maintenance mode + anti-pattern topology).
- **CrewAI** -> prototyping reference at best; not a durable spine.

---

## Hypothesis Verdicts (tested, not assumed)

- **H1 — "Jurati leans build (or heavy-customize a base)."** -> **Supported, refined to
  BUILD (the spine), not heavy-customize a base.** No named base fits a custom-backend SDLC
  spine; heavy-customizing any of them incurs the "wrapping the wrapper" tax on the cheap
  (leaf) part while providing nothing for the differentiating (spine) part. Borrow patterns
  and possibly thin libraries; own the spine.
- **H2 — "Aggregated one-harness-across-projects is preferred."** -> **Partially supported,
  refined.** Aggregate the *definition and control plane*; **isolate memory/credentials/
  audit per project.** Fully-aggregated *runtime* is a blast-radius liability; the winning
  topology is hybrid (Target Output 2, column C).
- **H3 — "Some security seams are worth laying now."** -> **Supported, made specific.** Three
  seams are worth laying now (tenant/scope threading, tool-invocation choke point with
  default-deny, structured audit schema); two (hardened secrets backend, runtime sandbox)
  can wait behind thin indirections. Don't build RBAC/SSO/microVM now.

---

## Unanswered Questions

- **Quantitative cost of build-vs-customize.** Q7 is answered *directionally* (fit, not
  effort). An engineering-effort estimate (person-weeks to build the spine vs. to bend
  LangGraph/Temporal to Unimatrix) would need a scoped PoC — out of scope for a directional
  literature survey. *Reason: requires proof-of-concept spike + internal effort data.*
- **Whether Jurati's Claude-Code-native, markdown-protocol runtime should ever move to a
  code-level graph engine.** This hinges on internal runtime constraints (Claude Code
  execution model, MCP limits) not visible to an external survey. *Reason: needs internal
  architecture spike.*
- **Real durability requirements** (do Jurati sessions run long/multi-service enough to
  justify a Temporal-class engine?). *Reason: depends on internal usage patterns.*
- **Several load-bearing ecosystem metrics are vendor/community claims** (claude-flow/ruflo
  "84.8% SWE-bench / 31k stars / Rust-WASM rewrite"; some 2026-dated blog benchmarks) and
  could not be independently verified to primary-source rigor within this survey. Treated as
  directional signal, not established fact. *Reason: no neutral primary benchmark available.*

---

## Out-of-Scope Discoveries

- **"Deterministic scaffold >= agentic" on structured coding tasks** (arXiv 2604.03515: a
  fixed localize->repair->re-rank pipeline can match/beat agentic loops on SWE-bench). This is
  a strong argument for Jurati's spine philosophy and possibly for making *more* of the SDLC
  deterministic than currently assumed. *Could warrant a spike: "where should Jurati be
  deterministic vs. agentic within a protocol phase?"*
- **Witness-signed releases / SLSA provenance** (metaharness Ed25519 pattern) — a cheap,
  differentiating trust feature for an OSS-first tool that redistributes agent definitions.
  Not in scope here; flag as a possible small feature.
- **Cost-aware model routing learned from eval logs** (metaharness router; LoRA-tuning a
  cheap tier) — a Q5-adjacent optimization that could materially cut Jurati's token cost.
  *Adjacent to ASS-005; note for that campaign.*
- **The Anthropic vs. Cognition "multi-agent" split is a false binary** — they disagree on
  *topology for different task shapes* (breadth-first research vs. tightly-coupled codegen),
  not on principles. Jurati spans both (research spikes = parallelizable; delivery = tightly
  coupled), so it likely needs *both* topologies, selected per session type. Worth an
  explicit design note in the vision synthesis.

---

## Recommendations Summary

- **Q1 (do/don't):** Workflow-first harness; own judgment at the seams, bound it in the
  leaves; use the Berkeley 14-failure taxonomy as a design checklist.
- **Q2 (deterministic vs. model):** Deterministic inspectable spine + bounded model leaves;
  design for durable-execution *concepts* now, adopt the *engine* later.
- **Q3 (topology):** Aggregate the definition/control plane; **isolate memory/credentials/
  audit per project** from day one. Hybrid beats both extremes.
- **Q4 (controlled autonomy):** Adopt typed guardrails+tripwires, rule-vs-risk gates,
  exception-based escalation, default-deny scoping, and **structured approvals-as-data**.
- **Q5 (self-improvement):** Build the eval-driven flywheel (capture -> golden set ->
  calibrated LLM-judge -> offline reflective optimizer -> guarded rollout). **Model frozen,
  harness evolves.** Never wire online signal directly to behavior. Optimize per-agent.
- **Q6 (seams):** Lay three now (tenant/scope threading, tool choke point + default-deny,
  audit schema); defer secrets-backend and sandbox behind thin indirections; skip RBAC/SSO.
- **Q7 (build vs customize):** **Build the spine, vendor patterns not platforms.** metaharness
  = anchor/patterns; LangGraph/OpenAI SDK/Anthropic = pattern donors; Temporal = future seam;
  claude-flow/AutoGen/CrewAI = study-or-avoid, not bases.
