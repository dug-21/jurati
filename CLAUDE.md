<!-- uni-init v1: DO NOT REMOVE THIS LINE -->
## Unimatrix

Knowledge engine (MCP server). Makes agent expertise searchable, trustworthy, and self-improving.

### Available Skills

| Skill | When to Use |
|-------|-------------|
| `/uni-init` | First-time setup: wire CLAUDE.md and get agent orientation |
| `/uni-seed` | Populate Unimatrix with foundational repo knowledge |
| `/uni-store-adr` | After each architectural decision — stores the ADR |
| `/uni-store-lesson` | After failures and gate rejections — prevents recurrence |
| `/uni-store-pattern` | When a reusable implementation pattern emerges |
| `/uni-store-procedure` | When a step-by-step how-to technique evolves |
| `/uni-knowledge-search` | Semantic search across knowledge before implementing |
| `/uni-knowledge-lookup` | Deterministic lookup by feature, category, or ID |
| `/uni-query-patterns` | Query component patterns before designing or coding |
| `/uni-retro` | Post-merge retrospective — extract and store what was learned |
| `/uni-review-pr` | PR security review and merge readiness check |
| `/uni-zero` | Strategic advisor for product evolution and vision alignment |

### Knowledge Categories

| Category | What Goes Here |
|----------|---------------|
| `decision` | Architectural decisions (ADRs) — use `/uni-store-adr` |
| `pattern` | Reusable implementation patterns — use `/uni-store-pattern` |
| `procedure` | Step-by-step workflows — use `/uni-store-procedure` |
| `convention` | Project-wide coding/process standards |
| `lesson-learned` | Post-failure takeaways — use `/uni-store-lesson` |

### When to Invoke

- Before implementing anything new → search knowledge base
- After each architectural decision → store ADR
- After each shipped feature → run retrospective
- When a technique evolves → update procedure
<!-- end uni-init v1 -->
