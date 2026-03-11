---
tracker:
  kind: linear
  project_slug: "68453044bcab"
  active_states:
    - __NO_ELIGIBLE_WORK__
  terminal_states:
    - Done
    - Closed
    - Cancelled
    - Canceled
    - Duplicate
polling:
  interval_ms: 5000
workspace:
  root: /Users/glitch/worktrees/symphony/altay-eval-workspaces
hooks:
  after_create: |
    echo "workspace created at $(pwd)" > .symphony-bootstrap.txt
agent:
  max_concurrent_agents: 2
  max_turns: 5
codex:
  command: codex app-server
  approval_policy: never
  thread_sandbox: workspace-write
  turn_sandbox_policy:
    type: workspaceWrite
server:
  port: 4099
---

You are working on Linear issue {{ issue.identifier }}.

Read AGENTS.md if present. Work only inside the provided workspace.
