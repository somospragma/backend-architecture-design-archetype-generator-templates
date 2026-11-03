# CI de templates

Cada cambio en templates se prueba generando proyectos reales con el plugin y compilándolos con sus tests, ArchUnit incluido.

## Ramas

- `main` es la rama de integración: los PR desde `feat/*` o `fix/*` entran aquí.
- `v1`, `v2`, … son las ramas que lee cada mayor del plugin: el plugin 1.x lee `v1`. Es lo que reciben los usuarios.
- Promover es abrir un PR de `main` a `v1`. Al mergearlo, el CI crea el tag siguiente `v1.x.y` (sube el patch; el minor se sube a mano).
- Un cambio incompatible sube el `schemaVersion` de `architectures/index.yml`. Va a la rama `v2` junto con el plugin 2.0, nunca a `v1`.

## Workflows

| Workflow | Cuándo corre | Qué hace |
|---|---|---|
| `ci.yml` | PR y push a `main` y a `v*` | gitleaks y lint de workflows, chequeo del contrato, la matriz completa contra core `main` y, en PR a `v*`, la misma matriz contra el último plugin publicado de ese mayor |
| `nightly.yml` | cada día a las 06:00 UTC | cada adapter solo en su propio proyecto, y violaciones metidas a propósito que el build debe rechazar |
| `generation.yml` | lo llaman los dos anteriores | la matriz de generación |
| `security.yml` | lo llama `ci.yml` | gitleaks, actionlint y zizmor |

La matriz sale de `architectures/index.yml` y de los `index.json` de adapters. Una arquitectura o un adapter nuevo entra a la matriz sin tocar los workflows.

| Modo | Proyectos | Qué prueba |
|---|---|---|
| `full` | cada arquitectura × paradigma | entidad, caso de uso y todos los adapters en el mismo proyecto; `build` con tests |
| `isolated` | `hexagonal-single` × paradigma × adapter | que cada adapter compile y pase sus tests solo |
| `negative` | cada arquitectura × paradigma | que se rechacen un dominio con Spring, un caso de uso que usa un adapter y, en reactivo, un `block()` |

## Scripts

Se corren igual en local:

```bash
# El plugin tiene que estar en mavenLocal: ./gradlew publishToMavenLocal en el core
scripts/ci/check-contract.py templates
scripts/ci/generate-and-build.sh --architecture onion-single --paradigm reactive \
  --plugin-version 1.3.5-SNAPSHOT --templates templates --out build/generated
scripts/ci/negative-check.sh --project build/generated/onion-single-reactive --paradigm reactive
```

El CI del core también usa `generate-and-build.sh` para su prueba de humo.

## Configuración en GitHub (una sola vez)

**Ruleset de `main` y de `v*`**
- PR obligatorio con 1 aprobación (en `v*` mejor 2), descartar aprobaciones viejas al haber nuevos commits y resolver conversaciones.
- Check obligatorio: `ci-ok`.
- Sin force push ni borrado. En `v*` el CI rechaza cualquier PR que no venga de `main` (job `promotion-source`).

**Variables del repositorio**
- `TEST_RELEASED_PLUGIN=true` cuando ya esté publicado el primer plugin que lee `v1`. Antes de eso, el plugin publicado (1.0.5) no entiende `schemaVersion` y esa matriz fallaría.
- `PLUGIN_MAJOR`: mayor del plugin que se integra en `main` (por defecto `1`).

**Seguridad del repositorio**
- Secret scanning con push protection y Dependabot alerts.
- Actions: permisos del `GITHUB_TOKEN` en solo lectura. El job que crea el tag pide `contents: write` solo para eso.
