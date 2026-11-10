# CI de templates

Cada cambio en templates se prueba generando proyectos reales con el plugin, compilándolos con sus tests (ArchUnit incluido) y escaneando sus dependencias. Los pipelines van por etapas: **Quality (CI) → Security (CI) → Build → Approval → Deploy (CD)**. Cada job lleva la etapa en su nombre, así que el grafo de GitHub Actions las muestra en columnas.

## Ramas

- `develop` es la rama de integración: los PR desde `feat/*` o `fix/*` entran aquí. Es la rama por defecto del repositorio.
- `main` está congelada: la leen los plugins 1.0.x ya publicados, que no entienden las plantillas nuevas. Solo recibe arreglos puntuales para esos usuarios, y se retira cuando ya nadie use 1.0.x.
- `v1`, `v2`, … son las ramas que lee cada mayor del plugin: el plugin 1.x lee `v1`. Es lo que reciben los usuarios.
- Promover es abrir un PR de `develop` a `v1`. Necesita la aprobación del environment `promote`; al mergearlo, el CI crea el tag siguiente `v1.x.y` (sube el patch; el minor se sube a mano).
- Un cambio incompatible sube el `schemaVersion` de `architectures/index.yml`. Va a la rama `v2` junto con el plugin 2.0, nunca a `v1`.

## Workflows

| Workflow | Cuándo corre | Etapas |
|---|---|---|
| `ci.yml` | PR y push a `develop` y a `v*` | Quality: contrato y, en PR a `v*`, que venga de `develop`. Security: gitleaks, actionlint y zizmor. Build: cada arquitectura × paradigma generada, compilada, probada y con sus dependencias escaneadas; en PR a `v*` también con el último plugin publicado. Approval: en PR a `v*`, aprobación del environment `promote`. Deploy: el merge a `v*` crea el tag `v1.x.y` |
| `security-weekly.yml` | cada lunes a las 07:00 UTC | Build: genera un proyecto por arquitectura × paradigma con todos los adapters. Security, sobre cada uno: dependencias (OSV), código (CodeQL `security-extended`) y secretos (gitleaks). Report: abre o actualiza un issue `security-weekly`; una corrida limpia lo cierra |
| `nightly.yml` | cada día a las 06:00 UTC | cada adapter solo en su propio proyecto, y violaciones metidas a propósito que el build debe rechazar |
| `generation.yml` | lo llaman los anteriores | la matriz de generación |

La matriz sale de `architectures/index.yml` y de los `index.json` de adapters. Una arquitectura o un adapter nuevo entra a la matriz, y al escaneo semanal, sin tocar los workflows.

| Modo | Proyectos | Qué prueba |
|---|---|---|
| `full` | cada arquitectura × paradigma | entidad, caso de uso y todos los adapters en el mismo proyecto; `build` con tests |
| `isolated` | `hexagonal-single` × paradigma × adapter | que cada adapter compile y pase sus tests solo |
| `negative` | cada arquitectura × paradigma | que se rechacen un dominio con Spring, un caso de uso que usa un adapter y, en reactivo, un `block()` |

## Seguridad de lo generado

Lo que reciben los usuarios son los proyectos generados, así que se escanean como ellos los recibirían:

| Escaneo | Herramienta | Bloquea | Cuándo |
|---|---|---|---|
| Dependencias, árbol completo | OSV-Scanner sobre los lockfiles que escribe Gradle | CVSS ≥ `quality.owasp-fail-on-cvss` de `versions.yml` (hoy 7.0) | cada PR y cada lunes |
| Código | CodeQL `security-extended` | security-severity ≥ 7.0 | cada lunes |
| Secretos | gitleaks sobre el proyecto | cualquier hallazgo | cada lunes |

Como el código generado no está en este repositorio, los hallazgos de CodeQL no van a la pestaña Security: quedan en el resumen del run y como SARIF en sus artefactos. Si el escaneo semanal corre sin `TEST_RELEASED_PLUGIN`, revisa `develop` con el plugin de core `main`; con la variable activa, revisa `v<mayor>` con el plugin publicado, que es lo que usa la gente.

Para corregir una dependencia vulnerable basta subir su versión en `versions.yml`: llega a los usuarios sin publicar plugin. Si la versión vulnerable llega como transitiva de otra librería, se fuerza desde el `buildConfiguration` del adapter que la trae, con `resolutionStrategy` (como en grpc, redis y postgresql reactivo). Nunca con un bloque `dependencies { }`: el plugin metería ahí las dependencias del siguiente adapter.

## Scripts

Se corren igual en local:

```bash
# El plugin tiene que estar en mavenLocal: ./gradlew publishToMavenLocal en el core
scripts/ci/check-contract.py templates
scripts/ci/generate-and-build.sh --architecture onion-single --paradigm reactive \
  --plugin-version 1.3.5-SNAPSHOT --templates templates --out build/generated
scripts/ci/negative-check.sh --project build/generated/onion-single-reactive --paradigm reactive
scripts/ci/scan-dependencies.sh --project build/generated/onion-single-reactive   # necesita osv-scanner
scripts/ci/sarif-gate.sh --sarif resultados.sarif --fail-on-severity 7.0
```

El CI del core usa `generate-and-build.sh` para su prueba de humo, y `scan-dependencies.sh` e `install-tools.sh` para escanear el plugin.

## Configuración en GitHub (una sola vez)

**Rama por defecto y `main`**
- Crear `develop` desde el `main` actual y ponerla como rama por defecto.
- Ruleset de `main`: sin push directo, sin force push ni borrado. Un arreglo para 1.0.x entra por PR con aprobación.

**Ruleset de `develop` y de `v*`**
- PR obligatorio con 1 aprobación (en `v*` mejor 2), descartar aprobaciones viejas al haber nuevos commits y resolver conversaciones.
- Check obligatorio: `ci-ok`. En un PR a `v*`, `ci-ok` espera al job Approval, así que no se puede mergear sin la aprobación del environment.
- Sin force push ni borrado. En `v*` el CI rechaza cualquier PR que no venga de `develop` (job `promotion-source`).

**Environment `promote`**
- Revisores obligatorios y "Prevent self-review".
- Deployment branches: sin restricción. Corre sobre el PR de promoción, cuya ref es la del PR; la protección real es el revisor.
- No guarda secretos: solo es la aprobación.

**Variables del repositorio**
- `TEST_RELEASED_PLUGIN=true` cuando ya esté publicado el primer plugin que lee `v1`. Antes de eso, el plugin publicado (1.0.5) no entiende `schemaVersion` y esa matriz fallaría.
- `PLUGIN_MAJOR`: mayor del plugin que se integra en `develop` (por defecto `1`).

**Seguridad del repositorio**
- Secret scanning con push protection y Dependabot alerts.
- Actions: permisos del `GITHUB_TOKEN` en solo lectura. El job que crea el tag pide `contents: write` y el reporte semanal `issues: write`, solo para eso.
