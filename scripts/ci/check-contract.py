#!/usr/bin/env python3
"""Static checks of the templates contract, before generating anything.

- every YAML and JSON file parses
- architectures/index.yml declares an integer schemaVersion and each listed
  architecture has a structure.yml
- every staticFiles source of every architecture exists, for each framework and
  paradigm it can be generated with
- every adapter listed in an index.json has a folder with metadata.yml

Usage: check-contract.py [templates-dir]   (default: templates)
"""
import json
import subprocess
import sys
from pathlib import Path

try:
    import yaml
except ImportError:  # CI runners ship yq instead of PyYAML
    yaml = None

root = Path(sys.argv[1] if len(sys.argv) > 1 else "templates")
errors = []


def load_yaml(path):
    if not path.is_file():
        return None
    if yaml is None:
        result = subprocess.run(["yq", "-o=json", ".", str(path)], capture_output=True, text=True)
        if result.returncode == 0:
            return json.loads(result.stdout)
        errors.append(f"{path}: invalid YAML: {result.stderr.strip()}")
        return None
    try:
        return yaml.safe_load(path.read_text(encoding="utf-8"))
    except yaml.YAMLError as e:
        errors.append(f"{path}: invalid YAML: {e}")
        return None


for path in root.rglob("*.yml"):
    load_yaml(path)
for path in root.rglob("*.json"):
    try:
        json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as e:
        errors.append(f"{path}: invalid JSON: {e}")

index = load_yaml(root / "architectures" / "index.yml") or {}
if not isinstance(index.get("schemaVersion"), int):
    errors.append("architectures/index.yml: schemaVersion must be an integer")

# (framework, paradigm) pairs that exist in the templates
targets = [(fw.name, p.name)
           for fw in sorted((root / "frameworks").iterdir()) if fw.is_dir()
           for p in sorted(fw.iterdir()) if (p / "adapters").is_dir()]

for arch in index.get("architectures", []):
    name = arch["name"]
    structure = load_yaml(root / "architectures" / name / "structure.yml")
    if structure is None:
        errors.append(f"architectures/{name}: listed in index.yml but has no structure.yml")
        continue
    for static in structure.get("staticFiles", []):
        source = static["source"]
        for framework, paradigm in targets:
            resolved = source.replace("{framework}", framework).replace("{paradigm}", paradigm)
            path = root / resolved[1:] if resolved.startswith("/") else root / "architectures" / name / resolved
            if not path.is_file():
                errors.append(f"architectures/{name}/structure.yml: {source} not found for {framework}/{paradigm}")

for index_json in root.glob("frameworks/*/*/adapters/*/index.json"):
    for adapter in json.loads(index_json.read_text(encoding="utf-8")).get("adapters", []):
        if not (index_json.parent / adapter["name"] / "metadata.yml").is_file():
            errors.append(f"{index_json}: adapter {adapter['name']} has no metadata.yml")

for e in sorted(set(errors)):
    print(f"::error::{e}")
print(f"{len(targets)} framework/paradigm targets, {len(index.get('architectures', []))} architectures, "
      f"{len(set(errors))} errors")
sys.exit(1 if errors else 0)
