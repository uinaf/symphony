#!/usr/bin/env bash
set -euo pipefail

ISSUE_ID="$(basename "$PWD")"
STATE="$(linear issue view "$ISSUE_ID" --json 2>/dev/null | jq -r '.state.name // empty')"
[ "$STATE" = "In Review" ] || exit 0

BRANCH="$(printf '%s' "$ISSUE_ID" | tr '[:upper:]' '[:lower:]')"
PR_URL="$(gh pr list --head "$BRANCH" --json url --jq '.[0].url // empty' 2>/dev/null || true)"

if [ -n "$PR_URL" ]; then
  MSG="🗿 ${ISSUE_ID} ${PR_URL} — review the diff. Reply with ONLY: the PR link as markdown [${ISSUE_ID}](url), then merge/reject + one sentence reason. Nothing else."
else
  MSG="🗿 ${ISSUE_ID} moved to In Review (no PR found). Check workspace and report verdict."
fi

HOOKS_TOKEN="${OPENCLAW_HOOKS_TOKEN:-}"
[ -z "$HOOKS_TOKEN" ] && exit 0

curl -s -X POST "http://localhost:18789/hooks/agent" \
  -H "Authorization: Bearer ${HOOKS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$(jq -n --arg msg "$MSG" '{message: $msg, deliver: true, channel: "telegram", to: "8734062810"}')" \
  >/tmp/symphony-after-run-wake.log 2>&1 || true
