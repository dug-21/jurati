# FINDINGS: ASS-009 — Control-Model PoC (Mode A vs Mode B, head-to-head)

**Spike**: ass-009
**Date**: 2026-07-17
**Approach**: proof-of-concept / run-and-measure (synthesis of two arms)
**Confidence**: **validated** — both control-model capabilities (enforced gates + REWORK, and out-of-context identity injection) were proven at runtime in both arms. **Accepted ceilings**: identity is proven only to the client wire toward `mcp_url`/`observe_url`, NOT server-side attribution (no server introspection this env); STDIO transport untested (accepted gap). Both are carried as sequels, not resolved here.

> **Synthesis note**: nothing here is re-run. Every claim is lifted from `FINDINGS-MODE-A.md` or `FINDINGS-MODE-B.md`. Where the two arms measured the same axis differently, the divergence is surfaced explicitly (§ Head-to-head cost/latency), not averaged.

---

## 1. Head-to-head scorecard (frozen §5 rubric — mechanical and judgment reported as SEPARATE rows, never averaged)

| Axis | Mode A (LLM-in-control + enforced hooks) | Mode B (external headless controller) |
|---|---|---|
| **Enforcement — Mechanical gate** | **HELD** · §2C bypass = **BLOCKED** | **HELD** · §2C bypass = **BLOCKED** |
| **Enforcement — Judgment gate** | **HELD** · §2C bypass = **BLOCKED** (only via a **separately-spawned** `claude -p` reviewer inside the blocking hook — see R7) | **HELD** · §2C bypass = **BLOCKED** (separate schema-constrained reviewer process) |
| **REWORK loop — Mechanical** | **CLOSED** · attempts-to-PASS = **2** | **CLOSED** · attempts-to-PASS = **2** |
| **REWORK loop — Judgment** | **CLOSED** · attempts-to-PASS = **2** (SCOPE_FAIL→PASS) | **CLOSED** · attempts-to-PASS = **2** (REWORKABLE_FAIL→PASS) |
| **Cost — canonical task** | Mechanical **$0.1542** (worker only; gate = $0 model). Judgment **$0.2037** = worker $0.0896 + reviewer $0.1141 | **$0.2034** (worker; 1 model call). Mechanical gate = **$0** |
| **Cost — with 1 REWORK cycle** | Mechanical **$0.1983**. Judgment **$0.6218** = worker $0.4373 + reviewer#1 $0.0936 + reviewer#2 $0.0909 | Mechanical **$0.1654**. Judgment **$0.3007** (reviewer + worker + reviewer = 3 model calls) |
| **Latency — per gated step** | Mechanical: negligible (~tens ms node). Judgment: +3.7–7.3 s/eval (reviewer spawn 3729/5838/7314 ms); worker step ~9–15 s | Worker `claude -p` ≈ 17–25 s; mechanical gate < 50 ms; judgment reviewer ≈ 5–15 s |
| **Latency — total task wall-clock** | Mechanical canonical **14.8 s** / w-rework **23.6 s**. Judgment canonical ~**15.3 s** / w-rework **92.1 s** (worker blocks on in-hook reviewer spawns) | Canonical ≈ **26 s**; judgment REWORK ≈ **52 s** |
| **Complexity — LoC** | ~**215** throwaway JS + ~28 JSON | **297** throwaway (proxy-bridge 54 + controller 243) + 16 config |
| **Complexity — moving parts** | ~**12** (3 processes + **5 hook registrations** + 3 config + 1 instrumented client) | ~**9** (5 process types + **0 hook registrations** + 4 files + **0 settings entries**) |
| **Complexity — install steps** | **6** (incl. `--settings` hook regs + headless-approval combo) | **5** (no settings edit, no hook registration, no session restart) |
| **Complexity — session lifecycle** | Headless `-p`: **NO restart** (hooks picked up per spawn — observed 8 runs). Interactive: blocking-hook add/remove mid-session **requires restart** [documented, not observed] | **respawn-per-step** OR driven **multi-turn via `--resume <session_id>`** — **both proven** in v2.1.212 |
| **Identity P1 (hook-mutate)** | **WORKED** — sentinel reached MCP wire (`bridge-wire.log` + `p1-hook.log`) | N/A (Mode A) |
| **Identity P2 (proxy)** | N/A (Mode B) | **WORKED** — sentinel in `outbound_params`, absent from `inbound_params` |
| **Identity P3 (cooperative)** | **forward-only** — observe-channel floor met (`ContextSearch{role=ATTEST-P3-coop}`), server correlation INCONCLUSIVE (R1) | Deferred to Mode A (mechanism is control-model-agnostic; not re-run) |
| **Cross-agent seam** | **TIGHTLY-COUPLED** — exit-2 hooks, `updatedInput` rewrite, `SubagentStart.agent_type` are all Claude-Code-native; identity+enforcement do not survive a worker swap | **CLEAN** — gates enforce on artifacts + out-of-context reviewers; identity stamped at the MCP wire; only a thin per-agent spawn/envelope adapter is Claude-specific |

**Cost/latency divergence to surface (measured differently by the arms — do NOT average):**
- **Canonical cost is not directly comparable**: Mode A reports mechanical ($0.1542) and judgment ($0.2037) canonical runs separately; Mode B reports a single canonical worker cost ($0.2034). On the worker-only comparison the two modes are within ~1¢.
- **Judgment REWORK cost diverges sharply**: Mode A **$0.6218 / 92.1 s** vs Mode B **$0.3007 / 52 s**. Mode A is ~2× the cost and ~1.8× the wall-clock on the judgment REWORK loop — because A's reviewer is spawned *inside a blocking hook* so the worker blocks on it, and A's observed worker rework was itself expensive ($0.4373). This is the clearest quantitative separation in the scorecard and it favors Mode B on the judgment gate.

---

## 2. Goal-question answers (each Capability + sub-part: answer · evidence · recommendation)

### Capability 1 — Out-of-context identity injection into Unimatrix (Goal 4, HARD REQUIREMENT)

#### Q: P1 — hook-mutate (Mode A): can a `PreToolUse` hook rewrite the MCP payload to inject identity, and does it reach the wire?
**Answer**: **WORKED** (proven-to-wire; server attribution untested).
**Evidence**: The LLM authored only `{"topic":"ass009 p1 target"}` (`p1-hook.log`: `original_tool_input:{"topic":"ass009 p1 target"}`); the sentinel reached the MCP wire — `bridge-wire.log` inbound: `"arguments":{"topic":"ass009 p1 target","_attested_identity":"ATTEST-P1-modeA"}`. `lifecycle.js` (read from source) forwards client params verbatim to `mcp_url`; server response `ok:true`. A cheap non-Unimatrix sanity probe first confirmed `hookSpecificOutput.updatedInput` is honored in v2.1.212.
**Ceiling**: floor met (identity left client toward `mcp_url`); **ceiling INCONCLUSIVE** — server attribution NOT tested (no introspection). STDIO untested (accepted gap). The rewrite is a **Claude-Code-only** contract (cross-agent seam TIGHTLY-COUPLED).
**Recommendation**: Treat P1 as a proven Goal-4 pathway for a Claude-native, HTTP-transport single mode — but do not claim server attribution and do not assume it survives a non-Claude worker or STDIO.

#### Q: P2 — controller-proxy (Mode B): can the controller stamp identity at the wire?
**Answer**: **WORKED** (proven-to-wire; server attribution untested).
**Evidence**: An authentic `claude -p` worker emitted `context_lookup` with no identity; `bridge-wire.log`: `inbound_params:{"topic":"arithmetic helpers"}` → `outbound_params:{"topic":"arithmetic helpers","_attested_identity":"ATTEST-P2-modeB"}`. A second run confirmed the server answered the enriched payload ("no entries" result summarized).
**Ceiling**: floor = "reached and was accepted at the wire" confirmed; **ceiling INCONCLUSIVE** (server attribution, no introspection). STDIO untested. Unlike P1, the stamp is on the **MCP stdio JSON-RPC wire**, so it is worker-agnostic (cross-agent seam CLEAN).
**Recommendation**: P2 is the more transport-robust and worker-agnostic Goal-4 pathway; prefer it if cross-agent or transport independence is a requirement.

#### Q: P3 — cooperative hook-to-hook: does Jurati's stamp forward to Unimatrix's edge client and get attributed server-side?
**Answer**: **forward-only** (floor met; server correlation INCONCLUSIVE) — exactly the R1-predicted outcome, which SCOPE pre-accepts as informative.
**Evidence** (Mode A ran it; Mode B confirmed the mechanism is control-model-agnostic and deferred): CC delivered attested identity — `hookinput.log`: `extra:{…,"agent_type":"ATTEST-P3-coop"}` on SubagentStart. Edge client forwarded on the observe channel — `observe-frame.log`: `type=ContextSearch role="ATTEST-P3-coop"` POSTed toward `observe_url`. The MCP `context_lookup` carried NO identity (`bridge-wire.log`: `"arguments":{"topic":"ass009-p3-lookup"}`) — separate channel, no shared client-side session id.
**Ceiling**: server-side correlation of observe-role to the MCP call is the server's job and is unobservable here → **INCONCLUSIVE**. Additional fragility observed: the forward is **conditional on transcript-tail extraction** (a first run stayed `role=null`; only the second promoted). Cooperation is **not shown impossible** — only not fully testable without server introspection.
**Recommendation**: Do not depend on P3 for Goal 4 today. It is the most on-vision (two-crowns, zero client proxy) path and becomes viable the moment the Unimatrix server correlates the observe and MCP channels — flag that server-side correlation as the single unknown gating it (sequel).

### Capability 2 — Enforced gate with REWORK loop (per gate type × per mode)

#### Q: Mechanical gate — does enforcement HOLD un-bypassed and does REWORK close, in each mode?
**Answer**: **HELD in both modes; §2C bypass BLOCKED in both; REWORK CLOSED in 2 attempts in both.**
**Evidence**: Mode A — Stop hook re-runs `node test.js` itself (never trusts the agent), `exit 2` on failure; `gate.log`: `[MECH attempt 1] verdict=FAIL exit=1 … → [MECH attempt 2] verdict=PASS exit=0`; §2C "report success" over a bad artifact was BLOCKED. This directly answers ASS-008's "sockets exist but unused": in CC v2.1.212 `exit 2` from a Stop hook genuinely blocks AND re-drives — not cosmetic. Mode B — controller re-runs `node test.js` out-of-context; `attempt1=FAIL(exit=1) → refined-scope → attempt2=PASS`; §2C worker envelope `subtype=success result="TASK COMPLETE"` over `a-b` artifact → gate re-ran `exit=1` → BLOCKED.
**Recommendation**: Mechanical gating is a wash — both modes are natively un-bypassable because the verdict is an objective re-run of an artifact the LLM did not author. Choose on the other axes.

#### Q: Judgment gate — does enforcement HOLD un-bypassed and does REWORK close, in each mode?
**Answer**: **HELD in both; §2C BLOCKED in both; REWORK CLOSED in 2 attempts in both — BUT the un-bypass MECHANISM differs and is decision-relevant.**
**Evidence**: Mode A — Stop hook spawns a **separate `claude -p` reviewer** (frozen §3.2 prompt), parses verdict, `exit 2` on non-PASS; `gate-J2.log`: `[JUDGE attempt 1] verdict=SCOPE_FAIL … → [JUDGE attempt 2] verdict=PASS`. All three §3.3 un-bypass conditions met — but only by embedding an out-of-context spawned reviewer (see §3 / R7). Mode B — controller spawns a separate reviewer **constrained by `--json-schema` (`enum: PASS|REWORKABLE_FAIL|SCOPE_FAIL`)**; §2B SCOPE_FAIL held; §2C "TASK COMPLETE" over weakened-test diff → reviewer computing from the actual diff returned SCOPE_FAIL → BLOCKED.
**Shared robustness caveat (both arms independently observed)**: a reviewer prefixed prose before the verdict token ("PASS is impossible here…"), defeating naive first-token parsing and nearly passing a bad artifact. Mode A hardened with most-restrictive-token-wins; Mode B eliminated it structurally with `--json-schema`. Free-text verdict parsing is a latent bypass surface (see Out-of-Scope).
**Recommendation**: For the judgment gate, prefer the structured-output reviewer (`--json-schema`, native to Mode B's controller). Note that Mode A's only route to an un-bypassable judgment verdict is to run Mode B's core move (an out-of-context spawned reviewer) inside a hook — i.e. the two modes converge here.

---

## 3. The decision this spike exists to produce (walking the SCOPE §6 wiring explicitly)

**Step 1 — P1 WORKED ⇒ the controller is NOT strictly forced for identity.** Per SCOPE/§6, "P1 works ⇒ Mode A can deliver Goal 4 (favors one mode)." P1 worked to the wire. Stated plainly: **Goal 4 does not strictly force Mode B.** A Claude-native, HTTP-transport single mode (Mode A) can inject an attested identity the LLM never authored. This is the headline permissive result.

**Step 2 — weigh the counter-evidence the arms surfaced.** The SCOPE win condition for shipping one mode has three clauses AND a cost/latency/complexity `≤ Mode B` gate. Checking each against the evidence:

- **Clause (a) — enforces BOTH gates un-bypassed.** Mechanical: **holds in A natively.** Judgment: holds in A, but **only by embedding Mode B's core move** — a separately-spawned out-of-context reviewer inside a blocking hook (R7). An in-context reviewer the same loop controls would be bypassable. *For the judgment gate specifically, Mode A IS the controller pattern wearing a Claude-Code hook — A converges to B.* Clause (a) is met, but the judgment half of it is met by importing B.
- **Clause (b) — drives the REWORK loop.** **Holds in both modes**, both gate types, 2 attempts. No separation.
- **Clause (c) — injects attested identity (P1 or P3).** **Holds via P1** (P3 is forward-only). Met — with the shared proven-to-wire ceiling and the TIGHTLY-COUPLED seam caveat: A's P1 is a Claude-Code-only `updatedInput` contract, so identity does not survive a worker swap.
- **The `≤ Mode B` gate — cost / latency / complexity.** This is where the modes separate and it does **not** cleanly favor A:
  - *Cost/latency*: mechanical is a wash; **judgment REWORK is ~2× cost and ~1.8× wall-clock in A** ($0.6218/92.1 s vs $0.3007/52 s) because A's reviewer blocks inside the hook.
  - *Complexity*: A has **more moving parts (12 vs 9), more install steps (6 vs 5), and 5 hook registrations vs 0**; B needs **no settings mutation, no hook registration, no session restart** (and Mode B discovered `--mcp-config + --strict-mcp-config + --allowedTools` bypasses the "Pending approval" gate entirely — a *lower* install burden than the harness assumed). B's raw LoC is higher (297 vs 215) but concentrated in one controller, not spread across live-config hook registrations.
  - *Cross-agent seam*: **A is TIGHTLY-COUPLED, B is CLEAN** — a Codex worker slots behind a thin adapter in B; in A, identity+enforcement do not survive a non-Claude worker.

**Per-gate split (as SCOPE demands — do not collapse):**
- **Mechanical gate → favors neither / slight edge to simplicity.** Both natively un-bypassable; B is marginally cheaper on rework and simpler to stand up.
- **Judgment gate → favors Mode B.** A can only achieve un-bypass by becoming B-inside-a-hook, at ~2× cost/latency, with a more fragile free-text parse that B solves structurally with `--json-schema`.

**Straight recommendation on Jurati's control model:**

> **Adopt a controller-first (Mode B) control model as Jurati's execution substrate.** The SCOPE win condition for shipping Mode A *only* — "enforce both gates un-bypassed AND drive REWORK AND inject identity, all at cost/latency/complexity ≤ Mode B" — **fails its final clause for the judgment gate**: Mode A meets (a)/(b)/(c) but only by importing Mode B's out-of-context reviewer, and it does so at ~2× judgment-REWORK cost and wall-clock, with more moving parts, live-config hook registrations, and a TIGHTLY-COUPLED cross-agent seam. Goal 4 does not *force* the controller (P1 worked), but every axis where the modes separate — judgment un-bypassability, judgment cost/latency, install burden, and cross-agent portability — points to the controller. Mechanical-only, Claude-only, single-transport deployments could run Mode A; the controller is the strictly-more-capable superset and the one that keeps the cross-agent (two-crowns) door open.

This is decision-relevant for the vision's "Leverage → Configure → **Structure**" crux: the evidence supports **one control model, and that model is the controller** — not two coexisting modes. (Mode A remains a legitimate *degenerate* configuration of the same idea for the mechanical-gate, Claude-native case, but it is not a separate architecture worth maintaining.)

---

## 4. Firewall discipline — observed vs inferred vs untested

**Observed at runtime (both arms):** all gate enforcement and REWORK closures; §2C bypass BLOCKED for both gate types in both modes; P1 sentinel on the MCP wire; P2 sentinel in outbound (absent inbound); P3 forward on the observe channel and *absence* of identity on the MCP channel; per-call cost/latency from result envelopes; headless approval/enforcement flag combinations; hooks picked up per `-p` spawn with no restart; `--resume` multi-turn context retention.

**Inferred / read-from-source (not wire-sniffed past pinned TLS):** `lifecycle.js` verbatim param forwarding (source read, R2 ceiling); interactive-session hook-restart requirement (CC-documented, not observed).

**Untested / accepted gaps → sequel:**
- **Server-side attribution** for P1, P2, and P3 — whether Unimatrix *acts on* `_attested_identity` / correlates the observe role, vs merely receiving it. INCONCLUSIVE in all three; no server introspection in this env. The floor ("identity reached and was accepted at the wire") is the falsifiable result; the ceiling ("server attributed the call") is out of reach here.
- **STDIO transport** identity injection — only HTTP proven; STDIO is a known, SCOPE-accepted gap.

---

## 5. Unanswered Questions (merged, deduped)

- **Server-side attribution (P1/P2/P3)** — does the Unimatrix server act on / attribute the injected identity? INCONCLUSIVE for all three pathways; requires server introspection unavailable this env. **This is the single unknown gating the most on-vision P3 (two-crowns) path** — if the server correlates the observe and MCP channels, P3 becomes viable with zero client proxy.
- **STDIO transport** — identity injection over STDIO untested (only HTTP proven); accepted sequel.
- **Whether the server honors an unknown `_attested_identity` field vs silently ignores it** — untested (follows from the attribution gap).
- **P3 forward reliability** — the observe-channel forward is conditional on transcript-tail extractability (one run stayed `role=null`); even the floor is timing-dependent. Robustness of the `index.js` SubagentStart→ContextSearch promotion is unquantified.

---

## 6. Out-of-Scope Discoveries (merged, deduped — one line each + why it matters)

- **Free-text verdict parsing is a latent bypass surface** (both arms) — a reviewer that prefixes reasoning before the verdict token defeats naive first-line parsing and can silently PASS a bad artifact. *Matters: real judgment gates need structured verdict output, not token scraping.* **Sequel-worthy** as a hardening requirement.
- **`--json-schema` on `claude -p` is a reusable un-bypassable-verdict primitive** (Mode B) — turns an LLM reviewer into a parseable oracle for any controller-enforced gate. *Matters: it is the structural fix to the free-text-parse bypass above; candidate convention.*
- **`--mcp-config` + `--strict-mcp-config` bypasses the "Pending approval" MCP gate** (Mode B) — contradicts the R4 assumption that `enableAllProjectMcpServers` is required; simplifies all headless Unimatrix onboarding. *Matters: candidate convention for any headless worker; materially lowers Mode B install burden.*
- **Capable workers self-heal before the gate fires** (Mode A) — with Read/Bash access the worker often corrected the seeded fault before stopping, so the gate never fired. *Matters: REWORK demonstrations (and gate tests) need worker inspection tools restricted to stay deterministic.*
- **Claude spontaneously refuses probe-shaped prompts** (Mode B) — an over-explicit "call the tool with exactly {…}, add nothing" prompt was refused. *Matters: a controller driving Claude headlessly must frame tool calls as genuine work, not tests, or scripted tasks silently break.*
- **The observe channel already carries attested `agent_type` server-ward, independent of the MCP call** (Mode A) — if the Unimatrix server ever correlates the two channels, P3 becomes viable with zero client proxy. *Matters: this is the one server-side change that unlocks the most on-vision identity path.* **Sequel-worthy.**

---

## 7. Recommendations Summary (read this first)

- **P1 (Mode A hook-mutate identity):** **WORKED** to the wire (server attribution untested) — Goal 4 does **not** strictly force the controller.
- **P2 (Mode B proxy identity):** **WORKED** to the wire, worker-agnostic (CLEAN seam) — the more transport/agent-robust Goal-4 pathway.
- **P3 (cooperative identity):** **forward-only / INCONCLUSIVE** (R1-predicted, SCOPE-accepted) — do not depend on it yet; it unlocks with server-side channel correlation.
- **Mechanical gate:** HELD + REWORK CLOSED (2 attempts), §2C BLOCKED, in **both** modes — a wash, natively un-bypassable in both.
- **Judgment gate:** HELD + REWORK CLOSED in both, **but favors Mode B** — Mode A achieves un-bypass only by embedding Mode B's out-of-context reviewer inside a hook, at ~2× judgment-REWORK cost ($0.62 vs $0.30) and ~1.8× wall-clock (92 s vs 52 s), with a fragile free-text parse Mode B solves via `--json-schema`.
- **Cost/complexity/seam:** Mode B is simpler to operate (9 vs 12 moving parts, 0 vs 5 hook registrations, no settings mutation/restart) and CLEAN cross-agent vs A's TIGHTLY-COUPLED.
- **One-mode-vs-two call:** **Ship ONE control model — the controller (Mode B / controller-first).** Mode A meets the capability clauses but fails the `≤ Mode B` cost/complexity clause on the judgment gate and converges to B to get there; the controller is the strictly-more-capable superset that also preserves the cross-agent (two-crowns) path.
