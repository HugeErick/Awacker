#!/usr/bin/env bash
# awaken.sh - keepawake for Supabase
#
# Requirements:
#   - curl installed 
#   - jq optional, only used for pretty-printing the response
#
# Usage:
#   chmod +x awaken.sh
#   ./awaken.sh

set -euo pipefail

# Config 
SUPABASE_URL="${SUPABASE_URL:-https://<your-project-ref>.supabase.co}"
SUPABASE_KEY="${SUPABASE_KEY:-<your-anon-or-service-role-key>}"

echo "Waking Supabase"
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$SUPABASE_URL/rest/v1/test_awaker" \
  -H "apikey: $SUPABASE_KEY" \
  -H "Authorization: Bearer $SUPABASE_KEY" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=representation" \
  -d "{\"note\": \"keepalive $(date -u +%Y-%m-%dT%H:%M:%SZ)\"}")

BODY=$(echo "$RESPONSE" | sed '$d')

if [[ "$HTTP_CODE" =~ ^2 ]]; then
  if command -v jq >/dev/null 2>&1; then
    echo "Supabase OK -> $(echo "$BODY" | jq -c .)"
  else
    echo "Supabase OK -> $BODY"
  fi
else
  echo "Supabase request failed (HTTP $HTTP_CODE): $BODY" >&2
  exit 1
fi

echo ""
echo "Done."
