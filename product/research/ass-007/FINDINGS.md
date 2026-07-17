# FINDINGS: Does Anyone But the Human Want This? (demand validation)

**Spike**: ass-007
**Date**: 2026-07-17
**Approach**: investigation + evaluation (external demand survey)
**Breadth**: industry / external (Claude Code + agentic-dev communities, competitor repos, standards bodies, market/practice literature)
**Confidence**: directional (proxy/expressed demand only — primary validation is explicitly deferred to the human's follow-on test, which this spike *designs* but does not *run*)

> **Reading discipline for this file.** Every demand signal is labelled **strong / moderate / weak / none** and cited. Per the Hard constraints and ASS-004: **GitHub stars are treated as a weak, noisy signal** (star counts for the same repo varied wildly across sources — see the conflict note below), and contributor count, issue/PR activity, release cadence, and evidence of *actual usage/criticism* are weighted far higher. Where a number is a vendor/community claim it is flagged. **A weak/none result is reported as a finding, not papered over** — the point of the spike is to test "others want this too," including the possibility that they don't for a given cluster.
>
> **Star-count reliability flag (applies throughout).** GitHub Spec Kit was reported at 40.6k, 93k, 111k, and 122k stars across four sources dated Aug 2025–June 2026; this is exactly the ASS-004 caveat in action. Star *magnitudes* below are directional only; the load-bearing signals are contributor counts, open-issue volume, release recency, and the presence of real adoption *and* real criticism.

---

## Findings

### Q1 — Demand-evidence map: per-cluster expressed/proxy demand and its strength

**Headline:** The demand that the audience-dependent identities rest on is **real and strongest for Cluster A (OSS Claude Code developers) — but that market is already crowded and contested, not empty.** Cluster B is moderate (methods have adoption but no willingness-to-pay). Cluster C is moderate-but-emerging (real, rising, expensive to reach). Cluster D is weak (a hot *trend* narrative, but no voiced pain for Jurati's specific offering). Ranked by evidence: **A > B ≈ C > D.**

---

#### Cluster A — OSS Claude Code developers wanting installable, proven SDLC discipline (H8, H7, H3)

**Signal strength: STRONG (demand proven; market saturated).**

**Voiced pain (strong, first-person).** The exact pain Jurati's discipline addresses is loudly and repeatedly voiced in Claude Code communities:
- "Output quality is wildly inconsistent — one session produces clean, well-architected code, while the next produces a tangled mess that takes longer to fix than to write from scratch." (Augment Code guide, synthesizing community reports.)
- **"Context rot"** is a named, shared problem: "As Claude fills its context window, output quality drops: responses get shorter, instructions get missed, and code gets sloppy" (GSD project framing, dev.to/stevengonsalvez). This is the precise failure Jurati's phase/gate/fresh-context-per-agent model targets.
- Fatigue with "a constant stream of approval prompts" and with "vibe coding … describe what you want and hope for the best" (multiple Medium/DEV practitioner posts; InnoGames engineering blog "Beyond Vibe-Coding").
- Community desire framed as wanting to "ship faster **without losing engineering discipline**" — the title pattern recurs across independent practitioner write-ups.

**Adjacent-tool adoption/traction (strong — and this is the double-edged part).** A dense field of installable "SDLC-discipline for Claude Code" tools has real, verifiable traction (weighting activity over stars):

| Tool | Real-traction signals (not stars) | Shape |
|---|---|---|
| **GitHub Spec Kit** (`github/spec-kit`) | GitHub-*official*; **200+ contributors**; **183 open issues + 143 open PRs** (live, high activity); 30+ agent integrations; MIT | spec → plan → tasks → implement |
| **GSD "Get Shit Done"** (`gsd-build/get-shit-done`) | 69 commands, 24 agents, **12+ runtimes**; active; solves context-rot via discuss/plan/execute/verify phases + parallel subagents | **near-identical shape to Jurati** |
| **BMAD-METHOD** (`bmad-code-org`) | Active org, multiple sub-projects, releases through Apr–May 2026 (v6.x), enterprise-positioned, traceability for GDPR/AI Act | planning-heavy, role-based agents |
| **Task Master** (`eyaltoledano/claude-task-master`) | **158 open issues, 47 open PRs**, release `0.43.1` (Mar 2026), model-agnostic | AI task management |
| **Agent OS** (`buildermethods/agent-os`) | Active, standards-injection + spec-writing, works with any AI tool | standards + specs |

**Community watering-holes (strong, concrete — feeds the ICP).** r/ClaudeAI ≈ **1.0M members**; r/ClaudeCode ≈ **353k members**; a large `awesome-claude-code` ecosystem (100+/154+ curated subagents, skills, plugins). Anthropic itself now publishes "Harness design for long-running apps," and Red Hat publishes "Harness engineering" — the *category vocabulary* has gone mainstream, which validates the framing but also means Jurati is entering a named, contested category, not an empty one.

**Willingness-to-pay (weak — important for T1/T8).** Nearly every tool in the table is **free MIT OSS**. This audience's demand is to *adopt free installable discipline*, not to *buy a product*. Willingness-to-adopt is high; willingness-to-pay is near zero (the paid end of this market is Devin-class autonomous agents, a different product). "Users" for Cluster A means **adopters and maintenance obligation**, not paying customers — exactly T1's maintenance-gravity warning made concrete.

**Counter-signal within Cluster A (must be weighed).** The **ceremony-tax backlash is real and voiced**: "Spec-Driven Development: The Waterfall Strikes Back" (marmelab); "for teams of 2–5 developers, specification overhead can consume a disproportionate amount of development time"; SDD is "overkill" for solo/short-lived/exploratory work; claude-flow/SPARC is criticized as "largely generic boilerplate," "overkill for normal tasks," where "forced parallelization can hurt quality." And a recurring sober note: "Spec-Driven frameworks don't actually solve the most important problem … the real bottleneck is still the AI model itself." **Net for A:** demand for discipline is proven, but so is resistance to *heavy* discipline — the win is in *right-weight* discipline plus something the incumbents lack (see Q3 gap).

---

#### Cluster B — the agentic-engineering field wanting a portable method/standard (H17)

**Signal strength: MODERATE (adoption real; monetizable/durable-audience demand weak).**

- Published methods **do** get adopted: SPARC (Specification/Pseudocode/Architecture/Refinement/Completion) is a named, reused methodology; BMAD and Spec Kit are as much *methods* as tools; "spec-driven development" is now a `github.com/topics` tag with many projects. So "a codified method others run without our code" has clear precedent and appetite.
- **But** methods are commodity/free, and the field is standardizing under heavyweight backers: the **Agentic AI Foundation (AAIF)** under the Linux Foundation (Dec 2025), anchored by MCP, `goose`, and `AGENTS.md`, with OpenAI, Anthropic, Block, Google, Microsoft, AWS, Bloomberg, Cloudflare (per Linux Foundation / OpenAI / TechCrunch). Publishing a method into that environment yields *influence*, not a durable captive audience, and competes with foundation-blessed standards.
- The H17 "publish-before-proven" risk (from ASS-006) is corroborated: SPARC/claude-flow shows what happens when a method over-promises — public criticism of overengineering attaches to the *method's name*.

**Net for B:** the demand is for *interoperable standards*, and that demand is being met by consortium-scale players. Jurati-as-method is viable as thought-leadership/adoption, but the evidence does not support it as a load-bearing *audience* that sustains the product.

---

#### Cluster C — accountable / regulated / enterprise-curious teams wanting audit-grade agentic delivery (H11 → H21)

**Signal strength: MODERATE, but EMERGING and expensive to reach.**

- Real, rising demand for **AI-agent audit trails and traceability**: "compliance guidance requires … prove why an agent took a specific action, what data it used, and what governance policies applied at the moment of execution"; "your compliance team will ask for an AI agent audit trail" (dev.to); SOC 2 / GDPR / EU AI Act pressure is explicit across multiple 2026 sources (Augment Code, Blaxel, Innovation Vista, MintMCP).
- **Partly already served on the delivery side:** BMAD explicitly markets "a traceable path from initial product vision through final code delivery" and "for GDPR and AI Act, specs provide the required audit trail." So audit-grade *delivery* is not an unclaimed niche — an incumbent already pitches it.
- The *acute* spend, however, is concentrated in **agent security/governance platforms** (Blaxel, MintMCP, tenant-isolation infra) — adjacent to, not the same as, Jurati's SDLC-delivery audit record. Industry guidance itself says platform audit capabilities are "expected to reach SOC-2 evidence requirements within two to four quarters" — i.e., *not yet acute*.
- **Reach cost is high:** "Most large companies won't even evaluate vendors without SOC 2 Type II." That is a heavy gate for a solo OSS builder — corroborating ASS-004's "speculative enterprise weight with no current tenant" warning and ASS-006's note that H21's cheapest test *isn't cheap*.

**Net for C:** genuine and growing, best treated as **the bridge (H11) laid cheaply now** (structured gate/audit records that serve the solo operator today and *become* the enterprise wedge later) — **not** as an enterprise-first pivot (H21) the current evidence can justify.

---

#### Cluster D — non-software knowledge workers wanting structured-work harnesses (H6, H22)

**Signal strength: WEAK (hot trend narrative; no voiced demand for Jurati's specific offering).**

- The *trend* is unmistakable in 2026 vendor/analyst content: agentic workflows for lawyers, analysts, and marketers; "making agentic systems accessible to professionals without coding backgrounds" via MCP; Anthropic positioning Claude Code as "an entry point for people without engineering backgrounds." The "agent harness" term is even being applied to enterprise business processes (Agentic BPM literature, arXiv 2601.18833).
- **But** the evidence is *supply-side framing* (consultancies, vendors, think-pieces), not *demand-side voiced pain*. No source shows non-developers asking for a **phase-gated, evidence-firewalled, memory-backed SDLC-shaped discipline harness**. The demand they express is for domain-specific *automation and outcomes* (draft this, monitor that, synthesize a brief), which general agent tools already chase. Jurati's differentiated value (gated discipline + compounding memory) is not what this audience is asking for — yet.
- This matches ASS-006's own anti-vision AV-9 ("NOT an everything-workflow tool on day one") and tension T2: the mechanism generalizes, but **nothing in the demand evidence supports a specific non-software second domain now.**

**Net for D:** do not build for it now; **do not manufacture demand to fill the table.** A weak result here is the honest finding, and it points away from a domain-general launch identity.

---

### Q2 — ICP for the strongest-signal cluster (Cluster A)

**Who:** The individual developer or 2–5-person team **already using Claude Code daily** (very often Claude Code *plus* a second agent — see Q5), technically fluent enough to drop a `.claude/` toolkit into a repo and run slash-commands, who has personally been burned by multi-session quality collapse.

**Context / trigger:** They've run a real project past the point where a single context window holds it, and hit **context rot** and **run-to-run inconsistency**. They have *tried at least one* discipline tool (Spec Kit, GSD, or BMAD) and either kept it grudgingly or dropped it as too heavy.

**Pain in their own words (verbatim-style, from the sources):**
- *"One session produces clean, well-architected code; the next produces a tangled mess."*
- *"As Claude fills its context window, output quality drops … instructions get missed, code gets sloppy."* (context rot)
- *"A constant stream of approval prompts"* / *"vibe coding … hope for the best."*
- Wants to *"ship faster without losing engineering discipline."*
- On the incumbents: *"when a skill runs and produces a suboptimal result, the user corrects Claude but that feedback disappears when the session ends."* (the statelessness gap — see Q3)

**Where they congregate (for the primary test's recruiting list):** r/ClaudeCode (~353k) and r/ClaudeAI (~1M); the `awesome-claude-code` / `awesome-claude-code-subagents` GitHub orgs and their issue trackers; issue threads on `github/spec-kit`, `gsd-build/get-shit-done`, `bmad-code-org/BMAD-METHOD`, and `eyaltoledano/claude-task-master` (people filing complaints there are pre-qualified, high-intent leads); Anthropic's Discord; X/Twitter Claude-Code dev circles; Show HN.

---

### Q3 — Competitive / adjacent landscape and the unmet gap

**The category is mature and crowded — this is the single most important competitive fact.** "Installable SDLC discipline for Claude Code" is not a gap; it is a **contested field with a GitHub-official entrant (Spec Kit)** and multiple high-activity independents. Jurati enters as newcomer N, not as first mover.

| Who | Serves | Real traction (weighted, not stars) | Axis / posture |
|---|---|---|---|
| **GitHub Spec Kit** | Cluster A/B | Official; 200+ contributors; 183 issues/143 PRs open; 30+ agents | Agnostic, spec-first, **the default anchor** |
| **GSD (Get Shit Done)** | Cluster A | 69 cmds/24 agents/12+ runtimes; phase + parallel-subagent engine | **Nearest competitor to Jurati's shape** |
| **BMAD-METHOD** | Cluster A/C | Active org, v6.x releases; enterprise + traceability pitch | Agnostic (multi-IDE), planning-heavy |
| **Task Master** | Cluster A | 158 issues/47 PRs, Mar-2026 release | Model-agnostic task mgmt |
| **Agent OS** | Cluster A | Active; standards + specs | Agnostic (markdown) |
| **AWS Kiro** | Cluster A/C | AWS-launched (May 2026), replaced Amazon Q | **Locked** (Bedrock/IAM/billing inside AWS) |
| **claude-flow / ruflo / SPARC** (ruvnet) | Cluster A/B | High activity **but churny** (claude-flow→ruflo/ROFLO renames) + **documented overengineering criticism** | Claude-Code-centric swarm |
| **SuperClaude** | Cluster A | Config framework (personas/commands) | Claude-Code-native |
| **Devin-class** (Cognition) | paid/enterprise | Commercial autonomous agent | Different product (autonomous, paid) |

**The unmet gap Jurati could fill (moderate confidence — this is the real find):** Almost every incumbent is a **largely stateless prompt/spec scaffold** — the spec drives *one run*; there is **no persistent, queryable memory that compounds across cycles, and no enforced learning loop.** The gap is voiced from inside the incumbents themselves: GSD/claude-flow users report that *"feedback disappears when the session ends,"* and there's "no way to close the feedback loop on skill quality." **None of the incumbents pairs a spec/gate workflow with (a) a persistent knowledge/memory engine (Jurati's Unimatrix), (b) enforced gates that emit structured/auditable decision records, and (c) capability-map proof-gating.** That combination — *the memory/verification flywheel + firewall discipline* — is Jurati's candidate differentiator. **The spec-workflow itself is commoditized; the compounding-memory + enforced-audit layer is not.**

**Two load-bearing caveats on that gap:**
1. It is precisely the **audience-dependent, demand-*ungrounded*** part. No source shows OSS devs *asking* for cross-cycle compounding memory; it's an inferred gap, not a voiced one. That is exactly what the primary test (Q4) must probe.
2. The **ceremony-tax counter-signal** (Q1) means the added machinery must feel *lighter*, not heavier, than Spec Kit/GSD — or it dies on adoption. GSD's own tagline ("Zero to Productive … Without the Faff") shows the market rewards *less* ceremony, and Jurati's discipline is heavier than GSD's.

---

### Q4 — Cheapest PRIMARY test per viable cluster (the human's next move)

Proxy evidence cannot replace primary validation. Below is the exact next move per cluster, cheapest first. **Run Cluster A's test first** — it is the nearest, cheapest, and highest-signal.

**Cluster A — run this first. Two-part: release-and-watch + discovery calls.**
- **Signal test (release-and-watch):** Package Jurati's `.claude/` as an installable and post a *Show HN* + an r/ClaudeCode post framed on the differentiator, not the workflow: *"Claude Code SDLC toolkit that remembers across sessions and gates its own work."* **The metric that matters is not stars — it is second-cycle retention:** of installers, how many run a *second* delivery cycle (i.e., value the compounding memory enough to return)? Instrument for that one number.
- **Discovery calls (5–8), recruited from pre-qualified complainers:** people who filed statelessness/context-loss issues on Spec Kit / GSD / BMAD / Task Master, plus active r/ClaudeCode posters lamenting inconsistency. Script:
  1. "Walk me through your last multi-session Claude Code project — where exactly did it go wrong?"
  2. "Have you tried Spec Kit / GSD / BMAD? Why did you keep it or drop it?" *(surfaces ceremony-tax threshold)*
  3. "What happens to what the agent *learned* between sessions today?" *(tests whether the statelessness gap is felt or a non-issue)*
  4. "If a tool gave you per-project compounding memory + enforced gates, is that worth more ceremony — or is it more overhead you'd disable?" *(directly tests the Q3 gap against the Q1 counter-signal)*
  5. "What would make you install a *new* one and still be using it in a month?"
- **Kill/continue criterion:** if ≥ ~1/3 of calls name the statelessness/no-memory gap *unprompted* AND second-cycle retention is non-trivial, the differentiator is real. If they only want *lighter* Spec Kit, the honest read is "no room; go personal-instrument (T1 left pole)."

**Cluster B — cheap, low-signal.** Publish the invariant set (firewall, single-writer, coordinator-never-generates, bounded-rework gates, three surfaces, versioned workflow) as one standalone method doc; post to HN / agentic-eng communities; measure whether anyone *applies it without the code* (forks, "I tried this" write-ups). Cheap to run, but remember methods are free — a positive result signals *influence*, not a sustaining audience.

**Cluster C — high-value, not cheap; defer behind A.** 5–8 discovery calls with engineering/security leads at SOC2-bound orgs already piloting Claude Code/Copilot. Ask: "Is an audit-grade record of *how* agent-built code was produced a felt need *now*, or a future checkbox?" and "Would you adopt an OSS tool that lacks SOC 2 Type II?" Expect long cycles; treat as validating the *H11 bridge seam*, not an enterprise pivot.

**Cluster D — do not run now.** Premature. If Cluster A validates and a specific adjacent domain keeps recurring, then (and only then) run 3–5 conversations with one concrete non-dev power-user segment (e.g., legal-ops or research analysts already using Claude). Running it before A is validated spends scarce attention against the weakest signal.

---

### Q5 — LLM-agnostic demand (cross-cutting)

> This is the founding "portability across Claude Code / OpenAI Codex / Google Gemini CLI" goal tested against **demand**, not feasibility. The result is nuanced and — critically — includes a strong counter-signal. **Bottom line: agnosticism as a *principle* has strong and rising demand, but agnosticism as a *differentiating feature of an SDLC harness* is weak, because it is already commoditized table-stakes AND because this category's value comes from depth. A weak/none finding on the *differentiator* question is the honest, valuable result — it points toward a Claude-Code-first, integration-deep identity.**

#### Q5a — Expressed/proxy demand for a vendor-portable / agent-agnostic delivery harness

**Signal strength: STRONG at the *ecosystem/standards* level; MODERATE as *voiced developer pain*; WEAK as a *purchase driver for a harness*.**

Evidence that portability demand is real and rising (strong):
- **`AGENTS.md`** adopted by **60,000+ open-source projects** (Amp, Codex, Cursor, Devin, Factory, Gemini CLI, GitHub Copilot, Jules, VS Code…) in months — a de-facto "write once, run across agents" instruction standard.
- **Agentic AI Foundation (AAIF)** under the Linux Foundation, anchored by MCP + `goose` + `AGENTS.md`, backed by OpenAI, Anthropic, Block, Google, Microsoft, AWS. Its explicit promise: agents "won't lock them into vendor-specific ecosystems" and "reduced friction … across multiple platforms." **43 new members** added as "enterprise and government adoption of open agent standards accelerates." That is consortium-scale endorsement of the anti-lock-in thesis.
- **Agent Client Protocol (ACP)** — editor↔agent portability ("switch between Claude Code, Gemini CLI, Codex, or Goose without switching editors").
- **OpenCode** (75+ providers, switch mid-session) and **Aider** (Claude/GPT/Gemini/local) exist *specifically* to avoid lock-in — and have real users.
- Voiced (moderate): "OpenCode avoids lock-in by allowing users to switch models freely," vs. Claude Code/Codex/Gemini each "tied to their vendor's models." Kiro's AWS lock-in is a **documented criticism** ("AWS-tied model constraints … undermine it at scale") — buyers *do* react negatively to lock-in.

**Which clusters the signal concentrates in:**
- **Cluster A/B — strongest, but as table stakes (see Q5b).** Every major SDLC-discipline tool is *already* agent-agnostic by construction: Spec Kit (30+ agents), Task Master (Anthropic/OpenAI/Gemini/xAI/OpenRouter/Ollama…), BMAD (Claude Code + Cursor + Gemini Gems + Custom GPTs), Agent OS ("works with any AI tool"), GSD (12+ runtimes), OpenSpec ("bring your own agent, model, and keys"). Because these are markdown/CLI-command/MCP layers, spanning agents is nearly free — so they all do it.
- **Cluster C — moderate and genuine.** Enterprises explicitly want to avoid vendor lock-in (AAIF's enterprise framing; the Kiro-vs-SpecKit lock-in debate). For regulated buyers, portability is a procurement *risk-reduction* argument, which is more load-bearing than for hobbyists.
- **Cluster D — agnostic by nature, but not a voiced demand.** MCP/markdown portability is assumed, not requested.

#### Q5b — Competitive positioning on the axis, the unmet gap, and the counter-signal

**Lock-in-vs-agnostic split of the Q3 field:**
- **Agent-agnostic (the majority):** Spec Kit, Task Master, BMAD, Agent OS, GSD (largely), OpenSpec, OpenCode, Aider.
- **Single-agent / vendor-locked:** AWS Kiro (Bedrock/IAM/billing inside AWS), Claude-Code-native tools (SuperClaude; claude-flow/SPARC is Claude-Code-centric), Devin-class (own platform).

**Is agnosticism a selling point buyers respond to?** *Partially, and mostly defensively.* It shows up as a **reason to reject a locked tool** (Kiro criticism; Spec Kit explicitly marketed as the portable anti-Kiro: "bring your own agent, your own model, your own keys, no token markup") — but it rarely shows up as the reason someone *chooses* a tool. Nobody in the sources adopts Spec Kit *because* it is agnostic; they adopt it because it is GitHub-official and works, and agnosticism is a checkbox they'd notice only in its absence.

**The unmet gap an LLM-agnostic Jurati would fill: essentially none on the agnosticism axis.** Portability is **already saturated/commoditized** in this category. An LLM-agnostic Jurati would not be differentiated by being agnostic — it would merely be *at parity* with every incumbent. There is no whitespace here.

**The counter-signal (this is the decisive, honest part — evidence users prefer deep single-agent integration over portable-but-shallow):**
1. **Developers pay a premium for depth and run multiple deep tools rather than one portable one.** The 2026 consensus in r/ClaudeCode is *"Codex for keystrokes, Claude Code for commits"* — developers run **two vendor-locked agents** and pick the best per task; they do **not** reach for a lowest-common-denominator wrapper. "Serious daily Claude Code use requires the $100 Max tier — 5x the cost of ChatGPT Plus," and they pay it because Claude Code wins on code quality (67% of blind comparisons vs Codex's 25%; Opus 4.8 at 88.6% SWE-bench). Depth wins wallet share.
2. **A portable harness is necessarily shallow at the seams.** Jurati's actual leverage lives in Claude-Code-specific machinery — subagents with isolated context windows, the Task tool, Skills, 9-event hooks, and the Unimatrix MCP substrate. A cross-agent abstraction can only use the *intersection* of Codex/Gemini/Claude Code capabilities, which strips exactly the depth that makes Jurati's spine work. This is the "portable-but-shallow vs. deep-but-locked" trade, and the market's revealed preference is depth.
3. **Even the agnostic incumbents are gravitationally single-agent.** GSD began as *Claude Code* context-engineering and only later spanned 12 runtimes; SuperClaude and claude-flow are Claude-Code-native; Kiro bet on deep single-vendor integration *despite* the lock-in criticism because depth sells to its target buyer.

**Q5 synthesis / recommendation:** Treat LLM-agnosticism as **cheap portability-by-convention (table stakes), not a headline.** Concretely: ship an `AGENTS.md`-style portable instruction/spec layer so Jurati *runs* on Codex/Gemini (parity, low cost, defensive value especially for Cluster C), **but build the differentiator deep on Claude Code** (subagents, hooks, Skills, MCP/Unimatrix) where the value actually is. **The evidence does not support "LLM-agnostic" as Jurati's positioning or its unmet gap** — it supports a **Claude-Code-first, integration-deep identity with portable convention underneath.** This is a weak-differentiator finding for Q5, and per the SCOPE that is a valid, valuable result.

---

## Unanswered Questions

- **Is the "compounding cross-cycle memory" gap (Q3) actually *wanted*, or merely *absent*?** No proxy source shows OSS devs *asking* for it; it is inferred from incumbents' statelessness complaints. Only the Cluster A primary test (Q4) can resolve this. *Reason: requires primary user contact — deferred by design.*
- **Real willingness-to-pay anywhere.** Every OSS incumbent is free; the paid tier is autonomous-agent (Devin) territory. Whether *any* cluster would pay for disciplined delivery (vs. adopt free) is unresolved. *Reason: needs pricing/primary signal, out of proxy reach.*
- **Whether Cluster C's audit demand is felt *now* or is a 2–4-quarter-out checkbox.** Sources say the latter; only discovery calls with regulated buyers settle it. *Reason: primary contact required; SOC2 gate blocks cheap testing.*
- **Star-count ground truth.** Spec Kit's star magnitude could not be pinned (40k–122k across sources). Immaterial to the conclusions (activity signals are consistent), but flagged. *Reason: conflicting secondary sources; GitHub API not queried this pass.*

## Out-of-Scope Discoveries

- **GSD is a near-clone of Jurati's shape** (discuss/plan/execute/verify phases + parallel fresh-context subagents + git-commit-per-task, 12 runtimes) already at large adoption. It is the closest existing competitor and the sharpest benchmark for "what's left to differentiate." *Warrants a dedicated competitive teardown spike before any product-facing build.*
- **"Harness" and "harness engineering" are now mainstream category terms** (Anthropic, Red Hat, metaharness). Category legitimacy is settled; category *crowding* is the risk. *Note for positioning, not a new spike.*
- **AGENTS.md + AAIF are a ready-made portability substrate.** If Jurati ever wants cheap multi-agent parity, adopting `AGENTS.md` is the near-zero-cost path — no need to invent a portability layer. *Small feature note, not a spike.*
- **BMAD already occupies the "traceability for GDPR/AI Act" delivery-audit position.** Cluster C is less unclaimed than H11 assumes. *Feed to the T8 triage.*

## Recommendations Summary

*(Demand evidence for the human triage — explicitly NOT a decision on Jurati's identity.)*

- **Q1 (demand map):** Cluster A **STRONG but saturated** > Cluster B **MODERATE (adopted, unmonetizable)** ~ Cluster C **MODERATE, emerging, costly to reach** > Cluster D **WEAK (trend, not voiced demand)**. "Others want this too" is **true for A**, qualified for B/C, and **not yet supported for D** — do not manufacture D.
- **Q2 (ICP):** Solo/small-team Claude Code developer burned by context-rot and run-to-run inconsistency, has tried Spec Kit/GSD/BMAD; lives in r/ClaudeCode, r/ClaudeAI, awesome-claude-code, and incumbent issue trackers.
- **Q3 (landscape/gap):** The category is crowded (Spec Kit official + GSD/BMAD/Task Master/Agent OS/Kiro). Jurati's only credible unmet gap is **compounding memory (Unimatrix) + enforced auditable gates + capability proof-gating** on top of a spec workflow — but that gap is *inferred, not voiced*, and must clear the **ceremony-tax** bar (market rewards *less* faff).
- **Q4 (primary test):** Run **Cluster A first** — release-and-watch instrumented on **second-cycle retention** + 5–8 discovery calls recruited from incumbent complainers; kill-criterion on whether the memory gap is named unprompted. Defer C (expensive), publish-and-watch for B (cheap/low-signal), do not run D yet.
- **Q5 (LLM-agnostic):** Portability demand is **strong as a principle / table-stakes (AGENTS.md 60k+, AAIF, ACP, OpenCode; every SDLC tool already agnostic)** but **weak as a differentiator or unmet gap**, with a **strong counter-signal that the market pays for depth** ("Codex for keystrokes, Claude Code for commits"; $100 Max tier; Kiro bets on depth despite lock-in criticism). Recommend **portable-by-convention (AGENTS.md-cheap) + differentiate deep on Claude Code** — an integration-deep, Claude-Code-first identity, not agnosticism-as-headline. A weak-differentiator Q5 result is the honest finding.
