#!/bin/bash
project=$(basename "$PWD")

# Read the JSON payload from stdin (Claude Code pipes hook data via stdin)
input=$(cat)

# Extract the transcript summary using jq, truncate for notification readability
summary=$(echo "$input" | jq -r '.transcript_summary // empty' 2>/dev/null | head -c 200)

if [ -n "$summary" ]; then
  osascript -e "display notification \"$summary\" with title \"Claude Code - $project\" sound name \"Glass\""
else
  osascript -e "display notification \"Done in $project\" with title \"Claude Code\" sound name \"Glass\""
fi
