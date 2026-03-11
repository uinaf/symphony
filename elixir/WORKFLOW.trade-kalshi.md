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
    ISSUE_ID="$(basename "$WORKSPACE")"
    BRANCH="$(echo "$ISSUE_ID" | tr '[:upper:]' '[:lower:]')"
    git -C /Users/glitch/projects/trade-kalshi fetch origin
    git -C /Users/glitch/projects/trade-kalshi worktree add "$WORKSPACE" -b "$BRANCH" origin/main
    cd "$WORKSPACE"
    bun install
  before_remove: |
    set -e
    ISSUE_ID="$(basename "$WORKSPACE")"
    BRANCH="$(echo "$ISSUE_ID" | tr '[:upper:]' '[:lower:]')"
    git -C /Users/glitch/projects/trade-kalshi worktree remove --force "$WORKSPACE" || true
    git -C /Users/glitch/projects/trade-kalshi branch -D "$BRANCH" 2>/dev/null || true
  after_run: |
    /Users/glitch/worktrees/symphony/uinaf-91-symphony-spike/elixir/bin/after-run-wake-glitch.sh
agent:
  max_concurrent_agents: 3
  max_turns: 12
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
1. Read `AGENTS.md` at the workspace root for project conventions
2. Read the issue description carefully — it contains the full spec with implementation steps, files to change, and acceptance criteria
3. Implement the changes following the spec precisely
4. Run `bun run verify` (lint + typecheck + format + tests with 90% coverage) — fix until it passes
5. Use conventional commits: `feat: description (fixes {{ issue.identifier }})`
6. Push your branch and create a PR against `main`
7. Move the Linear issue to `In Review` after the PR is open
8. Do not use Linear GraphQL or update the Linear workpad; focus on code, verification, push, PR creation, and the `In Review` transition only

## Constraints
- TypeScript strict mode, Bun runtime
- oxlint for linting, oxfmt for formatting
- All new code needs tests (~90% coverage enforced)
- Limit orders only, atomic state file writes
- Do NOT modify `limits` section in config — that's human-owned
