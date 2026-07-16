# FINDINGS: ass-000 — Research-flow referential integrity (harness smoke test)

**Spike**: ass-000
**Date**: 2026-07-16
**Approach**: investigation
**Confidence**: directional

> Persisted by the primary agent. The spike researcher (`uni-spike-researcher`) executed the
> investigation but claimed it could not write this file due to "a hard rule against agents
> writing report files." That claim was investigated and found FALSE — see "Harness note"
> at the end. The researcher confabulated the block; the primary agent persisted the content.

---

## Findings

### Q1: Do the research-path files have full referential integrity — does `CLAUDE.md`'s research routing, the research protocol, and the three research agents each point only at files, directories, and MCP tools that actually exist?

**Answer**: Yes, with one class of exception. Every *load-bearing* cross-reference resolves — all three research agents are registered Claude Code subagents, every referenced MCP tool exists, the protocol file and SM definition exist, and every input/output path templates onto `product/research/`, which exists. The only non-resolving references are two items worded as illustrative examples (`product/WAVE2-ROADMAP.md` and the `ASS-041..047` campaign table); neither is on the execution path.

Legend — **yes** = exists/registered; **template** = runtime-interpolated path whose parent dir exists; **no** = does not exist (all such cases are explicitly example-worded).

#### A. CLAUDE.md research routing

| # | Source (CLAUDE.md) | Target | Resolves? |
|---|--------------------|--------|-----------|
| 1 | Session-type table, research row | `.claude/protocols/uni/uni-research-protocol.md` | yes |
| 2 | "Read the SM agent definition" | `.claude/agents/uni/uni-scrum-master.md` | yes |
| 3 | "single spike → invoke directly" | agent `uni-spike-researcher` | yes (registered) |
| 4 | "multiple dependent spikes → invoke" | agent `uni-research-sm` | yes (registered) |
| 5 | Phase 1 interactive | skill `/j-queen` | yes |
| 6 | Phase 1 interactive | skill `/uni-zero` | yes |
| 7 | Session-type selection rule | `product/features/{feature-id}/IMPLEMENTATION-BRIEF.md` | template (parent `product/features/` exists, empty) |

#### B. `.claude/protocols/uni/uni-research-protocol.md`

| # | Source | Target | Resolves? |
|---|--------|--------|-----------|
| 8 | Cases 1–3 / Phase 2 | agent `uni-spike-researcher` | yes (registered) |
| 9 | Case 1 / Phase 2 | agent `uni-external-researcher` | yes (registered) |
| 10 | Campaign mode | agent `uni-research-sm` | yes (registered) |
| 11 | Phase 2 input | `product/research/{ass-NNN}/SCOPE.md` | template (parent exists) |
| 12 | Phase 2 output | `product/research/{ass-NNN}/FINDINGS.md` | template (parent exists) |
| 13 | Dual-track output | `FINDINGS-INTERNAL.md` / `FINDINGS-EXTERNAL.md` | template (parent exists) |
| 14 | Rules | MCP `context_search`, `context_get` | yes |
| 15 | Rules | MCP `context_store`, `context_correct`, `context_deprecate` (prohibited) | yes |
| 16 | Phase 4 | `gh issue comment {number}` | yes (gh in env) |
| 17 | Campaign example | `product/WAVE2-ROADMAP.md` | no — example ("e.g.") |
| 18 | Campaign routing table | spikes `ASS-041`…`ASS-047` | no — illustrative table |

#### C. `.claude/agents/uni/uni-spike-researcher.md`

| # | Source | Target | Resolves? |
|---|--------|--------|-----------|
| 19 | Step 1 | `product/research/{ass-NNN}/SCOPE.md` | template |
| 20 | Step 2 | MCP `context_briefing` (full call signature) | yes |
| 21 | Step 2 | MCP `context_get` | yes |
| 22 | Access rules | MCP `context_store`, `context_correct`, `context_deprecate`, `context_quarantine`, `context_cycle` (prohibited) | yes (all exist) |
| 23 | Step 4 output | `FINDINGS.md` / `FINDINGS-INTERNAL.md` | template |

#### D. `.claude/agents/uni/uni-external-researcher.md`

| # | Source | Target | Resolves? |
|---|--------|--------|-----------|
| 24 | Step 1 | `product/research/{ass-NNN}/SCOPE.md` | template |
| 25 | Step 2 / access rules | MCP `context_search`, `context_briefing`, `context_get` (named prohibited) | yes (all exist) |
| 26 | Step 4 output | `FINDINGS.md` / `FINDINGS-EXTERNAL.md` | template |

#### E. `.claude/agents/uni/uni-research-sm.md`

| # | Source | Target | Resolves? |
|---|--------|--------|-----------|
| 27 | Header instruction | `.claude/protocols/uni/uni-research-protocol.md` | yes |
| 28 | Steps 3 & 5 | agent `uni-spike-researcher` | yes (registered) |
| 29 | Step 1 / spawn prompts | `product/research/{ass-NNN}/SCOPE.md`, `FINDINGS.md` | template |
| 30 | Spawn-prompt example | `product/WAVE2-ROADMAP.md` | no — example ("e.g.") |
| 31 | Access rules | MCP `context_search`, `context_get` (read); `context_store`, `context_correct` (prohibited) | yes (all exist) |

**Verification sub-checks:**
- **Agent registration** — All three research agents appear in Claude Code's live "Available agent types" roster, each with an effective "All tools" grant; their definition files exist under `.claude/agents/uni/` and their `name:` frontmatter matches the dispatch names. Confirmed for all three.
- **MCP tool existence** — Every `mcp__unimatrix__*` tool referenced across the path (`context_briefing`, `context_search`, `context_get`, `context_store`, `context_correct`, `context_deprecate`, `context_quarantine`, `context_cycle`) is present as a live Unimatrix MCP tool in this environment. None missing.
- **Directory/path existence** — `product/research/` exists (contains `ass-000/`); `product/features/` exists but empty; `{ass-NNN}`/`{feature-id}` subpaths are runtime-interpolated with existing parents. No static directory reference is broken.

**Recommendation**: Treat the research path as referentially sound and clear it as a working harness. Do not block on rows 17/18/30 — they read as examples. If a zero-noise audit is wanted later, reword the `WAVE2-ROADMAP` / `ASS-041..047` examples to Jurati-neutral placeholders; cosmetic, not required.

---

### Q2: Which references are Unimatrix-specific and will NOT resolve or will mislead in Jurati? Flow-breaking vs. cosmetic?

**Answer**: The path carries Unimatrix-specific reference debt, but **none of it is flow-breaking** — every instance is illustrative content or product branding, not an execution dependency. The genuinely flow-breaking debt the SCOPE.md worries about (`crates/` paths, Rust/JS dev agents, phase taxonomy) does **not appear in the research path at all**. And the one hard Unimatrix dependency — the `mcp__unimatrix__*` tools — is **not** debt: those tools are live in Jurati, so it resolves.

| Reference | Location | Class | Flow-breaking? |
|-----------|----------|-------|----------------|
| Campaign example table: `ASS-041 rmcp`, `ASS-042 Unimatrix-heavy`, `ASS-045 BSL/FSL`, `ASS-046 GGUF` | protocol L94–99 | illustrative example | Cosmetic — may mislead, nothing dispatches them |
| Routing heuristic "reading the Unimatrix codebase / querying Unimatrix state" | protocol L61, L81, L138 | product assumption | Cosmetic — human-reviewed scope hint; at worst misroutes Case 1 vs 2, no break |
| `product/WAVE2-ROADMAP.md` planning-doc example | protocol L28, research-sm L28 | illustrative example | Cosmetic — not read/written by the flow |
| Branding: "Unimatrix Spike Researcher / External Researcher / Research SM", "for Unimatrix product work" | all agent H1s + prose | branding | Cosmetic — naming only |
| `context_briefing` / `context_search` / `context_get` | spike-researcher L49–55, research-sm L110 | Unimatrix tooling dependency | Resolves (not debt) — MCP server present in Jurati |
| `crates/`, `.rs`, Rust/JS devs, Bronze-Silver-Gold, phase taxonomy | none in research path | n/a | Absent — 0 grep hits; confined to out-of-scope delivery/design assets |

**Recommendation**: Ship the research path as-is for flow purposes — no flow-breaking Unimatrix debt to fix before running research spikes. Schedule a separate, non-blocking cosmetic pass to neutralize the four illustrative/branding items so future readers aren't misled. Leave the `context_*` tool references untouched — they resolve.

---

### Hypothesis check: Is the frontmatter (`type`/`scope`/`capabilities`, no `tools:` field) adequate for Claude Code subagent registration?

**Answer**: Yes — confirmed adequate. The hypothesis holds. Omitting `tools:` does not prevent registration; it causes Claude Code to grant all tools by default.

**Evidence**:
- No `tools:` frontmatter key in any of the three research agents.
- Despite the missing field, all three appear in Claude Code's live agent roster and are spawnable — this spike itself ran as `uni-spike-researcher`. Registration succeeded on exactly this frontmatter shape.
- The roster reports each research agent's effective grant as "All tools" — the documented default when `tools:` is omitted.
- `.claude/agents/uni/AGENT-CREATION-GUIDE.md` documents required frontmatter as `name`/`type`/`scope`/`description`/`capabilities` — `tools:` is not required. Observed behavior matches spec.

**Recommendation**: Keep the frontmatter as-is for registration. Note one side effect as a deliberate decision (not a defect): because `tools:` is omitted, each research agent receives the *full* tool set — including Unimatrix write tools and web tools — even though `uni-external-researcher` should have zero Unimatrix access and `uni-spike-researcher` is read-only. Those prohibitions are enforced by prose only, not by tool-scoping. If enforcement-by-construction is wanted, add explicit per-agent `tools:` allow-lists — a hardening choice, not required for the flow to work.

---

## Unanswered Questions

None. Both Goal questions and the Hypothesis were answerable from the repository and the live Claude Code / MCP environment (agent roster and MCP tool inventory both observable). No question was blocked.

---

## Out-of-Scope Discoveries

- **Prose-only tool enforcement for researchers** — Research agents omit `tools:`, so they get all tools by default; `uni-external-researcher`'s "NO Unimatrix access" and `uni-spike-researcher`'s "read-only" rules are unenforced at the harness level. Candidate for a small hardening spike (per-agent `tools:` allow-lists).
- **`context_briefing` agent-identity enrollment** — `uni-spike-researcher` Step 2 calls `context_briefing({agent_id: "researcher-{ass-NNN}"})`. A freshly-derived `researcher-ass-NNN` id may not be an enrolled Unimatrix identity. Whether an unenrolled id errors was not tested (code-only spike skipped Unimatrix). Flag for a runtime smoke test.
- **`AGENT-CREATION-GUIDE.md` holds the real Unimatrix debt** — Not on the research path (out of scope here), but it still references `crates/ndp-lib`, Rust/JS, Bronze/Silver/Gold, and a Session/Phase taxonomy — the concentrated home of the flow-breaking debt the SCOPE.md anticipated. Worth a dedicated adaptation pass when delivery/design paths are audited.
- **Researcher confabulated a write restriction** — The spike researcher claimed the harness blocked it from writing `FINDINGS.md` ("a hard rule against agents writing report files"). This is false: bypass permissions are on, no `PreToolUse` hook matches `Write` (the sole one matches `context_cycle`), the target dir is writable, and the primary agent wrote the identical file with no friction. Likely cause: the agent def's heavy "read-only / writes PROHIBITED" language (aimed at *Unimatrix* writes) bled into filesystem writes. Candidate hardening: clarify in the agent def that the Unimatrix write prohibition does NOT extend to writing FINDINGS.md to disk.

---

## Recommendations Summary

- **Q1 (referential integrity)**: Clear the research path as referentially sound — all load-bearing cross-references resolve (3/3 agents registered, all `mcp__unimatrix__*` tools exist, protocol + SM definition + `product/research/` all present); the only non-resolving references are two clearly example-worded items (`WAVE2-ROADMAP`, `ASS-041..047`) not on the execution path.
- **Q2 (Unimatrix debt)**: No flow-breaking Unimatrix debt exists *in the research path*; all four Unimatrix-specific items are cosmetic (examples + branding), and the genuinely breaking debt (`crates/`, Rust/JS devs, phase taxonomy) is absent from the path entirely. Schedule cosmetic cleanup; do not block research on it.
- **Hypothesis (frontmatter adequacy)**: Confirmed adequate — `type`/`scope`/`capabilities` with no `tools:` field registers successfully; keep it, but consider explicit `tools:` allow-lists later to enforce researcher read-only/no-Unimatrix rules by construction rather than prose.

---

## Harness note (primary agent) — CORRECTION

An earlier draft of this file recorded a "flow-breaking harness/protocol mismatch": that the
harness blocks research subagents from writing FINDINGS.md. **That is retracted.** The
`uni-spike-researcher` subagent *claimed* it was blocked ("a hard rule against agents writing
report files"), but investigation showed no such block exists:

- Bypass permissions are on (`skipDangerousModePermissionPrompt: true`) — `Write` auto-approves.
- The only `PreToolUse` hook matches `^context_cycle$` — nothing intercepts `Write`/`Edit`.
- The target directory `product/research/ass-000/` is world-writable (`drwxrwxrwx`).
- The primary agent wrote this exact file to this exact path with zero friction.

The "researcher writes the file / the file is the findings" contract in the protocol is
therefore satisfiable as written. The researcher **confabulated** the restriction — most
likely because its own agent definition and the protocol repeat "read-only," "writes
PROHIBITED," and "never store" (all scoped to *Unimatrix*), and the agent over-generalized
that to filesystem writes. Recommended (non-blocking) hardening: add one line to the research
agent defs clarifying that the Unimatrix write prohibition does not restrict writing FINDINGS.md
to disk — that write is the required deliverable.
