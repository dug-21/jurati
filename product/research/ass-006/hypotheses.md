# ASS-006 Hypotheses — What Jurati Could Be (and Not Be)

**Spike**: ass-006 · divergent-ideation (identity/ambition altitude)
**Generator**: `uni-hypothesizer` (Fable 5) · **Date**: 2026-07-16
**Status of every item below**: `claimed` — conjecture only. Nothing here is graded, ranked, or
recommended. Triage (park / probe / build) belongs to the j-queen + human convergent step.

**Evidence base**: ASS-001…005 FINDINGS (in full) + Jurati's real surface (`.claude/agents/uni/*` —
22 definitions; `.claude/skills/*` — 17 skills; `.claude/protocols/uni/*` — 5 protocols; the Unimatrix
`context_*` MCP substrate; founding issues #1 and #2; CLAUDE.md).

**How to read**: each identity is phrased to the lens — *"Jurati could be **T** for **U**, delivering
**O**, powered by **M**"* — and every one cites a specific lever from the findings or the surface.
The **north-star relation** tag (ratifies / sharpens / stretches / contradicts) marks how each identity
sits against the present position, so the triage can see where the real boundary is. It is a
description of direction, not a verdict of merit.

---

## A. Obvious — direct fits to the founding model

### H1 · The disciplined delivery harness for one developer

- **Statement**: Jurati could be **a deterministic SDLC/delivery harness** for **the human's own
  development work**, delivering **repeatable, gate-quality feature/bugfix/design cycles that freehand
  agent use cannot match**, powered by **the two-layer spine the protocols already embody —
  deterministic phase/gate/routing rails with LLM specialists as bounded leaves**.
- **Mechanism**: ASS-003's organizing finding (the protocols are already cleanly two-layered; the
  scrum-master role *is* a harness spec written in prose) + founding issue #1 + the shipped
  design/delivery/bugfix/research protocols and 22-agent roster.
- **Serves / outcome**: the human (solo developer/owner); shipped features with gated quality,
  captured decisions, and lower rework.
- **Class**: obvious · **North-star relation**: ratifies (the founding identity).
- **Level-up vs linear**: linear — it exists; this identity is a sharpening, not a step-function.
- **Cheapest test**: ship one real feature through the full delivery protocol side-by-side against a
  freehand Claude Code session on a comparable feature; compare rework, gate catches, and captured
  knowledge.
- **Key assumption**: the protocol overhead pays for itself even at solo scale. **Biggest risk**:
  ceremony tax — the spine costs more than it saves on small features, and the identity quietly
  becomes "process for its own sake."

### H2 · The self-improving process organism

- **Statement**: Jurati could be **a harness that measurably improves its own process definitions**
  for **its operator**, delivering **compounding process quality — each cycle makes the next one
  better**, powered by **the version-stamped, retro-driven, human-gated improvement loop (ASS-005 v1:
  three small connectors over existing substrate)**.
- **Mechanism**: ASS-005 Q3/Q5 — self-improvement is "an integration job, not an invention job";
  the loop is *already turning by hand* (commit `738083d`); ASS-002's proven retro→edit→`wf-v` bump
  cadence (14 real versions upstream); ASS-001's observation/effectiveness machinery as the
  measurement substrate.
- **Serves / outcome**: the human; a process whose defect classes get retired instead of recurring.
- **Class**: obvious · **North-star relation**: ratifies ("co-evolving," "increasingly autonomous"
  in its human-gated proven form).
- **Level-up vs linear**: level-up — improvement compounds; a static harness only accumulates.
- **Cheapest test**: build the git-tag-derived `wf-v` stamp on `context_cycle` tags, run two cycles on
  adjacent workflow versions, and check whether `context_cycle_review` yields a version-attributable
  delta.
- **Key assumption**: the inert measurement loop (0 retrospected / 315 obs) will discriminate good
  process changes from bad once exercised. **Biggest risk**: it doesn't — and the identity rests on a
  `claimed` measurement layer (both ASS-001 and ASS-005 flag exactly this).

### H3 · The per-repo discipline component ("jurati init")

- **Statement**: Jurati could be **a drop-in repo component** for **each of the human's (and later
  others') repositories**, delivering **local SDLC discipline installed in minutes — protocols, agents,
  skills, memory wiring per repo**, powered by **the runtime-read definition layer plus the proven
  init/binding mechanism (`.mcp.json` + 9-event hooks + skills + CLAUDE.md block)**.
- **Mechanism**: ASS-001 Q1 binding recipe (`unimatrix init` already performs exactly this class of
  install) + ASS-005 Layer 3 (definitions are files read at runtime — a copy-in install IS the whole
  deploy, no build step).
- **Serves / outcome**: any repo owner; per-project discipline with per-project memory isolation for
  free.
- **Class**: obvious · **North-star relation**: sharpens — takes the SCOPE's "component layered into
  each repository" pole of the topology question.
- **Level-up vs linear**: linear (replication of what exists), but it is the enabling move for H4/H8.
- **Cheapest test**: install Jurati's `.claude/` definition set into a second repo the human owns and
  run one design session unmodified.
- **Key assumption**: the definitions are repo-agnostic enough to transplant without hand-tuning.
  **Biggest risk**: fork-drift — N copies accumulate local patches and the learning loop fragments
  (ASS-004's named per-project failure mode).

### H4 · The cross-project queen — shared control plane, isolated data planes

- **Statement**: Jurati could be **a single versioned control plane over many repositories** for **a
  multi-project owner**, delivering **one place to improve the process, with pooled process-learning
  and strictly isolated per-project memory/credentials/audit**, powered by **ASS-004's topology
  column C plus Unimatrix's first-class remote multi-tenant mode (token-free `mcp-bridge` keyed by
  `projectHash`)**.
- **Mechanism**: ASS-004 Q3 headline ("aggregate the definition and control plane; isolate memory,
  credentials, and audit per project") + ASS-001 out-of-scope discovery that shared/cloud Unimatrix
  serving many repos is an anticipated engine topology.
- **Serves / outcome**: the human first, teams later; process fixes propagate once, blast radius stays
  per-project.
- **Class**: obvious · **North-star relation**: sharpens — takes the "true overseer" pole, but in the
  hybrid form the evidence supports (control plane shared, data plane isolated — NOT one shared
  runtime).
- **Level-up vs linear**: level-up — a topology change that makes every later identity multi-project.
- **Cheapest test**: two repos consuming one definition source (published package or subtree) with
  separate Unimatrix scopes; verify a definition fix propagates to both and memories don't bleed.
- **Key assumption**: tenant/scope threading gets laid *now* (the one thing ASS-004 says you must not
  skip). **Biggest risk**: skipping the seam and inheriting the classic retrofit migration; secondary
  risk — "queen" drifts toward a shared runtime (topology A) and its blast-radius liability.

### H5 · The structured-research harness

- **Statement**: Jurati could be **a research-campaign harness** for **an investigating product owner**,
  delivering **scoped, validated, confidence-tiered findings instead of vibes-driven exploration**,
  powered by **the shipped research protocol + `uni-research-sm` campaign machinery + the dual-track
  (internal/external/synthesis) routing that just executed ASS-001…005**.
- **Mechanism**: surface — `uni-research-protocol.md`, `uni-research-sm`, `uni-spike-researcher`,
  `uni-external-researcher`; existence proof — this very five-spike campaign completed end-to-end;
  ASS-002 proves a research-only sibling (arch-research) runs an entire product on this workload.
- **Serves / outcome**: the human as decision-maker; decisions grounded in evidence with an explicit
  confidence axis (directional/empirical/validated).
- **Class**: obvious · **North-star relation**: ratifies ("SDLC **+ research** workflows").
- **Level-up vs linear**: linear — already real; the identity question is whether research is co-equal
  with delivery or a supporting act.
- **Cheapest test**: already run — the founding campaign. The remaining test is whether its findings
  survive first contact (does the vision synthesis they feed hold up?).
- **Key assumption**: research workload recurs often enough to deserve co-equal billing. **Biggest
  risk**: research remains episodic and the machinery idles between campaigns.

---

## B. Adjacent — analogical transfers and compositions with what exists

### H6 · The domain-neutral structured-work harness

- **Statement**: Jurati could be **a harness for ANY phase-gated, evidence-firewalled work** — incident
  response, content pipelines, campaign management, even the "clinical trial" the engine itself
  names — for **knowledge workers beyond software**, delivering **auditable, gated, memory-backed
  execution of any recurring structured workflow**, powered by **the domain-agnostic cycle primitive
  plus the proven machinery-generalizes/taxonomy-doesn't split**.
- **Mechanism**: ASS-001 Q1 — `context_cycle` topic is explicitly "a software feature, incident,
  campaign, clinical trial, or any work unit a domain tracks from start to completion"; ASS-002 Q4 —
  the spine (coordinator-never-generates, single-writer, firewall, bounded-rework gates) is
  domain-neutral and already runs a second domain (research) in the wild; the swap points are the
  category taxonomy and the proof artifact.
- **Serves / outcome**: non-software or mixed-work operators; discipline + memory for structured work
  generally.
- **Class**: adjacent · **North-star relation**: stretches — the north-star says "other domain agentic
  workflows," but this identity makes non-SDLC domains first-class rather than an appendix, and its
  extreme form drops "S" from SDLC entirely.
- **Level-up vs linear**: level-up — a step-function widening of the addressable work.
- **Cheapest test**: stand up ONE non-software protocol (e.g., an incident-postmortem or
  research-adjacent content workflow) by swapping only the taxonomy and proof artifact; run it once
  end-to-end.
- **Key assumption**: the proof-artifact swap is genuinely the only hard part per domain. **Biggest
  risk**: dilution — every domain added taxes the definition set, and Jurati becomes a mediocre
  generic workflow tool instead of a superb SDLC one (see anti-set AV-9 and tension T2).

### H7 · The rule engine that calls LLMs (the spine as actual software)

- **Statement**: Jurati could be **a deterministic protocol-execution engine** for **anyone running
  multi-agent workflows on Claude Code**, delivering **orchestration that is enforced, not narrated —
  gates, rework caps, phase DAGs, and cycle bookkeeping that cannot be skipped**, powered by
  **ASS-003's Tier-1 extraction (gate state machine + rework counter, phase-transition engine,
  context_cycle auto-emission — pure-mechanical today)**.
- **Mechanism**: ASS-003 Q2 — the entire scrum-master job description is a harness spec written as
  prose; the corrective-prose density ("MANDATORY BLOCK", triple-repeated ordering warnings) is a
  ready-made ripeness heatmap; ASS-004 corroborates ("fixed pipeline can match or exceed agentic" on
  structured tasks; "model orchestration as a rule engine that calls LLMs").
- **Serves / outcome**: Jurati itself first, then any Claude Code power user; run-to-run orchestration
  variance goes to ~zero, which also unlocks trustworthy A/B attribution (ASS-003 Q3's prerequisite).
- **Class**: adjacent · **North-star relation**: sharpens — makes "deterministic harness" literally
  true in code, not aspirationally true in prose.
- **Level-up vs linear**: level-up — changes what Jurati *is* (markdown-instructed LLM coordinator →
  executable spine), and is the stated prerequisite for clean self-improvement measurement.
- **Cheapest test**: implement only the gate-verdict→next-action state machine + rework counter for
  one protocol; measure whether the reminded-against failure class (skipped steps, missed escalations)
  disappears.
- **Key assumption**: the Claude Code execution model permits a code-level spine without reframing the
  whole runtime (ASS-004 flags this as an unanswered internal question). **Biggest risk**: the
  extraction quietly turns Jurati into a framework project — the exact side of the harness/framework
  line the findings say not to cross.

### H8 · The versioned, signed process-definition product ("the definition registry")

- **Statement**: Jurati could be **a distributor of versioned, provenance-signed agent/skill/protocol
  definition sets** for **Claude Code users who want proven SDLC discipline without building it**,
  delivering **install-and-run process quality with trustworthy upgrade paths**, powered by
  **definitions-as-versioned-data (ASS-005 Layer 3) + the witness-signed-release pattern (Ed25519/SLSA,
  ASS-004) + the existing `uni-release` skill**.
- **Mechanism**: ASS-005 Q1 — the entire evolving object is file-based and git-versioned, so the
  product artifact already exists as a directory; ASS-004 Q6/OOS — witness-signing is a "cheap,
  differentiating trust feature for an OSS-first tool that redistributes agent definitions"; surface —
  `uni-release`, `uni-init` are the packaging/installation muscles.
- **Serves / outcome**: external developers; Jurati's learnings become a distributable asset rather
  than a private one.
- **Class**: adjacent · **North-star relation**: stretches — moves "OSS-first" from posture to product,
  and makes *users* a load-bearing constituency for the first time.
- **Level-up vs linear**: level-up — productization; the first identity where Jurati has customers.
- **Cheapest test**: package `.claude/` as a versioned artifact and have ONE external person install it
  in their repo and complete a session; observe where it breaks.
- **Key assumption**: demand exists — **none of the five findings contains user/demand evidence**
  (flagged below). **Biggest risk**: maintenance gravity — external users convert Jurati from the
  human's instrument into an obligation, the exact "wrapping the wrapper" burden ASS-004 observed
  consuming solo-maintainer projects.

### H9 · The garage funnel — a managed idea-intake engine

- **Statement**: Jurati could be **a divergent-ideation + convergent-triage engine** for **product
  owners**, delivering **a governed pipeline from raw possibility-space to parked/probed/built
  decisions — generation firewalled from grading**, powered by **the garage-funnel pattern ASS-002
  surfaced (scout → hypothesizer → goal-owner triage), of which this very spike is Jurati's first
  running instance**.
- **Mechanism**: ASS-002 out-of-scope discovery (the divergent-generate / convergent-cut split, with
  the generator deliberately on Fable 5); surface — `uni-hypothesizer` now exists, j-queen is the
  named convergent step; the ASS-006 protocol variance is the executed proof-of-plumbing.
- **Serves / outcome**: the human (and any product owner later); ideas conceived that demand-pull
  delivery would never surface — "a conjecture never conceived is lost forever."
- **Class**: adjacent · **North-star relation**: stretches — adds a *generative* intake mode to a
  harness whose founding model is demand-pull execution.
- **Level-up vs linear**: level-up — a new mode of operation, not a better version of an existing one.
- **Cheapest test**: this spike. Does the human triage of this file yield decisions judged more
  valuable than an ad-hoc brainstorm would have?
- **Key assumption**: the generation/triage firewall actually improves decision quality rather than
  just producing longer lists. **Biggest risk**: funnel theater — wide generation that triage always
  cuts back to the obvious candidates, adding cost without changing outcomes.

### H10 · The agent-identity and least-privilege trust layer

- **Statement**: Jurati could be **the attestable agent-identity + authorization provider** for
  **Unimatrix-backed multi-agent systems (its own swarms first)**, delivering **per-agent
  least-privilege on the knowledge base — read-only researchers, single writers, enforced not
  honor-system**, powered by **ASS-001 gap #2: Unimatrix's read/write/admin enforcement already exists
  and activates with NO engine change the moment Jurati supplies trustworthy identity**.
- **Mechanism**: ASS-001 Q4 — `context_enroll` trust levels + capabilities are present; the missing
  piece is identity outside the LLM context, explicitly named "a Jurati responsibility, not an engine
  gap"; ASS-002 corroborates the need (caller-asserted `created_by` is provenance, never audit).
- **Serves / outcome**: Jurati's own swarm safety first; any shared-Unimatrix deployment later. The
  single-writer and research-firewall rules become *enforced* invariants instead of prompt discipline.
- **Class**: adjacent · **North-star relation**: sharpens ("controlled") — and is the security
  precondition for both H4 (shared instances) and any enterprise story.
- **Level-up vs linear**: level-up — converts every prompt-level rule ("never write context_*") into a
  mechanical guarantee.
- **Cheapest test**: prototype one attestable per-subagent identity on the MCP connection and confirm
  the engine's existing enforcement blocks an out-of-privilege write.
- **Key assumption**: sub-agent identity can be attested outside the LLM context within Claude Code's
  execution model. **Biggest risk**: it can't (or only leakily) — leaving enforcement theater that is
  worse than honest prompt discipline.

### H11 · The audit-grade agentic delivery system

- **Statement**: Jurati could be **an audit-first delivery harness** for **developers and teams who
  must show their work (regulated, security-sensitive, or enterprise-curious)**, delivering **a
  structured, queryable record of every gate decision, approval, and artifact lineage across the whole
  agentic run**, powered by **structured-approvals-as-data + the audit-schema seam (ASS-004) laid over
  the three-surface model (ASS-002)**.
- **Mechanism**: ASS-004 Q4/Q6 — gates should emit structured decision records (intent, blast radius,
  rollback, reason codes); "audit is near-impossible to reconstruct after the fact; the schema must
  exist from the first action"; ASS-002 D1 three-surface model gives the storage split; ASS-003 shows
  gates already emit typed verdicts at known paths — the raw material exists.
- **Serves / outcome**: anyone accountable for agent-produced software; provable process, not asserted
  process.
- **Class**: adjacent · **North-star relation**: sharpens ("architected to extend to enterprise") — the
  cheapest enterprise seam that also feeds the self-improvement flywheel (same event stream).
- **Level-up vs linear**: linear now (formalizing records of what already happens); level-up if it
  becomes the enterprise wedge.
- **Cheapest test**: emit one structured decision record from one gate and check it answers a mock
  audit question ("who approved this change, against what evidence, with what rollback?").
- **Key assumption**: the audit record can be made mechanical (harness-emitted) rather than
  LLM-remembered. **Biggest risk**: building compliance weight for a tenant that doesn't exist
  (ASS-004's explicit warning about speculative enterprise weight).

### H12 · The AI product-owner pair (j-queen as the flagship)

- **Statement**: Jurati could be **a continuous product-ownership counterpart** for **solo founders and
  tech leads**, delivering **durable product intent — vision stewardship, alignment gating, capability
  tracking, and specialist creation — that survives context loss and time**, powered by **the shipped
  j-queen + uni-zero + uni-vision-guardian + uni-capability surface bound to Unimatrix memory**.
- **Mechanism**: surface — `j-queen` (pairing + specialist authoring), `uni-vision-guardian`
  (variance-classified alignment review in design 2b), `uni-zero-reviewer` (fresh-context product-lens
  gate reviews), `uni-capability` (goal→capability decomposition with behavioral-proof gating, issue
  #2); ASS-001 primitive-use map shows the memory/lineage substrate is Ready for exactly this.
- **Serves / outcome**: the human now, solo builders generally later; the *judgment continuity* side of
  the product, complementing H1's execution side.
- **Class**: adjacent · **North-star relation**: sharpens — reads "Jurati as queen" as *product
  ownership is the crown*, not orchestration.
- **Level-up vs linear**: linear (the pieces exist and deepen with use).
- **Cheapest test**: the imminent one — does this campaign's j-queen synthesis produce a
  PRODUCT-VISION.md + first goals + capability map the human genuinely endorses and reuses?
- **Key assumption**: an LLM pair can hold product intent stably enough to gate against. **Biggest
  risk**: sycophancy/drift — the pair ratifies rather than pressure-tests, and "alignment gating"
  becomes rubber-stamping.

### H13 · The eval-flywheel operator — failures become the asset

- **Statement**: Jurati could be **a system that converts every gate rejection, rework loop, and bugfix
  into a permanent regression asset** for **its operator (and any harness user later)**, delivering
  **a growing golden set that makes each process change safer to ship than the last**, powered by
  **the eval-driven data flywheel (ASS-004 Q5) fed by the ready-made outcome labels Jurati's gates
  already emit (ASS-003 Q3)**.
- **Mechanism**: ASS-004 — "production failures become tomorrow's regression tests," start at ~20
  cases; ASS-003 — gate verdicts + rework counts are discrete, attributable, already-emitted labels;
  ASS-005 hard-requires the frozen held-out suite anyway — this identity is that requirement promoted
  to a product concept.
- **Serves / outcome**: the operator; process changes gated on evidence harvested from the operator's
  own real failures, not synthetic benchmarks.
- **Class**: adjacent · **North-star relation**: ratifies (the "verification" half of "co-evolving
  memory/verification engine").
- **Level-up vs linear**: level-up — failures switch from cost to compounding asset.
- **Cheapest test**: harvest the gate rejections from the first N real cycles into a ~20-case golden
  set and use it to judge one proposed process edit.
- **Key assumption**: Jurati's failure volume at solo scale is high enough to grow a discriminating
  set (ASS-005's small-N statistical-power concern). **Biggest risk**: overfitting the process to a
  tiny idiosyncratic golden set — Goodhart at miniature scale.

### H14 · The capability-map strategy tracker — "what's left" as a query

- **Statement**: Jurati could be **a strategy-execution tracker** for **product owners**, delivering
  **"what remains to build, and what's actually proven" as a live graph query instead of a decaying
  planning document**, powered by **the `uni-capability` skill's goal→capability→feature decomposition
  with behavioral-proof gating over `Advances`/`Prerequisite` edges**.
- **Mechanism**: ASS-001 primitive-use map ("turn 'what to build next' into a graph query; behavioral
  proof gating on `done_when`" — template exists); ASS-002 live validation — the one-call hydrated
  board query works on a real board, and the firewall visibly held (0 proven / 7 capabilities after a
  POC); founding issue #2.
- **Serves / outcome**: the human; roadmap truth that cannot silently drift from delivery truth.
- **Class**: adjacent · **North-star relation**: ratifies (verification engine, controlled autonomy).
- **Level-up vs linear**: linear — the template exists; this is committed adoption.
- **Cheapest test**: model this campaign's own output (the first Jurati goals) as a capability map and
  run the board query for real.
- **Key assumption**: the human maintains the discipline of attaching behavioral evidence. **Biggest
  risk**: the map rots into ceremony if grading is done by assertion — the exact failure the firewall
  exists to prevent.

---

## C. Non-obvious / whitespace — inversions and possibilities nobody has named

### H15 · The process observatory — a longitudinal instrument, not (only) a harness

- **Statement**: Jurati could be **an instrument that answers "is the way we work getting better?"**
  for **any operator running versioned workflows**, delivering **version-over-version process trends —
  gate-failure decline, phase velocity, hotspot retirement — as a first-class product output**, powered
  by **`context_cycle_review`'s under-used regression machinery (`baseline_comparison`/`is_outlier`,
  per-phase `gate_outcome_text`) joined to the `wf-v` version stamp**.
- **Mechanism**: ASS-005 out-of-scope discovery — the telemetry surface is "richer than the loop
  currently uses"; ASS-001 Q3 hotspot taxonomy measures *harness execution health* directly; ASS-002's
  observed drift lesson makes the git-tag-derived stamp the reliable join key.
- **Serves / outcome**: operators and (later) teams; the measurement half of self-improvement sold as
  its own value, independent of whether anyone automates the improving.
- **Class**: non-obvious · **North-star relation**: sharpens — reframes "co-evolving" as *observable
  evolution*, which is the part the evidence says is nearest.
- **Level-up vs linear**: level-up — a new altitude of self-knowledge (portfolio view) that no current
  surface element provides.
- **Cheapest test**: after ~5 stamped cycles, hand-produce ONE version-over-version trend report from
  `cycle_review` output; judge whether it says anything a human didn't already know.
- **Key assumption**: per-cycle signals aggregate into meaningful trends at low cycle counts.
  **Biggest risk**: ASS-001 gap #7 — retrospection is per-cycle, not cross-cycle; the portfolio view
  needs either an engine feature or brittle caller-side aggregation.

### H16 · Unimatrix's proving ground — the consort that shapes the crown

- **Statement**: Jurati could be **the flagship consumer and co-evolution driver of Unimatrix** for
  **the Unimatrix ecosystem (with the human owning both sides)**, delivering **battle-tested
  conventions that graduate into engine features — the demand signal that decides what Unimatrix
  becomes**, powered by **the convention-over-engine-change governing principle plus the prioritized
  gap/wishlist backlog ASS-001 already produced**.
- **Mechanism**: ASS-001 Q4 + governing principle ("prefer convention over engine change… then promote
  it into the engine — matching how `uni-capability` already extends the domain-agnostic core");
  the 7-item wishlist is literally a roadmap Jurati generates for Unimatrix; ASS-002 shows a sibling
  consumer (arch-research) already exerting the same pressure.
- **Serves / outcome**: the two-product ecosystem; each real Jurati strain becomes a validated
  Unimatrix feature instead of a speculative one.
- **Class**: non-obvious · **North-star relation**: **contradicts (inverts)** — in this identity the
  *engine* is the durable center of gravity and Jurati is the proving consort, not the queen. Worth
  naming so the human can see which product the ambition actually attaches to.
- **Level-up vs linear**: level-up — a strategic reframe of which asset compounds.
- **Cheapest test**: track one convention end-to-end — e.g., the `wf-v` cycle-tag stamp — from Jurati
  convention → demonstrated strain → engine feature proposal; did the loop close?
- **Key assumption**: the human wants Unimatrix to be the durable asset. **Biggest risk**: Jurati
  under-invests in its own identity and becomes a demo repo — the harness ambition dissolves into
  engine QA.

### H17 · The methodology — a published, versioned method others can run without our code

- **Statement**: Jurati could be **a codified methodology** (a spec, like arch-research's 15-section
  method or SPARC) for **teams building agentic delivery systems anywhere**, delivering **the named
  invariants — firewall, single-writer, coordinator-never-generates, bounded-rework gates, three
  surfaces, versioned-workflow — as a portable standard**, powered by **the proof that the method is
  fully documentable and domain-neutral: a sibling system already runs it from a written spec**.
- **Mechanism**: ASS-002 — the entire factory operates from `research-factory-methodology.md`; its
  invariants transferred to a second domain (Jurati) with only taxonomy swaps; ASS-004 — the ecosystem
  adopts *patterns* freely ("the ecosystem's patterns are free; only platform lock-in is the thing to
  avoid") — implying the reverse: Jurati's patterns could be the export.
- **Serves / outcome**: the broader agentic-engineering field; influence and adoption decoupled from
  maintaining software for strangers.
- **Class**: non-obvious · **North-star relation**: stretches — "world-class harness" becomes
  "world-class *method*," with the software as the reference implementation.
- **Level-up vs linear**: level-up — decouples the idea's reach from the implementation's reach.
- **Cheapest test**: write the invariant set as one standalone document and have someone apply it in a
  non-Jurati, non-Unimatrix stack; observe what survives translation.
- **Key assumption**: the invariants, not the implementation, carry the value. **Biggest risk**:
  methodology-without-proof — Jurati's own loop is young (measurement inert, autonomy unproven), so
  publishing early risks codifying claims the firewall itself would grade `claimed`.

### H18 · The process-of-record — the org's "how we work" brain

- **Statement**: Jurati could be **the system of record for HOW work is done** for **a future team/org
  (the human's first)**, delivering **a queryable history binding every artifact to the exact process
  version, definitions, and evidence that produced it — "which process built this, and how well was it
  working?"**, powered by **storing each run's definition-set hash + model pin with its outcome
  (ASS-005's reproducibility hard-require) joined to cycle attribution**.
- **Mechanism**: ASS-005 Q4 ("store each run's definition-set hash with its outcome"; version all four
  artifact classes) + ASS-001's cycle/topic attribution and typed-edge lineage (SCOPE→SPEC→BRIEF→
  outcome as a traversable graph, primitive-use map "Ready").
- **Serves / outcome**: future collaborators, auditors, and the human's own future self; institutional
  process memory that survives personnel and context loss.
- **Class**: non-obvious · **North-star relation**: stretches — Unimatrix stores what the org *knows*;
  this identity makes Jurati the record of how the org *works*, a distinct and unclaimed altitude.
- **Level-up vs linear**: level-up — a new category of institutional memory.
- **Cheapest test**: store hash+pin+outcome for three runs, then answer one forensic question cold:
  "which definition version produced feature X, and what did its gates say?"
- **Key assumption**: someone will ask these questions (solo-scale value is mostly future-facing).
  **Biggest risk**: write-only history — meticulous records nobody ever queries.

### H19 · The cost and blast-radius governor

- **Statement**: Jurati could be **the budget-metering and blast-radius governor for autonomous agent
  runs** for **anyone letting agents run unattended (itself first)**, delivering **enforced — not
  assumed — spend caps, tool scopes, and stop conditions per cycle**, powered by **the named, unbuilt
  gap ASS-002 surfaced ("every budget discipline rests on a mechanism that does not exist") plus the
  default-deny/caps vocabulary ASS-004 catalogued**.
- **Mechanism**: ASS-002 out-of-scope discovery (budget metering is a gap ANY autonomous harness hits;
  arch-research is building `opcost` for it) + ASS-004 Target Output 3 (default-deny, per-turn call
  caps, timeouts, allowlists — mature primitives to compose).
- **Serves / outcome**: the operator; "increasingly autonomous" becomes affordable and bounded rather
  than aspirational and scary.
- **Class**: non-obvious · **North-star relation**: sharpens ("controlled") — the unglamorous
  precondition for the autonomy the north-star promises.
- **Level-up vs linear**: linear as a feature; level-up as an *enabler* (no credible autonomy without
  it).
- **Cheapest test**: append a per-cycle token/cost report at `context_cycle` stop and enforce one hard
  cap on one unattended run.
- **Key assumption**: cost signal is accessible per-cycle in this harness. **Biggest risk**: building
  a governor before there is anything autonomous to govern — sequencing, not substance.

### H20 · The permanently human-sovereign harness (autonomy inversion)

- **Statement**: Jurati could be **a deliberately, permanently human-gated harness** for **operators
  doing high-stakes work**, delivering **trustworthiness as THE feature — every adoption, merge, and
  process change passes one accountable human, forever, by design**, powered by **the evidence that
  human-gated is the only mode anyone has ever proven: the autonomous A/B half never ran once upstream,
  shipped industry systems all keep the human gate, and Jurati's own measurement loop is inert**.
- **Mechanism**: ASS-002 Q2 (the formal autonomous half has NEVER RUN; the human-gated half has 14
  versions of proof) + ASS-005 Q2/Q5 ("full autonomy on adoption is the frontier, not practice";
  "one human decision-maker at the adopt gate") + ASS-004 exception-based escalation as the mature
  pattern.
- **Serves / outcome**: operators who need to trust the system more than they need to be absent from
  it; a defensible identity in a market racing toward unsupervised agents.
- **Class**: non-obvious (inversion) · **North-star relation**: **contradicts** — deletes
  "increasingly autonomous" and replaces it with "increasingly *trustworthy under* a human." Generated
  so the triage can locate the real boundary of the autonomy ambition.
- **Level-up vs linear**: level-up in positioning (a stance competitors racing to autonomy cannot
  copy); a deliberate cap on capability.
- **Cheapest test**: enumerate the gates that would be "never autonomous," run N cycles, and measure
  what the human gate actually costs in cycle time — if the cost is small, autonomy was buying little.
- **Key assumption**: the human gate stays cheap at higher volume. **Biggest risk**: it doesn't scale —
  the single human becomes the bottleneck the autonomy ambition existed to remove.

### H21 · The enterprise-governance product (OSS-first inversion)

- **Statement**: Jurati could be **an enterprise agentic-governance harness first** for **organizations
  adopting agents under compliance pressure**, delivering **default-deny tool scoping, per-tenant
  isolation, structured approvals, and signed provenance as the headline (not the extension)**, powered
  by **the metaharness component map, where the pieces Jurati lacks are precisely the governance/
  enterprise ones, plus the fully-enumerated Q6 seam list**.
- **Mechanism**: ASS-004 orientation table — the two "*Not yet present*" rows against metaharness are
  the hardened governance layer and witness-signed releases; ASS-004 Q4/Q6 supply the complete
  build-list vocabulary (tripwires, rule-vs-risk gates, tenant threading, audit schema, choke point).
- **Serves / outcome**: enterprises; Jurati monetizes trust and control rather than developer
  productivity.
- **Class**: non-obvious (inversion) · **North-star relation**: **contradicts** — inverts
  "personal/OSS-first, extend to enterprise" into "enterprise-pull first." Generated to mark the other
  edge of the ambition envelope.
- **Level-up vs linear**: level-up (a market pivot).
- **Cheapest test**: none cheap from the current evidence — the findings establish mechanism
  feasibility but contain **zero demand evidence**; the honest cheapest test is a handful of discovery
  conversations, which is outside the current surface. Flagged below.
- **Key assumption**: enterprise demand exists and is reachable by a solo OSS builder. **Biggest
  risk**: ASS-004's own warning verbatim — "speculative enterprise weight with no current tenant to
  justify it"; it also forfeits the personal-flywheel that powers H2/H13.

### H22 · The genus parent — a family of sibling harnesses under one spine

- **Statement**: Jurati could be **the parent of a family of domain harness variants** — an SDLC
  variant, a research variant (already alive as arch-research's factory), an incident variant, and so
  on — for **a portfolio owner**, delivering **one maintained spine with cheap per-domain variant kits
  (taxonomy + proof-artifact + roster skin)**, powered by **the family structure that already exists in
  the wild: `factory-retro` self-describes as "the factory variant of `uni-retro` (which is
  SDLC-shaped)" — sibling systems under one parent**.
- **Mechanism**: ASS-002 Q4 — the two systems are explicit siblings; the transferable spine vs.
  domain-shaped taxonomy split is already demonstrated across two live domains; ASS-004's topology
  finding (aggregate the definition, isolate the data) applies across *domains* just as it does across
  *projects*.
- **Serves / outcome**: the human's whole portfolio of structured work; "queen over the ecosystem"
  realized as a *genus*, not a single organism.
- **Class**: non-obvious · **North-star relation**: stretches — reinterprets "queen over the ecosystem"
  from "one harness ruling projects" to "one spine mothering variants."
- **Level-up vs linear**: level-up — turns every new domain from a build into a derivation.
- **Cheapest test**: extract the shared spine into a common layer that both Jurati and a factory-style
  variant consume; count the duplicated definitions eliminated and whether one spine fix lands in both.
- **Key assumption**: the spine can be factored out of the two existing siblings without breaking
  either. **Biggest risk**: premature abstraction from N=2 — the classic wrong-generalization trap;
  ASS-002 explicitly warns the taxonomies must NOT be unified.

### H23 · The durable, resumable run — checkpointed agentic execution

- **Statement**: Jurati could be **a harness whose runs survive interruption** for **operators running
  long or unattended sessions**, delivering **resume-from-where-it-stopped instead of restart-from-
  zero — phase-level checkpointing as a first-class property**, powered by **the per-phase artifact
  trail that already IS a poor-man's checkpoint log (SCOPE.md → FINDINGS.md → gate reports at known
  paths), plus the durable-execution concepts ASS-004 names as a designed-for seam**.
- **Mechanism**: ASS-004 Q2 ("Jurati's per-phase artifacts are already a poor-man's checkpoint log —
  lean into that"; checkpoint-after-each-phase, resume-not-restart, idempotent steps) + ASS-003's fixed
  phase DAG making "where were we" mechanically decidable from artifacts on disk.
- **Serves / outcome**: the operator; interruption (context exhaustion, MCP disconnects — a real
  observed failure, ASS-002 OBS-3 — crashes, walking away) stops being a run-killer, which is itself a
  precondition for meaningful autonomy.
- **Class**: non-obvious · **North-star relation**: sharpens ("controlled and increasingly
  autonomous") — autonomy without resumability is a restart loop.
- **Level-up vs linear**: level-up — changes the unit of reliable work from "one sitting" to "one
  feature."
- **Cheapest test**: kill a delivery session mid-phase and script a "resume from artifacts" restart;
  measure what is recovered vs. lost.
- **Key assumption**: phase artifacts capture enough state to reconstruct the coordinator's position.
  **Biggest risk**: hidden state (rework counters, in-flight agent context) lives outside the artifact
  trail — exactly what ASS-001 says the telemetry-grade cycle cannot durably hold.

---

## The anti-vision set — what Jurati should NOT be, and why

Inversions and tempting adjacent traps. Each cites the lever that makes it a trap, not a taste.

- **AV-1 · NOT an agent framework/library.** The ecosystem's sharpest line: "Frameworks help
  developers build agents; harnesses help repositories ship agents" (ASS-004). The moment Jurati ships
  primitives for others to assemble, it competes with LangGraph/CrewAI on their turf and abandons its
  differentiator (the Unimatrix-backed SDLC spine — the part no framework provides). H7's biggest risk
  is exactly this slide.
- **AV-2 · NOT a fork of, or an orchestrator embedded inside, Unimatrix.** ASS-001 is explicit:
  companion, not fork; "do NOT try to make Unimatrix the run orchestrator"; extend by convention first,
  engine second, route-around never. Collapsing the two products destroys the co-evolution seam that
  both identities (H16 included) depend on.
- **AV-3 · NOT a single shared runtime across projects.** Topology A's canonical failures: cross-
  project memory bleed, one over-broad credential, blast radius that scales with adoption (ASS-004
  Target Output 2). "Queen" must never mean one process space touching everything — the evidence
  supports a shared *definition/control plane* only.
- **AV-4 · NOT a platform built by heavy-customizing a base.** Every named candidate fails the fit test
  (ASS-004 Q7): the base supplies only the cheap leaves, Jurati still builds the differentiating spine,
  and it inherits churn (claude-flow's rename/rewrite cycle), lock-in (OpenAI SDK), or maintenance-mode
  risk (AutoGen). "Wrapping the wrapper" is a named tax.
- **AV-5 · NOT an autonomously self-modifying system.** The autonomous, telemetry-proven improvement
  loop has never run once in the sibling system (ASS-002); Jurati's own measurement loop is inert
  (0 retrospected / 315 obs, ASS-005); and every credible production source keeps a human/regression
  gate between "we saw a failure" and "we changed behavior" (ASS-004/005). Online-signal→behavior-change
  wiring is the single most evidence-contradicted identity available.
- **AV-6 · NOT a conversational multi-agent playground.** Free-for-all GroupChat topology is the
  documented anti-pattern for structured work ("actions carry implicit decisions, and conflicting
  decisions carry bad results" — Cognition via ASS-004), and its flagship is in maintenance mode.
  Jurati's value is precisely that its agents do NOT converse freely.
- **AV-7 · NOT a model company — and NOT a "deterministic outputs" promise.** The model stays frozen;
  the harness evolves (ASS-004 Q5). And the self-description trap ASS-005 flags: an unqualified
  "execution is deterministic" claim "will be rejected by anyone who knows LLM internals." Jurati's
  honest sentence is fixed: *deterministic control flow + versioned definition-set + pinned model — NOT
  deterministic token output.*
- **AV-8 · NOT an enterprise RBAC/SSO/microVM platform today.** ASS-004 Q6 verdict: build full
  enterprise identity/isolation now and you carry "speculative enterprise weight with no current tenant
  to justify it." The evidence supports laying three thin seams (scope threading, tool choke point,
  audit schema) — the seams, not the fortress. (H21 is generated to test the boundary; this item marks
  the trap form of it.)
- **AV-9 · NOT an everything-workflow tool on day one.** The domain-neutral spine (H6/H22) is real, but
  ASS-002's own discipline cuts the other way: the taxonomy and proof artifact are domain-shaped and
  "must NOT be cross-imported"; each domain is a real per-domain build, and each dilutes the definition
  set. General structured work is a *direction* the mechanism supports, not a launch identity.
- **AV-10 · NOT a metric-maximizer.** A single-scalar quality score invites Goodhart and reward-hacking
  the moment any improvement loop touches it (ASS-005 Q4 risk table). North-star + guardrail metrics,
  frozen held-out sets — or no measurement-driven identity (H2/H13/H15) is safe.

---

## The tension map — where the identities cluster and conflict

Trade-offs the human triage must resolve; the identities are the poles, not the answers.

- **T1 · Personal instrument vs. product with users.** H1/H2/H12/H13 compound *because* one human
  operates the loop daily; H8/H17/H21 acquire users, and users convert the instrument into an
  obligation (maintenance gravity, support surface, demand evidence currently zero). The flywheel
  identities and the audience identities pull on the same scarce resource: the human's attention.
- **T2 · SDLC-sharp vs. general structured work.** H1/H5 vs. H6/H22. The spine is provably
  domain-neutral (ASS-002), but every added domain costs a taxonomy + proof-artifact build and dilutes
  focus (AV-9). The evidence supports the *capability*; nothing in the evidence yet supports the
  *demand* for any specific second domain.
- **T3 · Per-repo component vs. cross-project queen (the SCOPE's named topology question).** H3 vs.
  H4. The findings dissolve the binary at the *architecture* level (ASS-004 column C: shared
  definition/control plane + isolated data planes), but the *identity* question survives: is Jurati
  experienced as "a thing inside each repo" or "a thing above all repos"? The two poles imply different
  install stories, different first users, and different failure modes (drift vs. blast radius). H4
  additionally requires H10's identity work and the tenant seams *now*.
- **T4 · Software vs. method.** H7 (spine as executable code) vs. H17 (spine as published methodology)
  vs. the status quo (spine as prose executed by an LLM). All three are grounded; they imply different
  centers of gravity (engineering vs. writing vs. operating) and different moats. H7 also carries the
  AV-1 slide risk; H17 carries the publish-before-proven risk.
- **T5 · Increasingly autonomous vs. permanently human-sovereign.** The north-star's "increasingly
  autonomous" vs. H20's inversion. The evidence is lopsided in an uncomfortable way: everything proven
  is human-gated; everything autonomous is `claimed` (ASS-002/005). The triage must decide whether
  autonomy is the *destination* (H2/H19/H23 are its preconditions) or a *marketing word to drop*
  (H20's stance-as-differentiator).
- **T6 · Which product wears the crown — Jurati or Unimatrix?** "Jurati as queen over the ecosystem"
  vs. H16 (Unimatrix as the durable center, Jurati as its proving ground) vs. H22 (the crown belongs
  to the *spine/genus*, and both current systems are instances). Since the human owns both products,
  this is really: which asset should compound? Every hour of identity work lands on one side of it.
- **T7 · The measurement-dependency cluster (a shared load-bearing bet).** H2, H13, H15, and parts of
  H18 all stand on the same single leg: that the currently-inert Unimatrix measurement loop
  discriminates once exercised (0 retrospected / 315 obs — flagged by ASS-001 AND ASS-005 as `claimed`).
  If that bet fails, this whole cluster degrades together to the manual/observations-log mode. The
  cheapest de-risking move for four identities at once is the same first connector (the `wf-v` stamp +
  two exercised cycles). Conversely H1/H3/H5/H12/H14 do not depend on it at all — a resilience fact the
  triage may want to weight.
- **T8 · OSS-first vs. enterprise-pull.** North-star vs. H21, with H11 as the bridge identity (audit
  records serve the solo operator's flywheel today AND become the enterprise wedge later — the only
  identity on this axis the evidence lets you buy cheaply now).

---

## Flags — grounding limits (honest ceiling of the input)

- **Zero demand/user evidence.** All five FINDINGS establish *mechanism* feasibility. None contain
  evidence that anyone besides the human wants any of this. Identities with an external audience
  (H8, H17, H21, and the external halves of H6/H11) are mechanism-grounded but **demand-ungrounded**;
  their cheapest tests are correspondingly weaker (H21's isn't cheap at all — noted inline).
- **The measurement bet is shared and unproven.** T7 names it: H2/H13/H15/H18 lean on an inert loop
  both ASS-001 and ASS-005 explicitly grade `claimed`. Conjectures were phrased anyway (per lens), with
  the dependency surfaced rather than papered over.
- **Claude Code runtime constraints are an unanswered question upstream.** ASS-004 flags "whether
  Jurati's markdown-protocol runtime should ever move to a code-level graph engine" as needing an
  internal architecture spike. H7 and H23 inherit that open question; their mechanisms are cited from
  what the findings *do* establish (Tier-1 extractability, artifact-trail checkpointing).
- **No altitude failure.** The five FINDINGS were rich enough to generate at identity altitude across
  all three classes; no identity above required invention beyond the handed evidence. One deliberate
  exclusion: identities with no citable lever (e.g., "AI consultancy," "model routing marketplace")
  were not generated — vibes are out per the SCOPE's hard constraint.

---

## Compact index

| # | Statement (short) | Class | Serves | North-star relation |
|---|---|---|---|---|
| H1 | Disciplined delivery harness for one developer | obvious | the human | ratifies |
| H2 | Self-improving process organism | obvious | the human | ratifies |
| H3 | Per-repo discipline component | obvious | repo owners | sharpens (topology pole) |
| H4 | Cross-project queen (shared control plane) | obvious | multi-project owner | sharpens (topology pole) |
| H5 | Structured-research harness | obvious | the human as investigator | ratifies |
| H6 | Domain-neutral structured-work harness | adjacent | knowledge workers | stretches |
| H7 | Rule engine that calls LLMs (spine as software) | adjacent | Claude Code power users | sharpens |
| H8 | Versioned, signed definition registry | adjacent | external CC users | stretches |
| H9 | Garage funnel / idea-intake engine | adjacent | product owners | stretches |
| H10 | Agent-identity + least-privilege trust layer | adjacent | swarm operators | sharpens |
| H11 | Audit-grade agentic delivery | adjacent | accountable teams | sharpens |
| H12 | AI product-owner pair (j-queen flagship) | adjacent | solo founders/leads | sharpens |
| H13 | Eval-flywheel operator (failures → asset) | adjacent | the operator | ratifies |
| H14 | Capability-map strategy tracker | adjacent | product owners | ratifies |
| H15 | Process observatory (longitudinal instrument) | non-obvious | versioned-workflow operators | sharpens |
| H16 | Unimatrix's proving ground / consort | non-obvious | the two-product ecosystem | contradicts |
| H17 | Published methodology (code optional) | non-obvious | the agentic-eng field | stretches |
| H18 | Process-of-record ("how we work" brain) | non-obvious | future team/org | stretches |
| H19 | Cost + blast-radius governor | non-obvious | unattended-run operators | sharpens |
| H20 | Permanently human-sovereign harness | non-obvious | high-stakes operators | contradicts |
| H21 | Enterprise-governance-first product | non-obvious | enterprises | contradicts |
| H22 | Genus parent — family of sibling harnesses | non-obvious | portfolio owner | stretches |
| H23 | Durable, resumable runs | non-obvious | long/unattended runs | sharpens |

*End of conjecture set. Everything above is `claimed`. Triage — park / probe / build — is the
j-queen + human convergent step that consumes this file.*
