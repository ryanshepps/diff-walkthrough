#!/usr/bin/env bash
set -euo pipefail

[[ ${HERDR_ENV:-} == 1 ]] || { printf 'Run this inside Herdr.\n' >&2; exit 1; }
(( $# == 1 || $# == 2 )) || { printf 'Usage: %s <parent-pane-id> [pane-to-replace]\n' "$0" >&2; exit 1; }

excerpt_file=$(mktemp)
trap 'rm -f "$excerpt_file"' EXIT
cat > "$excerpt_file"
[[ -s $excerpt_file ]] || { printf 'No text was provided on stdin.\n' >&2; exit 1; }

if (( $# == 2 )); then
  herdr pane close "$2" >/dev/null
fi
pane=$(herdr pane split "$1" --direction right --cwd "$PWD" --focus | jq -er '.result.pane.pane_id')
printf -v pane_command 'less -R -- %q; rm -f -- %q; exit' "$excerpt_file" "$excerpt_file"
herdr pane run "$pane" "$pane_command"
trap - EXIT
herdr pane get "$pane" | jq -e '.result.pane.focused == true' >/dev/null
printf 'Focused excerpt in %s.\n' "$pane"
