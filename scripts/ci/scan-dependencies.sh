#!/usr/bin/env bash
# Scans the full dependency tree of a Gradle project (a generated project or the
# plugin itself) with OSV-Scanner and fails when a vulnerability reaches the
# CVSS threshold. Also writes a CycloneDX SBOM of the same tree.
#
#   scan-dependencies.sh --project build/generated/onion-single-reactive \
#     [--fail-on-cvss 7.0] [--out build/scan] [--osv-scanner osv-scanner]
#
# The threshold defaults to quality.owasp-fail-on-cvss in templates/versions.yml,
# the same one the generated projects use for dependency-check. Gradle locks
# every configuration first (lock-dependencies.init.gradle), so transitive
# dependencies are scanned too.
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)
threshold=""
osv=osv-scanner
out=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --project) project=$2; shift 2 ;;
    --fail-on-cvss) threshold=$2; shift 2 ;;
    --out) out=$2; shift 2 ;;
    --osv-scanner) osv=$2; shift 2 ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
done
: "${project:?--project is required}"
if [[ -z $threshold ]]; then
  threshold=$(sed -n 's/^ *owasp-fail-on-cvss: *"\{0,1\}\([0-9.]*\)"\{0,1\}.*/\1/p' "$here/../../templates/versions.yml")
fi
: "${threshold:?--fail-on-cvss is required (not found in versions.yml)}"

project=$(cd "$project" && pwd)
name=$(basename "$project")
out=${out:-$project/build/scan}
mkdir -p "$out"
out=$(cd "$out" && pwd)

# Lockfiles written here are removed at exit; existing ones are left alone
existing=$(find "$project" -name '*.lockfile' -not -path '*/build/*' | sort)
cleanup() {
  comm -13 <(echo "$existing") <(find "$project" -name '*.lockfile' -not -path '*/build/*' | sort) \
    | while read -r f; do [[ -z $f ]] || rm -f "$f"; done
}
trap cleanup EXIT

(cd "$project" && ./gradlew --console=plain --no-daemon --no-configuration-cache -q \
  --init-script "$here/lock-dependencies.init.gradle" lockAllDependencies --write-locks)

# Exit code 1 only means "vulnerabilities found"; the threshold decides below
status=0
"$osv" scan source --recursive --format json --output-file "$out/osv.json" "$project" || status=$?
[[ $status -le 1 ]] || { echo "osv-scanner failed with exit code $status" >&2; exit "$status"; }
"$osv" scan source --recursive --format cyclonedx-1-6 --output-file "$out/sbom.cdx.json" "$project" > /dev/null || true

# One row per vulnerability group: package, version, ids, max CVSS
rows=$(jq -r '.results[]?.packages[]? | . as $p | .groups[]?
  | [$p.package.name, $p.package.version, (.ids | join(" ")), (.max_severity // "")] | @tsv' "$out/osv.json" | sort -u)
blocking=$(awk -F'\t' -v t="$threshold" '$4 != "" && $4 + 0 >= t + 0' <<< "$rows" | grep -c . || true)
total=$(grep -c . <<< "$rows" || true)

report() {
  echo "### Dependencies: $name"
  echo
  echo "$total vulnerable package versions, $blocking at CVSS >= $threshold."
  if [[ $total -gt 0 ]]; then
    echo
    echo "| Package | Version | Vulnerabilities | Max CVSS |"
    echo "|---------|---------|-----------------|----------|"
    sort -t$'\t' -k4,4nr <<< "$rows" | awk -F'\t' '{ printf "| %s | %s | %s | %s |\n", $1, $2, $3, ($4 == "" ? "?" : $4) }'
  fi
  echo
}
report
[[ -z ${GITHUB_STEP_SUMMARY:-} ]] || report >> "$GITHUB_STEP_SUMMARY"

[[ $blocking -eq 0 ]]
