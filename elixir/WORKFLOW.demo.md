---
tracker:
  kind: linear
  project_slug: "886e530301e9"
  active_states:
    - Todo
    - In Progress
    - Rework
  terminal_states:
    - Done
    - Closed
    - Cancelled
    - Canceled
    - Duplicate
polling:
  interval_ms: 5000
workspace:
  root: /Users/glitch/worktrees/symphony-demo/workspaces
hooks:
  after_create: |
    ISSUE_ID="$(basename "$PWD")"
    BRANCH_NAME="$(printf '%s' "$ISSUE_ID" | tr '[:upper:]' '[:lower:]')"
    BASE_REPO="/Users/glitch/projects/symphony-demo"
    git -C "$BASE_REPO" fetch origin
    git -C "$BASE_REPO" worktree add "$PWD" -b "$BRANCH_NAME" origin/main
    bun install
  before_remove: |
    ISSUE_ID="$(basename "$PWD")"
    BRANCH_NAME="$(printf '%s' "$ISSUE_ID" | tr '[:upper:]' '[:lower:]')"
    BASE_REPO="/Users/glitch/projects/symphony-demo"
    git -C "$BASE_REPO" worktree remove --force "$PWD" || true
    git -C "$BASE_REPO" branch -D "$BRANCH_NAME" || true
  after_run: |
    /Users/glitch/worktrees/symphony/uinaf-91-symphony-spike/elixir/bin/after-run-wake-glitch.sh
agent:
  max_concurrent_agents: 2
  max_turns: 8
codex:
  command: codex app-server
  approval_policy: never
  thread_sandbox: danger-full-access
  turn_sandbox_policy:
    type: dangerFullAccess
server:
  port: 4101
---

You are working on Linear issue {{ issue.identifier }}.

Read `AGENTS.md` first.
Work only inside this repository clone.
Use `bun run verify` as the required verification gate.
Keep changes minimal and reviewable.

## Linear access

You should have access to Linear context during the run, either via Symphony's injected `linear_graphql` tool or a configured Linear MCP server.
Use it.

## Required workflow

1. Fetch the issue and read its current state.
2. If the issue is `Todo`, move it to `In Progress` before changing code.
3. Maintain a single progress comment with header `## Codex Workpad` and keep it updated.
4. Implement only the requested change.
5. Run `bun run verify` before claiming completion.
6. Create a git commit before handoff. Commit message must be conventional format.
7. Push the issue branch to `origin`.
8. Create or update a GitHub pull request for that branch into `main`.
9. Update the workpad with:
   - what changed
   - verification result
   - commit hash
   - PR URL
   - any blocker or caveat
10. Move the issue to `In Review` when the work is ready.

## Important constraints

- Do **not** move the issue directly to `Done`.
- Do **not** declare success without a commit.
- Do **not** move to `In Review` without a pushed branch and PR URL.
- If verification fails, keep the issue in `In Progress` and document the problem in the workpad.
- If Linear or GitHub tooling is unavailable, stop and report that as a blocker in the workpad.
