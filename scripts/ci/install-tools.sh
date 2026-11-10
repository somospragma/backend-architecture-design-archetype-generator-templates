#!/usr/bin/env bash
# Installs the scanners used by CI into a directory on the PATH, verifying each
# download against the checksums published with the release.
#
#   install-tools.sh <dir> osv-scanner gitleaks
set -euo pipefail

OSV_SCANNER_VERSION=2.7.0
GITLEAKS_VERSION=8.30.1

dir=$1; shift
mkdir -p "$dir"
cd "$dir"

for tool in "$@"; do
  case "$tool" in
    osv-scanner)
      base=https://github.com/google/osv-scanner/releases/download/v$OSV_SCANNER_VERSION
      curl -fsSLO "$base/osv-scanner_linux_amd64" -O "$base/osv-scanner_SHA256SUMS"
      grep " osv-scanner_linux_amd64\$" osv-scanner_SHA256SUMS | sha256sum -c -
      mv osv-scanner_linux_amd64 osv-scanner
      chmod +x osv-scanner ;;
    gitleaks)
      base=https://github.com/gitleaks/gitleaks/releases/download/v$GITLEAKS_VERSION
      file=gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz
      curl -fsSLO "$base/$file" -O "$base/gitleaks_${GITLEAKS_VERSION}_checksums.txt"
      grep " $file\$" "gitleaks_${GITLEAKS_VERSION}_checksums.txt" | sha256sum -c -
      tar -xzf "$file" gitleaks ;;
    *) echo "Unknown tool: $tool" >&2; exit 2 ;;
  esac
done
[[ -z ${GITHUB_PATH:-} ]] || pwd >> "$GITHUB_PATH"
