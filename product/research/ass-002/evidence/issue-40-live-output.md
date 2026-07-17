## Results — raw Unimatrix output from the live arch-research instance

Run read-only by a factory agent against the arch-research Unimatrix (`agent_id: jurati-req-researcher`) on 2026-07-16. All five queries below; #1–#4 are the load-bearing ones. Output is **verbatim** — field names, nulls, and zeros exactly as returned. No secrets/PII were present to redact (session UUIDs and content hashes are kept as-is; they are internal identifiers, not credentials).

**Two schema notes up front, because they change how you should read this:**

- **The run stamp is `wf-v<semver>`, not `wf:<version>`.** Query #2's cycle tags round-trip back as `"wf-v0.14"` (a flat tag), not a `wf:0.14` namespaced tag. Adjust ASS-005 accordingly.
- **Run grouping is NOT engine-native.** The DB `feature_cycle` field is empty (`""`) on every node we curate. A "run" (`opcost-001`) exists *only* as a curator-applied tag. This is the ground truth behind your Q3 — see #3.

---

### 1. The board query (§14.4) — one goal's capability board, hydrated

**Targeted:** `goal_id = 113` ("Know & ration the garage's Claude operating cost across repos").

**Canonical call issued:**
```
context_graph(mode:"subgraph", seed_ids:[113], max_depth:1,
              edge_types:["Advances"], direction:"incoming", detail:"full")
```

Note the one shape-difference from your template: our IDs are **integers**, not strings — `seed_ids:[113]`, not `["113"]`. The grade rides a `grade:<...>` **tag** on each node (`grade:missing` / `grade:partial`); none on this board is `proven` yet (see #4 for a proven node from another board). Every edge is stored `capability → goal` as `Advances` and returned with `"direction":"outgoing"` (canonical stored direction) even though we traversed `incoming` — that's expected per the tool contract.

Raw output:
```json
{"nodes":[{"id":113,"title":"Know & ration the garage's Claude operating cost across repos","content":"kind: goal\nname: Know & ration the garage's Claude operating cost across repos — measure current subscription usage, attribute it per repo+workstream, allocate a fixed usage ceiling across multiple project repos, and detect overrun. Piloted on arch-research, extensible to the rest.\nwhy: Claude is the garage's load-bearing platform (CLAUDE.md). Unmeasured, we cannot separate a productive burn from a wasteful one, and multiple repos silently compete for one shared subscription ceiling. This is the garage's OWN operating cost — distinct from the shd product's inference/escalation cost (#7 N1 / #99 cost-governance).\nsuccess: This repo's Claude usage is measured and attributable; a reproducible policy allocates the fixed subscription ceiling across repos; overrun against a repo's share is detected before the shared ceiling is exhausted.\nout-of-scope: The shd product's local-inference/escalation cost (#7/#99). Per-token API accounting except where a repo is explicitly on API billing.\nmode: poc-required\npilot: arch-research first; cross-repo by design (N-b).","topic":"opcost","category":"goal","tags":["goal","opcost","opcost-001"],"source":"","status":"Active","confidence":0.535493765503286,"created_at":1783651117,"updated_at":1783651117,"last_accessed_at":1784229867,"access_count":4,"supersedes":null,"superseded_by":null,"correction_count":0,"embedding_dim":384,"created_by":"opcost-001-curator","modified_by":"","content_hash":"e1147a268d10dd7bf9f4f096e5e3f651c0b54a92033c0f359dc2f735ed9b4ea3","previous_hash":"","version":1,"feature_cycle":"","trust_source":"agent","helpful_count":0,"unhelpful_count":0,"pre_quarantine_status":null},{"id":118,"title":"N-a — Subscription-faithful unit","content":"category: capability\nkind: nfr\nname: Subscription-faithful unit — report usage-against-limit (5h window + weekly cap), not an invented $ proxy, unless a repo is on API billing (modeled explicitly).\nwhy: A list-price $-estimate proxy would misstate the real constraint (subscription quota), corrupting allocation.\ndone_when: reported numbers reconcile to the actual subscription consumption model, not a $ proxy.\nstatus: missing","topic":"opcost","category":"capability","tags":["grade:missing","nfr","opcost","opcost-001"],"source":"","status":"Active","confidence":0.4667301780645799,"created_at":1783651136,"updated_at":1783651136,"last_accessed_at":0,"access_count":0,"supersedes":null,"superseded_by":null,"correction_count":0,"embedding_dim":384,"created_by":"opcost-001-curator","modified_by":"","content_hash":"f2c4ccd09fb31b1650c9a116ebb932ac6e2a314fa56226ab573c87092691354b","previous_hash":"","version":1,"feature_cycle":"","trust_source":"agent","helpful_count":0,"unhelpful_count":0,"pre_quarantine_status":null},{"id":119,"title":"N-b — Generalizes cross-repo without re-foundation","content":"category: capability\nkind: nfr\nname: Generalizes cross-repo without re-foundation — piloted on arch-research, the measurement + allocation approach extends to other repos without rework (the N4-analog).\nwhy: The point is cross-repo rationing; a one-repo-only design fails the goal.\ndone_when: the design does not foreclose multi-repo rollout.\nstatus: missing","topic":"opcost","category":"capability","tags":["grade:missing","nfr","opcost","opcost-001"],"source":"","status":"Active","confidence":0.4667301948768123,"created_at":1783651139,"updated_at":1783651139,"last_accessed_at":0,"access_count":0,"supersedes":null,"superseded_by":null,"correction_count":0,"embedding_dim":384,"created_by":"opcost-001-curator","modified_by":"","content_hash":"13d700b06d3b21c205cc1f7d99b96467fc188391f79dcf52ea9c57398000db13","previous_hash":"","version":1,"feature_cycle":"","trust_source":"agent","helpful_count":0,"unhelpful_count":0,"pre_quarantine_status":null},{"id":120,"title":"N-c — Low-overhead","content":"category: capability\nkind: nfr\nname: Low-overhead — measurement/enforcement must not itself consume meaningful budget or add session friction.\nwhy: An instrument that distorts what it measures (or burns the ceiling it guards) is self-defeating.\ndone_when: instrumentation overhead is negligible vs the usage it tracks.\nstatus: missing","topic":"opcost","category":"capability","tags":["grade:missing","nfr","opcost","opcost-001"],"source":"","status":"Active","confidence":0.46673020608496807,"created_at":1783651141,"updated_at":1783651141,"last_accessed_at":0,"access_count":0,"supersedes":null,"superseded_by":null,"correction_count":0,"embedding_dim":384,"created_by":"opcost-001-curator","modified_by":"","content_hash":"68f51aa10cb7a408e4ae995a920cc7aaa89615f5653d4ee278f4ecac48490c35","previous_hash":"","version":1,"feature_cycle":"","trust_source":"agent","helpful_count":0,"unhelpful_count":0,"pre_quarantine_status":null},{"id":125,"title":"B1 — Measure current Claude usage","content":"category: capability\nkind: business\nname: Measure current Claude usage — capture what this repo actually consumes (tokens / sessions / rolling-window load) in a queryable form.\nwhy: You cannot govern or allocate what you cannot see; measurement is the root of the whole board.\ndone_when: a real artifact reports this repo's Claude usage over a period with no manual tallying.\nstatus: partial\nproven_by: product/research/opcost-001/poc/opcost_poc.py (executed 2026-07-10, opcost-001; per-repo/per-day token buckets over real transcripts, no manual tallying — demonstrated altitude, not yet a standing autonomous instrument)\nnote: feasibility RESOLVED by opcost-001. Per-repo/per-day token usage is reconstructable from local transcripts (~/.claude/projects/**/*.jsonl) keyed on cwd; counts are reliable only when all four message.usage fields are summed (naive input+output undercounts ~60x — see finding). Subscription 5h/weekly quota-% is NOT officially observable (only undocumented /api/oauth/usage or CC>=2.1.x statusline stdin); the honest bucket unit is a self-defined token budget, not Anthropic's quota-% (see N-a resolution).","topic":"opcost","category":"capability","tags":["business","grade:partial","opcost","opcost-001"],"source":"","status":"Active","confidence":0.46691551795251107,"created_at":1783684191,"updated_at":1783684191,"last_accessed_at":0,"access_count":0,"supersedes":114,"superseded_by":null,"correction_count":0,"embedding_dim":384,"created_by":"opcost-001-curator","modified_by":"opcost-001-curator","content_hash":"3705aceb2ae0f6a4860221cb3d62f250198e35bddb303acbfafcf26f6595d9fa","previous_hash":"67fb600d283c50747df5d7ba1c8d4461c3bf2a408eb112f2e31012fff7c50fc8","version":2,"feature_cycle":"","trust_source":"agent","helpful_count":0,"unhelpful_count":0,"pre_quarantine_status":null},{"id":127,"title":"B2 — Attribute usage to repo + workstream","content":"category: capability\nkind: business\nname: Attribute usage to repo + workstream — slice usage by repo AND by activity class (interactive dev vs autonomous factory runs).\nwhy: A single aggregate cannot drive allocation or spot a wasteful workstream; attribution is what makes usage actionable.\ndone_when: any usage total decomposes to repo + workstream from captured data.\nstatus: partial\nproven_by: .claude/skills/opcost/opcost.py ; .claude/skills/opcost/SKILL.md (executed 2026-07-10 on real data). Repo attribution demonstrated by the opcost skill (per-repo split, e.g. 96/4 arch-research vs hotspot-bank). PARTIAL: the WORKSTREAM axis (interactive dev vs autonomous factory runs) is NOT yet split — that half of done_when remains open.","topic":"opcost","category":"capability","tags":["business","grade:partial","opcost","opcost-001","opcost-002"],"source":"","status":"Active","confidence":0.4670747046598799,"created_at":1783712554,"updated_at":1783712554,"last_accessed_at":0,"access_count":0,"supersedes":115,"superseded_by":null,"correction_count":0,"embedding_dim":384,"created_by":"opcost-002-curator","modified_by":"opcost-002-curator","content_hash":"3caa3efb49b221b6c394707cea3a7fe7dcff27aa86f474b94ccc62ee6d619a24","previous_hash":"e7b08a38d2566d303bbd668a81fa4718e174a9ca287f73de8176696985776f28","version":2,"feature_cycle":"","trust_source":"agent","helpful_count":0,"unhelpful_count":0,"pre_quarantine_status":null},{"id":128,"title":"B3 — Allocate a fixed ceiling across repos","content":"category: capability\nkind: business\nname: Allocate a fixed ceiling across repos — a reproducible policy mapping the subscription usage ceiling to per-repo shares (with headroom rules).\nwhy: Multiple repos share one ceiling; without an explicit split they compete blindly.\ndone_when: a defined, reproducible allocation splits the ceiling across N repos and yields this repo's share.\nstatus: partial\nproven_by: .claude/skills/opcost/opcost.py ; .claude/skills/opcost/SKILL.md (executed 2026-07-10 on real data). Reproducible per-repo share allocation of a self-defined weekly budget, demonstrated.","topic":"opcost","category":"capability","tags":["business","grade:partial","opcost","opcost-001","opcost-002"],"source":"","status":"Active","confidence":0.4670747271198895,"created_at":1783712558,"updated_at":1783712558,"last_accessed_at":0,"access_count":0,"supersedes":116,"superseded_by":null,"correction_count":0,"embedding_dim":384,"created_by":"opcost-002-curator","modified_by":"opcost-002-curator","content_hash":"e5479e1f96cfe313d1e1e8aad2985422f2d2ca8080ba8668da95fd07cbb79d69","previous_hash":"67e05a0958a3bc9c1a22d5d40d0d00289829532d0fae8b2642ecd9617269eea2","version":2,"feature_cycle":"","trust_source":"agent","helpful_count":0,"unhelpful_count":0,"pre_quarantine_status":null},{"id":129,"title":"B4 — Detect overrun against share","content":"category: capability\nkind: business\nname: Detect overrun against share — signal when a repo trends past its allocated share before the shared ceiling is exhausted.\nwhy: Allocation is inert unless breaches are caught early enough to act.\ndone_when: an over-share condition is detected and surfaced on real usage.\nstatus: partial\nproven_by: .claude/skills/opcost/opcost.py ; .claude/skills/opcost/SKILL.md (executed 2026-07-10 on real data). Ahead-of-pace / over-share detection demonstrated on real usage (flag fired at 1.89x of paced allowance).","topic":"opcost","category":"capability","tags":["business","grade:partial","opcost","opcost-001","opcost-002"],"source":"","status":"Active","confidence":0.467074749579902,"created_at":1783712562,"updated_at":1783712562,"last_accessed_at":0,"access_count":0,"supersedes":117,"superseded_by":null,"correction_count":0,"embedding_dim":384,"created_by":"opcost-002-curator","modified_by":"opcost-002-curator","content_hash":"5a0da7b89b275c4197a7519fde848172596a1927dcb28602db48e45ad5cd03b6","previous_hash":"4f23f2334af673908fc8d29850dbdb3cbe6a1382af929374ba9c16a454c98023","version":2,"feature_cycle":"","trust_source":"agent","helpful_count":0,"unhelpful_count":0,"pre_quarantine_status":null}],"edges":[{"source_id":118,"target_id":113,"relation_type":"Advances","direction":"outgoing","depth":1,"metadata":null},{"source_id":119,"target_id":113,"relation_type":"Advances","direction":"outgoing","depth":1,"metadata":null},{"source_id":120,"target_id":113,"relation_type":"Advances","direction":"outgoing","depth":1,"metadata":null},{"source_id":125,"target_id":113,"relation_type":"Advances","direction":"outgoing","depth":1,"metadata":null},{"source_id":127,"target_id":113,"relation_type":"Advances","direction":"outgoing","depth":1,"metadata":null},{"source_id":128,"target_id":113,"relation_type":"Advances","direction":"outgoing","depth":1,"metadata":null},{"source_id":129,"target_id":113,"relation_type":"Advances","direction":"outgoing","depth":1,"metadata":null}],"truncated":false,"seed_ids":[113],"depth_reached":1}
```

---

### 2. context_cycle_review for a recent `wf`-stamped run

**Targeted:** `feature_cycle = "opcost-001"` (a Design cycle; its cycle tags are `["decompose","opcost","wf-v0.14"]`).

**Canonical call issued:**
```
context_cycle_review(feature_cycle:"opcost-001", format:"json")
```

Direct answers to what you flagged, **as literally returned**:

- `metrics.universal.total_tool_calls` → **`0`**. OBS-6 still holds — the universal roll-up is not populated. (`total_duration_secs`, `bash_for_search_count`, `context_*_kb` etc. *are* populated; the tool-call counter specifically is 0.)
- `knowledge_curated` → **not a top-level field**. It appears per-session: `session_summaries[0].knowledge_curated = 1` (and `phase_stats` carry `knowledge_stored`/`knowledge_served` per phase). So "curated" *is* observable, but nested under session, not as a universal metric.
- `feature_knowledge_reuse.total_served` → **`0`** (and `total_stored: 0`, all `by_category: {}`, every category listed under `category_gaps`). OBS-6 confirmed here too — the reuse block reports zero even though `session_summaries[0].knowledge_served = 3` and `knowledge_stored = 12`. **The two accounting paths disagree** (session summary vs. feature_knowledge_reuse); worth a footnote in ASS-005.
- Per-phase / observation stream: **populated and detailed.** `phase_stats` has real durations, record counts, tool distributions, and human-written `gate_outcome_text` per phase (`decompose`, `research-b1`, and one empty-named tail phase). `hotspots`/`narratives`/`baseline_comparison` are all populated.
- Does the `wf` tag round-trip? **Yes — as `"wf-v0.14"`** in the top-level `tags` array. (Not `wf:0.14`.)

Entire object, verbatim:
```json
{
  "feature_cycle": "opcost-001",
  "session_count": 1,
  "total_records": 118,
  "metrics": {
    "computed_at": 1783771479,
    "universal": {
      "total_tool_calls": 0,
      "total_duration_secs": 33194,
      "session_count": 1,
      "search_miss_rate": 0.0,
      "edit_bloat_total_kb": 0.0,
      "edit_bloat_ratio": 0.0,
      "permission_friction_events": 0,
      "bash_for_search_count": 3,
      "cold_restart_events": 1,
      "coordinator_respawn_count": 0,
      "parallel_call_rate": 0.0,
      "context_load_before_first_write_kb": 18.720703125,
      "total_context_loaded_kb": 303.201171875,
      "post_completion_work_pct": 0.0,
      "follow_up_issues_created": 0,
      "knowledge_entries_stored": 0,
      "sleep_workaround_count": 0,
      "agent_hotspot_count": 0,
      "friction_hotspot_count": 0,
      "session_hotspot_count": 1,
      "scope_hotspot_count": 0
    },
    "phases": {},
    "domain_metrics": {}
  },
  "hotspots": [
    {
      "category": "Session",
      "severity": "Warning",
      "rule_name": "session_timeout",
      "claim": "Session 'http-59a1c514-60e3-4238-b602-f53f4a9aa9d2' had a 8.7h gap",
      "measured": 8.690555555555555,
      "threshold": 2.0,
      "evidence": [
        {
          "description": "Gap start",
          "ts": 1783651168000,
          "tool": null,
          "detail": "Last event before gap"
        },
        {
          "description": "Gap end",
          "ts": 1783682454000,
          "tool": null,
          "detail": "First event after gap"
        }
      ]
    }
  ],
  "is_cached": false,
  "baseline_comparison": [
    {
      "metric_name": "total_tool_calls",
      "current_value": 0.0,
      "mean": 0.0,
      "stddev": 0.0,
      "is_outlier": false,
      "status": "Normal",
      "phase": null
    },
    {
      "metric_name": "total_duration_secs",
      "current_value": 33194.0,
      "mean": 49680.5,
      "stddev": 79158.646099147,
      "is_outlier": false,
      "status": "Normal",
      "phase": null
    },
    {
      "metric_name": "session_count",
      "current_value": 1.0,
      "mean": 1.1666666666666667,
      "stddev": 0.3726779962499649,
      "is_outlier": false,
      "status": "Normal",
      "phase": null
    },
    {
      "metric_name": "search_miss_rate",
      "current_value": 0.0,
      "mean": 0.0,
      "stddev": 0.0,
      "is_outlier": false,
      "status": "Normal",
      "phase": null
    },
    {
      "metric_name": "edit_bloat_total_kb",
      "current_value": 0.0,
      "mean": 11.553548177083334,
      "stddev": 11.628754674843195,
      "is_outlier": false,
      "status": "Normal",
      "phase": null
    },
    {
      "metric_name": "edit_bloat_ratio",
      "current_value": 0.0,
      "mean": 0.08766801800551631,
      "stddev": 0.1723854101909985,
      "is_outlier": false,
      "status": "Normal",
      "phase": null
    },
    {
      "metric_name": "permission_friction_events",
      "current_value": 0.0,
      "mean": 0.0,
      "stddev": 0.0,
      "is_outlier": false,
      "status": "Normal",
      "phase": null
    },
    {
      "metric_name": "bash_for_search_count",
      "current_value": 3.0,
      "mean": 1.5,
      "stddev": 2.29128784747792,
      "is_outlier": false,
      "status": "Normal",
      "phase": null
    },
    {
      "metric_name": "cold_restart_events",
      "current_value": 1.0,
      "mean": 1.6666666666666667,
      "stddev": 2.357022603955158,
      "is_outlier": false,
      "status": "Normal",
      "phase": null
    },
    {
      "metric_name": "coordinator_respawn_count",
      "current_value": 0.0,
      "mean": 0.0,
      "stddev": 0.0,
      "is_outlier": false,
      "status": "Normal",
      "phase": null
    },
    {
      "metric_name": "parallel_call_rate",
      "current_value": 0.0,
      "mean": 0.0,
      "stddev": 0.0,
      "is_outlier": false,
      "status": "Normal",
      "phase": null
    },
    {
      "metric_name": "context_load_before_first_write_kb",
      "current_value": 18.720703125,
      "mean": 126.07552083333331,
      "stddev": 179.61368912194004,
      "is_outlier": false,
      "status": "Normal",
      "phase": null
    },
    {
      "metric_name": "total_context_loaded_kb",
      "current_value": 303.201171875,
      "mean": 309.89013671875,
      "stddev": 419.31539527671333,
      "is_outlier": false,
      "status": "Normal",
      "phase": null
    },
    {
      "metric_name": "post_completion_work_pct",
      "current_value": 0.0,
      "mean": 0.0,
      "stddev": 0.0,
      "is_outlier": false,
      "status": "Normal",
      "phase": null
    },
    {
      "metric_name": "follow_up_issues_created",
      "current_value": 0.0,
      "mean": 0.0,
      "stddev": 0.0,
      "is_outlier": false,
      "status": "Normal",
      "phase": null
    },
    {
      "metric_name": "knowledge_entries_stored",
      "current_value": 0.0,
      "mean": 0.0,
      "stddev": 0.0,
      "is_outlier": false,
      "status": "Normal",
      "phase": null
    },
    {
      "metric_name": "sleep_workaround_count",
      "current_value": 0.0,
      "mean": 0.0,
      "stddev": 0.0,
      "is_outlier": false,
      "status": "Normal",
      "phase": null
    },
    {
      "metric_name": "agent_hotspot_count",
      "current_value": 0.0,
      "mean": 0.5,
      "stddev": 0.7637626158259734,
      "is_outlier": false,
      "status": "Normal",
      "phase": null
    },
    {
      "metric_name": "friction_hotspot_count",
      "current_value": 0.0,
      "mean": 0.0,
      "stddev": 0.0,
      "is_outlier": false,
      "status": "Normal",
      "phase": null
    },
    {
      "metric_name": "session_hotspot_count",
      "current_value": 1.0,
      "mean": 1.6666666666666667,
      "stddev": 2.9249881291307074,
      "is_outlier": false,
      "status": "Normal",
      "phase": null
    },
    {
      "metric_name": "scope_hotspot_count",
      "current_value": 0.0,
      "mean": 0.0,
      "stddev": 0.0,
      "is_outlier": false,
      "status": "Normal",
      "phase": null
    }
  ],
  "narratives": [
    {
      "hotspot_type": "session_timeout",
      "summary": "session_timeout: Session 'http-59a1c514-60e3-4238-b602-f53f4a9aa9d2' had a 8.7h gap. 2 event cluster(s) detected",
      "clusters": [
        {
          "window_start": 1783651168000,
          "event_count": 1,
          "description": "1 event(s): Gap start"
        },
        {
          "window_start": 1783682454000,
          "event_count": 1,
          "description": "1 event(s): Gap end"
        }
      ],
      "top_files": [],
      "sequence_pattern": null
    }
  ],
  "session_summaries": [
    {
      "session_id": "http-59a1c514-60e3-4238-b602-f53f4a9aa9d2",
      "started_at": 1783651068000,
      "duration_secs": 33194,
      "tool_distribution": {
        "read": 4,
        "curate": 1,
        "store": 12,
        "execute": 21,
        "other": 58,
        "search": 3,
        "write": 4
      },
      "top_file_zones": [
        [
          "workspaces/arch-research/product",
          7
        ],
        [
          "tmp/claude-1000/-workspaces-arch-research",
          1
        ]
      ],
      "agents_spawned": [],
      "knowledge_served": 3,
      "knowledge_stored": 12,
      "knowledge_curated": 1
    }
  ],
  "feature_knowledge_reuse": {
    "search_exposure_count": 0,
    "explicit_read_count": 0,
    "explicit_read_by_category": {},
    "cross_session_count": 0,
    "by_category": {},
    "category_gaps": [
      "capability",
      "factory",
      "finding",
      "goal",
      "lesson-learned",
      "technology"
    ],
    "total_served": 0,
    "total_stored": 0,
    "cross_feature_reuse": 0,
    "intra_cycle_reuse": 0
  },
  "rework_session_count": 0,
  "context_reload_pct": 0.0,
  "attribution": {
    "attributed_session_count": 0,
    "total_session_count": 0
  },
  "phase_narrative": {
    "phase_sequence": [
      "decompose",
      "research-b1"
    ],
    "rework_phases": [],
    "per_phase_categories": {}
  },
  "goal": "Decompose a new goal `opcost` — know & ration the garage's Claude operating cost across repos (measure current subscription usage, attribute per repo+workstream, allocate a fixed ceiling, detect overrun). Pilot on arch-research, cross-repo by design. Distinct from shd product cost (#7/#99).",
  "tags": [
    "decompose",
    "opcost",
    "wf-v0.14"
  ],
  "cycle_type": "Design",
  "attribution_path": "cycle_events-first (primary)",
  "is_in_progress": false,
  "phase_stats": [
    {
      "phase": "decompose",
      "pass_number": 1,
      "pass_count": 1,
      "duration_secs": 31429,
      "start_ms": 1783651068000,
      "end_ms": 1783682497000,
      "session_count": 1,
      "record_count": 28,
      "agents": [],
      "tool_distribution": {
        "read": 0,
        "execute": 0,
        "write": 0,
        "search": 1
      },
      "knowledge_served": 1,
      "knowledge_stored": 8,
      "gate_result": "unknown",
      "gate_outcome_text": "Goal opcost #113 + board B1-B4/N-a-c (#114-120) written, all grade:missing, 12 edges wired. Firewall intact."
    },
    {
      "phase": "research-b1",
      "pass_number": 1,
      "pass_count": 1,
      "duration_secs": 1753,
      "start_ms": 1783682497000,
      "end_ms": 1783684250000,
      "session_count": 1,
      "record_count": 85,
      "agents": [],
      "tool_distribution": {
        "read": 4,
        "execute": 20,
        "write": 4,
        "search": 2
      },
      "knowledge_served": 2,
      "knowledge_stored": 4,
      "gate_result": "unknown",
      "gate_outcome_text": "B1 feasibility PROVEN on real data. Per-repo/day token bucketing works from transcripts (4-field sum); R2 accuracy scare debunked as field-selection artifact (~60x). N-a resolved to time-paced share-of-budget (F3 #121). Nodes: F1 #123, F2 #124, F3 #121, T1 #122 (partial). B1 #114→#125 grade partial w/ artifact. Board: B2/B3/B4/N-a still missing."
    },
    {
      "phase": "",
      "pass_number": 1,
      "pass_count": 1,
      "duration_secs": 12,
      "start_ms": 1783684250000,
      "end_ms": 1783684262000,
      "session_count": 1,
      "record_count": 3,
      "agents": [],
      "tool_distribution": {
        "read": 0,
        "execute": 1,
        "write": 0,
        "search": 0
      },
      "knowledge_served": 0,
      "knowledge_stored": 0,
      "gate_result": "unknown"
    }
  ],
  "parse_failure_count": 0
}
```

---

### 3. Knowledge-yield by run-id tag

**Targeted:** `run_id = opcost-001`.

This is the query that answers your Q3 directly. There is **no engine-native "run" grouping** — `feature_cycle` is `""` on every node (see #1/#4 raw). Yield is reconstructable **only** by filtering on the curator-maintained run-id tag.

**Canonical call issued** (findings-per-run):
```
context_lookup(tags:["opcost-001"], category:"finding", status:"active")
```
Raw result — 3 findings:
```
#121 | opcost bucket unit = time-paced share of a self-defined token budget; real quota-% is an optional anchor. | finding | [finding, opcost, opcost-001, position]
#123 | Claude subscription usage is observable per-repo (tokens) but has no supported quota meter. | finding | [finding, opcost, opcost-001]
#124 | Claude transcript token counts are reliable ONLY when all four message.usage fields are summed; naive input+output undercounts ~60x. | finding | [finding, opcost, opcost-001]
```

**Full run inventory** (drop the category filter) — `context_lookup(tags:["opcost-001"], status:"active")`:
```
#113 | Know & ration the garage's Claude operating cost across repos | goal | [goal, opcost, opcost-001]
#118 | N-a — Subscription-faithful unit | capability | [grade:missing, nfr, opcost, opcost-001]
#119 | N-b — Generalizes cross-repo without re-foundation | capability | [grade:missing, nfr, opcost, opcost-001]
#120 | N-c — Low-overhead | capability | [grade:missing, nfr, opcost, opcost-001]
#121 | opcost bucket unit = time-paced share of a self-defined token budget; real quota-% is an optional anchor. | finding | [finding, opcost, opcost-001, position]
#122 | Cwd-keyed transcript token-bucket parser | technology | [grade:partial, opcost, opcost-001, technology]
#123 | Claude subscription usage is observable per-repo (tokens) but has no supported quota meter. | finding | [finding, opcost, opcost-001]
#124 | Claude transcript token counts are reliable ONLY when all four message.usage fields are summed; naive input+output undercounts ~60x. | finding | [finding, opcost, opcost-001]
#125 | B1 — Measure current Claude usage | capability | [business, grade:partial, opcost, opcost-001]
#127 | B2 — Attribute usage to repo + workstream | capability | [business, grade:partial, opcost, opcost-001, opcost-002]
#128 | B3 — Allocate a fixed ceiling across repos | capability | [business, grade:partial, opcost, opcost-001, opcost-002]
#129 | B4 — Detect overrun against share | capability | [business, grade:partial, opcost, opcost-001, opcost-002]
```

**Reconstructing the yield / firewall ratio from that tag** (all counting is done by the caller, not the engine):
- Nodes stamped `opcost-001`: **12** — 1 goal, 7 capabilities, 3 findings, 1 technology.
- Findings produced by the run: **3** (#121, #123, #124).
- Firewall ratio on this run's *capability* board: **0 proven / 7** — 4 `grade:partial` (#125, #127, #128, #129), 3 `grade:missing` (#118, #119, #120). Zero reached `proven`; a POC moved four to `partial`.

Confirmed: the run/firewall view is a **curator-tag reconstruction**, not an engine report. Nothing in the tool surface returns "findings for run X" or "firewall ratio" — you assemble it from `tags:["<run-id>"]` + the `grade:` tags.

---

### 4. One stored proven node, fetched by id

**Targeted:** `node id = 97` ("Unimatrix — evidence-graded knowledge & governance engine", `technology`, `grade:proven`). Fetched with `context_get(id:97, format:"json")`.

Your three checks, confirmed against the raw record:

- **(a) `created_by`** → `"platform-vision-curator"`. **This one is populated, not `anonymous`** — so D6 is *partly* stale: attribution *does* persist for at least some writers now. (Our own access rules still carry the D6 caveat; treat "always anonymous" as no longer universally true — verify per-node.)
- **(b) grade vs. DB status** → confirmed distinct. `"status": "active"` (DB lifecycle) is a **separate field** from the grade, which rides the tag `"grade:proven"` in the `tags` array. Two different axes, exactly as your claim states.
- **(c) `cites:` / `proven_by:`** → confirmed as **fields, not nodes/edges.** `proven_by:` is prose inside `content` ("proven_by: live — Unimatrix is the running knowledge engine…"); the only real edge is one authored `Prerequisite → #93`. No `Cites`/`Tests`/`ProvenBy` edge types exist. (Note: on this particular node `proven_by` is narrative-in-content rather than a structured field, because the proof is "live production use" rather than a file artifact — compare #125 in #1, where `proven_by:` names an actual file path, still inside `content`.)

Raw record:
```json
{
  "id": 97,
  "title": "Unimatrix — evidence-graded knowledge & governance engine",
  "content": "TECHNOLOGY — the one PROVEN organ. status: PROVEN.\n\nWhy: the knowledge-governance organ of the platform; a real, built, in-use artifact — this research factory runs on it. Supplies the evidence-graded substrate for the platform's audit trail.\n\nPROVEN ENVELOPE (firewall, D7): proven AS a knowledge/governance engine in production use. NOT proven as the integrated platform spine — that integration is claimed at the unified-spine NFR (#95). Status is altitude-scoped: artifact demonstrates the engine, not the composition.\n\nproven_by: live — Unimatrix is the running knowledge engine of this research factory: context_* tools, the firewalled proven-vs-claimed graph, and cycle telemetry, in continuous use; built by us.\n\nEdge: Prerequisite → #93 (the wedge capability).",
  "topic": "platform-vision",
  "category": "technology",
  "tags": [
    "grade:proven",
    "platform",
    "technology",
    "unimatrix",
    "vision"
  ],
  "status": "active",
  "confidence": 0.5975789059551714,
  "created_at": 1782509083,
  "updated_at": 1782509083,
  "created_by": "platform-vision-curator",
  "supersedes": 94,
  "superseded_by": null,
  "correction_count": 0,
  "edges": [
    {
      "edge_type": "Prerequisite",
      "direction": "outbound",
      "target_id": 93,
      "target_title": "Auditable sovereign boundary — enforced egress with a complete audit trail of what crossed and why",
      "authored": true
    }
  ],
  "edge_totals": {
    "inbound": 0,
    "outbound": 1,
    "both": 0
  }
}
```

---

### 5. Resolve-forward vs. pinned read (optional)

**Targeted:** node `114` ("B1 — Measure current Claude usage"), which was corrected → reissued as `125`.

**Resolve-forward** — `context_graph(mode:"current", id:114, detail:"full")` returns the **active terminal, id `125`** (`"supersedes":114`, `"superseded_by":null`, content `status: partial` with a `proven_by:` file path):
```json
{"entry":{"id":125,"title":"B1 — Measure current Claude usage","content":"category: capability\nkind: business\nname: Measure current Claude usage — capture what this repo actually consumes (tokens / sessions / rolling-window load) in a queryable form.\nwhy: You cannot govern or allocate what you cannot see; measurement is the root of the whole board.\ndone_when: a real artifact reports this repo's Claude usage over a period with no manual tallying.\nstatus: partial\nproven_by: product/research/opcost-001/poc/opcost_poc.py (executed 2026-07-10, opcost-001; per-repo/per-day token buckets over real transcripts, no manual tallying — demonstrated altitude, not yet a standing autonomous instrument)\nnote: feasibility RESOLVED by opcost-001. Per-repo/per-day token usage is reconstructable from local transcripts (~/.claude/projects/**/*.jsonl) keyed on cwd; counts are reliable only when all four message.usage fields are summed (naive input+output undercounts ~60x — see finding). Subscription 5h/weekly quota-% is NOT officially observable (only undocumented /api/oauth/usage or CC>=2.1.x statusline stdin); the honest bucket unit is a self-defined token budget, not Anthropic's quota-% (see N-a resolution).","topic":"opcost","category":"capability","tags":["business","grade:partial","opcost","opcost-001"],"source":"","status":"Active","confidence":0.5147064500327555,"created_at":1783684191,"updated_at":1783684191,"last_accessed_at":1784229890,"access_count":2,"supersedes":114,"superseded_by":null,"correction_count":0,"embedding_dim":384,"created_by":"opcost-001-curator","modified_by":"opcost-001-curator","content_hash":"3705aceb2ae0f6a4860221cb3d62f250198e35bddb303acbfafcf26f6595d9fa","previous_hash":"67fb600d283c50747df5d7ba1c8d4461c3bf2a408eb112f2e31012fff7c50fc8","version":2,"feature_cycle":"","trust_source":"agent","helpful_count":0,"unhelpful_count":0,"pre_quarantine_status":null}}
```

**Pinned read** — `context_get(id:114, follow_supersessions:false)` holds the pin and returns id `114` itself, marked deprecated, with a `resolution` block pointing forward:
```json
{
  "id": 114,
  "title": "B1 — Measure current Claude usage",
  "content": "category: capability\nkind: business\nname: Measure current Claude usage — capture what this repo actually consumes (tokens / sessions / rolling-window load) in a queryable form.\nwhy: You cannot govern or allocate what you cannot see; measurement is the root of the whole board.\ndone_when: a real artifact reports this repo's Claude usage over a period with no manual tallying.\nstatus: missing\nproven_by: (none yet)\nnote: feasibility unknown and load-bearing — Claude Code OTEL / `/cost` reports token counts + estimated $ from API list prices, which is NOT subscription-limit (5h/weekly quota) consumption; the quota may not be programmatically exposed. Research-scope #1 resolves whether subscription-quota % is observable (see N-a).",
  "topic": "opcost",
  "category": "capability",
  "tags": [
    "business",
    "grade:partial",
    "opcost",
    "opcost-001"
  ],
  "status": "deprecated",
  "confidence": 0.4921969665195914,
  "created_at": 1783651124,
  "updated_at": 1783684191,
  "created_by": "opcost-001-curator",
  "supersedes": null,
  "superseded_by": 125,
  "correction_count": 1,
  "edges": [],
  "edge_totals": {
    "inbound": 0,
    "outbound": 0,
    "both": 0
  },
  "resolution": {
    "status": "as_stored_deprecated",
    "requested_id": 114,
    "superseded_by": 125
  }
}
```

Confirmed: `mode:"current"` resolves forward (114 → 125); `context_get(..., follow_supersessions:false)` holds the pinned/deprecated version and reports `"status":"deprecated"` + `"superseded_by":125`. One quirk worth flagging: the pinned deprecated node #114 carries a `grade:partial` **tag** while its frozen `content` still reads `status: missing` — because `grade:` tags mutate in place (no id reissue) whereas the content snapshot is frozen at correction time. Read the tag, not the content prose, for grade.

---

*Method note: every call above was read-only. `agent_id` was passed on all calls. Nothing was written to the graph. If any field here contradicts a claim in our `decisions.md`/`observations.md`, treat this live output as authoritative over the committed docs — that was the point of the request.*

