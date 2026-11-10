#!/usr/bin/env bash
# Reports the findings of a SARIF file (CodeQL, gitleaks) and fails when one
# reaches the severity threshold. Findings without a security-severity (code
# quality, or tools that do not score) count as blocking only with --fail-on-any.
#
#   sarif-gate.sh --sarif results/java.sarif --title "Code: onion-single-reactive" \
#     [--fail-on-severity 7.0 | --fail-on-any]
set -euo pipefail

threshold=7.0
any=false
title=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --sarif) sarif=$2; shift 2 ;;
    --title) title=$2; shift 2 ;;
    --fail-on-severity) threshold=$2; shift 2 ;;
    --fail-on-any) any=true; shift ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
done
: "${sarif:?--sarif is required}"
title=${title:-$(basename "$sarif")}

# One row per finding: rule, security-severity, location, message
rows=$(jq -r '.runs[]
  | (reduce (((.tool.driver.rules // []) + ([.tool.extensions[]?.rules // []] | add // []))[]) as $r
      ({}; .[$r.id] = ($r.properties["security-severity"] // ""))) as $severity
  | .results[]?
  | [ .ruleId,
      ($severity[.ruleId] // ""),
      ((.locations[0].physicalLocation.artifactLocation.uri // "?") + ":" + ((.locations[0].physicalLocation.region.startLine // 0) | tostring)),
      (.message.text | gsub("[\n|]"; " ") | .[0:160]) ]
  | @tsv' "$sarif")

total=$(grep -c . <<< "$rows" || true)
if [[ $any == true ]]; then
  blocking=$total
else
  blocking=$(awk -F'\t' -v t="$threshold" '$2 != "" && $2 + 0 >= t + 0' <<< "$rows" | grep -c . || true)
fi

report() {
  echo "### $title"
  echo
  if [[ $any == true ]]; then
    echo "$total findings, all blocking."
  else
    echo "$total findings, $blocking at security-severity >= $threshold."
  fi
  if [[ $total -gt 0 ]]; then
    echo
    echo "| Rule | Severity | Location | Message |"
    echo "|------|----------|----------|---------|"
    sort -t$'\t' -k2,2nr <<< "$rows" | awk -F'\t' '{ printf "| %s | %s | %s | %s |\n", $1, ($2 == "" ? "-" : $2), $3, $4 }'
  fi
  echo
}
report
[[ -z ${GITHUB_STEP_SUMMARY:-} ]] || report >> "$GITHUB_STEP_SUMMARY"

[[ $blocking -eq 0 ]]
