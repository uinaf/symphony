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
    BRANCH="$(printf '%s' "$ISSUE_ID" | tr '[:upper:]' '[:lower:]')"
    git -C /Users/glitch/projects/trade-kalshi fetch origin
    git -C /Users/glitch/projects/trade-kalshi worktree add "$PWD" -b "$BRANCH" origin/main
    cd "$PWD"
    bun install
  before_remove: |
    set -e
    ISSUE_ID="$(basename "$PWD")"
    BRANCH="$(printf '%s' "$ISSUE_ID" | tr '[:upper:]' '[:lower:]')"
    git -C /Users/glitch/projects/trade-kalshi worktree remove --force "$PWD" || true
    git -C /Users/glitch/projects/trade-kalshi branch -D "$BRANCH" 2>/dev/null || true
  after_run: |
    /Users/glitch/projects/symphony/elixir/bin/after-run-wake-glitch.sh
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

## Workflow
1. FIRST: use Codex's configured Linear MCP tools to move the issue to `In Progress`.
2. Read `AGENTS.md` and the issue description. Treat the issue description as the spec. Do not broaden scope.
3. Make the smallest change that satisfies the issue.
4. Run `bun run verify`. Fix only what `verify` reports.
5. Commit with `feat: description (fixes {{ issue.identifier }})`.
6. Push your branch and open a PR against `main`.
7. Use the configured Linear MCP tools to attach the PR to the issue and move the issue to `In Review`.
8. STOP immediately after the `In Review` transition. Do not continue coding, refactoring, or exploring.

## Constraints
- TypeScript strict mode, Bun runtime
- oxlint for linting, oxfmt for formatting
- All new code needs tests (~90% coverage enforced)
- Limit orders only, atomic state file writes
- Do NOT modify `limits` section in config — that's human-owned
- Use Linear MCP tools for lifecycle updates; do not improvise with shell GraphQL
- Be concise: avoid repo-wide rereads and long reasoning loops
