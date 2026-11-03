#!/usr/bin/env bash
# Proves the architecture tests of a generated project actually fail: injects
# one violation at a time into a project made by generate-and-build.sh, expects
# the build to fail on the rule that guards it, then removes the violation.
#
#   negative-check.sh --project ./build/generated/hexagonal-multi-reactive --paradigm reactive
#
# In multi-module architectures Gradle may reject a violation before ArchUnit
# (the domain module has no Spring on its classpath). A compile error counts as
# caught too: either way the violation cannot reach develop.
set -euo pipefail

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project) project=$2; shift 2 ;;
    --paradigm) paradigm=$2; shift 2 ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
done
: "${project:?--project is required}" "${paradigm:?--paradigm is required}"
project=$(cd "$project" && pwd)

# src_dir_of <path glob> <file name>
src_dir_of() { dirname "$(find "$project" -path "*/src/main/java/$1" -name "$2" | head -n 1)"; }
package_of() { sed -n 's/^package \(.*\);/\1/p' "$1" | head -n 1; }

entity_dir=$(src_dir_of "*/domain/model/*" Product.java)
usecase_dir=$(src_dir_of "*" CreateProductUseCase.java)
adapter_file=$(find "$project" -path '*/src/main/java/*/drivenadapters/*' -name '*Adapter.java' | head -n 1)
adapter_class="$(package_of "$adapter_file").$(basename "$adapter_file" .java)"

failed=0

# expect_violation <name> <rule> <file> <java source>
expect_violation() {
  local name=$1 rule=$2 file=$3 source=$4 log
  log=$(mktemp)
  printf '%s\n' "$source" > "$file"
  if (cd "$project" && ./gradlew --console=plain --no-daemon test > "$log" 2>&1); then
    echo "$name: NOT CAUGHT (build passed)"
    failed=1
  elif grep -Eq "$rule.*FAILED" "$log"; then
    echo "$name: caught by $rule"
  elif grep -q "Compilation failed" "$log"; then
    echo "$name: caught by the compiler"
  else
    echo "$name: build failed for another reason"
    tail -n 60 "$log"
    failed=1
  fi
  rm -f "$file" "$log"
}

expect_violation "framework in domain" domainIsFreeOfFrameworks "$entity_dir/SpringInDomain.java" "package $(package_of "$entity_dir/Product.java");

@org.springframework.stereotype.Component
public class SpringInDomain {
}"

expect_violation "use case reaches an adapter" ArchitectureTest "$usecase_dir/AdapterLeakUseCase.java" "package $(package_of "$usecase_dir/CreateProductUseCase.java");

public class AdapterLeakUseCase {
    public Class<?> adapter() {
        return $adapter_class.class;
    }
}"

if [[ $paradigm == reactive ]]; then
  expect_violation "blocking call on a publisher" noBlockingCallsOnPublishers "$usecase_dir/BlockingUseCase.java" "package $(package_of "$usecase_dir/CreateProductUseCase.java");

public class BlockingUseCase {
    public String execute(reactor.core.publisher.Mono<String> value) {
        return value.block();
    }
}"
fi

exit $failed
