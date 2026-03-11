---
tracker:
  kind: linear
  project_slug: "68453044bcab"
  active_states:
    - Todo
    - In Progress
    - Rework
  terminal_states:
    - Done
    - Cancelled
    - Closed
polling:
  interval_ms: 30000
workspace:
  root: /Users/glitch/worktrees/trade-kalshi
hooks:
  after_create: |
    set -e
    ISSUE_ID="$(basename "$PWD")"
    BRANCH="$(echo "$ISSUE_ID" | tr '[:upper:]' '[:lower:]')"
    git -C /Users/glitch/projects/trade-kalshi fetch origin
    git -C /Users/glitch/projects/trade-kalshi worktree add "$PWD" -b "$BRANCH" origin/main
    cd "$PWD"
    bun install
  before_remove: |
    set -e
    ISSUE_ID="$(basename "$PWD")"
    BRANCH="$(echo "$ISSUE_ID" | tr '[:upper:]' '[:lower:]')"
    git -C /Users/glitch/projects/trade-kalshi worktree remove --force "$PWD" || true
    git -C /Users/glitch/projects/trade-kalshi branch -D "$BRANCH" 2>/dev/null || true
  after_run: |
    /Users/glitch/worktrees/symphony/uinaf-91-symphony-spike/elixir/bin/after-run-wake-glitch.sh
agent:
  max_concurrent_agents: 1
  max_turns: 6
codex:
  command: codex app-server
  approval_policy: never
  thread_sandbox: danger-full-access
  turn_sandbox_policy:
    type: dangerFullAccess
server:
  port: 4102
---

You are working on `trade-kalshi`, a Kalshi prediction market trading bot.

## Context
- Issue: {{ issue.identifier }} — {{ issue.title }}
- Workspace: ~/worktrees/trade-kalshi/{{ issue.identifier }}

## Instructions
1. FIRST: use the repo-local Linear skill at `.codex/skills/linear/SKILL.md` together with Symphony's `linear_graphql` tool to move the issue to `In Progress` immediately.
2. Read `AGENTS.md` at the workspace root for project conventions.
3. Read the issue description carefully — it is the spec; do not broaden scope.
4. Implement the smallest change that satisfies the issue.
5. Do not wander, re-architect, or explore unrelated files.
6. Run `bun run verify` once you have a plausible implementation; then fix only what verify reports.
7. Use conventional commits: `feat: description (fixes {{ issue.identifier }})`.
8. Push your branch and create a PR against `main`.
9. Use the Linear skill + `linear_graphql` to attach the PR to the issue and move the issue to `In Review` immediately.
10. After moving the issue to `In Review`, STOP. Do not continue coding, refactoring, or exploring.
11. Use `linear_graphql` for lifecycle transitions; do not wing it with ad-hoc shell GraphQL.
12. Be concise: avoid repeated full-repo rereads and avoid long reasoning loops.

## Constraints
- TypeScript strict mode, Bun runtime
- oxlint for linting, oxfmt for formatting
- All new code needs tests (~90% coverage enforced)
- Limit orders only, atomic state file writes
- Do NOT modify `limits` section in config — that's human-owned
