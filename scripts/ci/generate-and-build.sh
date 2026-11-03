#!/usr/bin/env bash
# Generates a project with the plugin and these templates, adds an entity, a use
# case and adapters, then builds it and runs its tests (ArchUnit included).
#
#   generate-and-build.sh --architecture hexagonal-single --paradigm reactive \
#     --plugin-version 1.4.0 --templates ./templates --out ./build/generated \
#     [--framework spring] [--only out:mongodb]
#
# Without --only every adapter listed in the framework index.json is generated
# into the same project. --only generates a single adapter (in:<name> or
# out:<name>) to prove it builds on its own.
#
# The plugin is resolved from mavenLocal first (a core build published with
# publishToMavenLocal), then from the Gradle Plugin Portal. `gradle` must be on
# the PATH to bootstrap the project; the generated wrapper runs everything else.
set -euo pipefail

framework=spring
only=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --architecture) architecture=$2; shift 2 ;;
    --paradigm) paradigm=$2; shift 2 ;;
    --framework) framework=$2; shift 2 ;;
    --plugin-version) plugin_version=$2; shift 2 ;;
    --templates) templates=$2; shift 2 ;;
    --out) out=$2; shift 2 ;;
    --only) only=$2; shift 2 ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
done
: "${architecture:?--architecture is required}" "${paradigm:?--paradigm is required}"
: "${plugin_version:?--plugin-version is required}" "${templates:?--templates is required}" "${out:?--out is required}"

templates=$(cd "$templates" && pwd)
adapters_dir="$templates/frameworks/$framework/$paradigm/adapters"
name="$architecture-$paradigm${only:+-${only/:/-}}"
project="$out/$name"
logs="$out/logs/$name"
rm -rf "$project" "$logs"
mkdir -p "$project" "$logs"
project=$(cd "$project" && pwd)

cat > "$project/settings.gradle.kts" <<EOF
pluginManagement { repositories { mavenLocal(); gradlePluginPortal(); mavenCentral() } }
rootProject.name = "$name"
EOF
cat > "$project/build.gradle.kts" <<EOF
plugins { id("co.com.pragma.archetype-generator") version "$plugin_version" }
EOF
cat > "$project/.cleanarch.yml" <<EOF
templates:
  mode: developer
  localPath: $templates
  cache: false
EOF

results=()
failed=0

# step <label> <command...>: runs a step, logs it and records the result
step() {
  local label=$1; shift
  if "$@" > "$logs/$label.log" 2>&1; then
    results+=("$label=OK")
  else
    results+=("$label=FAIL")
    failed=1
    echo "::group::$name $label log"
    tail -n 80 "$logs/$label.log"
    echo "::endgroup::"
  fi
}

gw() { (cd "$project" && ./gradlew --console=plain --no-daemon "$@"); }

step init gradle -p "$project" --console=plain --no-daemon initCleanArch \
  --package=com.pragma.ci --architecture="$architecture" --paradigm="$paradigm" --framework="$framework"
if [[ $failed -ne 0 ]]; then
  echo "$name init=FAIL"
  exit 1
fi

step entity gw generateEntity --name=Product --fields=name:String,price:Double
step usecase gw generateUseCase --name=CreateProduct --methods=execute:Product:product:Product

input_adapter() {
  local type=$1 endpoints=()
  [[ $type == rest ]] && endpoints=(--endpoints=/products:POST:execute:Product:product:BODY:Product)
  step "$type" gw generateInputAdapter --name="Product${type//-/}" --type="$type" --useCase=CreateProduct ${endpoints[@]+"${endpoints[@]}"}
}
output_adapter() {
  local type=$1
  step "$type" gw generateOutputAdapter --name="Product${type//-/}" --entity=Product --type="$type"
}

if [[ -n $only ]]; then
  case "${only%%:*}" in
    in) input_adapter "${only#*:}" ;;
    out) output_adapter "${only#*:}" ;;
    *) echo "--only must be in:<name> or out:<name>" >&2; exit 2 ;;
  esac
else
  for type in $(jq -r '.adapters[].name' "$adapters_dir/driven-adapters/index.json"); do output_adapter "$type"; done
  for type in $(jq -r '.adapters[].name' "$adapters_dir/entry-points/index.json"); do input_adapter "$type"; done
fi

# Quality gates of the generated project that need network or take minutes are
# covered by their own jobs, not here.
step build gw build -x pitest -x dependencyCheckAnalyze

echo "$name ${results[*]}"
if [[ -n ${GITHUB_STEP_SUMMARY:-} ]]; then
  {
    echo "### $name"
    echo
    echo "| Step | Result |"
    echo "|------|--------|"
    for r in "${results[@]}"; do echo "| ${r%%=*} | ${r#*=} |"; done
    echo
  } >> "$GITHUB_STEP_SUMMARY"
fi
exit $failed
