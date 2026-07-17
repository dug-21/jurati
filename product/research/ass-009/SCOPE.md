# ASS-009 — Control-Model PoC: Enforced-Hooks (Mode A) vs. Headless Controller (Mode B), Head-to-Head

*Post-vision proof-of-concept spike · run-and-measure · decides one-mode-vs-two and whether Goal 4 forces the controller*

**Spike**: ass-009
**Assigned agent**: `uni-spike-researcher` (hands-on PoC of Jurati's own execution substrate; read-only in Unimatrix *knowledge* — it may invoke Unimatrix MCP calls as test targets but stores no findings as knowledge)
**Status**: scope drafted — awaiting human detailed review
**Predecessor**: ASS-008 (code teardown of ruflo — established the two control models exist; runtime never observed)

---

## The question behind the spike

ASS-008 read the code and found two disjoint control architectures. It explicitly did **not** run
anything: *"Runtime behavior not observed… a PoC spike would be needed to validate."* This spike is
that PoC. It drives both control models on real tasks and **measures** which one Jurati should be —
and, critically, whether the ★ **primary goal (Goal 4, agent identity)** can be delivered in the
cheaper control model or *forces* the controller.

Two control models, run head-to-head on the **same** tasks, each in its **own git worktree**
(per `uni-git` worktree conventions — isolation is mandatory; see Constraints):

- **Mode A — LLM-in-control + enforced hooks.** Claude Code runs the loop; deterministic gates are
  Claude Code `PreToolUse`/`PostToolUse` hooks that *actually block* (`exit 2`), not ruflo's cosmetic
  `exit 1`. Requires a `.claude/settings.json` hook registration.
- **Mode B — external headless controller.** A controller process spawns `claude -p --output-format
  json`, parses envelopes, and enforces gates from *outside* the LLM context; owns the MCP transport.

## Why it matters

- **Decides one-mode-vs-two** (`PRODUCT-VISION.md`: "Leverage → Configure → **Structure**") — the open
  crux the vision has been holding on. Result unblocks the two-crowns / center-lane vision edits.
- **Tests the ★ primary goal mechanically (Goal 4 — close Unimatrix's identity gap).** Injecting an
  attested agent identity *the LLM did not put there* is the differentiator "no other platform can
  touch." Whether it's achievable in Mode A or only Mode B is the single highest-leverage finding here.
- **Feeds Goal 5 (spend-minimized)** — cost/latency of a re-injecting controller vs. the in-context
  loop is measured, not assumed (ruflo's own quota-blowout P0 #2661 is the warning).
- **Tests "simplify the environment"** — install/lifecycle burden of each model is a scored dimension.

## The two capabilities the PoC must prove

### Capability 1 — Out-of-context identity injection into Unimatrix (Goal 4, HARD REQUIREMENT)

Get in front of a Unimatrix MCP call and attach an **agent type/identity the LLM did not provide**.
**Only the HTTP custom-connection transport is testable in this environment (accepted); STDIO is a
known gap — noted, not proven here (sequel).** Test on a **read-class** call (`context_lookup`) to
prove interception **without polluting the knowledge base**. Three candidate pathways — establish which
work:

- **P1 — hook-mutate (Mode A):** can a Claude Code `PreToolUse` hook *rewrite* the MCP call payload to
  inject identity, or can it only block?
- **P2 — controller-proxy (Mode B):** controller owns the transport (proxies Unimatrix's **HTTP**) and
  stamps identity at the wire. (STDIO-child variant is the same idea but out of scope this env.)
- **P3 — cooperative hook-to-hook:** Jurati's hook stamps an attested identity out-of-band →
  **Unimatrix's own edge/hook client (PreToolUse) reads and forwards it** to server enforcement.
  **Order of hooks may matter** — test registration/execution order. This is the most on-vision path
  (two-crowns cooperation). A negative or inconclusive result is an acceptable, informative outcome.

*Decision wiring:* P1 works ⇒ Mode A can deliver Goal 4 (favors one mode). P1 fails & only P2 works ⇒
**Goal 4 forces the controller.** P3 works ⇒ cooperation delivers Goal 4 without a full proxy.

### Capability 2 — Enforced gate with REWORK loop (delivery-spine control)

Not binary block/pass. The gate fails → the control model drives a **REWORK with a refined scope** that
corrects the failure → re-attempt → pass. Maps onto the existing `uni-validator` verdict
(PASS / REWORKABLE FAIL / SCOPE FAIL). Prove the control model can (a) enforce a verdict
**un-bypassably** and (b) close the loop via refined-scope re-attempt.

**Sample two gate *types* (not all five review kinds — these two span the spectrum):**
- **Mechanical gate** — e.g. test-results/coverage or PR-merge check. Objective pass/fail; tests hard
  enforcement + block-until-met.
- **Judgment gate** — e.g. scope or design review. Needs an *LLM reviewer verdict* that must then be
  enforced un-bypassably; tests whether REWORKABLE-FAIL holds and refined-scope REWORK closes it.

## Execution steps

*Phase 0 — Setup.* One worktree per arm per `uni-git`. Capture `claude --version`, model, auth.
Confirm a running Unimatrix reachable via **HTTP** (only transport testable this env; STDIO noted gap).
Define **one** canonical task reused by both arms (apples-to-apples) plus an **adversarial** variant
that tries to trip each gate. All PoC code is **throwaway scaffolding** — captured as evidence in
FINDINGS.md, discarded with the worktrees; nothing ships.

*Phase 1 — Mode A (worktree A).* Register a real blocking (`exit 2`) `PreToolUse` hook in that
worktree's `.claude/settings.json`. Run `claude -p` on the canonical + adversarial tasks. Record: does
the gate hold un-bypassed? Does REWORK-with-refined-scope close a failure? Attempt identity-injection
pathways **P1** and **P3**. Note the settings.json + session-lifecycle burden (does a live session need
restart to pick up hooks? — capture as a product-relevant cost).

*Phase 2 — Mode B (worktree B).* A controller spawns `claude -p --output-format json`; enforces the
**same** gates from outside. Probe the two big unknowns: **multi-turn drive vs. re-spawn-per-step**
(candidates: `--resume`, `--continue`, `stream-json`) and **what enforcement flags actually exist**
(`--allowedTools` etc. — discover, don't assume). Attempt identity-injection pathway **P2** over
HTTP. Assess the **cross-agent seam** (is the interface abstract enough a Codex adapter could
slot in? — assess, don't build).

*Phase 3 — Score both, same axes:* enforcement (un-bypassable?), cost (tokens/$ per task — Goal 5),
latency (wall-clock per gated step), complexity/operability (LoC, moving parts, install + session
lifecycle burden), identity-injection (which pathways worked, over HTTP), cross-agent seam.

## Success criteria (the decision this produces)

- **Mode A wins → ship one mode** *only if* it (a) enforces both sampled gates un-bypassed, (b) drives
  the REWORK loop, **and (c) injects attested identity into the Unimatrix call (P1 or P3)** — all at
  cost/latency/complexity **≤ Mode B**.
- **If Mode A cannot do (c)** → the controller (Mode B) is required for Goal 4 → evidence for two modes
  or controller-first.
- Different gate *types* may need different criteria; report per-type, don't average them away.

## Deliverable — `FINDINGS.md`

Head-to-head scorecard on all axes; the identity-injection pathway results (P1/P2/P3 × transport) with
the explicit one-mode-vs-two implication; the REWORK-loop result per gate type; a straight
recommendation on Jurati's control model — **with the firewall honored: claim only what was observed at
runtime, flag what was inferred.**

## Known constraints & dependencies

- **Isolation is mandatory.** All hook registration happens in a **worktree's** `.claude/settings.json`
  per `uni-git`. **Never modify this repo's live `.claude/settings.json`** — a blocking hook in live
  config would break operating sessions.
- **Unimatrix knowledge is read-only** — invoke MCP calls as test targets (read-class only); store **no
  findings as knowledge**; do not pollute the knowledge base.
- **Only HTTP is testable in this environment (accepted).** Capability 1 is proven over HTTP only;
  **STDIO is a known, accepted gap** — carried as a sequel, not a blocker for this spike.
- **P3 depends on visibility into Unimatrix's edge/hook client.** If its internals aren't inspectable,
  run a **black-box** propagation test; **inconclusive is an acceptable, informative outcome.**
- **PoC altitude** — throwaway scaffolding to prove capability, not production hardening. Bounded to:
  2 capabilities × (identity: HTTP transport, 3 pathways) × 2 gate types × 2 control models. Explicitly
  **out:** the other three review types, a real cross-agent adapter, production hardening, adopting any
  ruflo code.

---

*Sequel candidates (do NOT scope here): **prove identity injection over STDIO** (the transport this env
can't test); a real cross-agent adapter (Codex) once Fork A resolves; a brief teardown of `metaharness`
if the "blend the useful 2%" positioning firms up.*
