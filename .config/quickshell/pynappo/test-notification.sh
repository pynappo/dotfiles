#!/usr/bin/env bash
set -euo pipefail

if ! command -v notify-send >/dev/null 2>&1; then
  printf '%s\n' "notify-send is not installed or is not in PATH" >&2
  exit 1
fi

notify-send \
  --app-name="Quickshell Test" \
  --urgency=normal \
  "Short notification" \
  "This is a short notification." &

notify-send \
  --app-name="Quickshell Test" \
  --urgency=normal \
  "Long notification" \
  "This is a long notification body designed to verify that notification text wraps correctly instead of overflowing past the popup." &

wait
