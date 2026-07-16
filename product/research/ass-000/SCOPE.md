# SCOPE: ass-000 — Research-flow referential integrity (harness smoke test)

**Spike**: ass-000
**Status**: complete (all fields present)
**Purpose**: Validate that Jurati's research execution path works end-to-end. This is a
harness smoke test — the spike exists to prove the flow, and its findings double as a
referential-integrity audit of the research path.

---

## Goal

Answerable questions:

1. Do the research-path files in this repo have full referential integrity — i.e., does
   `CLAUDE.md`'s research routing, `.claude/protocols/uni/uni-research-protocol.md`, and the
   three research agents (`uni-spike-researcher`, `uni-external-researcher`,
   `uni-research-sm`) each point only at files, directories, and MCP tools that actually
   exist in this repo? List every cross-reference and whether its target resolves.
2. Which references in the research path are Unimatrix-specific and will NOT resolve or will
   mislead in Jurati (e.g., paths under `crates/`, Rust/JS dev agents, Unimatrix product
   assumptions, phase-prefix taxonomy)? For each, state whether it breaks the research flow
   or is merely cosmetic reference debt.

## Breadth

`code-only` — this repo's `.claude/` and `CLAUDE.md` only. No external sources.

## Approach

`investigation` — read the files, trace the references, report. No code written.

## Confidence required

`directional` — a defensible audit; no PoC needed.

## Target outputs

Design input: a referential-integrity report of the research path, with a table of every
cross-reference (source → target → resolves? yes/no) and a separate list of
Unimatrix-specific reference debt classified as flow-breaking vs. cosmetic.

## Constraints

- **Hard**: Do not modify any files. This is read-only investigation.
- **Hard**: Assess only the *research* execution path. Delivery/design/bugfix agents and
  their protocols are out of scope except where the research path references them.
- **Hypothesis** (challengeable): The pulled-in agent frontmatter (`type`/`scope`/
  `capabilities`, no `tools:` field) is assumed adequate for Claude Code subagent
  registration. If you see evidence it is not, say so.

## Dependencies

None. This spike unblocks nothing — it is a validation gate for the research harness itself.

## Prior art

- The founding model and the "0 of 19 agents ship" gap are described in GitHub issues #1 and #2.
- The research flow was assembled this session by pulling protocols and agents as-is from
  `dug-21/unimatrix`. Nothing has been adapted to Jurati yet.
